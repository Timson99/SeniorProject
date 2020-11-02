extends Object

class_name EntityStats

var stat_keys = ["LEVEL", "HP", "MAX_HP", "SP","MAX_SP","ATTACK","DEFENSE",
	"WAVE_ATTACK","WAVE_DEFENSE","SPEED","WILLPOWER", "LUCK"]
	
const stats_template = {
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
}
	
var LEVEL
var HP
var MAX_HP
var SP
var MAX_SP
var ATTACK
var DEFENSE
var WAVE_ATTACK
var WAVE_DEFENSE
var SPEED
var WILLPOWER
var LUCK

var status_effect
var stat_buffs


func _init(base_stats := stats_template):
	_set_stats(base_stats)
		
		
	
func _set_stats(new_stats):
	if !_validate_stats(new_stats):
		Debugger.dprint("ERROR, INVALID STATS IN SET, USING DEFAULTS")
		
	LEVEL = new_stats["LEVEL"]
	HP = new_stats["HP"]
	MAX_HP = new_stats["MAX_HP"]
	SP = new_stats["SP"]
	MAX_SP = new_stats["MAX_SP"]
	ATTACK = new_stats["ATTACK"]
	DEFENSE = new_stats["DEFENSE"]
	WAVE_ATTACK = new_stats["WAVE_ATTACK"]
	WAVE_DEFENSE = new_stats["WAVE_DEFENSE"]
	SPEED = new_stats["SPEED"]
	WILLPOWER = new_stats["WILLPOWER"]
	LUCK = new_stats["LUCK"]
	
	
#Validate constructor stats has all stat keys, all values positive ints	
func _validate_stats(new_stats : Dictionary) -> bool:
	if !new_stats.has_all(stat_keys):
		return false
	
	#Initialized Stats must be 1 or greater, must be ints	
	for v in new_stats.values():
		if(typeof(v) != TYPE_INT or v < 1 or v > 999):
			return false
	return true
	
#Returns true if change, return false is clamped
func set_stat(stat_key : String, new_value : int) -> bool:
	var final_stat
	if((stat_key == "HP")):
		final_stat = clamp(0, new_value, MAX_HP)
	elif((stat_key == "SP")):
		final_stat = clamp(0, new_value, MAX_SP)
	elif stat_key in stat_keys:
		final_stat = clamp(1, new_value, 99)
	else:
		Debugger.dprint("Stat not Set: stat_key is invalid")
		return false
	set(stat_key, final_stat)
	return (true if get(stat_key) == new_value else false)
	
func print_stats():
	print("-------------")
	print("LEVEL : " + LEVEL)
	print("HP : " + HP)
	print("MAX_HP : " + MAX_HP)
	print("SP : " + SP)
	print("MAX_SP : " + MAX_SP)
	print("ATTACK : " + ATTACK)
	print("DEFENSE : " + DEFENSE)
	print("WAVE_ATTACK : " + WAVE_ATTACK)
	print("WAVE_DEFENSE : " + WAVE_DEFENSE)
	print("SPEED : " + SPEED)
	print("WILLPOWER : " + WILLPOWER)
	print("LUCK : " + LUCK)
	print("-------------")
