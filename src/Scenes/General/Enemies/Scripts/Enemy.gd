extends "res://Scenes/General/Non-Player (Both Enemies & NPCs)/Non-Player.gd"

onready var player_party = null
onready var target_player = EnemyHandler.target_player

enum Mode {Stationary, Chase, Wander, Patrol, Battle, Defeated}

export(Mode) var current_mode := Mode.Wander
export var data_id := 1
export var alive := true
export var is_boss := false

var battle_sprite
var key := ""
var spawn_balancer_id: int
var allies := []

func _ready():
	$DetectionRadius.connect("body_entered", self, "begin_chasing")
	$DetectionRadius.connect("body_exited", self, "stop_chasing")
	$DetectionRadius.connect("area_entered", self, "add_allies_to_gang")
	$DetectionRadius.connect("area_exited", self, "remove_allies_from_gang")
	initial_mode = current_mode


func _physics_process(delta):
	target_player = EnemyHandler.target_player
	if current_mode == Mode.Stationary:
		velocity = velocity.normalized() * 0
	elif player_party && current_mode == Mode.Chase:
		velocity = move_toward_player()
	elif current_mode == Mode.Wander:
		velocity = self.call("wander", next_movement).normalized() * default_speed
	elif current_mode == Mode.Patrol && pathing_coordinates.size() > 1:
		velocity = self.call("follow_path", pathing_coordinates).normalized() * default_speed
	
	animate_movement()
	
	var collision = move_and_collide(velocity * delta)
	if collision && target_player && collision.collider.name == target_player.persistence_id:
		initiate_battle()
	velocity = pause_movement()
	
	
func initiate_battle():
	BgEngine.save_song()
	BgEngine.play_battle_music()
	EnemyHandler.freeze_all_nonplayers()
	$CollisionBox.disabled = true
	EnemyHandler.retain_enemy_data()
	EnemyHandler.collect_battle_enemy_ids(data_id)
	EnemyHandler.add_to_battle_queue(key)
	for other_enemy in allies:
		EnemyHandler.collect_battle_enemy_ids(other_enemy.data_id)
		EnemyHandler.add_to_battle_queue(other_enemy.key)
	SceneManager.goto_scene("battle", "", true)	


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
	return Vector2(x_diff, y_diff).normalized() * default_speed
	
	
func begin_chasing(body: Node):
	if target_player && body.name == target_player.persistence_id:
		player_party = body
		current_mode = Mode.Chase
	
	
func stop_chasing(body: Node):
	if target_player && body.name == target_player.persistence_id:
		player_party = null
		current_mode = initial_mode


func freeze_in_place():
	$DetectionRadius.disconnect("body_entered", self, "begin_chasing")
	velocity = Vector2(0,0)
	current_mode = Mode.Battle


func unfreeze():
	$DetectionRadius.connect("body_entered", self, "begin_chasing")
	current_mode = initial_mode
	if $DetectionRadius.overlaps_body(target_player):
		current_mode = Mode.Chase


func post_battle():
	current_mode = Mode.Defeated
	velocity = Vector2(0,0)


# Overlapping enemy Area2Ds throw enemies into array that may be instanced in battle later
func add_allies_to_gang(area: Area2D):
	if area.name == "DetectionRadius":
		allies.append(area.get_parent())

	
# Corresponding removal function for "add_to_gang"
func remove_allies_from_gang(area: Area2D):
	if area.name == "DetectionRadius":
		allies.erase(area.get_parent())
