extends Node2D


# Declare member variables here. Examples:
# var a = 2
var resDictionary = {}
export var ResFile = "Test_Project_Dialogue"

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	var path = "res://Assets/CB_Test_Assets/" + ResFile + ".res"
	
	# Create file, test for existance
	var file = File.new()
	if !(file.file_exists(path)):
		print("File not found")
		return
	file.open(path, file.READ)
	
	#parse file
	var raw = file.get_as_text()
	file.close()
	var rawArray = raw.split("\n", false)
	print(rawArray[1])
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _beginTransmit(var spID):
	show()
	print("Received Request for Dialogue from: " + spID)
