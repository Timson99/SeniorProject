extends Object
#Bully Spec

var battle_entity 

var stats = EntityStats.new({
	"LEVEL" : 1,
	"HP" : 10,
	"MAX_HP" : 10,
	"SP" : 20,
	"MAX_SP" : 20,
	"ATTACK" : 6,
	"DEFENSE" : 3,
	"WAVE_ATTACK" : 8,
	"WAVE_DEFENSE" : 5,
	"SPEED" : 5,
	"WILLPOWER" : 1,
	"LUCK" : 1,
})

var skill_ids = ["Big Punch"]
var item_ids = []

var custom_skills = {
	"Say Something Mean" : {
		"LP" : INF,
		"Description" : "",
		"Power" : Enums.SkillPower.Weak,
		"Cost" : 10,
		"Target_All": false,
		"Hit_Rate": 0.8,
		"Type": Enums.SkillType.Text,
		"Text:" : "You are terrible.",
		"Elemental" : null,
		}
}

func _ready():
	pass 


	
func make_move() -> BattleMove:
	var characters = SceneManager.current_scene.character_party.party_alive
	var move = BattleMove.new(battle_entity, "Skills", characters[0], "Big Punch")
	#var move = BattleMove.new(battle_entity, "Defend")
	return move

