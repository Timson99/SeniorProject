extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#pass
	print(scale)
	material.set_shader_param("sprite_scale",scale)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
