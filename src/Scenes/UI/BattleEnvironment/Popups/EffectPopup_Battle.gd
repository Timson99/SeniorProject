extends CanvasLayer
var input_id = "Menu" 
var submenu = null
var parent = null

onready var btn_container = $Control/VBoxContainer

var item = null
var buttons = []
var focused = 0
onready var party_group := get_tree().get_nodes_in_group("BattleParty")
var curr_party = ["C1","C2",]

func _ready():
	_populate_party()
	_name_buttons()
	refocus(0)

func _name_buttons():
	#Its roundabout, but I don't think we should make a new button scene for this
	buttons = btn_container.get_children()
	for i in range(len(buttons)):
		if i < len(curr_party):
			buttons[i].get_node("Label").text = curr_party[i]
		else:
			buttons[i].hide()
	buttons.slice(0,len(party_group))

func _populate_party():
	if len(party_group)>0:
		curr_party = []
		for x in party_group[0].party:
			curr_party.append(x.save_id)
func refocus(to):
	if to >=0 and to < len(buttons):
		buttons[focused].get_node("AnimatedSprite").animation = "unfocused" 
		buttons[to].get_node("AnimatedSprite").animation = "focused"
		focused = to

func use_item():
	print(item.item_name, " was used by character ", focused)
	#item.affect(SaveDataManager.characters[focused]) something like this
	pass

func reposition(new_pos):
	$Control.set_position(new_pos)

func up():
	if submenu:
		submenu.up()
	else:
	   refocus(focused-1)
	
func down():
	if submenu:
		submenu.down()
	else:
		refocus(focused+1)

func left():
	if submenu:
		submenu.left()
	pass
func right():
	if submenu:
		submenu.right()
	pass
	
func accept():
	if submenu:
		submenu.accept()
	else:
		use_item()
		back()

func back():
	if submenu:
		submenu.back()
	queue_free()
	parent.submenu = null
