extends SelectionInterface

class_name DiscreteSelection


# Removes visual aids used to create UI in scene view
func _ready():
	if selection_format == Format.VERTICAL:   container_node = $VBoxContainer
	if selection_format == Format.HORIZONTAL: container_node = $HBoxContainer
	if selection_format == Format.GRID: 	  container_node = $GridContainer
		
func activate():
	show()
	InputManager.activate(self)
	
	for node in container_node.get_children():
		node.deselect()
		
	if !no_initial_selection:
		selected_index = default_selected_index
		select()
	else: 
		selected_index = null
	
	
			
################################################################


