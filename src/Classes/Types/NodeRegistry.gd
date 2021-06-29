"""
	NodeRegistry Object
		
	Wrapper for a Array holding scene nodes
	Underlying Array may be sorted or modified to act like a Stack/Queue/Priority Queue
	An object to catalogue to nodes that register themselves and want to be tracked
	Automatically removes all deleted nodes when object is used
	
	Prohibits -> 
		Nodes without the specified id property
		Empty string id's
		Duplicate id's
"""

extends Object

class_name NodeRegistry

var nodes = [] setget set_nodes,get_nodes
var id_property_name := ""

# Variable name used to identify the registered node
func _init(id_name := "name"):
	self.id_property_name = id_name

func get_nodes():
	_update_nodes()
	return nodes
	
func set_nodes(new_nodes : Array):
	nodes = new_nodes
	_update_nodes()
	
# makes sure it has the identifier
# Checks for duplicates and prevents them
func register(new_node):
	_update_nodes()
	# Prohibit Nodes without proper identifier
	if !(id_property_name in new_node):
		Debugger.dprint("ERROR: CAN'T REGISTER NODE - No '%s' property in Node '%s'" 
						% [id_property_name, new_node.name])
		return
	# Prohibit Nodes without empty string id
	if new_node.get(id_property_name) == "":
		Debugger.dprint("ERROR: CAN'T REGISTER NODE '%s' WITH EMPTY STRING FOR ID '%s'" 
						% [new_node.name, id_property_name])
		return
	# Prohibit Duplicate Nodes
	for node in nodes:
		if node.get(id_property_name) == new_node.get(id_property_name):
			Debugger.dprint("ERROR: CAN'T REGISTER NODE - %s '%s' is a duplicate in node '%s'" 
							% [id_property_name, new_node.get(id_property_name), new_node.name], 5)
			return
	nodes.push_back(new_node)
	
	
func deregister(exiting_node):
	_update_nodes()
	for i in range(nodes.size() - 1, -1, -1):
		if nodes[i] == exiting_node:
			nodes.remove(i)
			
# Fetch node by id or return null
func fetch(id : String):
	for node in nodes:
		if is_instance_valid(node) && id == node.get(id_property_name):
			return node
	return null
	
# Returns true if registry has node by id
func has(id : String) -> bool:
	for node in nodes:
		if is_instance_valid(node) && id == node.get(id_property_name):
			return true
	return false

# Removed invalid instances that may have been deleted
func _update_nodes():
	for i in range(nodes.size() - 1, -1, -1):
		if !is_instance_valid(nodes[i]):
			nodes.remove(i)
	
	

	
