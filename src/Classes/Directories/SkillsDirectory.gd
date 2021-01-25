extends Object

#Inflict Status Effect
# Multiple Choice -> Effect
#Inflict Elemental Damage
#Say Something
"""
Cure
Heal
Fire Blast
Electrocute
Blizzard
Bludgeon
Stabbing 
HP -> SP
Revive
Yawn
Scan
"""

class_name SkillsDirectory

const skills = {
	"Lil' Ice" : {
		"LP" : 5,
		"Description" : "Just a Lil' Ice",
		"Power" : Enums.SkillPower.Weak,
		"Cost" : 5,
		"Target_All": false,
		"Hit_Rate": 0.95,
		"Type": Enums.SkillType.Spell,
		"Elemental" : Enums.Elementals.Ice,
	},
	"Big Punch" : {
		"LP" : INF,
		"Description" : "Test Description",
		"Power" : Enums.SkillPower.Weak,
		"Cost" : 10,
		"Target_All": false,
		"Hit_Rate": 0.8,
		"Type": Enums.SkillType.Force,
		"Elemental" : null,
	},
}
