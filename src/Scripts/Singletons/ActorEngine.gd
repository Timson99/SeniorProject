extends Node

signal async_actor_command_complete

var actors_dict: Dictionary = {}
var actors_array: Array = []
var command_timer: SceneTreeTimer

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
		if command_timer && command_timer.time_left > 0:
			execute_command(actor, command_string)
		if command_timer && command_timer.time_left <= 0:
			emit_signal("async_actor_command_complete")
	

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
		print(party_members)
		for i in range(party_members.size()):
			party_members[i].change_sequenced_follow_formation(optional_param)
	elif npc_regex.search(id):
		pass
	elif enemy_regex.search(id):
		pass
	#actor_position = Vector2(round(actor_position.x), round(actor_position.y))
	if mode == "async":
		start_command_timer(time)
	else:
		pass


func execute_command(actor: Node, command: String):
	if actor.has_method(command):
		actor.call(command)
	else:
		Debugger.dprint("Invalid command action") 


func execute_party_move_to_position():
	pass


func start_command_timer(added_time: float):
	command_timer = get_tree().create_timer(added_time, false)
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
