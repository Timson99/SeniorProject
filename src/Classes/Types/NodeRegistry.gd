"""
	Wrapper for a List/Stack/Dictionary/PQueue holding scene nodes
	An object to catalogue to nodes that register themselves and want to be tracked
"""

extends Object

class_name NodeRegistry

var nodes = [] setget set_nodes,get_nodes
var id_property_name := ""

# Variable name used to identify the registered node
func _init(id_property_name : String):
	self.id_property_name = id_property_name

func get_nodes():
	_update_nodes()
	return nodes
	
func set_nodes(new_nodes : Array):
	_update_nodes()
	nodes = new_nodes
	
# makes sure it has the identifier
# Checks for duplicates and prevents them
func register(new_node):
	_update_nodes()
	# Prohibit Nodes without proper identifier
	if !(id_property_name in new_node):
		Debugger.dprint("ERROR: CAN'T REGISTER NODE - No '%s' property in Node" % id_property_name)
		return
	# Prohibit Duplicate Nodes
	for node in nodes:
		if node.get(id_property_name) == new_node.get(id_property_name):
			Debugger.dprint("ERROR: CAN'T REGISTER NODE - ID '%s' is a duplicate" % new_node.get(id_property_name))
	nodes.push_back(new_node)
	
func fetch(id : String):
	_update_nodes()
	for node in nodes:
		if id == node.get(id_property_name):
			return node
	return null

# Removed invalid instances that may have been deleted
func _update_nodes():
	for i in range(nodes.size() - 1, -1, -1):
		if !is_instance_valid(nodes[i]):
			nodes.remove(i)
	
	

	
