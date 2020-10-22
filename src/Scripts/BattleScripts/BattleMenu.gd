extends VBoxContainer


enum Button {Attack, Skills, Items, Defend, Run}

var submenu_open

var held_actions = {}
var quick_scrolling = []
const quick_scroll_sec = 0.07
const qscroll_after_msec = 500

onready var buttons = {
	Button.Attack : 
		{
		 "anim_player" : $Attack/Attack,
		 "command" : "Attack",
		},
	Button.Skills : 
		{
		 "anim_player" : $Skills/Skills,
		 "command" : "Skills",
		},
	Button.Items : 
		{
		 "anim_player" : $Items/Items,
		 "command" : "Items",
		},
	Button.Defend :
		{
		 "anim_player" :  $Defend/Defend,
		 "command" : "Defend",
		},
	Button.Run : 
		{
		 "anim_player" : $Run/Run,
		 "command" : "Run",
		},
}

var default_focused = Button.Attack
var focused = default_focused

# Called when the node enters the scene tree for the first time.
func _ready():
	reset()
	
func reset():
	focused = default_focused
	buttons[focused]["anim_player"].animation = "on" 
	
	
func move_up():
	buttons[focused]["anim_player"].animation = "off" 
	focused -= 1
	focused = Button.Run if focused < Button.Attack else focused
	buttons[focused]["anim_player"].animation = "on" 
	
	if(!("move_up" in held_actions)):
		held_actions["move_up"] = OS.get_ticks_msec()
	
func move_down():
	buttons[focused]["anim_player"].animation = "off" 
	focused += 1
	focused = Button.Attack if focused > Button.Run else focused
	buttons[focused]["anim_player"].animation = "on" 
	
	if(!("move_down" in held_actions)):
		held_actions["move_down"] = OS.get_ticks_msec()
	
func release_up():
	held_actions.erase("move_up")
func release_down():
	held_actions.erase("move_down")
	
func accept_pressed():
	buttons[focused]["anim_player"].animation = "off" 
	return buttons[focused]["command"]


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
	
