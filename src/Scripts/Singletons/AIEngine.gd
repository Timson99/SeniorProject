extends Node

var ai_actors_dict: Dictionary = {}
var ai_actors_array: Array = []
var command_timer: float = 0

var actor: Node
var actor_position: Vector2
var command_string: String
var move_destination: Vector2

func _physics_process(delta):
	ai_actors_array = get_tree().get_nodes_in_group("AI_Movable")
	for ai_actor in ai_actors_array:
		var ai_key: String = ai_actor.ai_movement_id
		ai_actors_dict[ai_key] = ai_actor
		if command_timer > 0:
			execute_command(actor, command_string, move_destination)
			command_timer -= delta
	

func process_command(ai_id: String, command : String, destination: Vector2, time : float) -> void:
	actor = ai_actors_dict[ai_id]
	actor_position = actor.get_global_position()
	actor_position = Vector2(round(actor_position.x), round(actor_position.y))
	command_string = command
	move_destination = destination
	start_command_timer(time)


func execute_command(actor : Node, command : String, destination: Vector2):
	#var tween = Tween.new()
	if actor.has_method(command):
		actor.call(command)
	else:
		print("Invalid command action") 


func start_command_timer(added_time: float):
	command_timer += added_time
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
