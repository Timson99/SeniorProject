extends CanvasLayer


var submenu = null
var parent = null

enum Button {CancelQuit, ConfirmQuit}

onready var buttons = {
	Button.CancelQuit: {
		"selectable_button": $TextureRect/VBoxContainer/ModifyControls,
		"choice": preload("res://Scenes/UI/ControlLayout/GameControlLayout.tscn"), 
		"top":  $TextureRect/VBoxContainer/QuitGame
	},
	Button.ConfirmQuit: {
		"selectable_button": $TextureRect/VBoxContainer/ChangeMusicVolume,
		"choice": null
	},
} 


func _ready():
	pass


func back():
	if submenu:
		submenu.back()
	else:
		queue_free()
