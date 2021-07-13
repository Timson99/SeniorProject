extends SelectionInterface

class_name DiscreteSelection

#############
#	Public 
#############

# Prepares/Validates selection list and shows it
func activate():
	var container_children = container_node.get_children()
	assert(container_children.size() != 0, 
		"DiscreteSelection must have nonzero children")
	
	for node in container_children:
		node.deselect()
		
	_show_selection()


