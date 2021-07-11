extends SelectionInterface

class_name DiscreteSelection

		
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


