extends CanvasLayer
var input_id = "Menu" 
var submenu = null
var parent = null

onready var btn_container = $Control/VBoxContainer
var buttons = []
var focused = 0

func _ready():
	buttons = btn_container.get_children()
	refocus(0,0)

func refocus(from, to):
	buttons[from].get_node("AnimatedSprite").animation = "unfocused" 
	buttons[to].get_node("AnimatedSprite").animation = "focused"

func up():
	refocus(1,0)
	
func down():
	refocus(0,1)

func left():
	pass
func right():
	pass
	
func accept():
	pass

func back():
	queue_free()
	parent.submenu = null
