extends Node

signal async_actor_command_complete
signal sync_actor_commands_complete

var actors_dict: Dictionary = {}
var actors_array: Array = []
var synchronous_actors_dict: Dictionary = {}
var async_command_timer: SceneTreeTimer

const actor_timed_func := ["move_up", "move_down", "move_left", "move_right"]
const actor_one_arg_func := []

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
		if async_command_timer && async_command_timer.time_left <= 0:
			emit_signal("async_actor_command_complete")
		if actor_body in synchronous_actors_dict.keys() && synchronous_actors_dict[actor_body][0].time_left > 0:
			execute_command(actor_body, synchronous_actors_dict[actor_body][1])
		if actor_body in synchronous_actors_dict.keys() && synchronous_actors_dict[actor_body][0].time_left <= 0:
			synchronous_actors_dict.erase(actor_body)
		if synchronous_actors_dict.empty():
			emit_signal("sync_actor_commands_complete")
	

func process_command(mode: String, id: String, command : String, time : float, optional_param) -> void:
	var party_member_regex = RegEx.new()
	var npc_regex = RegEx.new()
	var enemy_regex = RegEx.new()
	actor = actors_dict[id]
	command_string = command
	party_member_regex.compile("^PChar\\d+")
	if party_member_regex.search(id):
		var party_members = []
		for key in actors_dict:
			if party_member_regex.search(key):
				party_members.append(actors_dict[key]) 
		#print(party_members)
		for i in range(party_members.size()):
			party_members[i].change_sequenced_follow_formation(optional_param)
	elif npc_regex.search(id):
		pass
	elif enemy_regex.search(id):
		pass
	#actor_position = Vector2(round(actor_position.x), round(actor_position.y))
	if mode == "async":
		start_async_command_timer(time)
	else:
		add_actor_to_synchronous_actors(actor, command_string, time)
		# add actor to a locked-actor list so that it cannot accept commands until it finishes the current one
		# associate actor with its own timer
		# ensure that the associated timer starts and gets referenced in the physics process
		pass


func execute_command(actor: Node, command: String):
	if actor.has_method(command):
		actor.call(command)
	else:
		Debugger.dprint("Invalid command action") 


func execute_party_move_to_position():
	pass


func start_async_command_timer(added_time: float):
	async_command_timer = get_tree().create_timer(added_time, false)


func add_actor_to_synchronous_actors(actor: Node, command: String, time: float):
	synchronous_actors_dict[actor] = [get_tree().create_timer(time, false), command]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
