extends Control


export var persistence_id := "C1" #Can't be a number or mistakeable for a non string type
var input_id := "Battle_Menu"

onready var menu = $UI/MainMenu
onready var anim_player = $UI/AnimatedSprite

export var alive := true
var skills = {} #"Skill" : Num_LP
onready var stats := EntityStats.new(BaseStats.get_for(persistence_id))
onready var temp_battle_stats := stats

var module_rise := 2

var party_data = null

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
	pass
	
func accept():
	var command = menu.accept()
	emit_signal("move", command)
	
	
func up():
	menu.up()
	
func down():
	menu.down()
	
func release_up():
	menu.release_up()
	
func release_down():
	menu.release_down()
	

func activate_player():
	$UI.position.y -= module_rise
	anim_player.play("Display_To_Menu")
	yield(anim_player, "animation_finished")
	anim_player.stop()
	anim_player.animation = "Menu"
	menu.show()
	InputEngine.activate_receiver(self)
	
	
# When followed or incapacitated, player is an AI follower
func deactivate_player():
	InputEngine.deactivate_receiver(self)
	$UI.position.y += module_rise
	anim_player.animation = "Display"
	menu.hide()
	menu.reset()
	
func save():
	var save_dict = {
		"persistence_id" : persistence_id,
		"stats" : stats,
		"skills" : skills,
		"alive" : alive
	}	
	return save_dict


