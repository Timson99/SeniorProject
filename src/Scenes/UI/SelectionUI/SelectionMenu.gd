extends Control

class_name SelectionMenu

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

var container_node
# Arrangment of selectable items
var selection_format
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
# Container node in tree that will hold selection items (optional)
export (NodePath) var container

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
	
	if container:
		container_node = get_node(container)
	else: # First child container object found is assumed to be selection list
		var children = get_children()
		assert(children.size()==1, 
			"SelectableInterface Error: Must have a single container child")
		container_node = children[0]
	
	if container_node.is_class("VBoxContainer"):
		selection_format = Format.VERTICAL
	elif container_node.is_class("HBoxContainer"): 
		selection_format = Format.HORIZONTAL
	elif container_node.is_class("GridContainer"): 	  
		selection_format = Format.GRID
	else:
		assert(false,
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


# Initializes and Validates and EXISTING list of selectable nodes
# Shows and Activates the Selection Menu UI
func activate():
	var container_children = container_node.get_children()
	assert(container_children.size() != 0, "Selection must have nonzero children")
		
	# CHILDREN MUST HAVE ALL REQUIRED METHODS
	for child in container_node.get_children():
		for required_method in ["select","deselect","get_value","set_value"]:
			assert(child.has_method(required_method), 
				"Selectable Node '%s' does not have required method '%s'" % 
				[child.name, required_method])
				
	# DESELECT ALL CHILDREN AND SET DEFAULT CHILD
	for node in container_children:
		node.deselect()
	if !no_initial_selection:
		selected_index = default_selected_index
		select_current()
	else: selected_index = null
	
	# ACTIVATE AND SHOW
	InputManager.activate(self)
	show()

# Deactivates and Hides Selection Menu
func deactivate():
	InputManager.deactivate(self)
	hide()


#############
#	Functions 
#############	

# Takes a direction and calculates what the next index with be
func get_index_after_input(index : int, direction : String):
	var new_index = index
	if direction == "up":
		if selection_format == Format.VERTICAL: 
			new_index -= 1
		if selection_format == Format.GRID:
			new_index -= $GridContainer.columns
	elif direction == "down":
		if selection_format == Format.VERTICAL: 
			new_index += 1
		if selection_format == Format.GRID:
			new_index += $GridContainer.columns
	elif direction == "left":
		if selection_format != Format.VERTICAL: new_index -= 1
	elif direction == "right":
		if selection_format != Format.VERTICAL: new_index += 1
		
	return validify_index(new_index)
	
# Returns first child index with a given value
func get_index_by_value(value):
	var items = container_node.get_children()
	for i in range(0, items.size()):
		if items[i].get_value() == value:
			return i
	return 0
	
# Returns first child index with a given value
func get_value_by_index(index):
	var items = container_node.get_children()
	return items[index].get_value()
	
	
# Takes a index and returns and clamps it to the boundaries
func validify_index(index):
	var items = container_node.get_children()
	if wrap_around:
		if index > items.size()-1: index = 0
		elif index < 0: index = items.size()-1
		else: index = index
	else:
		index = clamp(index, 0, items.size()-1)
	return index
	
func input_changes_selection(direction):
	if selected_index == null: return true
	var next_index = get_index_after_input(selected_index, direction)
	return next_index != selected_index
	
#############
#	Modifiers 
#############	
	

# Sets the currently selected node by index
func set_selected_by_index(new_index):
	var initial_selected_index = selected_index
	deselect_current()
	selected_index = validify_index(new_index)
	select_current()
	if selected_index != initial_selected_index:
		emit_signal("selection_changed", get_current_value())


func set_selected_by_value(value):
	set_selected_by_index(get_index_by_value(value))
	
	
# Visually changes the currently selected index based on a input direction
func set_selected_from_input(direction):
	#AudioManager.play_sound("BattleMenuSwitchFocus")
	
	# Select default if nothing currently selected
	if no_initial_selection and selected_index == null:
		selected_index = default_selected_index
		select_current()
		return
		
	var next_index = get_index_after_input(selected_index, direction)
	set_selected_by_index(next_index)

############################
#	Selectable Interaction
#############################

# Calls the select method on the selected entry	
func select_current():
	var items = container_node.get_children()
	if items.size() == 0 || selected_index == null: return
	items[selected_index].select()

# Calls the deselect method on the selected entry	
func deselect_current():
	var items = container_node.get_children()
	if items.size() == 0 || selected_index == null: return
	items[selected_index].deselect()

# Gets the value of the selected entry	
func get_current_value():
	return get_value_by_index(selected_index)
	
#############
#	Private 
#############

# Calls an action repeatedly while it is being held
# Start time ensures prevents out of date coroutines fro running
func _quick_scroll(action, start_time):
	if !input_changes_selection(action): 
		quick_scrolling.erase(action)
		return
	call_deferred(action)
	yield(get_tree().create_timer(quick_scroll_sec, false), "timeout")
	if(action in held_actions and held_actions[action] == start_time):
		_quick_scroll(action, start_time)
	else:
		quick_scrolling.erase(action)
	

func _log_scroll_action_pressed(direction):
	if(!(direction in held_actions) and input_changes_selection(direction)):
		held_actions.clear() # Only 1 action allowed at a time
		held_actions[direction] = OS.get_ticks_msec() # When first pressed
	
	
####################
#	Action Mappings 
#####################

func accept():
	#AudioManager.play_sound("BattleMenuButtonSelect")
	if selected_index == null: return
	emit_signal("selection_made", get_current_value())
	if hide_on_accept: deactivate()


func cancel():
	#AudioManager.play_sound("BattleMenuButtonReturn")
	if hide_on_cancel: deactivate()
	
	
func right():
	_log_scroll_action_pressed("right")
	set_selected_from_input("right")	

func left():
	_log_scroll_action_pressed("left")
	set_selected_from_input("left")
	
func up():
	_log_scroll_action_pressed("up")
	set_selected_from_input("up")
	
func down():
	_log_scroll_action_pressed("down")
	set_selected_from_input("down")
	

func release_right():
	held_actions.erase("right")
	
func release_left():
	held_actions.erase("left")
	
func release_up():
	held_actions.erase("up")
	
func release_down():
	held_actions.erase("down")

	

