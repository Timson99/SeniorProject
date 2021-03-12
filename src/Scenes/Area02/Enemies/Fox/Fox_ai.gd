extends "res://Scenes/General/Enemies/Scripts/BattleEnemy_ai.gd"
# Fox enemy Spec

var stats = EntityStats.new({
	"LEVEL" : 1,
	"HP" : 20,
	"MAX_HP" : 30,
	"SP" : 15,
	"MAX_SP" : 25,
	"ATTACK" : 2,
	"DEFENSE" : 3,
	"WAVE_ATTACK" : 4,
	"WAVE_DEFENSE" : 5,
	"SPEED" : 6,
	"WILLPOWER" : 2,
	"LUCK" : 2,
})
var stat_variance = 2

var skill_ids = ["Minor Self-Heal", "Smack"]
var item_ids = []
var custom_skills = {}

var move_choice_thresholds = {
	"Defend": 0.6,
	"Smack": 0,
	"Minor Self-Heal": 0.8
}

func make_move() -> BattleMove:
	var characters = SceneManager.current_scene.character_party.party_alive
	battle_rng.randomize()
	var move_choice = battle_rng.randf_range(0, 1.0)
	if move_choice > move_choice_thresholds["Defend"]:
		return BattleMove.new(battle_entity, "Defend")
	elif move_choice > move_choice_thresholds["Minor Self-Heal"] && has_sp(stats):
		return BattleMove.new(battle_entity, "Skills", battle_entity, "Minor Self-Heal")
	var target = characters[battle_rng.randi_range(0, characters.size() - 1)]
	if move_choice > move_choice_thresholds["Smack"] && has_sp(stats):
		return BattleMove.new(battle_entity, "Skills", target, "Smack")
	else:
		return BattleMove.new(battle_entity, "Attack", target)

