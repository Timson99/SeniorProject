extends Node

signal sync_command_complete

const actor_timed_func := ["move_up", "move_down", "move_left", "move_right", "move_to_position"]
const actor_instant_func := ["change_follow", "change_speed", "restore_default_speed"]

var actors_dict: Dictionary = {}
var actors_array: Array = []
var asynchronous_actors_dict: Dictionary = {}
var asynchronous_delay_time: float = 0.0
var sync_command_timer: SceneTreeTimer

var actor: Node2D
var actor_position: Vector2
var command_string: String
var extra_param = null


func _physics_process(delta: float):
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



func process_command(mode: String, id: String, command : String, number_or_flag=null, optional_param=null) -> void:
	var time: float
	var flag: String
	actor = actors_dict[id]
	command_string = command
	extra_param = optional_param if (optional_param != null) else null
	if command in actor_instant_func:
		execute_command(actor, command_string, number_or_flag)
		return
	time = number_or_flag
	if command in actor_timed_func:
		if mode == "Actor-sync":
			start_sync_command_timer(time)
		elif mode == "Actor-async":
			asynchronous_delay_time = max(time, asynchronous_delay_time)
			add_actor_to_asynchronous_actors(actor, command_string, time, extra_param)
	else:
		Debugger.dprint("Unexpected command string")
	
	
func execute_command(actor: Node, command: String, optional_param=null) -> void:
	if actor.has_method(command):
		if optional_param != null:
			actor.call(command, optional_param)
		else:
			actor.call(command)
	else:
		Debugger.dprint("Invalid command action") 


func start_sync_command_timer(added_time: float) -> void:
	sync_command_timer = get_tree().create_timer(added_time, false)


func add_actor_to_asynchronous_actors(actor: Node, command: String, time: float, extra_param=null) -> void:
	asynchronous_actors_dict[actor] = [get_tree().create_timer(time, false), command, extra_param]


func _ready():
	pass
