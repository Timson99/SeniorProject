extends CanvasLayer

var active = null
var asm_stack = null

#InputEngine Reqs
var input_id = "Menu" 
const main_menu_path = "res://Scenes/Luis_Test_Scenes/MenuManager/MainMenu.tscn"
#input receiver methods
func overlay_ui():	
	add_to_group("Input_Reciever")
	activate_submenu(main_menu_path)
	active = true
	print("Menu : ACTIVE {active}".format({"active":active}))
	print(asm_stack)
	
func remove_ui():
	close_menu()
	if len(asm_stack) ==0:
		remove_from_group("Input_Reciever") 
		active = false
	print("BUTTON PRESSED: ACTIVE {active}".format({"active":active}))

func activate_submenu(menu_path:String,parent_node=false):
	var submenu = load(menu_path).instance()
	if parent_node:
		parent_node.call_deferred("add_child",submenu)
	else: 
		call_deferred("add_child",submenu)
	asm_stack.append(submenu) 
#	print("stack {submenu}".format({'submenu':asm_stack}))
	print("Menu Shown\n%5d"% OS.get_unix_time())
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
func _ready():
	asm_stack = []
	active = false

