extends CanvasLayer

export var show_on_start = false
var active = null
#TODO: implement active submenu stack
#I will model usage of menus as a stack
#so that I may adapt moving through 
#submenus byt each specific menu
var asm_stack = null
var submenus = null

#InputEngine Reqs
var input_id = "Menu" 
#input receiver methods
func overlay_ui():
#	add_to_group("Input_Reciever")
	if active:
		deactivate_submenu($MainMenu)
		remove_from_group("Input_Reciever")
	else:
		activate_submenu($MainMenu)
		add_to_group("Input_Reciever")
#	toggle(active)

func toggle(switch:bool):
	switch = not switch
func activate_submenu(submenu:Node):
	active = true
	submenu.show()
	asm_stack.append(submenu) 
	print("Menu Shown\n%5d"% OS.get_unix_time())
#	add_to_group("Input_Reciever")

#will remove most recent submenu from stack by default
func deactivate_submenu(submenu:Node):
	active = false
	submenu.hide()
	print("Menu Hidden\n %5d" % OS.get_unix_time())
	asm_stack.pop_back()
#	remove_from_group("Input_Reciever") #Can comment out this line to debug on its own
#
func _ready():
	asm_stack = []
	active = not show_on_start
	print(active)
	overlay_ui()
#	deactivate_submenu($MainMenu)

