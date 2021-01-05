extends KinematicBody2D

enum Mode {Stationary, Chase, Patrol, Battle}

export var default_speed := 60
export var chase_factor := 0.8
export var alive := true
export var current_mode := Mode.Patrol
export var data_id := 1
export var enemy_type := "Regular"
export var has_patrol_pattern := "patrol_erratic"
var key := ""
onready var player_party = null
onready var target_player = EnemyHandler.target_player
onready var skins  = {
	"Enemy" : {
		"default" : $AnimatedSprite,
		"battle"  : "res://Assets/Enemy_Art/Bully/Battle_Bully.png"
	}
}
onready var animations = skins["Enemy"]["default"]

const patrol_patterns := ["patrol_erratic", "patrol_linear", "patrol_circle", "patrol_box"]	

var battle_sprite
var dir_anims := {
	Enums.Dir.Up: ["Idle_Up", "Walk_Up"],
	Enums.Dir.Down: ["Idle_Down", "Walk_Down"],
	Enums.Dir.Left: ["Idle_Left", "Walk_Left"],
	Enums.Dir.Right: ["Idle_Left", "Walk_Left"]
}
var current_dir = Enums.Dir.Down
var isMoving := false

var rand_num_generator = RandomNumberGenerator.new()
var initial_mode = current_mode
var velocity = Vector2(0,0)
var patrol_timer: SceneTreeTimer
var wait_timer: SceneTreeTimer
var next_movement: String = ""


func _ready():
	$DetectionRadius.connect("body_entered", self, "begin_chasing")
	$DetectionRadius.connect("body_exited", self, "stop_chasing")
	$DetectionRadius.connect("area_entered", self, "add_to_gang")
	$DetectionRadius.connect("area_exited", self, "remove_from_gang")


func _physics_process(delta):
	position = Vector2(round(position.x), round(position.y))
	if current_mode == Mode.Stationary:
		velocity = velocity.normalized() * default_speed
	elif player_party && current_mode == Mode.Chase:
		velocity = move_toward_player()
	elif current_mode == Mode.Patrol:
		velocity = self.call(has_patrol_pattern, next_movement).normalized() * default_speed
	
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
	
	var collision = move_and_collide(velocity * delta)
	if collision and collision.collider.name == target_player.persistence_id: # Collides with party in general currently
		EnemyHandler.queued_battle_enemies.append(key)
		EnemyHandler.can_spawn = false
		#print("ENEMY COLLIDED WITH %s" % target_player.persistence_id)
		stop_chasing(player_party)
		current_mode = Mode.Battle
		$CollisionBox.disabled = true
		SceneManager.goto_scene("battle", "", true)
	velocity = Vector2(0,0)
	

func move_toward_player():
	var party_position = player_party.get_global_position()
	var enemy_position = self.get_global_position()
	var x_diff = party_position.x - enemy_position.x
	var y_diff = party_position.y - enemy_position.y
	var movement_vector: Vector2 = Vector2(x_diff, y_diff)
	if enemy_position.y > party_position.y:
		current_dir = Enums.Dir.Up
	else:
		current_dir = Enums.Dir.Down
	if party_position.x > enemy_position.x:
		current_dir = Enums.Dir.Right
	else:
		current_dir = Enums.Dir.Left
	return Vector2(x_diff, y_diff).normalized() * default_speed * chase_factor
	
	
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
	
	
func begin_chasing(body: Node):
	if body.name == target_player.persistence_id:
		#print("SHOULD CHASE CHARACTER")
		player_party = body
		current_mode = Mode.Chase
	
	
func stop_chasing(body: Node):
	if body.name == target_player.persistence_id:
		#print("SHOULD STOP CHASING CHARACTER")
		player_party = null
		current_mode = initial_mode


# Overlapping enemy Area2Ds throw enemies into array that may be instanced in battle later
func add_to_gang():
	pass

	
# Corresponding removal function for "add_to_gang"
func remove_from_gang():
	pass


func patrol_erratic(current_movement: String):
	if patrol_timer && patrol_timer.get_time_left() > 0:
		return self.call(current_movement)
	elif patrol_timer && patrol_timer.get_time_left() <= 0 && not wait_timer:
		patrol_timer = null
		wait_timer = get_tree().create_timer(rand_num_generator.randf_range(0,3), false)
		return Vector2(0,0)
	elif wait_timer && wait_timer.get_time_left() > 0:
		return Vector2(0, 0)
	elif (not wait_timer && not patrol_timer) || (wait_timer.get_time_left() <= 0):
		if wait_timer && wait_timer.get_time_left() <= 0:
			wait_timer = null
		var movement_options = ["move_up", "move_down", "move_left", "move_right"]
		rand_num_generator.randomize()
		var movement_index = rand_num_generator.randi_range(0,3)
		next_movement = movement_options[movement_index]
		#print(next_movement)
		patrol_timer = get_tree().create_timer(rand_num_generator.randf_range(0,1), false)
		return self.call(next_movement)		


func patrol_linear():
	pass
	
	
func patrol_box():
	pass


func patrol_circle():
	pass
