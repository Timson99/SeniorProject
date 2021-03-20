extends KinematicBody2D

onready var animations = $AnimatedSprite
onready var party := []

export var pathing_coordinates = []

const pixel_per_frame := 1
const default_speed := 60.0 * pixel_per_frame

var speed := default_speed 
var velocity = Vector2(0,0)
var current_dir = Enums.Dir.Left
var isMoving := false
var dir_anims := {
	Enums.Dir.Up: ["Idle_Up", "Walk_Up"],
	Enums.Dir.Down: ["Idle_Down", "Walk_Down"],
	Enums.Dir.Left: ["Idle_Left", "Walk_Left"],
	Enums.Dir.Right: ["Idle_Left", "Walk_Left"]
}
var initial_mode


func _ready():
	pass


func _physics_process(delta):
	pass


func animate_movement():
	if velocity.length() != 0:
		animations.animation = dir_anims[current_dir][1]
		if(!isMoving): 
			animations.play()
			isMoving = true
		animations.flip_h = (current_dir == Enums.Dir.Right)
	else:
		animations.stop()
		animations.animation = dir_anims[current_dir][0]
		isMoving = false
	

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
	

func pause_movement():
	return Vector2(0,0)


func freeze_in_place():
	pass


func unfreeze():
	pass

		
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
	
	
var target_path_index = 0

func follow_path(pathing_coordinates: Array):
	# For clarity, pathing coordinates must be in the order in which they are
	# meant to be visited by the NPC.
	var current_position = self.get_global_position().round()
	var target_loc: Vector2 = pathing_coordinates[target_path_index]
	if current_position.x == target_loc.x && current_position.y == target_loc.y:
		target_path_index += 1
		if target_path_index >= pathing_coordinates.size():
			target_path_index = 0
		target_loc = pathing_coordinates[target_path_index]
		return self.call("pause_movement")
	return self.call("get_next_move", current_position, target_loc)


func get_next_move(current_position: Vector2, target_loc: Vector2):
	var next_move: String
	var x_delta = round(target_loc.x - current_position.x)
	var y_delta = round(target_loc.y - current_position.y)
	if y_delta != 0:
		if current_position.y > target_loc.y:
			next_move = "move_up"
		else:
			next_move = "move_down"
	elif y_delta <= 0 && x_delta != 0:
		if current_position.x > target_loc.x:
			next_move = "move_left"
		else:
			next_move = "move_right"
	return self.call(next_move)
