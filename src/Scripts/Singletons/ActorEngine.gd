extends Node

signal sync_command_complete

var actors_dict: Dictionary = {}
var actors_array: Array = []
var asynchronous_actors_dict: Dictionary = {}
var asynchronous_delay_time: float = 0.0
var sync_command_timer: SceneTreeTimer

var actor: Node2D
var actor_position: Vector2
var command_string: String
var untimed_command_begun: bool
var untimed_command_done: bool
var additional_params


func _ready():
	SceneManager.connect("scene_loaded", self, "update_actors")
	update_actors()
	
func update_actors(actor_group_array = null):
	if actor_group_array == null:
		actors_array = get_tree().get_nodes_in_group("Actor")
	else:
		actors_array = actor_group_array
	
	# Executes each command for each async actor for duration of their 
	# respective timers
	for actor_body in actors_array:
		var key: String = actor_body.actor_id
		actors_dict[key] = actor_body
		if actor_body in asynchronous_actors_dict && asynchronous_actors_dict[actor_body][0].get_time_left() > 0:
			if asynchronous_actors_dict[actor_body].size() == 3: 
				execute_command(actor_body, asynchronous_actors_dict[actor_body][1], asynchronous_actors_dict[actor_body][2])
			else:
				execute_command(actor_body, asynchronous_actors_dict[actor_body][1])
		elif actor_body in asynchronous_actors_dict && asynchronous_actors_dict[actor_body][0].get_time_left() <= 0:
			asynchronous_actors_dict.erase(actor_body)
	


func _physics_process(_delta: float):	
	
	# Executes command until sync timer runs out; deletes sync timer at completion
	if sync_command_timer && sync_command_timer.get_time_left() > 0:
		execute_command(actor, command_string, additional_params)
	elif sync_command_timer && sync_command_timer.get_time_left() <= 0:
		emit_signal("sync_command_complete")
		sync_command_timer = null
	
	elif untimed_command_begun && !untimed_command_done:
		execute_command(actor, command_string, additional_params)
	elif untimed_command_begun && untimed_command_done:
		emit_signal("sync_command_complete")
		untimed_command_done = false
		untimed_command_begun = false
		actor.disconnect("command_completed", ActorEngine, "indicate_untimed_done")
	
	elif asynchronous_actors_dict:
		update_actors()


func set_command(id : String, property : String, new_value):
	actor = actors_dict[id]
	if property in actor:
		actor.set_deferred(property, new_value)
	else:
		Debugger.dprint("Invalid property %s on actor %s" % [property, actor.name])
	
	
func call_command(id, func_name, params):
	actor = actors_dict[id]
	if actor.has_method(func_name):
		actor.call_deferred("callv", func_name, params)
	else:
		Debugger.dprint("Actor %s does not have method %s" % [id, func_name])


func async_or_sync_command(params: Array):
	actor = actors_dict[params[1]]
	command_string = params[2]
	var possible_time = params[3]
	if typeof(possible_time) == TYPE_INT || typeof(possible_time) == TYPE_REAL:
		if params[0] == "Actor-sync":
			start_sync_command_timer(possible_time)
		else:
			asynchronous_delay_time = max(possible_time, asynchronous_delay_time)
			add_actor_to_asynchronous_actors(actor, command_string, asynchronous_delay_time)
		additional_params = null
	else:
		additional_params = params.slice(3, params.size())
		untimed_command_begun = true
		untimed_command_done = false
		actor.connect("command_completed", ActorEngine, "indicate_untimed_done")

		
func indicate_untimed_done():
	untimed_command_done = true
	
	
func execute_command(actor: Node, command: String, additional_params = null) -> void:
	if actor.has_method(command):
		if additional_params != null:
			actor.call_deferred("callv", command, additional_params)
		else:
			actor.call_deferred(command)
	else:
		Debugger.dprint("Invalid command action") 


func start_sync_command_timer(added_time: float) -> void:
	sync_command_timer = get_tree().create_timer(added_time, false)


func add_actor_to_asynchronous_actors(actor: Node, command: String, time: float) -> void:
	asynchronous_actors_dict[actor] = [get_tree().create_timer(time, false), command]
