extends CanvasLayer


enum Button {Items, Equip, Skills, Status, Config}

onready var character_choice = preload("res://Scenes/UI/MainMenuUI/Submenus/CharacterChoice.tscn")
var choice_menu = null

onready var buttons = { 
	Button.Items : {
		"anim" : $Background/MenuOptions/Items/Items,
		"submenu" : preload("res://Scenes/UI/MainMenuUI/Submenus/ItemsMenu.tscn")
	},
	 Button.Equip : {
		"anim" : $Background/MenuOptions/Equip/Equip,
		"submenu" : preload("res://Scenes/UI/MainMenuUI/Submenus/EquipMenu.tscn")
	}, 
	 Button.Skills : {
		"anim" : $Background/MenuOptions/Skills/Skills,
		"submenu" : preload("res://Scenes/UI/MainMenuUI/Submenus/SkillsMenu.tscn")
	},
	 Button.Status : {
		"anim" : $Background/MenuOptions/Status/Status,
		"submenu" : preload("res://Scenes/UI/MainMenuUI/Submenus/StatusMenu.tscn")
	},
	 Button.Config : {
		"anim" : $Background/MenuOptions/Config/Config,
		"submenu" : preload("res://Scenes/UI/MainMenuUI/Submenus/ConfigMenu/ConfigMenu.tscn")
	}
}


var input_id = "Menu" 
var submenu = null
var parent = null

var default_focused = Button.Items
var focused = default_focused

var held_actions = {}
var quick_scrolling = []
const quick_scroll_sec = 0.075
const qscroll_after_msec = 500


func _ready():
	InputEngine.activate_receiver(self)
	buttons[focused]["anim"].animation = "on"
	show_char_menu()
	
func _exit_tree():
	InputEngine.deactivate_receiver(self)
	parent.deactivate()
	
func _process(_delta):
	for action in held_actions.keys():
		if(!(action in quick_scrolling) and 
		abs(held_actions[action] - OS.get_ticks_msec()) > qscroll_after_msec):
			quick_scrolling.append(action)
			quick_scroll(action, held_actions[action])
			
func quick_scroll(action, start_time):
	call_deferred(action)
	yield(get_tree().create_timer(quick_scroll_sec, false), "timeout")
	if(action in held_actions and held_actions[action] == start_time):
		quick_scroll(action, start_time)
	else:
		quick_scrolling.erase(action)
		
func show_char_menu():
	choice_menu= character_choice.instance()
	call_deferred("add_child", choice_menu)
	choice_menu.layer = layer + 1
	choice_menu.focused = -1

func back():
	if submenu:
		submenu.back()
	else:
		queue_free()
		
func accept():
	if submenu:
		submenu.accept()
	else:
		BgEngine.play_sound("MenuButtonSelect")
		if not(focused == Button.Items or focused == Button.Config):
			submenu = choice_menu
			submenu.forward = buttons[focused]["submenu"]
			submenu.parent = self
			submenu.refocus(0)
		else:
			submenu = buttons[focused]["submenu"].instance()
			call_deferred("add_child", submenu)
			submenu.layer = layer + 1
			submenu.parent = self
		
func up():
	if submenu:
		submenu.up()
	else:
		buttons[focused]["anim"].animation = "off" 
		focused -= 1
		focused = Button.Config if focused < Button.Items else focused
		buttons[focused]["anim"].animation = "on" 
		
	if(!("up" in held_actions)):
		held_actions["up"] = OS.get_ticks_msec()
	
func down():
	if submenu:
		submenu.down()
	else:
		buttons[focused]["anim"].animation = "off" 
		focused += 1
		focused = Button.Items if focused > Button.Config else focused
		buttons[focused]["anim"].animation = "on" 
		
	if(!("down" in held_actions)):
		held_actions["down"] = OS.get_ticks_msec()

func left():
	if submenu:
		submenu.left()
	
func right():
	if submenu:
		submenu.right()
			
func release_up():
	held_actions.erase("up")
	
func release_down():
	held_actions.erase("down")
	
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





###############################################################
"""
func activate_submenu(menu_path:PackedScene,parent_node=false):
	var submenu = menu_path.instance()
	if parent_node:
		parent_node.call_deferred("add_child",submenu)
	else: 
		call_deferred("add_child", submenu)
	asm_stack.append(submenu) 
	return submenu
	
func restack_submenu(submenu):
	if submenu in asm_stack:
		if submenu == asm_stack[-1]:
			deactivate_submenu()
		else:
			asm_stack.remove(submenu)
			asm_stack.append(submenu)
			return submenu
	return null
	
func deactivate_submenu():
	var submenu = asm_stack.pop_back()
	if submenu:
		submenu.queue_free()
	print("Menu Hidden\n %5d" % OS.get_unix_time())
	
	
func close_menu():
	while asm_stack:
		deactivate_submenu()
#################################################################
"""

	

