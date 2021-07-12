extends SelectionInterface

class_name AutoSelection


export (PackedScene) var selectable_scene
var prototype_selectable


func _ready():
	prototype_selectable = selectable_scene.instance()
	

#############
#	Public 
#############

# Creates selection list from a list of strings
func activate(str_list : Array ):
	
	# Removes Visual Aids and/or previous lists
	for n in container_node.get_children():
		n.free() # Must free stand-ins immediately
	prototype_selectable.deselect()
	prototype_selectable.hide()
	
	# Initialiize group
	for i in range( 0, str_list.size() ):
		var new_item = prototype_selectable.duplicate()
		new_item.name = str(i)
		container_node.add_child(new_item)
		new_item.set_value(str_list[i])
		new_item.show()
		
	prototype_selectable.queue_free()
	_show_selection()
	
# Update the selection while keeping the same entry focused
func update_selection(str_list : Array):
	var saved_selected_index = selected_index
	deactivate()
	activate(str_list)
	selected_index = saved_selected_index
	_validify_selected_index()
	_select_current()


