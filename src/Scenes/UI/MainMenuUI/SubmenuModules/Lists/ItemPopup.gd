extends CanvasLayer
var input_id = "Menu" 
var submenu = null
var parent = null



onready var btn_container = $Control/VBoxContainer
var choice_path = "res://Scenes/UI/MainMenuUI/SubmenuModules/Lists/EffectPopup.tscn"
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

func reposition(new_pos):
#	print(new_pos)
	$Control.set_position(new_pos)

func discard():
	print(item.item_name," was discarded.")
	#item.discard(1) something along these lines
	pass

func up():
	if submenu:
		submenu.up()
	refocus(0)
	
func down():
	if submenu:
		submenu.down()
	refocus(1)

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
		back()
	#can be done with enum, but may be too much trouble for
	#two buttons that can be done as a binary
	elif focused ==0:
		submenu = load(choice_path).instance()
		call_deferred("add_child", submenu)
		submenu.reposition($Control.get_position())
		submenu.item = item
		submenu.layer = layer + 1
		submenu.parent = self
	else:
		discard() #TODO
		back()

func back():
	if submenu:
		submenu.back()
	else:
		queue_free()
		parent.submenu = null
