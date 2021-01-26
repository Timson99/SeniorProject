extends StaticBody2D

export var actor_id = "exit_door"

onready var anim = $AnimatedSprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Actor")
	anim.play("closed")
	
func close():
	anim.play("closed")
	
func open():
	print("OPEN CALLED")
	anim.play("open")



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
