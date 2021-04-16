extends CanvasLayer

var submenu = null
var parent = null

var choice_menu = null
var default_focused = Button.ModifyControls
var focused = default_focused

enum Button {ModifyControls, ChangeMusicVolume, ChangeSoundVolume, QuitGame}

onready var buttons = {
	Button.ModifyControls: {
		"selectable_button": $TextureRect/VBoxContainer/ModifyControls,
		"submenu": preload("res://Scenes/UI/ControlLayout/GameControlLayout.tscn"), 
		"top":  $TextureRect/VBoxContainer/QuitGame
	},
	Button.ChangeMusicVolume: {
		"selectable_button": $TextureRect/VBoxContainer/ChangeMusicVolume,
		"submenu": null
	},
	Button.ChangeSoundVolume: {
		"selectable_button": $TextureRect/VBoxContainer/ChangeSFXVolume,
		"submenu": null,
	},
	Button.QuitGame: {
		"selectable_button": $TextureRect/VBoxContainer/QuitGame,
		"submenu": preload("res://Scenes/UI/MainMenuUI/Submenus/QuitWarning.tscn"),
		"bottom": $TextureRect/VBoxContainer/ModifyControls
	}
} 

func _ready():
	buttons[focused]["selectable_button"].grab_focus()

func back():
	if submenu:
		submenu.back()
	else:
		queue_free()
		
func accept():
	if submenu:
		submenu.accept()
	elif buttons[focused]["submenu"] is Object:
		submenu = buttons[focused]["submenu"].instance()
		call_deferred("add_child", submenu)
		submenu.layer = layer + 1
		submenu.parent = self
	elif self.has_method(buttons[focused]["submenu"]):
		self.call(buttons[focused]["submenu"])
	else:
		Debugger.dprint("Error: Invalid config menu option")
	
func quit_game():
	DialogueEngine.custom_message("WARNING: Unsaved data will be lost. Are you sure you want to quit?")
	yield(DialogueEngine, "end")
	var game_objects = get_tree().get_root().get_children()
	game_objects.invert()
	var menu_manager = game_objects.remove(game_objects.find("MenuManager"))
	var input_engine = game_objects.remove(game_objects.find("InputEngine"))
	for child in game_objects:
		print(child.name)
		child.queue_free()
	#menu_manager.queue_free()
	#input_engine.queue_free()
	get_tree().quit()	
	
	
func up():
	if submenu:
		submenu.up()
	else:
		focused -= 1
		focused = Button.QuitGame if focused < Button.ModifyControls else focused
	
func down():
	if submenu:
		submenu.down()
	else:
		focused += 1
		focused = Button.ModifyControls if focused > Button.QuitGame else focused

func left():
	if submenu:
		submenu.left()
	else:
		pass
	
func right():
	if submenu:
		submenu.right()
	else:
		pass
			





