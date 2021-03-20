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
	"Minor Self-Heal": {
		"LP" : INF,
		"Description" : "Phew, that's a little better",
		"Power" : null,
		"Cost" : 5,
		"Target_All": false,
		"Hit_Rate": 1.00,
		"Type": Enums.SkillType.Healing,
		"Elemental" : null,
	},
	"Smack" : {
		"LP" : INF,
		"Description" : "Just a light smack",
		"Power" : Enums.SkillPower.Weak,
		"Cost" : 10,
		"Target_All": false,
		"Hit_Rate": 0.9,
		"Type": Enums.SkillType.Force,
		"Elemental" : null,
	},
	"Waste Time": {
		"LP": INF,
		"Description": "Sample Enemy move",
		"Power": Enums.SkillPower.Weak,
		"Cost": 0,
		"Target_All": false,
		"Hit_Rate": 1.0,
		"Type": Enums.SkillType.Force,
		"Elemental": null
	},
}
