extends Node

class_name Custom_YSort


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func ysort(a,b):
	if(a.name == "Party"):
		if a.active_player.get_global_position().y < b.position.y:
			return true
		return false
	elif(b.name == "Party"):
		if a.position.y < b.active_player.get_global_position().y:
			return true
		return false
	else:
		if a.position.y < b.position.y:
			return true
		return false

# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	var list = get_children()
	list.sort_custom(self, "ysort")
		
	for i in range(list.size()):
		if(list[i].get_index() != i ):
			move_child(list[i], i)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
