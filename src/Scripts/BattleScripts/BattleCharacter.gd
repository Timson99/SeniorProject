extends Control


export var persistence_id := "C1" #Can't be a number or mistakeable for a non string type
var input_id := "Battle_Menu"

onready var battle_brain = SceneManager.current_scene
onready var menu = null
onready var anim_player = $UI/AnimatedSprite
onready var name_label = $UI/Name
onready var HP_Bar : ProgressBar = $UI/HP_Bar
onready var SP_Bar : ProgressBar = $UI/SP_Bar


export var alive := true
var skills = {} #"Skill" : Num_LP
onready var stats := EntityStats.new(BaseStats.get_for(persistence_id))
onready var temp_battle_stats = stats



var module_rise := 2

var party_data = null

var enemy_select_mode = false

signal move(move)

func _ready():	
	pass
	
func on_load():
	menu = battle_brain.dialogue_node.get_node("Menu")
	menu.selector = self
	menu.hide()
	
	var temp_battle_stats = stats
	
	
	
func _process(_delta):
	HP_Bar.max_value = stats.MAX_HP
	HP_Bar.min_value = 0
	HP_Bar.value = stats.HP
	HP_Bar.get_node("HP_Num").text = str(stats.HP)
	
	SP_Bar.max_value = stats.MAX_SP
	SP_Bar.min_value = 0
	SP_Bar.value = stats.SP
	SP_Bar.get_node("SP_Num").text = str(stats.SP)
											
enum Mode {Inactive, Menu, Enemy_Select}
var current_mode = Mode.Inactive

	
func test_command1():
	pass
	
func back():
	if current_mode == Mode.Menu:
		menu.back()
	elif current_mode == Mode.Enemy_Select:
		battle_brain.enemy_party.deselect_current()
		InputEngine.deactivate_receiver(self)
		#Anim Menu Open (Menu Sprite Relocated)
		#OLD anim_player.play("Display_To_Menu")
		#OLD yield(anim_player, "animation_finished")
		#anim_player.stop()
		#anim_player.animation = "Menu"
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
				menu.hide()
				menu.reset(false)
				current_mode = Mode.Enemy_Select
				battle_brain.enemy_party.select_current()
	elif current_mode == Mode.Enemy_Select:
		var selected_enemy = battle_brain.enemy_party.get_selected_enemy()
		battle_brain.enemy_party.deselect_current()
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
		menu.left()
	elif current_mode == Mode.Enemy_Select:
		battle_brain.enemy_party.select_left()


func right():
	if current_mode == Mode.Menu:
		menu.right()
	elif current_mode == Mode.Enemy_Select:
		battle_brain.enemy_party.select_right()
	
func release_up():
	menu.release_up()
	
func release_down():
	menu.release_down()
	
func release_left():
	menu.release_left()
	
func release_right():
	menu.release_right()
	

func activate_player():
	$UI.position.y -= module_rise
	#Animate enu, relocaed
	#anim_player.play("Display_To_Menu")
	#yield(anim_player, "animation_finished")
	#anim_player.stop()
	#anim_player.animation = "Menu"
	menu.show()
	current_mode = Mode.Menu
	InputEngine.activate_receiver(self)
	
	
# When followed or incapacitated, player is an AI follower
func deactivate_player():
	InputEngine.deactivate_receiver(self)
	$UI.position.y += module_rise
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


