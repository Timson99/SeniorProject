extends Object

class_name BaseStats


const c1_base_stats = {
	"LEVEL" : 1,
	"HP" : 20,
	"MAX_HP" : 20,
	"SP" : 15,
	"MAX_SP" : 15,
	"ATTACK" : 2,
	"DEFENSE" : 1,
	"WAVE_ATTACK" : 3,
	"WAVE_DEFENSE" : 2,
	"SPEED" : 3,
	"WILLPOWER" : 2,
	"LUCK" : 1,
}
const c2_base_stats = {
	"LEVEL" : 1,
	"HP" : 15,
	"MAX_HP" : 15,
	"SP" : 25,
	"MAX_SP" : 25,
	"ATTACK" : 1,
	"DEFENSE" : 1,
	"WAVE_ATTACK" : 2,
	"WAVE_DEFENSE" : 2,
	"SPEED" : 2,
	"WILLPOWER" : 1,
	"LUCK" : 3,
}
const c3_base_stats = {
	"LEVEL" : 1,
	"HP" : 25,
	"MAX_HP" : 25,
	"SP" : 10,
	"MAX_SP" : 10,
	"ATTACK" : 1,
	"DEFENSE" : 3,
	"WAVE_ATTACK" : 3,
	"WAVE_DEFENSE" : 5,
	"SPEED" : 1,
	"WILLPOWER" : 1,
	"LUCK" : 1,
}

const base_stats = {
	"C1" : c1_base_stats,
	"C2" : c2_base_stats,
	"C3" : c3_base_stats
}


static func get_for(id):
	return base_stats[id].duplicate()



