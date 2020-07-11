extends KinematicBody2D

export var speed: int
var isMoving : bool = false

var velocity = Vector2()
var animString = ""

func _ready():
	pass
	
func reposition(new_position, new_direction):
	position.x = new_position.x
	position.y = new_position.y
	if new_direction == GlobalTypes.Direction.Up: animString = "Up"
	elif new_direction == GlobalTypes.Direction.Down: animString = "Down"
	elif new_direction == GlobalTypes.Direction.Left: animString = "Left"
	elif new_direction == GlobalTypes.Direction.Right: animString = "Right"
	else: print("ERROR")
	$AnimatedSprite.animation = animString
	$AnimatedSprite.frame = 0

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
		animString = "Right"
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
		animString = "Left"
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
		animString = "Down"
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
		animString = "Up"
	
	if Input.is_key_pressed(KEY_S):
		print("Save")
		SaveManager.test_data["1"] += 1
		SaveManager.save_game()
	if Input.is_key_pressed(KEY_L):
		print("Load")
		SaveManager.load_game()
		print(SaveManager.test_data)

func _physics_process(delta):	
	
	get_input()
	if velocity.length() != 0 && GameManager.player_control_enabled():
		$AnimatedSprite.animation = animString
		velocity = velocity.normalized() * speed
		if(!isMoving): 
			$AnimatedSprite.play()
			$AnimatedSprite.frame = 1
			isMoving = true
	else:
		$AnimatedSprite.stop()
		$AnimatedSprite.frame = 0
		isMoving = false
	
	move_and_collide(velocity * delta)
	$Camera2D.align()
