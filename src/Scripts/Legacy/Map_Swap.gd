extends Node

#For loading map sections and switching between them

#WIP

var current 
var container
var map_id = 0
onready var lobby = preload("res://Scenes/Map Subsections/Map_Lobby.tscn").instance()
onready var hallway = preload("res://Scenes/Map Subsections/Map_Hallway.tscn").instance()

# Called when the node enters the scene tree for the first time.
func _ready():
	container = get_node("Map Container")
	current = container.add_child(lobby)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_focus_next"):
		container.remove_child(lobby)
		container.add_child(hallway)
