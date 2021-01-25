extends Control

export var persistence_id = "Boss"
export var alive := true
var stats = EntityStats.new()


var moveset = null

func _ready():
	add_to_group("Persistence")
	
func on_load():
	var temp_battle_stats #= stats

# Called upon enemy's defeat
func deactivate_enemy():
	# Indicate enemy's defeat and remove sprite from party
	pass 
	
func save():
	return {
		"persistence_id" : persistence_id,
		"alive" : alive, 
	}
