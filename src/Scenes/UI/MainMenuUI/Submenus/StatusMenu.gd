extends CanvasLayer

var submenu = null
var parent = null

#The following information should be stored in game state
const gen_stats = ["ATTACK","DEFENSE","LUCK","WILLPOWER","SPEED","WAVE_ATTACK","WAVE_DEFENSE"]
var curr_char = "C1"
var char_params ={}
var sprite = null

# Called when the node enters the scene tree for the first time.
func _ready():
#	print(char_params)
	$Data/Name.text = curr_char
	$Data/Character.set_texture(sprite)
	$Data/Level.text = str("Level: ", char_params.get("LEVEL"))
	$Data/Bars/Max_HP.text = str("HP: ", char_params.get("HP"),"/",char_params.get("MAX_HP"))
	$Data/Bars/Max_SP.text = str("SP: ", char_params.get("SP"),"/",char_params.get("MAX_SP"))
	$Data/Stats/Attack.text = str("Attack: ", char_params.get("ATTACK"))
	$Data/Stats/Defense.text = str("Defense: ", char_params.get("DEFENSE"))
	$Data/Stats/Luck.text = str("Luck: ", char_params.get("LUCK"))
	$Data/Stats/Willpower.text = str("Willpower: ", char_params.get("WILLPOWER"))
	$Data/Stats/Speed.text = str("Speed: ", char_params.get("SPEED"))
	$Data/Stats/WaveAttack.text = str("Wave Attack: ", char_params.get("WAVE_ATTACK"))
	$Data/Stats/WaveDefense.text = str("Wave Defense: ", char_params.get("WAVE_DEFENSE"))
	#May be done with a loop, but need to modify strings
#	for stat in gen_stats:
#		get_node("Data/Stats/{s}".format({"s":stat})).text = str(stat,": ",char_params.get(stat))

func _change_char(new_char):
	curr_char = new_char
	sprite = parent.sprites.get(new_char)
	char_params = parent.stats.get(new_char)
	_ready()
	
func back():
	if submenu:
		submenu.back()
	else:
		queue_free()
		
func accept():
	if submenu:
		submenu.accept()
	else:
		pass
	
func up():
	if submenu:
		submenu.up()
	else:
		pass
		
	
func down():
	if submenu:
		submenu.down()
	else:
		pass

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
		var curr_index = parent.curr_party.find(curr_char,0)
		curr_index = (curr_index +1) % len(parent.curr_party)
		_change_char(parent.curr_party[curr_index])
	
	
func l_trig():
	if submenu:
		submenu.r_trig()
	else:
		var curr_index = parent.curr_party.find(curr_char,0)
		curr_index = (curr_index if curr_index>0 else len(parent.curr_party)) -1
		_change_char(parent.curr_party[curr_index])


