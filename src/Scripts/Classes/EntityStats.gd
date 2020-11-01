extends Object

class_name EntityStats

const stat_template := {
	"LEVEL" : 1,
	"HP" : 1,
	"MAX HP" : 1,
	"SP" : 1,
	"MAX SP" : 1,
	"ATTACK" : 1,
	"DEFENSE" : 1,
	"WAVE ATTACK" : 1,
	"WAVE DEFENSE" : 1,
	"SPEED" : 1,
	"WILLPOWER" : 1,
	"LUCK" : 1,
}

var stats := stat_template.duplicate() setget , get_stats


func _init(base_stats = stat_template):
	if !validate_stats(base_stats):
		Debugger.dprint("ERROR, INVALID STATS IN CONSTRUCTION, USING DEFAULTS")

func get_stats() -> Dictionary:
	return stats
	
func get_stat_template():
	return stat_template
	
func set_stats(new_stats):
	if !validate_stats(new_stats):
		Debugger.dprint("ERROR, INVALID STATS IN SET, USING DEFAULTS")
	
#Validate constructor stats has all stat keys, all values positive ints	
func validate_stats(new_stats : Dictionary) -> bool:
	var stat_keys = ["LEVEL", "HP", "MAX HP", "SP","MAX SP","ATTACK","DEFENSE",
	"WAVE ATTACK","WAVE DEFENSE","SPEED","WILLPOWER", "LUCK"]
	if !new_stats.has_all(stat_keys):
		return false
	
	#Initialized Stats must be 1 or greater, must be ints	
	for v in new_stats.values():
		if(typeof(v) != TYPE_INT or v < 1 or v > 999):
			return false
	
	stats = new_stats
	return true
	
#Returns true if change, return false is clamped
func set_stat(stat_key : String, new_value : int) -> bool:
	if((stat_key in ["HP"])):
		stats[stat_key] = clamp(0, new_value, stats["MAX_HP"])
	elif((stat_key in ["SP"])):
		stats[stat_key] = clamp(0, new_value, stats["MAX_SP"])
	else:
		stats[stat_key] = clamp(1, new_value, 99)
		
	return (true if stats[stat_key] == new_value else false)

