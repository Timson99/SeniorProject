extends Control


var alive := true
var selected = false



#Populated by Party
var ai
var stats
var selected_material : ShaderMaterial
var party = null
var screen_name
var tween : Tween
onready var animation_player = $AnimationPlayer
var defending = false


var moveset = null

func _ready():
	tween = Tween.new()
	tween.name = "Tween"
	self.add_child(tween)
	tween = $Tween
	
func on_load():	
	pass

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
	animation_player.play("Hit")
	yield(animation_player, "animation_finished")
	stats.HP -= damage
	if stats.HP <= 0 and alive == true:
		stats.HP = 0
		yield(terminate_enemy(), "completed")
		if party.terminated:
			yield()
	print(damage)

	
func select():
	$Sprite.set_material(selected_material)
	party.battle_brain.dialogue_node.display_message(screen_name)
	
func deselect():
	$Sprite.material = null
	party.battle_brain.dialogue_node.clear()
