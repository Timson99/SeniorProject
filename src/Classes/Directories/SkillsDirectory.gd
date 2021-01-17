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
}
