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



#############
#	Callbacks 
#############

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
		
		
func _process(_delta):
	if quick_scroll_enabled:
		for action in held_actions.keys():
			if(!(action in quick_scrolling) and 
			abs(held_actions[action] - OS.get_ticks_msec()) > qscroll_after_msec):
				quick_scrolling.append(action)
				_quick_scroll(action, held_actions[action])



#############
#	Public 
#############
	
func deactivate():
	InputManager.deactivate(self)
	hide()
	
	
#############
#	Private 
#############

# Shows a selection, assuming the list has already been initialized with "activate"
# Called by children at the end of their "activate" function
func _show_selection():
	
	for child in container_node.get_children():
		print(child.get_class())
		#assert(child.is_class("Selectable"), 
		#"Selection Error: Selectables must inherit from the Selectable Interface")
	
	if !no_initial_selection:
		selected_index = default_selected_index
		_select_current()
	else: selected_index = null
		
	InputManager.activate(self)
	show()
	
# Calls an action repeatedly while it is being held
# Start time ensures prevents out of date coroutines fro running
func _quick_scroll(action, start_time):
	call_deferred(action)
	yield(get_tree().create_timer(quick_scroll_sec, false), "timeout")
	if(action in held_actions and held_actions[action] == start_time):
		_quick_scroll(action, start_time)
	else:
		quick_scrolling.erase(action)


# Visually changes the currently selected index based on a input direction
func _change_selected(direction):
	#AudioManager.play_sound("BattleMenuSwitchFocus")
	if(!(direction in held_actions)):
		held_actions.clear() # Only 1 action allowed at a time
		held_actions[direction] = OS.get_ticks_msec() # When first pressed
	
	if no_initial_selection and selected_index == null:
		selected_index = default_selected_index
		_select_current()
		return
	
	_deselect_current()
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
		
	_validify_selected_index()
	_select_current()
	emit_signal("selection_changed", _get_current_value())
	
	
# Takes the selected_index and changes it to match selection constraints
func _validify_selected_index():
	var items = container_node.get_children()
	if wrap_around:
		if selected_index > items.size()-1: selected_index = 0
		elif selected_index < 0: selected_index = items.size()-1
		else: selected_index = selected_index
	else:
		selected_index = clamp(selected_index, 0, items.size()-1)
	
# Calls the select method on the selected entry	
func _select_current():
	var items = container_node.get_children()
	if items.size() == 0: return
	items[selected_index].select()

# Calls the deselect method on the selected entry	
func _deselect_current():
	var items = container_node.get_children()
	if items.size() == 0: return
	items[selected_index].deselect()

# Gets the value of the selected entry	
func _get_current_value():
	var items = container_node.get_children()
	return items[selected_index].get_value()
	
	
####################
#	Action Mappings 
#####################

func accept():
	#AudioManager.play_sound("BattleMenuButtonSelect")
	if selected_index == null:
		return
		
	emit_signal("selection_made", _get_current_value())
	if hide_on_accept: deactivate()


func cancel():
	#AudioManager.play_sound("BattleMenuButtonReturn")
	if hide_on_cancel: deactivate()
	
	
func right():
	_change_selected("right")	

func left():
	_change_selected("left")
	
func up():
	_change_selected("up")
	
func down():
	_change_selected("down")
	

func release_right():
	held_actions.erase("right")
	
func release_left():
	held_actions.erase("left")
	
func release_up():
	held_actions.erase("up")
	
func release_down():
	held_actions.erase("down")

	

