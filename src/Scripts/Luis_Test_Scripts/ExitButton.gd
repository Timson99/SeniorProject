extends Button

export(bool) var start_focused = false
export(bool) var top_level = false


func _ready():
	if start_focused:
		grab_focus()
	connect("mouse_entered",self,"_on_Button_mouse_entered")
	connect("pressed", self, "_on_Button_Pressed")
		
func _on_Button_mouse_entered():
	grab_focus()
func _on_Button_Pressed():
	MenuManager.remove_ui() if top_level else MenuManager.deactivate_submenu()
		
