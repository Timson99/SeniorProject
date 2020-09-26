extends KinematicBody2D

export var speed := 50
export var persistance_id := "C1" #Can't be a number or mistakeable for a non string type
export var input_id := "Player"
export var alive = true

var party_data = null

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
	print(speed)
	if party_data != null and party_data["active"] != self:
		follow(delta)
	
	
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
	var collision = move_and_collide(velocity * delta)
	if collision:
		$AnimatedSprite.animation = dir_anims[current_dir][0]
	$Camera2D.align()
	velocity = Vector2()
	
# When leader, player input is activate, 
func activate_player():
	add_to_group("Input_Reciever")
	$Camera2D.current = true
	$CollisionBox.disabled = false
	$Area2D/InteractableArea.disabled = false
	
# When followed or incapacitated, player is an AI follower
func deactivate_player():
	remove_from_group("Input_Reciever")
	$Camera2D.current = false
	$CollisionBox.disabled = true
	$Area2D/InteractableArea.disabled = true
	
	
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
	
func follow(delta): 
	var line_position = party_data["num"]
	var leader = party_data["party"][line_position - 1]
	var to_leader = leader.position - position
	var distance = abs(to_leader.x) + abs(to_leader.y)
	var party_spacing = 16
	
	if(distance > party_spacing):
		
		if (leader.current_dir in [Dir.Left, Dir.Right] &&
		!(to_leader.normalized() in [Vector2.RIGHT, Vector2.LEFT])):
			var vertical_diff = position.y - leader.position.y
			if vertical_diff > 0 && abs(vertical_diff) > (speed * delta):
				move_up()
			elif vertical_diff < 0 && abs(vertical_diff) > (speed * delta):
				move_down()
			else:
				position.y = leader.position.y
		elif (leader.current_dir in [Dir.Up, Dir.Down] &&
		!(to_leader.normalized() in [Vector2.UP, Vector2.DOWN])):
			var horizontal_diff = position.x - leader.position.x
			if horizontal_diff > 0 and abs(horizontal_diff) > (speed * delta):
				move_left()
			elif horizontal_diff < 0 and abs(horizontal_diff) > (speed * delta):
				move_right()
			else:
				position.x = leader.position.x
		else:
			if(to_leader.normalized() == Vector2.RIGHT): move_right()
			elif(to_leader.normalized() == Vector2.DOWN): move_down()
			elif(to_leader.normalized() == Vector2.LEFT): move_left()
			elif(to_leader.normalized() == Vector2.UP): move_up()
			
	$AnimatedSprite.frame = party_data["active"].get_node("AnimatedSprite").frame
