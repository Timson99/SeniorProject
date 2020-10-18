extends Node


export var persistence_id := "C1" #Can't be a number or mistakeable for a non string type
export var alive := true
var skills = {} #"Skill" : Num_LP
var stats := EntityStats.new()
var temp_battle_stats := EntityStats.new()


var moveset = null #Generated


func on_load():
	var temp_battle_stats = stats
	
func save():
	var save_dict = {
		"persistence_id" : persistence_id,
		"stats" : stats,
		"skills" : skills,
		"alive" : alive
	}	
	return save_dict


