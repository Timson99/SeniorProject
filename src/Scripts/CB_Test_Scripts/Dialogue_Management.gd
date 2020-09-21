extends Node2D


# Member variables
var dialogueDictionary = {}
var speakerDictionary = {}
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
	print("started parse")
	var raw = file.get_as_text()
	file.close()
	var rawArray = raw.split("\n", false)
	for val in rawArray:
		var mdLength = val.find("*/")
		if mdLength > -1:
			#get metadata and split into array
			var metaData = val.left(mdLength + 2)
			var metaArray = metaData.split(" ", false)
			if metaArray.size() > 5 && metaArray[1].length() == 5:
				#check for -z flag, to update speaker dictionary
				if !speakerDictionary.has(metaArray[1]) && metaArray[3] == "-z":
					print("New Speaker w/ Queue: " +  metaArray[1])
					speakerDictionary[metaArray[1]] = metaArray[2]
				
				#insert message into dialogueDictionary
				var toInsert = [val.right(mdLength + 3)]
				dialogueDictionary[metaArray[2]] = toInsert
				
	print("finished parse")
	print(dialogueDictionary.keys())
	print(speakerDictionary.keys())
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _beginTransmit(var spID):
	if !speakerDictionary.has(spID):
		print("Could not find speaker ID: " + spID + " in dictionary!")
		return
	show()
	var msgID = speakerDictionary[spID]
	get_node("Dialogue Box/RichTextLabel").text = dialogueDictionary[msgID][0]
	
