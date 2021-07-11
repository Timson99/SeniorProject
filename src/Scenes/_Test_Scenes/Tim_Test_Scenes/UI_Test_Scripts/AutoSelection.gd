extends SelectionInterface

class_name AutoSelection


export (PackedScene) var selectable_scene

# Creates selection list from a list of strings
func activate(str_list : Array ):
	
	var prototype_selectable = selectable_scene.instance()
	# Removes Visual Aids and/or previous lists
	for n in container_node.get_children():
		n.free() # Must free stand-ins immediately
	prototype_selectable.get_node("AnimatedSprite").play("deselected")
	prototype_selectable.hide()
	
	for i in range( 0, str_list.size() ):
		var new_item = prototype_selectable.duplicate()
		new_item.name = str(i)
		container_node.add_child(new_item)
		new_item.get_node("RichTextLabel").text = str_list[i]
		new_item.show()
		
	prototype_selectable.queue_free()
		
	initialize()
			
			
################################################################


