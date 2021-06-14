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
		"LP" : 10,
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
		"LP" : 20,
		"Description" : "Phew, that's a little better",
		"Power" : null,
		"Cost" : 5,
		"Target_All": false,
		"Hit_Rate": 1.00,
		"Type": Enums.SkillType.Healing,
		"Elemental" : null,
	},
	"Smack" : {
		"LP" : 1.0,
		"Description" : "Just a light smack",
		"Power" : Enums.SkillPower.Weak,
		"Cost" : 10,
		"Target_All": false,
		"Hit_Rate": 0.9,
		"Type": Enums.SkillType.Force,
		"Elemental" : null,
	},
	"Waste Time": {
		"LP": 5,
		"Description": "Sample Enemy move",
		"Power": Enums.SkillPower.Strong,
		"Cost": 5,
		"Target_All": false,
		"Hit_Rate": 1.0,
		"Type": Enums.SkillType.Force,
		"Elemental": null
	},
	"Ultimate Attack": {
		"LP": 5,
		"Description": "Seriously, this early in the game?? Geez, what have RPGs come to these days...",
		"Power": Enums.SkillPower.Strong,
		"Cost": 5,
		"Target_All": false,
		"Hit_Rate": 0.75,
		"Type": Enums.SkillType.Force,
		"Elemental": null
	}
}
