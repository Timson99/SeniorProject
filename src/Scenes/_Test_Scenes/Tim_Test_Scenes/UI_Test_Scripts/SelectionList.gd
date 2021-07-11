extends Control

const input_data : Dictionary = {
	"loop": "_process",
	"pressed": {},
	"just_pressed": {
		"ui_test1" : "test_command1",
		"ui_up" : "up",
		"ui_down" : "down",
		"ui_left" : "left",
		"ui_right" : "right",
		"ui_accept" : "accept",
		"ui_cancel": "back",
	},
	"just_released":{
		"ui_left" : "release_left",
		"ui_right" : "release_right",
		"ui_up" : "release_up",
		"ui_down" : "release_down",
	},
}

enum Format {
	VERTICAL,
	HORIZONTAL,
	GRID,
}

onready var prototype_item = $SelectablePrototype

# reference to node currently focused item in list
var selected = null
# Default 
var default_selected = null

# Arrangment of selectable items
export (Format) var selection_format = Format.VERTICAL

# Whether or not to select the default beofre any input is received
export var select_before_input = false 

# Whether the back button will delete this submenu
export var delete_on_cancel = false

# Quick Scrolling properties
var held_actions = {} # Actions mapped to msecs they have been held
var quick_scrolling = [] # Actions that are currently quick scrolling 
const quick_scroll_sec = 0.07  # Time before next scroll
const qscroll_after_msec = 500 # msecs to hold action before quickscrolling

# Removes visual aids used to create UI in scene view
func _ready():
	for node in [$VBoxContainer, $HBoxContainer, $GridContainer]:
		for n in node.get_children():
			n.queue_free()
	prototype_item.hide()
	
	
# Creates selection list from a list of strings
func create(str_list : Array ):
	InputManager.activate(self)
	var counter = 0
	for str_item in str_list:
		counter+=1 
		var new_item = prototype_item.duplicate()
		new_item.name = str(counter)
		$VBoxContainer.add_child(new_item)
		new_item.get_node("RichTextLabel").text = str_item
		new_item.show()
		
		
	
func destroy():
	InputManager.deactivate(self)
	queue_free()
	
	
func quick_scroll(action, start_time):
	call_deferred(action)
	yield(get_tree().create_timer(quick_scroll_sec, false), "timeout")
	if(action in held_actions and held_actions[action] == start_time):
		quick_scroll(action, start_time)
	else:
		quick_scrolling.erase(action)


func _process(_delta):
	for action in held_actions.keys():
		if(!(action in quick_scrolling) and 
		abs(held_actions[action] - OS.get_ticks_msec()) > qscroll_after_msec):
			quick_scrolling.append(action)
			quick_scroll(action, held_actions[action])
			
			
################################################################

func select():
	pass
	
func deselect():
	pass
	
func reset(reset_focused = true):
	if select_before_input:
		deselect()
	selected = default_selected if reset_focused else selected
	select()
	
	
func left():
	#AudioManager.play_sound("BattleMenuSwitchFocus")
	deselect()
	#focused -= 1
	#focused = Button.Run if focused < Button.Attack else focused
	#select_focused()
	
	if(!("left" in held_actions)):
		held_actions["left"] = OS.get_ticks_msec()
	
func right():
	#AudioManager.play_sound("BattleMenuSwitchFocus")
	#if is_instance_valid(submenu):
	#	submenu.right()
	#else:
	#	deselect_focused()
	#	focused += 1
	#	focused = Button.Attack if focused > Button.Run else focused
	#	select_focused()
	
		if(!("right" in held_actions)):
			held_actions["right"] = OS.get_ticks_msec()
	
func release_right():
	held_actions.erase("right")
	
func release_left():
	held_actions.erase("left")
	
func release_up():
	held_actions.erase("up")
	
func release_down():
	held_actions.erase("down")
	
	
func accept():
	AudioManager.play_sound("BattleMenuButtonSelect")
	# Emit Item selection as a signal

func back():
	AudioManager.play_sound("BattleMenuButtonReturn")

		
func up():
	AudioManager.play_sound("BattleMenuSwitchFocus")
	
func down():
	AudioManager.play_sound("BattleMenuSwitchFocus")

	

