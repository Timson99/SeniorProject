extends CanvasLayer

var parent = null

enum Button {CancelQuit, ConfirmQuit}

var default_focused = Button.CancelQuit
var focused = default_focused

onready var buttons = {
	Button.CancelQuit: {
		"selectable_button": $TextureRect/Options/CancelQuit,
		"choice": "back"
	},
	Button.ConfirmQuit: {
		"selectable_button": $TextureRect/Options/ConfirmQuit,
		"choice": "quit_game"
	},
} 

func _ready():
	buttons[focused]["selectable_button"].grab_focus()

func accept():
	if self.has_method(buttons[focused]["choice"]):
		self.call(buttons[focused]["choice"])
	else:
		Debugger.dprint("Error: Invalid function call in selected button option")
		
func up():
	focused -= 1
	focused = Button.CancelQuit if focused < Button.CancelQuit else focused
	
func down():
	focused += 1
	focused = Button.ConfirmQuit if focused > Button.ConfirmQuit else focused

func left():
	pass
	
func right():
	pass

func back():
	reset_parent_button()
	queue_free()


func reset_parent_button():
	var parent_quit_button = parent.buttons[parent.focused]["selectable_button"]
	parent_quit_button.grab_focus()


func quit_game():
	var game_objects = get_tree().get_root().get_children()
	game_objects.invert()
	var menu_manager = get_tree().get_root().get_node("MenuManager")
	game_objects.remove(game_objects.find(menu_manager))
	menu_manager.queue_free()
	for child in game_objects:
		child.queue_free()
	get_tree().quit()	
