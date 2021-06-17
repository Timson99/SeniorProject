extends CanvasLayer

var submenu = null
var parent = null

var button_path = "res://Scenes/UI/MainMenuUI/SubmenuModules/Buttons/CharacterBtn.tscn"
var forward = preload("res://Scenes/UI/MainMenuUI/Submenus/StatusMenu.tscn")
var sprites = {
	"C1": preload("res://Assets/Art/Character_Art/C1/C1_02.png"),
	"C2": preload("res://Assets/Art/Character_Art/C2/C2_02.png"),
	"C3": preload("res://Assets/Art/Character_Art/C3/C3_02.png")
}
#The following information should be stored in game state
const condition_stats = ["HP", "MAX_HP", "SP", "MAX_SP"]
const gen_stats = ["ATTACK","DEFENSE","LUCK","WILLPOWER","SPEED","WAVE_ATTACK","WAVE_DEFENSE"]
onready var button_container = $CharacterSelection
var stats ={}
#the character ids here are save ids
onready var party_group := get_tree().get_nodes_in_group("Party")
var curr_party = ["C1","C2","C3"]
var curr_party_names := []
var curr_party_stats := []
var buttons = []
var focused = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	_populate_party()
	_init_stats()
	refocus(focused)
	

func refocus(to):
	if to >=0 and to < len(buttons):
		if focused>=0:
			buttons[focused].get_node("AnimatedSprite").animation = "unfocused" 
		buttons[to].get_node("AnimatedSprite").animation = "focused"
		focused = to
		
func unfocus():
	buttons[focused].get_node("AnimatedSprite").animation = "unfocused" 
	focused = -1
	
func _populate_party():
	if len(party_group)>0:
		curr_party = []
		curr_party_names = []
		curr_party_stats = []
		for x in party_group[0].party:
			curr_party.append(x.save_id)
			curr_party_names.append(x.screen_name)
			curr_party_stats.append(x.stats)
			
		

func _init_stats():
	for character in curr_party:
		stats[character] =  curr_party_stats[curr_party.find(character)].to_dict()
		_add_item_button(character)

func _add_item_button(item):
	var button = load(button_path).instance()
	button._setup(curr_party_names[curr_party.find(item)],stats[item],sprites[item])
	buttons.append(button)
	button_container.add_child(button)

func back():
	if submenu:
		if not submenu.submenu:
			submenu.back()
			submenu=null
			back()
		else:
			submenu.back()
	else:
		BgEngine.play_sound("MenuButtonReturn")
		unfocus()
		parent.submenu = null
#		queue_free()
		
func accept():
	if submenu:
		submenu.accept()
	else:
		BgEngine.play_sound("MenuButtonSelect")
		submenu = forward.instance()
		call_deferred("add_child", submenu)
		submenu.curr_char = curr_party_names[focused]
		submenu.char_params = stats[curr_party[focused]]
		submenu.sprite = sprites[curr_party[focused]]
		submenu.layer = layer + 1
		submenu.parent = self
	
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
	else:
		pass
	
func right():
	if submenu:
		submenu.right()
	else:
		pass
			
func r_trig():
	if submenu:
		submenu.r_trig()
	else:
		pass
	
func l_trig():
	if submenu:
		submenu.l_trig()
	else:
		pass




