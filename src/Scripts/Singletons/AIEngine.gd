extends Node

signal ai_command_complete

var ai_actors_dict: Dictionary = {}
var ai_actors_array: Array = []
var command_timer: float = 0

enum PartyState {Following, Split, InTandem}

var actor: Node
var actor_position: Vector2
var command_string: String
var move_destination: Vector2
var state: int

func _physics_process(delta):
	ai_actors_array = get_tree().get_nodes_in_group("AI_Movable")
	for ai_actor in ai_actors_array:
		var ai_key: String = ai_actor.ai_movement_id
		ai_actors_dict[ai_key] = ai_actor
		if command_timer > 0:
			execute_party_command(actor, command_string, move_destination)
			command_timer -= delta
		if command_timer <= 0:
			emit_signal("ai_command_complete")
	

func process_party_command(ai_id: String, command : String, time : float, party_state_enum: int) -> void:
	var party_members = []
	var party_member_regex = RegEx.new()
	party_member_regex.compile("^PChar\\d+")
	for key in ai_actors_dict:
		if party_member_regex.search(key):
			party_members.append(ai_actors_dict[key]) 
	actor = ai_actors_dict[ai_id]
	actor_position = actor.get_global_position()
	#print(actor_position)
	actor_position = Vector2(round(actor_position.x), round(actor_position.y))
	command_string = command
	state = party_state_enum
	for party_member in party_members:
		party_member.party_data["sequence_formation"] = state
		#print(party_member.party_data["sequence_formation"])
	start_command_timer(time)


func execute_party_command(actor : Node, command : String, destination: Vector2):
	if actor.has_method(command):
		actor.call(command)
	else:
		print("Invalid command action") 

func execute_party_move_to_position():
	pass

func start_command_timer(added_time: float):
	command_timer += added_time
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
