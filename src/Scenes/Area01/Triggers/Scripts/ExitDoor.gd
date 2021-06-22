extends StaticBody2D

onready var anim = $AnimatedSprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	ActorManager.register_actor(self)
	anim.play("closed")
	
func close():
	anim.play("closed")
	
func open():
	anim.play("open")



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
