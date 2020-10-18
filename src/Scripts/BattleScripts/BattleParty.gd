extends Node


export var persistence_id := "main_party"
export var C2_in_party = false
export var C3_in_party = false
var items := []

var Battle_Brain = null

func on_load():
	Battle_Brain.update_character_party()
	


func save():
	var save_dict = {
		"persistence_id" : persistence_id,
		#"C1_in_party" : C1_in_party,
		"C2_in_party" : C2_in_party,
		"C3_in_party" : C3_in_party,
		"items" : items,
	}	
	return save_dict
