extends Control


var alive := true
var selected = false

signal move_effects_completed

#Populated by Party
var ai
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
	alive = false	
	tween.interpolate_property(self, "modulate:a", null, 0.0, 1.0)
	tween.start()
	yield(tween, "tween_completed")
	party.check_alive()
	party.enemies.erase(self)
	
func make_move() -> BattleMove:
	var move = ai.make_move()
	return move
	
func take_damage(damage):
	stats.HP -= damage
	if stats.HP <= 0 and alive == true:
		stats.HP = 0
		terminate_enemy()
	else:
		emit_signal("move_effects_completed")
	
func select():
	$Sprite.set_material(selected_material)
	party.battle_brain.dialogue_node.display_message(screen_name)
	
func deselect():
	$Sprite.material = null
	party.battle_brain.dialogue_node.clear()
