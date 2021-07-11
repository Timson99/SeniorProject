extends SelectionInterface

class_name AutoSelection


onready var prototype_item = $SelectablePrototype

# Removes visual aids used to create UI in scene view
func _ready():
	for node in [$VBoxContainer, $HBoxContainer, $GridContainer]:
		for n in node.get_children():
			n.free() # Must free stand-ins immediately
	prototype_item.get_node("AnimatedSprite").play("deselected")
	prototype_item.hide()
	
	if selection_format == Format.VERTICAL:   container_node = $VBoxContainer
	if selection_format == Format.HORIZONTAL: container_node = $HBoxContainer
	if selection_format == Format.GRID: 	  container_node = $GridContainer
	
	
# Creates selection list from a list of strings
func activate(str_list : Array ):
	show()
	InputManager.activate(self)
	
	for i in range( 0, str_list.size() ):
		var new_item = prototype_item.duplicate()
		new_item.name = str(i)
		container_node.add_child(new_item)
		new_item.get_node("RichTextLabel").text = str_list[i]
		new_item.show()
		
	if !no_initial_selection:
		selected_index = default_selected_index
		select()
	else: 
		selected_index = null
			
			
################################################################


