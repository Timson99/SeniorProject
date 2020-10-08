extends Node

signal async_actor_command_complete
signal sync_actor_commands_complete

var actors_dict: Dictionary = {}
var actors_array: Array = []
var synchronous_actors_dict: Dictionary = {}
var async_command_timer: SceneTreeTimer

const actor_timed_func := ["move_up", "move_down", "move_left", "move_right"]
const actor_instant_func := ["change_sequenced_follow_formation"]

var actor: Node
var actor_position: Vector2
var command_string: String
var move_destination: Vector2



func _physics_process(delta):
	actors_array = get_tree().get_nodes_in_group("Actor")
	for actor_body in actors_array:
		var key: String = actor_body.actor_id
		actors_dict[key] = actor_body
		if async_command_timer && async_command_timer.time_left > 0:
			execute_command(actor, command_string)
			print(async_command_timer.time_left)
		if async_command_timer && async_command_timer.time_left <= 0.1:
			#emit_signal("async_actor_command_complete")
			async_command_timer.set_time_left(0.00)
		if actor_body in synchronous_actors_dict && synchronous_actors_dict[actor_body][0].time_left > 0:
			execute_command(actor_body, synchronous_actors_dict[actor_body][1])
			print(synchronous_actors_dict[actor_body][0].time_left)
		if actor_body in synchronous_actors_dict.keys() && synchronous_actors_dict[actor_body][0].time_left <= 0:
			print("SYNC DONE")
			synchronous_actors_dict.erase(actor_body)
		if  synchronous_actors_dict.empty():
			emit_signal("sync_actor_commands_complete")
		else: 
			pass

	

func process_command(mode: String, id: String, command : String, time_or_optional_param) -> void:
	if actors_dict[id] in synchronous_actors_dict:
		#print("WAITING FOR SYNC TO FINISH")
		yield(ActorEngine, "sync_actor_commands_complete")
	actor = actors_dict[id]
	command_string = command
	if command in actor_instant_func:
		execute_command(actor, command_string, time_or_optional_param)
		return
	elif command in actor_timed_func:
		if mode == "async":
			start_async_command_timer(time_or_optional_param)
		if mode == "sync":
			add_actor_to_synchronous_actors(actor, command_string, time_or_optional_param)
		return
	else:
		Debugger.dprint("Unexpected command string")
		return


func execute_command(actor: Node, command: String, optional_param=0):
	if actor.has_method(command):
		if typeof(optional_param) == TYPE_STRING:
			actor.call(command, optional_param)
		else:
			actor.call(command)
	else:
		Debugger.dprint("Invalid command action") 


func execute_party_move_to_position():
	pass


func start_async_command_timer(added_time: float):
	async_command_timer = get_tree().create_timer(added_time, false)
	print("ASYNC TIMER STARTED")

func add_actor_to_synchronous_actors(actor: Node, command: String, time: float):
	synchronous_actors_dict[actor] = [get_tree().create_timer(time, false), command]
	#print(synchronous_actors_dict)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
