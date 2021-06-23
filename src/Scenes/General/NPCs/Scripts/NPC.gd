extends "res://Scenes/General/Non-Player (Both Enemies & NPCs)/Non-Player.gd"

onready var interact_area = $Area2D

export var present_in_scene = true

enum Mode {Wandering, Pathing, Motionless, Interacting}
export(Mode) var current_mode = Mode.Motionless


func _ready():
	ActorManager.register(self)
	SaveManager.register(self)
	interact_area.connect("body_entered", self, "allow_interaction")
	interact_area.connect("body_exited", self, "restrict_interaction")
	party = get_tree().get_nodes_in_group("Party")
	initial_mode = current_mode


func _physics_process(delta):
	if current_mode == Mode.Motionless || current_mode == Mode.Interacting:
		velocity = velocity.normalized() * 0.0
	elif current_mode == Mode.Wandering:
		velocity = self.call("wander", next_movement).normalized() * default_speed
	elif current_mode == Mode.Pathing && pathing_coordinates.size() > 1:
		velocity = self.call("follow_path", pathing_coordinates).normalized() * default_speed
		
	animate_movement()
		
	var collision = move_and_collide(velocity * delta)
	velocity = pause_movement()


func interact():
	print("Interacted")
	current_mode = Mode.Interacting
	# Dialogue Engine code here, I assume, based on NPC 
	# DialogueEngine.custom_message(message) ?
	# yield until interaction finishes
	yield(get_tree().create_timer(2.0, false), "timeout")
	current_mode = initial_mode


func allow_interaction(body: Node):
	if party.size() == 1 && body == party[0].active_player:
		body.interact_areas.append(self)
	
	
func restrict_interaction(body: Node):
	if party.size() == 1 && body == party[0].active_player:
		if self in body.interact_areas:
			body.interact_areas.erase(self)
	

func set_speed(new_speed: float):
	speed = new_speed


func reset_speed():
	speed = default_speed


func freeze_in_place():
	velocity = pause_movement()
	current_mode = Mode.Motionless


func unfreeze():
	current_mode = initial_mode

		
func move_to_position(new_position: Vector2, global = true):
	var current_position = self.get_global_position().round()
	if !global:
			new_position = current_position + new_position
	while current_position != new_position:
		yield(get_tree().create_timer(0, false), "timeout")
		current_position = self.get_global_position().round()
			
		self.call("get_next_move", current_position, new_position)


func save():
	return {
		"position": position,
		"current_dir": current_dir,
		"present_in_scene" : present_in_scene,
	}

