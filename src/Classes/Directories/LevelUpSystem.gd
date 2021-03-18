extends Object


class_name LevelUpSystem

var stat_rng = RandomNumberGenerator.new()

var c1_stats
var c2_stats
var c3_stats

var c1_xp := 0 
var c2_xp := 0
var c3_xp := 0

var c1_to_next_level := 100
var c2_to_next_level := 100
var c3_to_next_level := 100


const c1_stat_growth := {
	"LEVEL" : 1.0,
	"HP" : 1.2,
	"MAX_HP" : 1.2,
	"SP" : 1.4,
	"MAX_SP" : 1.4,
	"ATTACK" : 0.9,
	"DEFENSE" : 0.6,
	"WAVE_ATTACK" : 0.95,
	"WAVE_DEFENSE" : 0.68,
	"SPEED" : 0.5,
	"WILLPOWER" : 0.65,
	"LUCK" : 0.45,
}

const c2_stat_growth := {
	"LEVEL" : 1.0,
	"HP" : 1.05,
	"MAX_HP" : 1.05,
	"SP" : 1.45,
	"MAX_SP" : 1.45,
	"ATTACK" : 0.6,
	"DEFENSE" : 0.3,
	"WAVE_ATTACK" : 0.65,
	"WAVE_DEFENSE" : 0.5,
	"SPEED" : 0.65,
	"WILLPOWER" : 0.65,
	"LUCK" : 0.8,
}

const c3_stat_growth := {
	"LEVEL" : 1.0,
	"HP" : 1.25,
	"MAX_HP" : 1.25,
	"SP" : 1.05,
	"MAX_SP" : 1.05,
	"ATTACK" : 0.7,
	"DEFENSE" : 0.9,
	"WAVE_ATTACK" : 0.75,
	"WAVE_DEFENSE" : 0.95,
	"SPEED" : 0.2,
	"WILLPOWER" : 0.5,
	"LUCK" : 0.5,
}

var xp := {
	"C1": c1_xp,
	"C2": c2_xp,
	"C3": c3_xp,
}

var to_next_level := {
	"C1": c1_to_next_level,
	"C2": c2_to_next_level,
	"C3": c3_to_next_level,
}

var stat_growths := {
	"C1": c1_stat_growth,
	"C2": c2_stat_growth,
	"C3": c3_stat_growth
}

var stats := {
	"C1": c1_stats,
	"C2": c2_stats,
	"C3": c3_stats
}


func give_xp(id: String, earned_xp: int):
	xp[id] += earned_xp


func level_up(id: String) -> EntityStats:
	xp[id] -= to_next_level[id]
	_increase_level_up_threshold(id)
	return _get_new_level_stats(id)
	

func _get_new_level_stats(id: String) -> EntityStats:
	stat_rng.randomize()
	var char_stats = EntityStats.new(BaseStats.get_for(id)).to_dict()
	var stat_growth = stat_growths[id]
	var new_stats := {}
	for stat in char_stats.keys():
		if stat == "LEVEL":
			new_stats[stat] = char_stats[stat] + 1
		elif stat_growth[stat] > 1.0:
			new_stats[stat] = int(ceil(char_stats[stat] * stat_growth[stat]))
		else:
			var stat_boost_chance = stat_rng.randf_range(0, 1.0)
			new_stats[stat] = char_stats[stat]
			if stat_boost_chance <= stat_growth[stat]:
				new_stats[stat] += 1
	stats[id] = new_stats
	return EntityStats.new(new_stats)
	

func _increase_level_up_threshold(id: String):
	var curr_threshold = to_next_level[id]
	to_next_level[id] = curr_threshold * 1.75
	
func crossed_lv_xp_threshold(id: String) -> bool:
	return xp[id] >= to_next_level[id]
	
func get_stats(id: String) -> EntityStats:
	return EntityStats.new(stats[id])	
	
func get_xp_for(id: String) -> int:
	return xp[id]	
	
func get_to_next_lv_for(id: String) -> int:
	return to_next_level[id]

func calculate_needed_xp(id: String) -> int:
	return to_next_level[id] - xp[id]
