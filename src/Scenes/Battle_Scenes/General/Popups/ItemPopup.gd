extends CanvasLayer
var input_id = "Menu"
var submenu = null
var parent = null

onready var base = $Control
onready var btn_container = $Control/VBoxContainer
var choice_path = "res://Scenes/Battle_Scenes/General/Popups/EffectPopup_Battle.tscn"
var item = null
var buttons = []
var focused = 0

onready var battle_brain = SceneManager.current_scene
var menu = null
enum Mode {Inactive, Menu, Enemy_Select, Character_Select}
var current_mode = Mode.Inactive


func _ready():
	menu= battle_brain.dialogue_node.get_node("Menu") 
	buttons = btn_container.get_children()
	refocus(0)
func _use_skill(chara):
	print("Used ", item.item_name, " on ", chara)

func refocus(to):
	if to >=0 and to < len(buttons):
		buttons[focused].get_node("AnimatedSprite").animation = "unfocused"
		buttons[to].get_node("AnimatedSprite").animation = "focused"
		focused = to

func reposition(new_pos):
#	print(new_pos)
	$Control.set_position(new_pos)

func discard():
	print(item.item_name," was discarded.")
	#item.discard(1) something along these lines
	pass

func up():
	if current_mode == Mode.Enemy_Select:
		battle_brain.enemy_party.select_up()
	elif submenu:
		submenu.up()
	refocus(0)

func down():
	if current_mode == Mode.Enemy_Select:
		battle_brain.enemy_party.select_down()
	elif submenu:
		submenu.down()
	refocus(1)

func left():
	if current_mode == Mode.Enemy_Select:
		battle_brain.enemy_party.select_left()
	elif current_mode == Mode.Character_Select:
		battle_brain.character_party.select_left()
	elif submenu:
		submenu.left()
	pass
func right():
	if current_mode == Mode.Enemy_Select:
		battle_brain.enemy_party.select_right()
	elif current_mode == Mode.Character_Select:
		battle_brain.character_party.select_right()
	elif submenu:
		submenu.right()
	pass

func accept():
	if current_mode != Mode.Inactive:
		var selected_character = null
		if current_mode  == Mode.Character_Select:
			selected_character = battle_brain.character_party.get_selected_character()
			battle_brain.character_party.deselect_current()
		elif current_mode == Mode.Enemy_Select:
			selected_character = battle_brain.enemy_party.get_selected_enemy()
			battle_brain.enemy_party.deselect_current()
		#Use Skill, we can use a signal or something if we get an item manager of sorts ...
		_use_skill(selected_character.screen_name)
		#to get back to menu
		back()
		#reset the menu
		#This time it will exit out of the submenu only used if one usage allowed per turn
		back()
	elif submenu:
		submenu.accept()
		back()
	#can be done with enum, but may be too much trouble for
	#two buttons that can be done as a binary
	elif focused ==0:
		#Use this block if we want to use a submenu list
		# submenu = load(choice_path).instance()
		# call_deferred("add_child", submenu)
		# submenu.reposition($Control.get_position())
		# submenu.item = item
		# submenu.layer = layer + 1
		# submenu.parent = self
		parent.base.hide()
		base.hide()
		print(item)
		if parent.get_focused().get("Target") == "ally": #something like this
			battle_brain.character_party.select_current()
			current_mode = Mode.Character_Select
		else:
			battle_brain.enemy_party.select_current()
			current_mode = Mode.Enemy_Select
		menu.reset(false)
	else:
		discard() #TODO
		back()

func back():
	if current_mode != Mode.Inactive:
		if current_mode  == Mode.Character_Select:
			battle_brain.character_party.deselect_current()
		elif current_mode == Mode.Enemy_Select:
			battle_brain.enemy_party.deselect_current()
		current_mode = Mode.Inactive
		parent.base.show()
		base.show()
	elif submenu:
		submenu.back()
	else:
		queue_free()
		parent.submenu = null
