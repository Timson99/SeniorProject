extends Control

var active = true#inactive by default
#I will model usage of menus as a stack
#so that I may adapt moving through 
#submenus byt each specific menu
var active_sm_stack = null
var submenus = null

#InputEngine Reqs
var input_id = "MainMenu" 
#input receiver methods
func overlay_ui():
	toggle(active)
	get_tree().paused= not active
	activate_menu() if active else deactivate_menu()
		
func activate_submenu(submenu:Node = self):
	if submenu != self:
		active_sm_stack.append(submenu) 
	submenu.show()
	print("Menu Shown")
	add_to_group("Input_Receiver")

#will remove most recent submenu from stack by default
func deactivate_submenu(submenu:Node = active_sm_stack.pop_back()):
	remove_from_group("Input_Receiver")
	submenu.hide()
	print("Menu Hidden")
	
func activate_menu():
	active_sm_stack.push_front(self)
	activate_submenu()
func deactivate_menu():
	active_sm_stack.pop_front()
	deactivate_submenu(self)
	
func toggle(binary:bool):
	binary = not binary
	
func _ready():
	active_sm_stack = []
	submenus = get_tree().get_root()
	print(submenus)
	activate_menu() if active else deactivate_menu()



