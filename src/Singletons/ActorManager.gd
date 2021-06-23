"""
	ActorManager
		Provides an interfeace for fetching any registered actor in a scene
		Allows registeration of an id'd node
		Provides Sequencer a actor interface for setting and calling actors
			Includes async and sync commands for calling methods that are coroutines
		
	Dependencies
		None

"""
extends Node

# Registry based on node scene tree names to identify actors
var id_property_name = "name"
var actor_registry = NodeRegistry.new(id_property_name)

# Notfies coroutine that currently acting actors may have changed
signal updated_async_actors
# Tracks which actors are currently carrying out async commands
var async_actors = []

	
#######
#	Public
#######
	
# Register a actor with a nonempty string id 
func register(node):
	actor_registry.register(node)

# Check if actor registry has an actor by id
func has_actor(id) -> bool:
	return (actor_registry.fetch(id) == null)
	
# Get any registered actor by id
func get_actor(id):
	return actor_registry.fetch(id)


#########
# Sequencer Functions
########

# Calls a function on a registered actor by id
func call_command(id, func_name, params):
	var actor = actor_registry.fetch(id)
	if !actor:
		Debugger.dprint("CALL COMMAND FAILED: ACTOR WITH ID '%s' NOT REGISTERED" % id)
	if actor.has_method(func_name):
		actor.call_deferred("callv", func_name, params)
	else:
		Debugger.dprint("Actor %s does not have method %s" % [id, func_name])

# Sets a property on a registered actor by id
func set_command(id : String, property : String, new_value):
	var actor = actor_registry.fetch(id)
	if !actor:
		Debugger.dprint("SET COMMAND FAILED: ACTOR WITH ID '%s' NOT REGISTERED" % id)
	if property in actor:
		actor.set_deferred(property, new_value)
	else:
		Debugger.dprint("Invalid property %s on actor %s" % [property, actor.name])

# Calls a syncronous function on a registered actor by id
# Prevents further commands until this one is finished 
# (Sequencer doesnt call next command till this function finishes)
# (Sequencer doesnt call next command till this function finishes)
func sync_command(id, func_name, params):
	var actor = actor_registry.fetch(id)
	if !actor:
		Debugger.dprint("SYNC COMMAND FAILED: ACTOR WITH ID '%s' NOT REGISTERED" % id)
	if actor.has_method(func_name):
		# Don't execute sync command if actor executing async command
		while(id in async_actors):
			yield(self, "updated_async_actors")
			
		var function_ref = funcref(actor, func_name)
		yield(  function_ref.call_funcv(params)  , "completed"  )
	else:
		Debugger.dprint("Actor %s does not have method %s" % [id, func_name])

# Calls a asyncronous function on a registered actor by id
# Prevents further commands for this actor until this one is finished, all other continue
func async_command(id, func_name, params):
	var actor = actor_registry.fetch(id)
	if !actor:
		Debugger.dprint("ASYNC COMMAND FAILED: ACTOR WITH ID '%s' NOT REGISTERED" % id)
	if actor.has_method(func_name):
		# Don't execute async command if actor executing async command
		while(id in async_actors):
			yield(self, "updated_async_actors")
		async_actors.append(id)
		var function_ref = funcref(actor, func_name)
		yield(  function_ref.call_funcv(params)  , "completed"  )
		async_actors.erase(id)
		emit_signal("updated_async_actors")
	else:
		Debugger.dprint("Actor %s does not have method %s" % [id, func_name])


