extends CanvasLayer

var submenu = null
var parent = null

onready var button_container = $ItemList/VBoxContainer
onready var description_container = $ItemList/InfoPanel/RichDescription
onready var scrollbar = $ItemList/Scrollbar

var default_focused = 0
var focused = default_focused
var buttons = []
var items = []
var scroll_level= 0
var btn_ctnr_size = 6
var button_path = "res://Scenes/UI/MainMenuUI/SubmenuModules/Buttons/ItemButton.tscn"

var data= MenuManager.item_data
var data_source=MenuManager.item_data
var num_cols = 1

var sc_start =0
var scrollbar_size = 2
var scrollbar_offset = 0
var max_sc_offset = 92
var offset_size = max_sc_offset/5

func _ready():
	_instantiate_items()
	_update_buttons()
	_repopulate_btn_container()
	refocus(focused)
	_update_scrollbar()
	pass
	

func refocus(to):
	if to >=0 and to < len(buttons):
		if focused>=0:
			buttons[focused].get_node("AnimatedSprite").animation = "unfocused"
		buttons[to].get_node("AnimatedSprite").animation = "focused"
		focused = to
		#can update to use funcref to be reusable
		update_description(data_source[buttons[to].item_name])

func unfocus():
	buttons[focused].get_node("AnimatedSprite").animation = "unfocused" 
	focused = -1

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
			scroll_level +=num_cols
			_move_scrollbar("down")
	else:
		if(scroll_level >= 1):
			scroll_level -=num_cols
			_move_scrollbar("up")
	_update_buttons()
	_repopulate_btn_container()
	
		

func _update_scrollbar():
	var middle = scrollbar.get_node("middle")
	sc_start = middle.get_position()
	scrollbar_offset = sc_start.y
	var prop_size = (float(len(buttons))/(len(items)+1))*max_sc_offset
	middle.set_scale(Vector2(1,prop_size/scrollbar_size))
	scrollbar_size = prop_size
	
	scrollbar.get_node("bottom").set_position(middle.get_position()+Vector2(0,scrollbar_size))
	var hidden_rows= ((len(items)-btn_ctnr_size)/num_cols)
	if num_cols>1 and not even(len(items)):
		hidden_rows += 1
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
		
const input_data: Dictionary = {
	"loop": "_process",
	"pressed":{},
	"just_pressed": {
		"ui_cancel": "back",
		"ui_accept": "accept",
		"ui_up": "up",
		"ui_down": "down",
		"ui_left": "left",
		"ui_right": "right",
		"ui_right_trigger":"r_trig",
		"ui_left_trigger":"l_trig"
	},
	"just_released": {},
}


func back():
	if submenu:
		submenu.back()
		submenu= null
	else:
		queue_free()
		parent.submenu = null
		
func accept():
	if submenu:
		submenu.accept()
	else:
		parent.update_field(buttons[focused].item_name)
		back()
		
	
func up():
	if submenu:
		submenu.up()
	else:
		var next_focused = focused - num_cols
	#	print(next_focused, " ", scroll_level)
		if next_focused < 0 and next_focused+(scroll_level+1)>=0:
			scroll("up")
			next_focused+=num_cols
		if next_focused >=0:
			refocus(next_focused)
			
		
	
func down():
	if submenu:
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
	if submenu:
		submenu.left()
	elif num_cols>1:
		var next_focused = focused - 1
		if even(next_focused):
			refocus(next_focused)
			
	
func right():
	if submenu:
		submenu.right()
	elif num_cols>1:
		var next_focused = focused + 1
		if not even(next_focused) and next_focused <= len(buttons)-1:
			refocus(next_focused)
			
func r_trig():
	if submenu:
		submenu.r_trig()
	else:
		pass
	
func l_trig():
	if submenu:
		submenu.l_trig()
	else:
		pass
