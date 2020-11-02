extends Control


var alive := true
var selected = false

#Populated by Party
var stats := EntityStats.new()
onready var temp_battle_stats = stats
var selected_material : ShaderMaterial
var party = null
var screen_name


var moveset = null

func _ready():
	pass # Replace with function body.
	
func on_load():
	var temp_battle_stats #= stats

# Called upon enemy's defeat
func terminate_enemy():
	hide()
	
func make_move() -> BattleMove:
	var move = BattleMove.new(self, "Defend")
	return move
	
func take_damage(damage):
	stats.get_stats()["HP"] -= damage
	if stats.get_stats()["HP"] <= 0:
		stats.get_stats()["HP"] = 0
		terminate_enemy()
	
	
	
func select():
	$Sprite.set_material(selected_material)
	
func deselect():
	$Sprite.material = null
