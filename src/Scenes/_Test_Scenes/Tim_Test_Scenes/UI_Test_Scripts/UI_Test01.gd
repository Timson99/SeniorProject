extends Node2D

func _ready():
	$SelectionList.create_from_list(["Option1", "Option2", "Option3"])
	#$SelectionList.create()
