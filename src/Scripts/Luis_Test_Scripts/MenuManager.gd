extends Control

export var active = true
#I will model usage of menus as a stack
#so that I may adapt moving through 
#submenus byt each specific menu
var asm_stack = null
var submenus = null

#InputEngine Reqs
var input_id = "Menu" 
#input receiver methods
func overlay_ui():
#	print("FUCK")
	print(self.visible)
	active = self.visible
	deactivate_menu() if self.visible else activate_menu()
		
func activate_submenu(submenu:Node):
	submenu.show()
	
	asm_stack.push_front(submenu)if submenu != self else asm_stack.append(submenu) 
	print("Menu Shown")
	add_to_group("Input_Reciever")

#will remove most recent submenu from stack by default
func deactivate_submenu(submenu:Node):
	submenu.hide()
	print("Menu Hidden")
	remove_from_group("Input_Reciever")
	asm_stack.pop_front() if submenu == self else asm_stack.pop_back()

func activate_menu():
	activate_submenu(self)
func deactivate_menu():
	deactivate_submenu(self)
	
func toggle(binary:bool):
	binary = not binary
	
func _ready():
#	active = true#default visibility
	asm_stack = []
	submenus = get_tree().get_root()
	print(submenus)
	activate_menu() if active else deactivate_menu()

