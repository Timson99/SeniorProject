extends KinematicBody2D

onready var interact_area = $Area2D
onready var animations = $AnimatedSprite
onready var party := []

export var persistence_id := "NPC1" 
export var actor_id := "NPC_name"
export var present_in_scene = true

enum Mode {Wandering, Pathing, Motionless, Interacting}
export(Mode) var current_mode = Mode.Motionless

const pixel_per_frame := 1
const default_speed := 60.0 * pixel_per_frame

var speed := default_speed setget set_speed
var velocity = Vector2(0,0)
var current_dir = Enums.Dir.Left
var dir_anims := {
	Enums.Dir.Up: ["Idle_Up", "Walk_Up"],
	Enums.Dir.Down: ["Idle_Down", "Walk_Down"],
	Enums.Dir.Left: ["Idle_Left", "Walk_Left"],
	Enums.Dir.Right: ["Idle_Left", "Walk_Left"]
}


func _ready():
	ActorEngine.register_actor(self)
	add_to_group("Persistent")
	interact_area.connect("body_entered", self, "allow_interaction")
	interact_area.connect("body_exited", self, "restrict_interaction")
	party = get_tree().get_nodes_in_group("Party")


func _physics_process(delta):
	if current_mode == Mode.Motionless || current_mode == Mode.Interacting:
		velocity = velocity.normalized() * 0
	elif current_mode == Mode.Wandering:
		velocity = self.call("wander", next_movement).normalized() * default_speed
	elif current_mode == Mode.Pathing:
		# To be implemented on a case-by-case basis for instanced NPCs?
		velocity = self.call("follow_path").normalized() * default_speed


func interact():
	print("Interacted")
	# Dialogue Engine code here, I assume, based on NPC 
	# DialogueEngine.custom_message(message) ?


func allow_interaction(body: Node):
	if party.size() == 1 && body == party[0].active_player:
		body.interact_areas.append(self)
	
	
func restrict_interaction(body: Node):
	if party.size() == 1 && body == party[0].active_player:
		if self in body.interact_areas:
			body.interact_areas.erase(self)
	

func set_speed(new_speed: float):
	speed = new_speed


func move_up():
	current_dir = Enums.Dir.Up
	return Vector2(velocity.x, velocity.y - 1)

	
func move_down():
	current_dir = Enums.Dir.Down
	return Vector2(velocity.x, velocity.y + 1)

	
func move_right():
	current_dir = Enums.Dir.Right
	return Vector2(velocity.x + 1, velocity.y)

	
func move_left():
	current_dir = Enums.Dir.Left
	return Vector2(velocity.x - 1, velocity.y)

		
func move_to_position(new_position: Vector2, global = true):
	var current_position = self.get_global_position().round()
	if !global:
			new_position = current_position + new_position
	while current_position != new_position:
		yield(get_tree().create_timer(0, false), "timeout")
		current_position = self.get_global_position().round()
			
		var x_delta = round(new_position.x - current_position.x)
		var y_delta = round(new_position.y - current_position.y)
		
		if y_delta != 0:
			if current_position.y > new_position.y:
				move_up()
			else:
				move_down()
		elif y_delta <= 0 && x_delta != 0:
			if current_position.x > new_position.x:
				move_left()
			else:
				move_right()


var rand_num_generator = RandomNumberGenerator.new()
var wander_timer: SceneTreeTimer
var wait_timer: SceneTreeTimer
var next_movement: String = ""

func wander(current_movement: String):
	if wander_timer && wander_timer.get_time_left() > 0:
		return self.call(current_movement)
	elif wander_timer && wander_timer.get_time_left() <= 0 && not wait_timer:
		wander_timer = null
		wait_timer = get_tree().create_timer(rand_num_generator.randf_range(0,3), false)
		return Vector2(0,0)
	elif wait_timer && wait_timer.get_time_left() > 0:
		return Vector2(0, 0)
	elif (not wait_timer && not wander_timer) || (wait_timer.get_time_left() <= 0):
		if wait_timer && wait_timer.get_time_left() <= 0:
			wait_timer = null
		var movement_options = ["move_up", "move_down", "move_left", "move_right"]
		rand_num_generator.randomize()
		var movement_index = rand_num_generator.randi_range(0,3)
		next_movement = movement_options[movement_index]
		wander_timer = get_tree().create_timer(rand_num_generator.randf_range(0,1), false)
		return self.call(next_movement)		
	

func follow_path():
	# To-do
	pass


func save():
	if(persistence_id != ""):
		return {
			"persistence_id" : persistence_id,
			"present_in_scene" : present_in_scene,
		}
	else:
		return {}
