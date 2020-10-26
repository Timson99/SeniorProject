extends KinematicBody2D

enum Mode {Stationary, Chase, Patrol}

export var default_speed := 48
export var alive := true
export var current_mode := Mode.Stationary
export var data_id := 1

var initial_mode = current_mode
#export var detection_radius: float = $DetectionRadius.shape.radius

var target_player = "C1"
onready var player_party = null

var velocity = Vector2()

func _ready():
	$DetectionRadius.connect("body_entered", self, "begin_chasing")
	$DetectionRadius.connect("body_exited", self, "stop_chasing")


func _physics_process(delta):
	position = Vector2(round(position.x), round(position.y))
	if current_mode == Mode.Stationary:
		velocity = velocity.normalized() * default_speed
	elif player_party && current_mode == Mode.Chase:
		velocity = move_toward_player()
	var collision = move_and_collide(velocity * delta)
	if collision and collision.collider.name == target_player:
		print("ENEMY COLLIDED WITH PLAYER")
		$CollisionBox.disabled = true
		print(collision.collider.name)
		SceneManager.goto_scene("DemoBattle")
	velocity = Vector2()

func move_toward_player():
	var party_position = player_party.get_global_position()
	var enemy_position = self.get_global_position()
	var x_diff = party_position.x - enemy_position.x
	var y_diff = party_position.y - enemy_position.y
	return Vector2(x_diff, y_diff).normalized() * default_speed
	
func begin_chasing(body: Node):
	if typeof(body) == 17 && body.name == target_player:
		print("SHOULD CHASE CHARACTER")
		player_party = body
		current_mode = Mode.Chase
		#print(position)
	
func stop_chasing(body: Node):
	if typeof(body) == 17 && body.name == target_player:
		print("SHOULD STOP CHASING CHARACTER")
		player_party = null
		current_mode = initial_mode
		yield(get_tree().create_timer(randi()%1+3, false), "timeout")	

func patrol_erratic():
	pass

func patrol_linear():
	pass
	
func patrol_box():
	pass

func patrol_circle():
	pass
