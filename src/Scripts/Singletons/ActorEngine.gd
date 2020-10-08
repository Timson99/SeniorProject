extends Node

signal async_actor_command_complete
signal sync_actor_commands_complete

var actors_dict: Dictionary = {}
var actors_array: Array = []
var synchronous_actors_dict: Dictionary = {}
var async_command_timer: SceneTreeTimer

const party_actors = ["PChar1", "PChar2", "PChar3"]
const actor_timed_func := ["move_up", "move_down", "move_left", "move_right", "move_to_position"]
const actor_instant_func := ["change_sequenced_follow_formation"]

var actor: KinematicBody2D
var actor_position: Vector2
var command_string: String
var extra_param = null


func _physics_process(delta: float):
	actors_array = get_tree().get_nodes_in_group("Actor")
	for actor_body in actors_array:
		var key: String = actor_body.actor_id
		actors_dict[key] = actor_body
		if async_command_timer && async_command_timer.get_time_left() > 0:
			if extra_param != null:
				execute_command(actor, command_string, extra_param)
			else:
				execute_command(actor, command_string)
		if actor_body in synchronous_actors_dict && synchronous_actors_dict[actor_body][0].get_time_left() > 0:
			if synchronous_actors_dict[actor_body].size() == 3: 
				execute_command(actor_body, synchronous_actors_dict[actor_body][1], synchronous_actors_dict[actor_body][2])
			else:
				execute_command(actor_body, synchronous_actors_dict[actor_body][1])
		if actor_body in synchronous_actors_dict.keys() && synchronous_actors_dict[actor_body][0].get_time_left() <= 0:
			synchronous_actors_dict.erase(actor_body)
			if synchronous_actors_dict.empty():
				emit_signal("sync_actor_commands_complete")
		else: 
			pass

	

func process_command(mode: String, id: String, command : String, time: float, optional_param=null) -> void:
	if actors_dict[id] in synchronous_actors_dict:
		yield(ActorEngine, "sync_actor_commands_complete")
	actor = actors_dict[id]
	command_string = command
	print(command_string)
	print(optional_param)
	if optional_param != null:
		extra_param = optional_param
	else: 
		extra_param = null
	if command in actor_instant_func:
		execute_command(actor, command_string, optional_param)
	elif command in actor_timed_func:
		if mode == "Actor-async":
			start_async_command_timer(time)
		elif mode == "Actor":
			add_actor_to_synchronous_actors(actor, command_string, time, extra_param)
	else:
		Debugger.dprint("Unexpected command string")


func execute_command(actor: Node, command: String, optional_param=null):
	if actor.has_method(command):
		if optional_param != null && (typeof(optional_param) == TYPE_STRING || typeof(optional_param) == TYPE_VECTOR2):
			actor.call(command, optional_param)
		else:
			actor.call(command)
	else:
		Debugger.dprint("Invalid command action") 
		

func start_async_command_timer(added_time: float):
	async_command_timer = get_tree().create_timer(added_time, false)
	#print("ASYNC TIMER STARTED")

func add_actor_to_synchronous_actors(actor: Node, command: String, time: float, extra_param=null):
	synchronous_actors_dict[actor] = [get_tree().create_timer(time, false), command, extra_param]
	#print(synchronous_actors_dict)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
