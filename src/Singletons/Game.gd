extends Node

func validate( name : String ):
	return get_tree().get_root().get_node(name)
