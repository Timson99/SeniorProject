extends Control


export var persistence_id := "C1" #Can't be a number or mistakeable for a non string type
var input_id := "Battle_Menu"

onready var menu = $UI/MainMenu
onready var anim_player = $UI/AnimatedSprite

export var alive := true
var skills = {} #"Skill" : Num_LP
onready var stats := EntityStats.new(BaseStats.get_for(persistence_id))
onready var temp_battle_stats := stats

var enemy_party = null

var module_rise := 2

var party_data = null

var enemy_select_mode = false

signal move(move)

func _ready():
	menu.parent = self	
	
func _process(_delta):
	$UI/RichTextLabel.text = ("HP: %d/%d\nSP: %d/%d" % [stats.get_stats()["HP"], 
											stats.get_stats()["MAX HP"], 
											stats.get_stats()["SP"], 
											stats.get_stats()["MAX SP"]] )


func on_load():
	var temp_battle_stats = stats
	
func test_command1():
	pass
	
func back():
	if !enemy_select_mode:
		menu.back()
	else:
		InputEngine.deactivate_receiver(self)
		anim_player.play("Display_To_Menu")
		yield(anim_player, "animation_finished")
		anim_player.stop()
		anim_player.animation = "Menu"
		menu.show()
		enemy_select_mode = false
		InputEngine.activate_receiver(self)
		
	
func accept():
	if !enemy_select_mode:
		var command = menu.accept()
		#If accept didn't just open another submenu, and returned a command
		if command != null:
			if command in ["Run", "Defend"]:
				emit_signal("move", command)
			else:
				enemy_select_mode = true
				anim_player.animation = "Display"
				menu.hide()
				menu.reset(false)
				enemy_party = SceneManager.current_scene.enemy_party
				enemy_select_mode = true
				#emit_signal("move", command)
	
	
func up():
	if !enemy_select_mode:
		menu.up()
	
func down():
	if !enemy_select_mode:
		menu.down()
	
		
func left():
	if !enemy_select_mode:
		menu.up()
	else:
		pass
	
func right():
	if !enemy_select_mode:
		menu.down()
	else:
		pass
	
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
	enemy_party = null
	
func save():
	var save_dict = {
		"persistence_id" : persistence_id,
		"stats" : stats,
		"skills" : skills,
		"alive" : alive
	}	
	return save_dict


