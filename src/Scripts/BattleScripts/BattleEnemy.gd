extends Control


var alive := true
var selected = false

#Populated by Party
var stats := EntityStats.new()
onready var temp_battle_stats = stats
var selected_material : ShaderMaterial
var party = null
var screen_name
var tween : Tween


var moveset = null

func _ready():
	tween = Tween.new()
	tween.name = "Tween"
	self.add_child(tween)
	tween = $Tween
	
func on_load():
	var temp_battle_stats #= stats

# Called upon enemy's defeat
func terminate_enemy():
	tween.interpolate_property(self, "modulate:a", null, 0.0, 1.0)
	tween.start()
	yield(tween, "tween_completed")
	
	alive = false
	party.check_alive()
	
func make_move() -> BattleMove:
	var move = BattleMove.new(self, "Defend")
	return move
	
func take_damage(damage):
	stats.HP -= damage
	if stats.HP <= 0:
		stats.HP = 0
		terminate_enemy()
	
	
	
func select():
	$Sprite.set_material(selected_material)
	
func deselect():
	$Sprite.material = null
