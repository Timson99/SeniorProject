extends KinematicBody2D

const default_speed := 60

export var speed := default_speed
export var persistence_id := "C1" #Can't be a number or mistakeable for a non string type
export var input_id := "Player" #Don't overwrite in UI
export var actor_id := "PChar"
export var alive := true

#Array oof objects that are currently interactable
var interact_areas := []

#Party Vars, set by party
var party_data : Dictionary = {}

#Movement Vars
var velocity := Vector2()
var isMoving := false

var current_dir = Enums.Dir.Down
var dir_anims := {
	Enums.Dir.Up: ["Idle_Up", "Walk_Up"],
	Enums.Dir.Down: ["Idle_Down", "Walk_Down"],
	Enums.Dir.Left: ["Idle_Left", "Walk_Left"],
	Enums.Dir.Right: ["Idle_Left", "Walk_Left"]
}

# Test Vars
var destination = "res://Scenes/Tim_Test_Scenes/TestTileMap.tscn"



func on_load():
	position = Vector2(round(position.x), round(position.y))


func _physics_process(delta : float):
	explore(delta)
	

func explore(delta : float):
	if party_data != null and "active" in party_data and party_data["active"] != self:
		if party_data["sequence_formation"] == "following":
			follow(delta)	
		elif party_data["sequence_formation"] == "split":
			pass

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
		
	$AnimatedSprite.flip_h = (current_dir == Enums.Dir.Right)
	var collision = move_and_collide(velocity * delta)
	position = Vector2(round(position.x), round(position.y))
	if collision:
		$AnimatedSprite.animation = dir_anims[current_dir][0]
	velocity = Vector2()
	
	
# When leader, player input is activate, 
func activate_player():
	InputEngine.activate_receiver(self)
	$CollisionBox.disabled = false
	
# When followed or incapacitated, player is an AI follower
func deactivate_player():
	InputEngine.deactivate_receiver(self)
	$CollisionBox.disabled = true
	
	
#Input Receiver Methods
func move_up():
	velocity.y -= 1
	current_dir = Enums.Dir.Up
	
func move_down():
	velocity.y += 1
	current_dir = Enums.Dir.Down
	
func move_right():
	velocity.x += 1
	current_dir = Enums.Dir.Right
	
func move_left():
	velocity.x -= 1
	current_dir = Enums.Dir.Left
	
func down_just_released():
	#print("Down Just Released")
	pass
	
func up_just_pressed():
	#print("Up Just Pressed")
	pass
	
func test_command():
	Sequencer.execute_event("test_seq7")

func save_game():
	SaveManager.save_game()

func change_scene():
	SceneManager.goto_scene(destination)



#Interactions with Interactables (Box Openings, Dialogue Starters)
#Should add functionality to change direction toward thing being interacted with
func interact():
  if(interact_areas.size() != 0 and interact_areas.back().has_method("interact")):
	  interact_areas.back().interact()
	
func change_follow(formation: String):
	self.party_data["sequence_formation"] = formation
	
func change_speed(speed_string: float):
	var new_speed = float(speed_string)
	$AnimatedSprite.set_speed_scale(new_speed/default_speed) 
	self.speed = float(new_speed)

func restore_default_speed():
	# Resets the walking animation to its original speed 
	$AnimatedSprite.set_speed_scale(1) 
	self.speed = default_speed

func move_to_position(new_position: Vector2):
	var current_position = self.get_global_position()
	current_position = Vector2(round(position.x), round(position.y))
	var x_delta = new_position.x - current_position.x
	var y_delta = new_position.y - current_position.y
	#print(current_position)
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
	

#Persistent Object Method
func save():
	var save_dict = {
		"persistence_id" : persistence_id,
		"position" : position, 
		"current_dir" : current_dir
	}	
	return save_dict
	
"""
Persistent Objects need three things:
	1. Add to the 'Persistent' group
	2. A persistence id (Must have at least one letter).
	3. Have a save function with an an id attribute and all other attributes to save.
"""
	
func follow(delta : float): 
	var line_position : int = party_data["num"]
	var leader = party_data["party"][line_position - 1]
	var to_leader : Vector2 = leader.position - position
	var distance : float = abs(to_leader.x) + abs(to_leader.y)
	var party_spacing : float = party_data["spacing"]
	
	if(distance > party_spacing):
		if (leader.current_dir in [Enums.Dir.Left, Enums.Dir.Right] &&
		!(to_leader.normalized() in [Vector2.RIGHT, Vector2.LEFT])):
			var vertical_diff = position.y - leader.position.y
			if vertical_diff > 0 && abs(vertical_diff) > (speed * delta):
				move_up()
			elif vertical_diff < 0 && abs(vertical_diff) > (speed * delta):
				move_down()
			else:
				position.y = leader.position.y
		elif (leader.current_dir in [Enums.Dir.Up, Enums.Dir.Down] &&
		!(to_leader.normalized() in [Vector2.UP, Vector2.DOWN])):
			var horizontal_diff = position.x - leader.position.x
			if horizontal_diff > 0 && abs(horizontal_diff) > (speed * delta):
				move_left()
			elif horizontal_diff < 0 && abs(horizontal_diff) > (speed * delta):
				move_right()
			else:
				position.x = leader.position.x
		else:
			if(to_leader.normalized() == Vector2.RIGHT): move_right()
			elif(to_leader.normalized() == Vector2.DOWN): move_down()
			elif(to_leader.normalized() == Vector2.LEFT): move_left()
			elif(to_leader.normalized() == Vector2.UP): move_up()
			
	$AnimatedSprite.frame = party_data["active"].get_node("AnimatedSprite").frame
