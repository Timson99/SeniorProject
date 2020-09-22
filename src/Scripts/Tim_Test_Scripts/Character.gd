extends KinematicBody2D

export var speed := 300
onready var screen_size := get_viewport_rect().size
export var persistance_id := "C1" #Can't be a number or mistakeable for a non string type
export var input_id := "C1"
var velocity := Vector2()
var anim_string = "Idle_Down"
var destination = "res://Scenes/Tim_Test_Scenes/Opening2.tscn"
var isMoving : bool = false

enum Dir {Up, Down, Left, Right}
var current_dir = Dir.Down
var dir_anims = {
	Dir.Up: ["Idle_Up", "Walk_Up"],
	Dir.Down: ["Idle_Down", "Walk_Down"],
	Dir.Left: ["Idle_Left", "Walk_Left"],
	Dir.Right: ["Idle_Left", "Walk_Left"]
}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta : float):
	
	velocity = velocity.normalized() * speed
	if velocity.length() != 0:
		$AnimatedSprite.animation = dir_anims[current_dir][1]
		velocity = velocity.normalized() * speed
		if(!isMoving): 
			$AnimatedSprite.play()
			isMoving = true
	else:
		$AnimatedSprite.stop()
		$AnimatedSprite.animation = dir_anims[current_dir][0]
		isMoving = false
		
	$AnimatedSprite.flip_h = (current_dir == Dir.Right)
	
	move_and_collide(velocity * delta)
	$Camera2D.align()
	velocity = Vector2()
	
	
#Input Reciever Methods
func move_up():
	velocity = Vector2()
	velocity.y -= 1
	current_dir = Dir.Up
	
func move_down():
	velocity = Vector2()
	velocity.y += 1
	current_dir = Dir.Down
	
func move_right():
	velocity = Vector2()
	velocity.x += 1
	current_dir = Dir.Right
	
func move_left():
	velocity = Vector2()
	velocity.x -= 1
	current_dir = Dir.Left
	
func down_just_released():
	print("Down Just Released")
	
func up_just_pressed():
	print("Up Just Pressed")

func save_game():
	SaveManager.save_game()

func change_scene():
	SceneManager.goto_scene(destination, -1)

#Persistant Object Method
func save():
	var save_dict = {
		"id" : persistance_id,
		"position" : var2str(position) #Vectors must be pre-converted for json
	}	
	return save_dict
	
	"""
	Persistant Objects need three things:
		1. Add to the 'Persistent' group
		2. A persistance id (Must have at least one letter).
		3. Have a save function with an an id attribute and all other attributes to save.
	"""
