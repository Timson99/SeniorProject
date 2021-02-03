extends Node

var battle_entity

var stats = EntityStats.new({
	"LEVEL" : 1,
	"HP" : 1,
	"MAX_HP" : 1,
	"SP" : 1,
	"MAX_SP" : 1,
	"ATTACK" : 1,
	"DEFENSE" : 1,
	"WAVE_ATTACK" : 1,
	"WAVE_DEFENSE" : 1,
	"SPEED" : 1,
	"WILLPOWER" : 1,
	"LUCK" : 1,
	})

var skill_ids = ["Waste Time"]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func make_move() -> BattleMove:
	var characters = SceneManager.current_scene.character_party.party_alive
	var move = BattleMove.new(battle_entity, "Skills", characters[0], "Waste Time")
	return move
