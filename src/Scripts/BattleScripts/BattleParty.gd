extends Node


export var persistence_id := "main_party"
export var C2_in_party = true
export var C3_in_party = true
var items := []

func _ready():
	pass # Replace with function body.


func save():
	var save_dict = {
		"persistence_id" : persistence_id,
		#"C1_in_party" : C1_in_party,
		"C2_in_party" : C2_in_party,
		"C3_in_party" : C3_in_party,
		"items" : items,
	}	
	return save_dict
