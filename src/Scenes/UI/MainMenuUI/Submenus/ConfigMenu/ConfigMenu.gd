extends CanvasLayer

var submenu = null
var parent = null

var choice_menu = null
var default_focused = Button.ModifyControls
var focused = default_focused


enum Button {ModifyControls, ChangeSoundVolume, QuitGame}

onready var buttons = {
	Button.ModifyControls: {
		"selectable_button": $TextureRect/VBoxContainer/ModifyControls,
		"submenu": preload("res://Scenes/UI/MainMenuUI/ControlLayout/GameControlLayout.tscn"), 
		"top":  $TextureRect/VBoxContainer/QuitGame,
	},
	Button.ChangeSoundVolume: {
		"selectable_button": $TextureRect/VBoxContainer/ChangeSoundVolume,
		"submenu": preload("res://Scenes/UI/MainMenuUI/Submenus/ConfigMenu/ChangeSoundMenu.tscn"),
	},
	Button.QuitGame: {
		"selectable_button": $TextureRect/VBoxContainer/QuitGame,
		"submenu": preload("res://Scenes/UI/MainMenuUI/Submenus/ConfigMenu/QuitWarning.tscn"),
		"bottom": $TextureRect/VBoxContainer/ModifyControls,
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
	else:
		submenu = buttons[focused]["submenu"].instance()
		call_deferred("add_child", submenu)
		submenu.layer = layer + 1
		submenu.parent = self	
	
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
	
func right():
	if submenu:
		submenu.right()
			





