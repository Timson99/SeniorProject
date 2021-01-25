extends TextureButton

export var reference_path=""
export var smc_path = "../../Submenu" #submenu_container_path
export(bool) var start_focused = false
var btn_menu_instance = null

func _ready():
	if start_focused:
		grab_focus()
	connect("mouse_entered",self,"_on_Button_mouse_entered")
	connect("pressed", self, "_on_Button_Pressed")
		
func _on_Button_mouse_entered():
	grab_focus()
func _on_Button_Pressed():
	if btn_menu_instance:
		btn_menu_instance = MenuManager.restack_submenu(btn_menu_instance)
	elif reference_path:
		var submenu_container = get_node(smc_path)
		print(reference_path)
		btn_menu_instance = MenuManager.activate_submenu(reference_path, submenu_container)
		
