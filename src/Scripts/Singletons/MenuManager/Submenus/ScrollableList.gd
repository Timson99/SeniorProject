extends Control
onready var button_container = $GridContainer
onready var description_container = $InfoPanel/RichDescription

var input_id = "Menu"
var default_focused = 0
var focused = default_focused 
var buttons = []
var button_path = "res://Scripts/Singletons/MenuManager/Submenus/ItemButton.tscn"
func _ready():
	_instantiate_items()
	buttons = button_container.get_children()
	refocus(0,0)

func refocus(from, to):
	buttons[from].get_node("AnimatedSprite").animation = "unfocused" 
	buttons[to].get_node("AnimatedSprite").animation = "focused"
	update_description(MenuManager.item_data[buttons[to].item_name])
	
func update_description(item):
	var description = ""
	for val in item :
		description = str(description,"\t",val," : ", item[val])
	description_container.text = description

func even(num):# can adjust condition to fit any number of columns
	return num%2 ==0

func down():
	var next_focused = focused + 2
	if next_focused <= len(buttons)-1:
		refocus(focused,next_focused)
		focused = next_focused

func up():
	var next_focused = focused - 2
	if next_focused >=0:
		refocus(focused,next_focused)
		focused = next_focused
	
func right():
	var next_focused = focused + 1
	if not even(next_focused):
		refocus(focused,next_focused)
		focused = next_focused
func left():
	var next_focused = focused - 1
	if even(next_focused):
		refocus(focused,next_focused)
		focused = next_focused
	
func _instantiate_items():
	for item in MenuManager.item_data:
		_add_item_button(item)

func _add_item_button(item):
#	print(item)
	var button = load(button_path).instance()
	button._setup(item)
	button_container.add_child(button)
	buttons.append(button)

