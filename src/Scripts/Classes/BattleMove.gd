extends Object

class_name BattleMove

const move_template := {
	"Agent" : null, #Object Ref to agent (has its stats, skills (for lookup) and itesm (for lookup), status effects
	"Target" : null,  #Object Ref to agent (has its stats, skills (for lookup) and itesm (for lookup), status effects
	"Type" : "", #Type of Move, can be Attack, Skill, Item, Run, Defend
	"Skill_id" : "",
	"Item_id" : "",
}

const move_data = move_template

func _init(agent, type, target = null, special_id = ""):
	if !(type in ["Attack", "Skills", "Items", "Defend", "Run"]):
		Debugger.dprint("Invalid Move Type")
	
	move_data["Agent"] = agent
	move_data["Type"] = type
	move_data["Target"] = target
	
	if type == "Skils":
		move_data["Skill_id"] = special_id
	else:
		move_data["Item_id"] = special_id
	
	
