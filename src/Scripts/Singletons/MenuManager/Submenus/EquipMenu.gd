extends CanvasLayer

var submenu = null
var parent = null

onready var button_container = $Categories

var list_path = "res://Scripts/Singletons/MenuManager/Submenu_Modules/Lists/EquipList.tscn"

var input_id = "Menu"
var curr_char = "C1"
var char_params = {}
var sprite = null

var default_focused = 0
var focused = default_focused
var buttons = []
	
func _ready():
	_setup_char()
	for button in button_container.get_children():
		buttons.append(button) 
		refocus(0)
	pass
	
func update_field(item):
	#Calls something like Character.equip(item)
	var text = buttons[focused].get_node("Current").text.split(" ")
	text.resize(1)
	text.append(item)
	buttons[focused].get_node("Current").text = text.join(" ")
	print("Chose ", item)
	
func _setup_char():
	$Character/Name.text = curr_char
	$Character.set_texture(sprite)
	$Character/Level.text = str("Level: ", char_params.get("LEVEL"))

func refocus(to):
	if to >=0 and to < len(buttons):
		buttons[focused].get_node("AnimatedSprite").animation = "unfocused"
		buttons[to].get_node("AnimatedSprite").animation = "focused"
		focused = to
func back():
	if submenu:
		submenu.back()
	else:
		queue_free()
		parent.submenu = null
		
func accept():
	if submenu:
		submenu.accept()
	else:
		submenu = load(list_path).instance()
		call_deferred("add_child", submenu)
		submenu.data_source = MenuManager.skill_data if focused==2 else MenuManager.item_data
		submenu.data= MenuManager.skill_data if focused==2 else MenuManager.party.items
		submenu.layer = layer + 1
		submenu.parent = self
		

func up():
	if submenu:
		submenu.up()
	else:
	   refocus(focused-1)
	
func down():
	if submenu:
		submenu.down()
	else:
		refocus(focused+1)

func left():
	if submenu:
		submenu.left()
	pass
func right():
	if submenu:
		submenu.right()
	pass
func r_trig():
	if submenu:
		submenu.r_trig()
	else:
		back()
		parent.down()
		parent.accept()
	
func l_trig():
	if submenu:
		submenu.l_trig()
	else:
		back()
		parent.up()
		parent.accept()
