extends HBoxContainer


enum Button {Attack, Skills, Items, Defend, Run}

var icon_highlight = preload("res://Resources/Shaders/HighlightGreen.tres")

var items_submenu = preload("res://Scenes/UI/BattleEnvironment/BattleItems_Submenu.tscn")
var skills_submenu = preload("res://Scenes/UI/BattleEnvironment/BattleSkills_Submenu.tscn")

var submenu = null
var selector = null

var held_actions = {}
var quick_scrolling = []
const quick_scroll_sec = 0.07
const qscroll_after_msec = 500

onready var buttons = {
	Button.Attack : 
		{
		 "sprite" : $Attack/AttackIcon,
		 "text" : $Attack/AttackText,
		 "command" : "Attack",
		},
	Button.Skills : 
		{
		 "sprite" : $Skills/SkillsIcon,
		 "text" : $Skills/SkillsText,
		 "command" : "Skills",
		},
	Button.Items : 
		{
		 "sprite" : $Items/ItemsIcon,
		 "text" : $Items/ItemsText,
		 "command" : "Items",
		},
	Button.Defend :
		{
		 "sprite" :  $Defend/DefendIcon,
		 "text" : $Defend/DefendText,
		 "command" : "Defend",
		},
	Button.Run : 
		{
		 "sprite" : $Run/RunIcon,
		 "text" : $Run/RunText,
		 "command" : "Run",
		},
}

var default_focused = Button.Attack
var focused = default_focused

# Called when the node enters the scene tree for the first time.
func _ready():
	reset()
	
func instance_items_submenu():
	submenu = items_submenu.instance()
	submenu.parent = self
	add_child(submenu)
	
func instance_skills_submenu():
	submenu = skills_submenu.instance()
	submenu.parent = self
	add_child(submenu)
	
func select_focused():
	buttons[focused]["sprite"].set_material(icon_highlight)
	buttons[focused]["text"].set_material(icon_highlight)
	
func deselect_focused():
	buttons[focused]["sprite"].set_material(null)
	buttons[focused]["text"].set_material(null)
	
func reset(reset_focused = true):
	if reset_focused:
		deselect_focused()
	focused = default_focused if reset_focused else focused
	select_focused()
	
	
func left():
	if submenu:
		submenu.left()
	else:
		deselect_focused()
		focused -= 1
		focused = Button.Run if focused < Button.Attack else focused
		select_focused()
	
	if(!("left" in held_actions)):
		held_actions["left"] = OS.get_ticks_msec()
	
func right():
	if submenu:
		submenu.right()
	else:
		deselect_focused()
		focused += 1
		focused = Button.Attack if focused > Button.Run else focused
		select_focused()
	
		if(!("right" in held_actions)):
			held_actions["right"] = OS.get_ticks_msec()
	
func release_right():
	held_actions.erase("right")
func release_left():
	held_actions.erase("left")
func release_up():
	pass
func release_down():
	pass
	
func accept():
	if submenu:
		submenu.accept()
	else:
		deselect_focused()
		return buttons[focused]["command"]

func back():
	if submenu:
		submenu.back()
	else:
		pass

func up():
	if submenu:
		submenu.up()
	else:
		pass
	
func down():
	if submenu:
		submenu.down()
	else:
		pass
		
			



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
	
