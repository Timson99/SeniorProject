extends KinematicBody2D

enum Mode {Stationary, Chase, Patrol}

export var default_speed := 58
export var alive := true
export var current_mode := Mode.Patrol
#export var detection_radius: float = $DetectionRadius.shape.radius

onready var stats = EntityStats.new()

var velocity = Vector2()

func _ready():
	$DetectionRadius.connect("body_entered", self, "_begin_chasing")
	$DetectionRadius.connect("body_exited", self, "_stop_chasing")
	position = Vector2(round(position.x), round(position.y))


func _physics_process(delta):
	velocity = velocity.normalized() * default_speed
	var collision = move_and_collide(velocity * delta)
	position = Vector2(round(position.x), round(position.y))
	if collision:
		print("ENEMY COLLIDED WITH PLAYER")
		$CollisionBox.disabled = true
		SceneManager.goto_scene("res://Scenes/Battle_Scenes/General/Demo_Battle_Scene.tscn")
	velocity = Vector2()
	

func _begin_chasing(body: Node):
	print("SHOULD CHASE CHARACTER")
	
func _stop_chasing(body: Node):
	print("SHOULD STOP CHASING CHARACTER")

func patrol_erratic():
	pass

func patrol_linear():
	pass
	
func patrol_box():
	pass

func patrol_circle():
	pass
