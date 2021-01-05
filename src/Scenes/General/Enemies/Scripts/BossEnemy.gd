extends KinematicBody2D

export var default_speed := 60
export var alive := true
export var persistence_id := "Bully"
export var actor_id := "Bully"
export var type := "Boss"
var speed = 60
var exploring = true

onready var skins  = {
	"Boss" : {
		"default" : $AnimatedSprite,
	}
}
onready var animations = skins["Boss"]["default"]

onready var data = EnemyHandler.Enemies.enemy_types[persistence_id]
onready var stats = data["battle_data"]
onready var battle_id = "battle"

var dir_anims := {
	Enums.Dir.Up: ["Idle_Up", "Walk_Up"],
	Enums.Dir.Down: ["Idle_Down", "Walk_Down"],
	Enums.Dir.Left: ["Idle_Left", "Walk_Left"],
	Enums.Dir.Right: ["Idle_Left", "Walk_Left"]
}
var current_dir = Enums.Dir.Down
var isMoving := false
var velocity = Vector2(0,0)

func on_load():
	if !alive:
		exploring = false
		change_anim("Sleep_Closed")

func _physics_process(delta):
	if exploring == true:
		explore(delta)

func explore(delta : float):
	velocity = velocity.normalized() * speed
	if velocity.length() != 0:
		animations.animation = dir_anims[current_dir][1]
		velocity = velocity.normalized() * speed
		if(!isMoving): 
			animations.play()
			isMoving = true
	else:
		animations.stop()
		animations.animation = dir_anims[current_dir][0]
		isMoving = false
		
	animations.flip_h = (current_dir == Enums.Dir.Right)
	
	var last_position = position
	var collision = move_and_collide(velocity * delta)
	velocity = Vector2()
			

signal command_completed
func move_to_position(new_position: Vector2, global = false):
	var current_position
	if global:
	 current_position = self.get_global_position()
	else:
		current_position = position
		
	var x_delta = new_position.x - current_position.x
	var y_delta = new_position.y - current_position.y
	if y_delta != 0:
		if current_position.y > new_position.y:
			move_up()
		else:
			move_down()
	elif y_delta <= 0 && x_delta != 0:
		if current_position.x > new_position.x:
			move_left()
		else:
			move_right()
	if current_position == new_position:
		emit_signal("command_completed")


func _ready():
	pass
	
func initiate_battle():
	
	print("RAN")
	
	EnemyHandler.queued_battle_enemies.append(persistence_id)
	SceneManager.goto_scene(battle_id, "", true)

# Physics process kept in just in case we want to sequence boss movement prior
# to or after a battle

func change_anim(anim_string):
	animations.play(anim_string)
	
	
func move_up():
	velocity = Vector2(0,0)
	velocity.y -= 1
	current_dir = Enums.Dir.Up
	
func move_down():
	velocity = Vector2(0,0)
	velocity.y += 1
	current_dir = Enums.Dir.Down
	
func move_right():
	velocity = Vector2(0,0)
	velocity.x += 1
	current_dir = Enums.Dir.Right
	
func move_left():
	velocity = Vector2(0,0)
	velocity.x -= 1
	current_dir = Enums.Dir.Left
	
	
# Persistent data to be saved
func save():
	var save_dict = {
		"persistence_id" : persistence_id,
		"position" : position, 
		"current_dir" : current_dir,
		"alive" : alive,
	}	
	return save_dict


