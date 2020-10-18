extends Control


export var persistence_id := "C1" #Can't be a number or mistakeable for a non string type
var input_id := "Battle_Menu"

export var alive := true
var skills = {} #"Skill" : Num_LP
var stats := EntityStats.new()
var temp_battle_stats := EntityStats.new()

var party_data = null


var moveset = null #Generated

signal move(move)

func _ready():
	pass	
	
func _process(_delta):
	$UI/RichTextLabel.text = ("HP: %d/%d\nSP: %d/%d" % [stats.get_stats()["HP"], 
											stats.get_stats()["MAX HP"], 
											stats.get_stats()["SP"], 
											stats.get_stats()["MAX SP"]] )


func on_load():
	var temp_battle_stats = stats
	
func test_command1():
	emit_signal("move", "Attack")
	
	

func activate_player():
	InputEngine.activate_receiver(self)
	$UI.position.y -= 5;
	
# When followed or incapacitated, player is an AI follower
func deactivate_player():
	InputEngine.deactivate_receiver(self)
	$UI.position.y += 5;
	
func save():
	var save_dict = {
		"persistence_id" : persistence_id,
		"stats" : stats,
		"skills" : skills,
		"alive" : alive
	}	
	return save_dict


