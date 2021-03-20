extends Object

var battle_entity 
var stat_rng = RandomNumberGenerator.new()
var battle_rng = RandomNumberGenerator.new()
var vary_stats := true 


func _ready():
	pass


func get_stat_variations(stats: EntityStats, variance_range: int):
	stat_rng.randomize()
	var max_boost = floor(variance_range / 2)
	var min_boost = -max_boost
	var base_stats_dict = stats.to_dict()
	var varied_stats = {}
	for stat_name in base_stats_dict.keys():
		if stat_name in ["LEVEL", "MAX_HP", "MAX_SP"]:
			varied_stats[stat_name] = stats[stat_name]
			continue
		var stat_change_val = stat_rng.randi_range(min_boost, max_boost)
		varied_stats[stat_name] = base_stats_dict[stat_name] + stat_change_val
	return EntityStats.new(varied_stats)
	

func has_sp(stats: EntityStats):
	return stats.to_dict()["SP"] > 0.0

	
func make_move() -> BattleMove:
	var characters = SceneManager.current_scene.character_party.party_alive
	var move: BattleMove
	return move
