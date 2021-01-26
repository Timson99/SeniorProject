extends Node

signal sync_command_complete

var actors_dict: Dictionary = {}
var actors_array: Array = []


var async_actors = []


func _ready():
	SceneManager.connect("scene_loaded", self, "update_actors")
	update_actors()
	
func update_actors(actor_group_array = null):
	if actor_group_array == null:
		actors_array = get_tree().get_nodes_in_group("Actor")
	else:
		actors_array = actor_group_array

	for actor_body in actors_array:
		var key: String = actor_body.actor_id
		actors_dict[key] = actor_body

func call_command(id, func_name, params):
	var actor = actors_dict[id]
	if actor.has_method(func_name):
		actor.call_deferred("callv", func_name, params)
	else:
		Debugger.dprint("Actor %s does not have method %s" % [id, func_name])
		
func set_command(id : String, property : String, new_value):
	var actor = actors_dict[id]
	if property in actor:
		actor.set_deferred(property, new_value)
	else:
		Debugger.dprint("Invalid property %s on actor %s" % [property, actor.name])
		
func sync_command(id, func_name, params):
	var actor = actors_dict[id]
	if actor.has_method(func_name):
		var function_ref = funcref(actor, func_name)
		yield(  function_ref.call_funcv(params)  , "completed"  )
	else:
		Debugger.dprint("Actor %s does not have method %s" % [id, func_name])

signal updated_async_actors		
func async_command(id, func_name, params):
	var actor = actors_dict[id]
	if actor.has_method(func_name):
		
		while(id in async_actors):
			yield(self, "updated_async_actors")
		print("Execute Async")
		
		async_actors.append(id)
		var function_ref = funcref(actor, func_name)
		yield(  function_ref.call_funcv(params)  , "completed"  )
		async_actors.erase(id)
		emit_signal("updated_async_actors")
	else:
		Debugger.dprint("Actor %s does not have method %s" % [id, func_name])


