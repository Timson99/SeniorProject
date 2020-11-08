extends KinematicBody2D

export var default_speed := 60
export var alive := true
export var persistence_id := "Boss1"

onready var skins  = {
	"Boss" : {
		"default" : $AnimatedSprite,
	}
}
onready var animations = skins["Boss"]["default"]

onready var stats = EnemyHandler.Enemies[persistence_id]["battle_data"]

var dir_anims := {
	Enums.Dir.Up: ["Idle_Up", "Walk_Up"],
	Enums.Dir.Down: ["Idle_Down", "Walk_Down"],
	Enums.Dir.Left: ["Idle_Left", "Walk_Left"],
	Enums.Dir.Right: ["Idle_Left", "Walk_Left"]
}
var current_dir = Enums.Dir.Down
var isMoving := false
var velocity = Vector2(0,0)


func _ready():
	pass


# Physics process kept in just in case we want to sequence boss movement prior
# to or after a battle
func _physics_process(delta):
	velocity = velocity.normalized() * default_speed
	if velocity.length() != 0:
		animations.animation = dir_anims[current_dir][1]
		if(!isMoving): 
			animations.play()
			isMoving = true
		animations.flip_h = (current_dir == Enums.Dir.Right)
	else:
		animations.stop()
		animations.animation = dir_anims[current_dir][0]
		isMoving = false
	velocity = Vector2(0,0)
	
	
func move_up():
	current_dir = Enums.Dir.Up
	return Vector2(velocity.x, velocity.y - 1)

	
func move_down():
	current_dir = Enums.Dir.Down
	return Vector2(velocity.x, velocity.y + 1)

	
func move_right():
	current_dir = Enums.Dir.Right
	return Vector2(velocity.x + 1, velocity.y)

	
func move_left():
	current_dir = Enums.Dir.Left
	return Vector2(velocity.x - 1, velocity.y)


# Sequenced call command?
func queue_for_battle():
	EnemyHandler.queued_battle_enemies.append(EnemyHandler.Enemies.bosses[persistence_id])
	
	
# Persistent data to be saved
func save():
	var save_dict = {
		"persistence_id" : persistence_id,
		"position" : position, 
		"current_dir" : current_dir,
		"stats" : stats,
		"alive" : alive,
	}	
	return save_dict


