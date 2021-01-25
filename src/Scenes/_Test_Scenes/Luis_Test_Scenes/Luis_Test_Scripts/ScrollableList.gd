extends Control
onready var button_container = $GridContainer
onready var description_container = $InfoPanel/RichDescription

var input_id = "Menu"
var default_focused = 0
var focused = default_focused 
var buttons = []
var items = []
var scroll_level= 0
var btn_ctnr_size = 12
var button_path = "res://Scripts/Singletons/MenuManager/Submenus/ItemButton.tscn"
func _ready():
	_instantiate_items()
	_update_buttons()
	_repopulate_btn_container()
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

func scroll(direction):
	if direction == "down":
		if(scroll_level+btn_ctnr_size < len(items)):
			scroll_level +=2
			_update_buttons()
			_repopulate_btn_container()
	else:
		if(scroll_level >= 0):
			scroll_level -=2
			_update_buttons()
			_repopulate_btn_container()
		

func down():
	#is more complicated because it must deal with odd
	#numbers of items in the list
	var next_focused = focused + 2
	if next_focused >= btn_ctnr_size and next_focused+(scroll_level+1)<=len(items):
			scroll("down")
			next_focused-=2
	elif focused == btn_ctnr_size-1 and next_focused-1 >= btn_ctnr_size and next_focused+(scroll_level)<=len(items):
			scroll("down")
			focused -=1
			next_focused-=3
	if next_focused+(scroll_level+1)<=len(items) and next_focused <= btn_ctnr_size-1:
		refocus(focused,next_focused)
		focused = next_focused

func up():
	var next_focused = focused - 2
#	print(next_focused, " ", scroll_level)
	print(next_focused+(scroll_level+1))
	if next_focused < 0 and next_focused+(scroll_level+1)>=0:
			scroll("up")
			next_focused+=2
	if next_focused >=0:
		refocus(focused,next_focused)
		focused = next_focused
	
func right():
	var next_focused = focused + 1
	if not even(next_focused) and next_focused <= len(buttons)-1:
		refocus(focused,next_focused)
		focused = next_focused
func left():
	var next_focused = focused - 1
	if even(next_focused):
		refocus(focused,next_focused)
		focused = next_focused
	
func _instantiate_items():
	for item in MenuManager.item_data:
		_add_item(item)

func _add_item(item):
	items.append(item)
	
func _update_buttons():
	buttons= []
	for i in range(btn_ctnr_size):
		var item_ix = i+scroll_level
		print(item_ix)
		if item_ix <len(items):
			_add_item_button(items[item_ix])
		else:
			break
		
func _add_item_button(item):
	var button = load(button_path).instance()
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
		child.queue_free()

