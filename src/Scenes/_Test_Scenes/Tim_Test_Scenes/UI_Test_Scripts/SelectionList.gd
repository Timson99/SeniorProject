extends Control

signal selection_made(selection)

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
}

onready var prototype_item = $SelectablePrototype
onready var container_node = $VBoxContainer


# Child index of selected child under the container node
var default_selected_index = 0
var selected_index = null


# Arrangment of selectable items
export (Format) var selection_format = Format.VERTICAL

# Wrap around to beginning
export var wrap_around = false

# Whether or not to select the default beofre any input is received
export var no_initial_selection = false 

# Whether or not input scrolls quickly when held after a duration
export var quick_scroll_enabled = false

# Whether the cancel input will delete this submenu
export var delete_on_cancel = false

# Whether the accept input will delete this submenu
export var delete_on_accept = false

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
	prototype_item.get_node("AnimatedSprite").animation = "deselected"
	prototype_item.hide()
	
	
# Creates selection list from a list of strings
func create(str_list : Array ):
	InputManager.activate(self)
	
	if selection_format == Format.VERTICAL:   container_node = $VBoxContainer
	if selection_format == Format.HORIZONTAL: container_node = $HBoxContainer
	if selection_format == Format.GRID: 	  container_node = $GridContainer
	
	for i in range( 0, str_list.size() ):
		var new_item = prototype_item.duplicate()
		new_item.name = str(i)
		container_node.add_child(new_item)
		new_item.get_node("RichTextLabel").text = str_list[i]
		new_item.show()
		
	if !no_initial_selection:
		selected_index = default_selected_index
		select()
		
		
func delete():
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
	if quick_scroll_enabled:
		for action in held_actions.keys():
			if(!(action in quick_scrolling) and 
			abs(held_actions[action] - OS.get_ticks_msec()) > qscroll_after_msec):
				quick_scrolling.append(action)
				quick_scroll(action, held_actions[action])
			
			
################################################################

func change_selected(direction):
	
	if(!(direction in held_actions)):
		held_actions.clear() # Only 1 action allowed at a time
		held_actions[direction] = OS.get_ticks_msec() # When first pressed
	
	
	if no_initial_selection and selected_index == null:
		selected_index = default_selected_index
		select()
		return

	var items = container_node.get_children()
	var new_index = selected_index
	deselect()
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
		if selection_format == Format.HORIZONTAL: new_index -= 1
	elif direction == "right":
		if selection_format == Format.HORIZONTAL: new_index += 1
		
	if wrap_around:
		if new_index > items.size()-1: selected_index = 0
		elif new_index < 0: selected_index = items.size()-1
		else: selected_index = new_index
	else:
		selected_index = clamp(new_index, 0, items.size()-1)
	select()	
		
		
func select():
	var items = container_node.get_children()
	items[selected_index].get_node("AnimatedSprite").animation = "selected"
	
func deselect():
	var items = container_node.get_children()
	items[selected_index].get_node("AnimatedSprite").animation = "deselected"
	
func reset(reset_focused = true):
	if no_initial_selection:
		deselect()
	selected_index = default_selected_index if reset_focused else selected_index
	select()
	
	
func left():
	change_selected("left")
	
func right():
	change_selected("right")
	
func up():
	#AudioManager.play_sound("BattleMenuSwitchFocus")
	change_selected("up")
	
func down():
	#AudioManager.play_sound("BattleMenuSwitchFocus")
	change_selected("down")
	
	
func accept():
	#AudioManager.play_sound("BattleMenuButtonSelect")
	
	if selected_index == null:
		return
	
	# Emit Item selection as a signal
	
	if delete_on_accept: delete()

func cancel():
	#AudioManager.play_sound("BattleMenuButtonReturn")
	
	if delete_on_cancel: delete()

	
	
func release_right():
	held_actions.erase("right")
	
func release_left():
	held_actions.erase("left")
	
func release_up():
	held_actions.erase("up")
	
func release_down():
	held_actions.erase("down")

	

