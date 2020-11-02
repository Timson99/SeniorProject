extends Object

class_name BattleMove


var agent = null #Object Ref to agent (has its stats, skills (for lookup) and itesm (for lookup), status effects
var target = null  #Object Ref to agent (has its stats, skills (for lookup) and itesm (for lookup), status effects
var type = ""  #Type of Move, can be Attack, Skill, Item, Run, Defend
var skill_id = ""
var item_id = ""

func _init(agent, type, target = null, special_id = ""):
	if !(type in ["Attack", "Skills", "Items", "Defend", "Run"]):
		Debugger.dprint("Invalid Move Type")
	
	self.agent = agent
	self.type = type
	self.target = target
	if type == "Skils":
		self.skill_id = special_id
	elif type == "Item":
		self.item_id = special_id
		
func print_move():
	print("+++++++++++")
	print("agent : " + agent)
	print("target : " + target)
	print("type : " + type)
	print("skill_id : " + skill_id)
	print("item_id : " + item_id)
	print("+++++++++++")
	
	
