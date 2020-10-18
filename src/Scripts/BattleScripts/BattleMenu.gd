extends VBoxContainer


enum Button {Attack, Skills, Items, Defend, Run}

var submenu_open

onready var buttons = {
	Button.Attack : 
		{
		 "anim_player" : $Attack/Attack,
		 "command" : "Attack",
		},
	Button.Skills : 
		{
		 "anim_player" : $Skills/Skills,
		 "command" : "Skills",
		},
	Button.Items : 
		{
		 "anim_player" : $Items/Items,
		 "command" : "Items",
		},
	Button.Defend :
		{
		 "anim_player" :  $Defend/Defend,
		 "command" : "Defend",
		},
	Button.Run : 
		{
		 "anim_player" : $Run/Run,
		 "command" : "Run",
		},
}

var default_focused = Button.Attack
var focused = default_focused

# Called when the node enters the scene tree for the first time.
func _ready():
	reset()
	
func reset():
	focused = default_focused
	buttons[focused]["anim_player"].animation = "on" 
	
	
func move_up():
	buttons[focused]["anim_player"].animation = "off" 
	focused -= 1
	focused = Button.Run if focused < Button.Attack else focused
	buttons[focused]["anim_player"].animation = "on" 
	
func move_down():
	buttons[focused]["anim_player"].animation = "off" 
	focused += 1
	focused = Button.Attack if focused > Button.Run else focused
	buttons[focused]["anim_player"].animation = "on" 
	
func accept_pressed():
	buttons[focused]["anim_player"].animation = "off" 
	return buttons[focused]["command"]
	
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
