extends Control


export var persistence_id := "C1" #Can't be a number or mistakeable for a non string type
var input_id := "Battle_Menu"

onready var menu = $UI/MainMenu
onready var anim_player = $UI/AnimatedSprite

export var alive := true
var skills = {} #"Skill" : Num_LP
onready var stats := EntityStats.new(BaseStats.get_for(persistence_id))
onready var temp_battle_stats = stats

onready var battle_brain = SceneManager.current_scene

var module_rise := 2

var party_data = null

var enemy_select_mode = false

signal move(move)

func _ready():
	menu.parent = self	
	
func _process(_delta):
	$UI/RichTextLabel.text = ("HP: %d/%d\nSP: %d/%d" % [stats.HP, 
											stats.MAX_HP, 
											stats.SP, 
											stats.MAX_SP ] )
											
enum Mode {Inactive, Menu, Enemy_Select}
var current_mode = Mode.Inactive


func on_load():
	var temp_battle_stats = stats
	
func test_command1():
	pass
	
func back():
	if current_mode == Mode.Menu:
		menu.back()
	elif current_mode == Mode.Enemy_Select:
		battle_brain.enemy_party.deselect_current()
		InputEngine.deactivate_receiver(self)
		anim_player.play("Display_To_Menu")
		yield(anim_player, "animation_finished")
		anim_player.stop()
		anim_player.animation = "Menu"
		menu.show()
		current_mode = Mode.Menu
		InputEngine.activate_receiver(self)
		
var saved_command

func accept():
	if current_mode == Mode.Menu:
		var command = menu.accept()
		#If accept didn't just open another submenu, and returned a command
		if command != null:
			if command in ["Run", "Defend"]:
				emit_signal("move", BattleMove.new(self, command))
			else:
				saved_command = command
				anim_player.animation = "Display"
				menu.hide()
				menu.reset(false)
				current_mode = Mode.Enemy_Select
				battle_brain.enemy_party.select_current()
				#emit_signal("move", command)
	elif current_mode == Mode.Enemy_Select:
		battle_brain.enemy_party.deselect_current()
		var selected_enemy = battle_brain.enemy_party.get_selected_enemy()
		emit_signal("move", BattleMove.new(self, saved_command, selected_enemy))
	
	
	
func up():
	if current_mode == Mode.Menu:
		menu.up()
	elif current_mode == Mode.Enemy_Select:
		battle_brain.enemy_party.select_up()
	
func down():
	if current_mode == Mode.Menu:
		menu.down()
	elif current_mode == Mode.Enemy_Select:
		battle_brain.enemy_party.select_down()
	
		
func left():
	if current_mode == Mode.Menu:
		menu.up()
	elif current_mode == Mode.Enemy_Select:
		battle_brain.enemy_party.select_left()
	
func right():
	if current_mode == Mode.Menu:
		menu.down()
	elif current_mode == Mode.Enemy_Select:
		battle_brain.enemy_party.select_right()
	
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
	current_mode = Mode.Menu
	InputEngine.activate_receiver(self)
	
	
# When followed or incapacitated, player is an AI follower
func deactivate_player():
	InputEngine.deactivate_receiver(self)
	$UI.position.y += module_rise
	anim_player.animation = "Display"
	menu.hide()
	menu.reset()
	current_mode = Mode.Inactive
	
func save():
	var save_dict = {
		"persistence_id" : persistence_id,
		"stats" : stats,
		"skills" : skills,
		"alive" : alive
	}	
	return save_dict


