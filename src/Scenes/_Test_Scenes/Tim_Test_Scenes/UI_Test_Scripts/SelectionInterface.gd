extends Control

class_name SelectionInterface

signal selection_made(selection)
signal selection_changed(selection)

const input_data : Dictionary = {
	"loop": "_process",
	"pressed": {},
	"just_pressed": {
		"ui_up" : "up",
		"ui_down" : "down",
		"ui_left" : "left",
		"ui_right" : "right",
		"ui_accept" : "accept",
		"ui_cancel": "cancel",
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
	#CUSTOM_GIRD # Container that organizes enemies in a customizes grid with row offsets
}

var container_node = null
# Arrangment of selectable items
var selection_format = Format.VERTICAL

# Child index of selected child under the container node
var default_selected_index = 0
var selected_index = null

# Wrap around to beginning
export var wrap_around = false

# Whether or not to select the default beofre any input is received
export var no_initial_selection = false 

# Whether the cancel input will delete this submenu
export var hide_on_cancel = false

# Whether the accept input will delete this submenu
export var hide_on_accept = false

# Whether or not input scrolls quickly when held after a duration
export var quick_scroll_enabled = false

# Quick Scrolling properties
var quick_scroll_sec = 0.07  # Time before next scroll
var qscroll_after_msec = 500 # msecs to hold action before quickscrolling
var held_actions = {} # Actions mapped to msecs they have been held
var quick_scrolling = [] # Actions that are currently quick scrolling 



func _ready():
	hide()
	# First child container object found is assumed to be selection list
	
	var children = get_children()
	assert(children.size()==1, 
		"SelectableInterface Error: Must have a single container child")
	var container = children[0]
	
	if container.is_class("VBoxContainer"):   
		container_node = container
		selection_format = Format.VERTICAL
	elif container.is_class("HBoxContainer"): 
		container_node = container
		selection_format = Format.HORIZONTAL
	elif container.is_class("GridContainer"): 	  
		container_node = container
		selection_format = Format.GRID
		
	assert(container_node != null, 
		"SelectionInterface Violation: List Scene has no valid Container")
	
func initialize():
	if !no_initial_selection:
		selected_index = default_selected_index
		select()
	else: selected_index = null
		
	InputManager.activate(self)
	show()
	
	
func deactivate():
	InputManager.deactivate(self)
	hide()
	
	
func quick_scroll(action, start_time):
	call_deferred(action)
	yield(get_tree().create_timer(quick_scroll_sec, false), "timeout")
	if(action in held_actions and held_actions[action] == start_time):
		quick_scroll(action, start_time)
	else:
		quick_scrolling.erase(action)


func _process(_delta):
	if quick_scroll_enabled:
		for action in held_actions.keys():
			if(!(action in quick_scrolling) and 
			abs(held_actions[action] - OS.get_ticks_msec()) > qscroll_after_msec):
				quick_scrolling.append(action)
				quick_scroll(action, held_actions[action])
			
			
################################################################

func change_selected(direction):
	#AudioManager.play_sound("BattleMenuSwitchFocus")
	if(!(direction in held_actions)):
		held_actions.clear() # Only 1 action allowed at a time
		held_actions[direction] = OS.get_ticks_msec() # When first pressed
	
	if no_initial_selection and selected_index == null:
		selected_index = default_selected_index
		select()
		return
	
	deselect()
	if direction == "up":
		if selection_format == Format.VERTICAL: 
			selected_index -= 1
		if selection_format == Format.GRID:
			selected_index -= $GridContainer.columns
	elif direction == "down":
		if selection_format == Format.VERTICAL: 
			selected_index += 1
		if selection_format == Format.GRID:
			selected_index += $GridContainer.columns
	elif direction == "left":
		if selection_format != Format.VERTICAL: selected_index -= 1
	elif direction == "right":
		if selection_format != Format.VERTICAL: selected_index += 1
		
	validify_selected_index()
	select()
	
func validify_selected_index():
	var items = container_node.get_children()
	if wrap_around:
		if selected_index > items.size()-1: selected_index = 0
		elif selected_index < 0: selected_index = items.size()-1
		else: selected_index = selected_index
	else:
		selected_index = clamp(selected_index, 0, items.size()-1)
	
	
func select():
	var items = container_node.get_children()
	if items.size() == 0: return
	items[selected_index].select()
	
func deselect():
	var items = container_node.get_children()
	if items.size() == 0: return
	items[selected_index].deselect()
	
func get_current_value():
	var items = container_node.get_children()
	return items[selected_index].get_value()
	

func accept():
	#AudioManager.play_sound("BattleMenuButtonSelect")
	if selected_index == null:
		return
		
	emit_signal("selection_made", get_current_value())
	
	if hide_on_accept: deactivate()


func cancel():
	#AudioManager.play_sound("BattleMenuButtonReturn")
	if hide_on_cancel: deactivate()
	
	
func right():
	change_selected("right")	

func left():
	change_selected("left")
	
func up():
	change_selected("up")
	
func down():
	change_selected("down")
	

func release_right():
	held_actions.erase("right")
	
func release_left():
	held_actions.erase("left")
	
func release_up():
	held_actions.erase("up")
	
func release_down():
	held_actions.erase("down")

	

