extends Control


enum Button {Items, Equip, Skills, Status, Config}

onready var buttons = { 
	Button.Items : {
		"anim" : $MainMenu/Background/MenuOptions/Items/Items,
		"submenu" : ""
	},
	 Button.Equip : {
		"anim" : $MainMenu/Background/MenuOptions/Equip/Equip,
		"submenu" : ""
	}, 
	 Button.Skills : {
		"anim" : $MainMenu/Background/MenuOptions/Skills/Skills,
		"submenu" : ""
	},
	 Button.Status : {
		"anim" : $MainMenu/Background/MenuOptions/Status/Status,
		"submenu" : ""
	},
	 Button.Config : {
		"anim" : $MainMenu/Background/MenuOptions/Config/Config,
		"submenu" : ""
	}
}


var input_id = "Menu" 
var submenu = null
var parent = null

var default_focused = Button.Items
var focused = default_focused

var held_actions = {}
var quick_scrolling = []
const quick_scroll_sec = 0.07
const qscroll_after_msec = 500


func _ready():
	InputEngine.activate_receiver(self)
	buttons[focused]["anim"].animation = "on"
	
func _exit_tree():
	InputEngine.deactivate_receiver(self)
	
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

func back():
	if !submenu:
		parent.deactivate()
	else:
		submenu.back()
		
func accept():
	if !submenu:
		submenu = buttons[focused]["submenu"].instance()
	else:
		submenu.accept()
	
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
		submenu.down
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

	

