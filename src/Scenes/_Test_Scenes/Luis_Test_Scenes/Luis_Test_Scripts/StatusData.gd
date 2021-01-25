extends Control

#The following information should be stored in game state
enum Stats {Attack, Defense, Speed, Luck, Willpower, WaveAttack, WaveDefense}
onready var char_params = {
	"C1":{
		"sprite": preload("res://Assets/Character_Art/C1/C1_01.png"),
		"Level" :1,
		"Max_HP" : 60,
		"Max_SP" : 60,
		Stats.Attack : 45,
		Stats.Defense : 35,
		Stats.Speed : 40,
		Stats.Luck : 2,
		Stats.Willpower : 10,
		Stats.WaveAttack : 20,
		Stats.WaveDefense : 15
	}
}

var curr_char = "C1"

# Called when the node enters the scene tree for the first time.
func _ready():
	$Data/Name.text = curr_char
	$Data/Character.set_texture(char_params[curr_char]["sprite"])
	$Data/Level.text = str("Level: ", char_params[curr_char]["Level"])
	$Data/Bars/Max_HP.text = str("HP: ", char_params[curr_char]["Max_HP"],"/",char_params[curr_char]["Max_HP"])
	$Data/Bars/Max_SP.text = str("SP: ", char_params[curr_char]["Max_SP"],"/",char_params[curr_char]["Max_HP"])
	for stat in Stats:
		get_node("Stats/{s}".format({"s":stat})).text = str(stat,": ",char_params[curr_char][Stats[stat]])
