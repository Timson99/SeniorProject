extends Object

class_name BattleCalculations
	
func attack(move : BattleMove):
	var damage = move.agent.stats.ATTACK
	damage = int(damage/2 if move.target.defending else damage )
	return int(damage)
	
	
func skill(move : BattleMove):
	var damage = (move.agent.stats.ATTACK * (move.skill_ref["Power"] + 2))
	randomize()
	var hit = true if randf() < move.skill_ref["Hit_Rate"] else false
	if hit:
		damage = int(damage/2 if move.target.defending else damage )
	else:
		damage = NAN
	return int(damage)
	
	
func item(move : BattleMove):
	pass
	
	
func run(move : BattleMove):
	pass
