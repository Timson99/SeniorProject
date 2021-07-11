extends SelectionInterface

class_name DiscreteSelection


# Removes visual aids used to create UI in scene view
func _ready():
	for node in container_node.get_children():
		node.deselect()
	
	
# Creates selection list from a list of strings
func create():
	InputManager.activate(self)
	
	if selection_format == Format.VERTICAL:   container_node = $VBoxContainer
	if selection_format == Format.HORIZONTAL: container_node = $HBoxContainer
	if selection_format == Format.GRID: 	  container_node = $GridContainer
		
	if !no_initial_selection:
		selected_index = default_selected_index
		select()
			
			
################################################################


