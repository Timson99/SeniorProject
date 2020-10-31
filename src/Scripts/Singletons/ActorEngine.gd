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
var extra_param = null

func _ready():
	SceneManager.connect("scene_loaded", self, "update_actors")
	update_actors()
	
func update_actors():
	actors_array = get_tree().get_nodes_in_group("Actor")
	
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
	actors_array = get_tree().get_nodes_in_group("Actor")
	
	# Executes command until sync timer runs out; deletes sync timer at completion
	if sync_command_timer && sync_command_timer.get_time_left() > 0:
		if extra_param != null:
			execute_command(actor, command_string, extra_param)
		else:
			execute_command(actor, command_string)
	elif sync_command_timer && sync_command_timer.get_time_left() <= 0:
		emit_signal("sync_command_complete")
		sync_command_timer = null


func set_command(id : String, property : String, new_value):
	actor = actors_dict[id]
	actor.set_deferred(property, new_value)

	
func call_command(id, func_name, params):
	actor = actors_dict[id]
	actor.call_deferred("callv", func_name, params)


func sync_command(params: Array):
	actor = actors_dict[params[0]]
	command_string = params[1]
	if typeof(params[2]) in range(2,3):
		start_sync_command_timer(params[2])
	
	
func async_command(params: Array):
	actor = actors_dict[params[0]]
	command_string = params[1]
	if typeof(params[2]) in range(2,3):
		asynchronous_delay_time = max(params[2], asynchronous_delay_time)
		add_actor_to_asynchronous_actors(actor, command_string, asynchronous_delay_time)
	
	
func execute_command(actor: Node, command: String, optional_param=null) -> void:
	
	if actor.has_method(command):
		if optional_param != null:
			actor.call_deferred(command, optional_param)
		else:
			actor.call_deferred(command)
	else:
		Debugger.dprint("Invalid command action") 


func start_sync_command_timer(added_time: float) -> void:
	sync_command_timer = get_tree().create_timer(added_time, false)


func add_actor_to_asynchronous_actors(actor: Node, command: String, time: float, extra_param=null) -> void:
	asynchronous_actors_dict[actor] = [get_tree().create_timer(time, false), command, extra_param]
