extends CanvasLayer

#InputEngine
var input_id = "Dialogue"

# Member variables
var dialogueDictionary = {}
var speakerDictionary = {}
export var ResFile = "Test_Project_Dialogue"
var displayedID = null
var currentspID = null
var finalWaltz = true
var inOptions = false
var selectedOption = 1
var totalOptions = 1

# Nodes for ease of access
onready var scrollAudio = get_node("TextAudio")
onready var dialogue_box = $"Control/Dialogue Box"
onready var options_box = $"Control/Options Box"
onready var textNode = dialogue_box.get_node("RichTextLabel")
onready var textTimer = get_node("Timer")

# Called when the node enters the scene tree for the first time.
func _ready():
	dialogue_box.hide()
	options_box.hide()
	var path = "res://Assets/Christian_Test_Assets/" + ResFile + ".res"
	
	# Create file, test for existance
	var file = File.new()
	if !(file.file_exists(path)):
		Debugger.dprint("File not found")
		return
	file.open(path, file.READ)
	
	#parse file
	#print("started parse")
	var raw = file.get_as_text()
	file.close()
	var rawArray = raw.split("\n", false)
	var prevSequenceID = null
	for val in rawArray:
		var mdLength = val.find("*/")
		if mdLength > -1:
			#get metadata and split into array
			var metaData = val.left(mdLength + 2)
			var metaArray = metaData.split(" ", false)
			if metaArray.size() > 5 && metaArray[1].length() == 5:
				#check for -z flag, to update speaker dictionary
				if !speakerDictionary.has(metaArray[1]) && metaArray[3] == "-z":
					speakerDictionary[metaArray[1]] = metaArray[2]
				
				#establish sub dictionary to add as val to dialogueDictionary
				var toInsert = {"msg": val.right(mdLength + 3)}
				var mdIndex = 0
				
				#get parent id for option logic
				if metaArray[metaArray.size() - 2].length() > 5:
					toInsert["pID"] = metaArray[metaArray.size() - 2] 
				
				#manage the flags in the metaArray
				for item in metaArray:
					match item:
						"-s":
							if prevSequenceID != null:
								dialogueDictionary[prevSequenceID]["-s"] = metaArray[2]
							prevSequenceID = metaArray[2]
						"-z":
							prevSequenceID = metaArray[2]
						"-t":
							if prevSequenceID != null:
								dialogueDictionary[prevSequenceID]["-s"] = metaArray[2]
							toInsert["-t"] = true
							prevSequenceID = null
						"-q":
							toInsert["-q"] = metaArray[mdIndex + 1]
							prevSequenceID = null
						"-x":
							toInsert["-x"] = metaArray[mdIndex + 1]
						"-o":
							var optvals = mdIndex+1
							toInsert["-o"] = []
							while optvals < metaArray.size() - 1 && metaArray[optvals].length() > 5:
								toInsert["-o"].append(metaArray[optvals])
								optvals += 1
					mdIndex += 1
				
				#add entry with key of msgID and value as metadata subdirectory
				dialogueDictionary[metaArray[2]] = toInsert
				
	#print("finished parse")
	

#either skips scroll, advances to next line, or selects option
func ui_accept_pressed():
	if textNode.get_visible_characters() < textNode.get_text().length():
		textNode.set_visible_characters(textNode.get_text().length() - 1)
	else:
		_advance()

#move up and down in an option
func ui_up_pressed():
	if inOptions:
		var opName = "Option" + str(selectedOption) + "/Selected"
		options_box.get_node(opName).hide()
		selectedOption += 1
		if selectedOption > totalOptions:
			selectedOption = 1
		opName = "Option" + str(selectedOption) + "/Selected"
		options_box.get_node(opName).show()

#move up and down in an option
func ui_down_pressed():
	if inOptions:
		var opName = "Option" + str(selectedOption) + "/Selected"
		options_box.get_node(opName).hide()
		selectedOption -= 1
		if selectedOption < 1:
			selectedOption = totalOptions
		opName = "Option" + str(selectedOption) + "/Selected"
		options_box.get_node(opName).show()

func _beginTransmit(var spID):
	InputEngine.activate_receiver(self)
	finalWaltz = false
	if !speakerDictionary.has(spID):
		Debugger.dprint("Could not find speaker ID: " + spID + " in dictionary!")
		return
	currentspID = spID
	dialogue_box.show()
	_advance()
	
func _advance():
	if dialogue_box.is_visible_in_tree():
		#if this was the final message, close
		if finalWaltz:
			#print("hiding")
			dialogue_box.hide()
			currentspID = null
			displayedID = null
			InputEngine.deactive_receiver(self)
			return
		
		textNode.set_visible_characters(0)
		
		if displayedID == null:
			displayedID = speakerDictionary[currentspID]
			textNode.text = dialogueDictionary[displayedID]["msg"]
		else:
			#obtain and display the next item in the sequence
			if dialogueDictionary[displayedID].has("-s"):
				var advanceID = dialogueDictionary[displayedID]["-s"]
				textNode.text = dialogueDictionary[advanceID]["msg"]
				displayedID = advanceID
		
		#check for a terminal flag and queued message to set
		if dialogueDictionary[displayedID].has("-q"):
			finalWaltz = true
			speakerDictionary[currentspID] = dialogueDictionary[displayedID]["-q"]
		if dialogueDictionary[displayedID].has("-t"):
			finalWaltz = true
			
		#begin text scroll
		textTimer.start()
		while (textNode.get_visible_characters() < textNode.get_text().length()):
			scrollAudio.play()
			textNode.set_visible_characters(textNode.get_visible_characters()+1)
			yield(textTimer, "timeout")
		
		#check for options flag and bring up bar if needed
		if dialogueDictionary[displayedID].has("-o"):
			inOptions = true
			options_box.show()
			var opCount = 1
			#create node for each option
			for val in dialogueDictionary[displayedID]["-o"]:
				var opNode = $"Control/Options Box/Option0".duplicate()
				opNode.get_node("msg").text = dialogueDictionary[val]["msg"]
				var marginSize = abs(opNode.get_node("msg").margin_top - opNode.get_node("msg").margin_bottom)
				opNode.position.y += opCount * marginSize
				#opNode.get_node("msg").margin_top = opNode.get_node("msg").margin_top + (opCount * marginSize)
				#opNode.get_node("msg").margin_bottom = opNode.get_node("msg").margin_bottom + (opCount * marginSize)
				opNode.set_owner(options_box)
				opNode.show()
				opNode.get_node("Selected").hide()
				options_box.add_child(opNode, true)
				opCount += 1
			totalOptions = opCount - 1
