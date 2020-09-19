extends Sprite

export var speed := 300
onready var screen_size := get_viewport_rect().size
var persistance_id := "this_id" #Can't be a number or mistakeable for a non string type

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta : float):
	#####################################################
	if(Input.is_key_pressed(KEY_S)):
		print("Saving...")
		SaveManager.save_game()
		#set_process(false) # Replace with a Game Manager that disables handling
	########################################################
	if(Input.is_key_pressed(KEY_F)):
		SceneManager.goto_scene("res://Scenes/Test_Scenes/Opening2.tscn", -1)
		set_process(false) # Replace with a Game Manager that disables handling
	######################################################
	var velocity := Vector2()
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	velocity = velocity.normalized() * speed
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	#####################################################

	
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
		

	
	
	
