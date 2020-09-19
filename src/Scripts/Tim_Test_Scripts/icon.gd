extends Sprite

export var speed := 300
onready var screen_size := get_viewport_rect().size
var persistance_id := "this_id" #Can't be a number or mistakeable for a non string type
var velocity := Vector2()
var destination = "res://Scenes/Tim_Test_Scenes/Opening2.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta : float):
	velocity = velocity.normalized() * speed
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	velocity = Vector2()

#Input Reciever Methods
func move_up():
	velocity = Vector2()
	velocity.y -= 1
	
func move_down():
	velocity = Vector2()
	velocity.y += 1
	
func move_right():
	velocity = Vector2()
	velocity.x += 1
	
func move_left():
	velocity = Vector2()
	velocity.x -= 1
	
func down_just_released():
	print("Down Just Released")
	
func up_just_pressed():
	print("Up Just Pressed")

func save_game():
	SaveManager.save_game()
	#set_process(false) # Replace with a Game Manager that disables handling

func change_scene():
	SceneManager.goto_scene(destination, -1)
	#set_process(false) # Replace with a Game Manager that disables handling

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
