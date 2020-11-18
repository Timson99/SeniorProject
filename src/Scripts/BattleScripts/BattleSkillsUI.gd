extends CanvasLayer

var submenu = null
var parent = null

onready var base = $Control/Battle_UI_v2_05
onready var button_container = $Control/Battle_UI_v2_05/ItemList/GridContainer
onready var description_container = $Control/Battle_UI_v2_05/ItemList/InfoPanel/RichDescription
onready var scrollbar = $Control/Battle_UI_v2_05/ItemList/Scrollbar

var input_id = "Menu"
var default_focused = 0
var focused = default_focused
var buttons = []
var items = []
var scroll_level = 0
var btn_ctnr_size = 12
var button_path = "res://Scripts/Singletons/MenuManager/Submenu_Modules/Buttons/ItemButton.tscn"
var popup_path = "res://Scenes/Battle_Scenes/General/Popups/EffectPopup_Battle.tscn"

var party = null
#Must set data sources to valid source
#var data_source=MenuManager.item_data
#var data = MenuManager.party.items

var data_source= MenuManager.skill_data
var data = MenuManager.skill_data


var num_cols = 2

var sc_start =0
var scrollbar_size = 2
var scrollbar_offset = 0
var max_sc_offset = 92
var offset_size = max_sc_offset/5

# const api_script = preload("res://Scripts/BattleScripts/BattleCharacter.gd")
# const api = api_script.new()

onready var battle_brain = SceneManager.current_scene
var menu = null
enum Mode {Inactive, Menu, Enemy_Select, Character_Select}
var current_mode = Mode.Inactive


func _ready():
	menu= battle_brain.dialogue_node.get_node("Menu")
	#There may be a better way to get this data via singleton maybe...
	_instantiate_items()
	_update_buttons()
	_repopulate_btn_container()
	refocus(focused)
	_update_scrollbar()

func _use_skill(chara):
	print("Used ", buttons[focused].item_name, " on ", chara)

func refocus(to):
	if to >=0 and to < len(buttons):
		if focused>=0:
			buttons[focused].get_node("AnimatedSprite").animation = "unfocused"
		buttons[to].get_node("AnimatedSprite").animation = "focused"
		focused = to
		#can update to use funcref to be reusable
		update_description(_get_item(to))

func unfocus():
	buttons[focused].get_node("AnimatedSprite").animation = "unfocused"
	focused = -1

func update_description(item):
	var description = item["Description"]
	#for val in item :
		#description = str(description,"\t",val," : ", item[val])
	description_container.text = description

func even(num):# can adjust condition to fit any number of columns
	return num%2 ==0

func scroll(direction):
	if direction == "down":
		if(scroll_level+btn_ctnr_size < len(items)):
			scroll_level += num_cols
		_move_scrollbar("down")
	else:
		if(scroll_level >= 1):
			scroll_level -= num_cols
			_move_scrollbar("up")
	_update_buttons()
	_repopulate_btn_container()



func _update_scrollbar():
	var middle = scrollbar.get_node("middle")
	sc_start = middle.get_position()
	scrollbar_offset = sc_start.y
	var prop_size = (float(len(buttons))/len(items))*max_sc_offset
	middle.set_scale(Vector2(1,prop_size/scrollbar_size))
	scrollbar_size = prop_size

	scrollbar.get_node("bottom").set_position(middle.get_position()+Vector2(0,scrollbar_size))
	var hidden_rows= ((len(items)-btn_ctnr_size)/num_cols)
	if num_cols>1 and not even(len(items)):
		hidden_rows +=1
	offset_size = float(max_sc_offset - scrollbar_size)/hidden_rows


func _move_scrollbar(direction):
	scrollbar_offset += offset_size if direction == "down" else -offset_size
	scrollbar.get_node("top").set_position(Vector2(sc_start.x,scrollbar_offset-1))
	scrollbar.get_node("middle").set_position(Vector2(sc_start.x,scrollbar_offset))
	scrollbar.get_node("bottom").set_position(Vector2(sc_start.x,scrollbar_offset+scrollbar_size))


func _instantiate_items():
	for item in data:
		_add_item(item)

func _add_item(item):
	items.append(item)

func _update_buttons():
	buttons= []
	for i in range(btn_ctnr_size):
		var item_ix = i+scroll_level
#		print(item_ix)
		if item_ix <len(items):
			_add_item_button(items[item_ix])
		else:
			break

func _add_item_button(item):
	var button = load(button_path).instance()
	#print(item)
	button._setup(item)
	buttons.append(button)


func _repopulate_btn_container():
	_clear_btn_container()
	_populate_btn_container()

func _populate_btn_container():
	for i in range(len(buttons)):
		var button = buttons[i]
		button_container.add_child(button)

func _clear_btn_container():
	for child in button_container.get_children():
		#queue_free() is preferable for standards,
		#but it makes the scrolling glitch out.
		child.free()
func get_focused():
	return _get_item(focused)

func _get_item(ix):
	return data_source.get(buttons[ix].item_name)


func back():
	if current_mode != Mode.Inactive:
		if current_mode  == Mode.Character_Select:
			battle_brain.character_party.deselect_current()
		elif current_mode == Mode.Enemy_Select:
			battle_brain.enemy_party.deselect_current()
		current_mode = Mode.Inactive
		base.show()
	elif submenu:
		submenu.back()
	else:
		menu.reset(false)
		menu.show()
		queue_free()
#		parent.submenu = null

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
		# back()
	elif submenu:
		submenu.accept()
	else:
		base.hide()
		if get_focused().get("Target") == "ally": #something like this
			battle_brain.character_party.select_current()
			current_mode = Mode.Character_Select
		else:
			battle_brain.enemy_party.select_current()
			current_mode = Mode.Enemy_Select
		menu.reset(false)


func up():
	if current_mode == Mode.Enemy_Select:
		battle_brain.enemy_party.select_up()
	elif submenu:
		submenu.up()
	else:
		var next_focused = focused - num_cols
	#	print(next_focused, " ", scroll_level)
		if next_focused < 0 and next_focused+(scroll_level+1)>=0:
				scroll("up")
				next_focused+= num_cols
		if next_focused >=0:
			refocus(next_focused)



func down():
	if current_mode == Mode.Enemy_Select:
		battle_brain.enemy_party.select_down()
	elif submenu:
		submenu.down()
	else:
		#is more complicated because it must deal with odd
		#numbers of items in the list
		var next_focused = focused + num_cols

		if next_focused >= btn_ctnr_size and next_focused+(scroll_level+1)<=len(items):
			scroll("down")
			next_focused-=num_cols
		else:
			for i in range(num_cols):
				if focused == btn_ctnr_size-i and next_focused-i >= btn_ctnr_size and next_focused+(scroll_level)<=len(items):
					scroll("down")
					focused -=i
					next_focused-=num_cols+i
					break
		if next_focused+(scroll_level+1)<=len(items) and next_focused <= btn_ctnr_size-1:
			refocus(next_focused)


func left():
	if current_mode == Mode.Enemy_Select:
		battle_brain.enemy_party.select_left()
	elif current_mode == Mode.Character_Select:
		battle_brain.character_party.select_left()
	elif submenu:
		submenu.left()
	elif num_cols>1:
		var next_focused = focused - 1
		if even(next_focused):
			refocus(next_focused)


func right():
	if current_mode == Mode.Enemy_Select:
		battle_brain.enemy_party.select_right()
	elif current_mode == Mode.Character_Select:
		battle_brain.character_party.select_right()
	elif submenu:
		submenu.right()
	elif num_cols>1:
		var next_focused = focused + 1
		if not even(next_focused) and next_focused <= len(buttons)-1:
			refocus(next_focused)
