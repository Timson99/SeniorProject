extends CanvasLayer
var input_id = "Menu" 
var submenu = null
var parent = null

onready var btn_container = $Control/VBoxContainer

var item = null
var buttons = []
var focused = 0

func _ready():
	buttons = btn_container.get_children()
	refocus(0)

func refocus(to):
	if to >=0 and to < len(buttons):
		buttons[focused].get_node("AnimatedSprite").animation = "unfocused" 
		buttons[to].get_node("AnimatedSprite").animation = "focused"
		focused = to

func use_item():
	print(item.item_name, " was used by character ", focused)
	#item.affect(PersistentData.characters[focused]) something like this
	pass

func reposition(new_pos):
	$Control.set_position(new_pos)

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
	
func accept():
	if submenu:
		submenu.accept()
	else:
		use_item()
		back()
		parent.back()

func back():
	if submenu:
		submenu.back()
	queue_free()
	parent.submenu = null
