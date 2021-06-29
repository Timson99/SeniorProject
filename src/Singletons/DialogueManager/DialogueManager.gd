"""
	DialogueManager
"""
extends CanvasLayer

signal begin()
signal page_over()
signal end()

# Dialogue Filing System (Reform?)
var current_area = "Area01"
var dialogue_areas = {}
var dialogue_files = {
	"Area01" : ["res://Resources/Dialogue/Area01_NEW.res"],
	#"Area02" : ["res://Resources/Dialogue/Area02.res"],
}

# CONFIGURABLE GLOBAL SCROLL OPTIONS -> CHANGE THROUGH FUNCTION CALLS
var scroll_time := 0.02 #Can't be faster than a frame, 1/60
var character_jump = 2
var breath_pause = 0.5
var breath_char = "`"

# Dilogue Specific members
var transmitting = false
var message = []
var current_d_id = "" #For queueing to a specific d_id
var message_counter = 0

# Variables for dialogue options
var inOptions = false
var inOptionTree = false
var selectedOption = 1
var totalOptions = 1

#	TREE NODE ACCESS
onready var scrollAudio = get_node("TextAudio")
onready var optionAudio = get_node("OptionAudio")
onready var dialogue_box = $"Control/Dialogue Box"
onready var options_box = $"Control/Options Box"
onready var textNode = dialogue_box.get_node("RichTextLabel")
onready var textTimer = get_node("Timer")

# Called when the node enters the scene tree for the first time.
func _ready():
		
	for area_name in dialogue_files:
		var dialogue_src = ""
		for path in dialogue_files[area_name]:
			dialogue_src += "\n" + FileTools.file_to_string(path)
		var dialogue_dict = DialogueParser.parse(dialogue_src)
		
		var file_path = dialogue_files[area_name]
		dialogue_areas[area_name] = {
			"id_context_queue" : {},
			"dialogueDictionary" : dialogue_dict,
		}
	dialogue_box.hide()
	options_box.hide()
	
#####################################################################

# Sends an item message
func item_message(itemId):
	transmit_message("You recieved " + itemId + "!")

# Trasmits a dialogue stream from a d_id
func transmit_dialogue(var d_id):
	var dialogue_info = dialogue_areas[current_area]
	if !dialogue_info["dialogueDictionary"].has(d_id):
		Debugger.dprint("Could not find speaker ID: " + d_id + " in dictionary!")
		return
	if dialogue_info["id_context_queue"].has(d_id):
		var context = dialogue_info["id_context_queue"][d_id]
		message = dialogue_info["dialogueDictionary"][d_id][context].duplicate()
	elif dialogue_info["dialogueDictionary"][d_id].has("MAIN"):
		message = dialogue_info["dialogueDictionary"][d_id]["MAIN"].duplicate()
	else:
		Debugger.dprint("No MAIN Context for d_id %s" % d_id)
		return
		
	current_d_id = d_id
	message_counter = 0
	InputManager.activate(self)
	dialogue_box.show()
	emit_signal("begin")
	_advance()
	
# Display a message or an array of messages
func transmit_message(input_message):
	var message_array = input_message.duplicate() if typeof(input_message) == TYPE_ARRAY else [input_message]
	for str_message in message_array:
		message.push_back({"type" : "TEXT", "text" : str_message})
	
	message_counter = 0
	InputManager.activate(self)
	dialogue_box.show()
	emit_signal("begin")
	_advance()

######################################################################################
	
# Advance dialogue to next message and scroll out text
func _advance():

	while true:
		# FETCH MESSAGE
		################
		if(message.size() == 0):
			_close_dialogue_box()
			return	
		var line_dict = message.pop_front()
		# INTERPRET MESSAGE TYPE
		########################
		if line_dict["type"] == "QUEUE":
			dialogue_areas[current_area]["id_context_queue"][current_d_id] = line_dict["queued_context"]
		elif line_dict["type"] == "EXECUTE":
			EventManager.execute_event(line_dict["event_id"])
		elif line_dict["type"] == "OPTION":
			_display_options( line_dict["options"] )
			return
		elif line_dict["type"] == "TEXT":
			message_counter += 1
			_text_scroll( line_dict["text"], message_counter )
			return
		else:
			Debugger.dprint("Unrecognized Line Dict Type: %s" % line_dict)


# Show options an initialize ui interaction
func _display_options(options : Array):
	textNode.set_visible_characters(0)
	pass
	"""
		inOptions = true
			options_box.show()
			var opCount = 1
			#create node for each option
			for val in dialogueDictionary[displayedID]["-o"]:
				var opNode = $"Control/Options Box/Option0".duplicate()
				opNode.get_node("msg").text = dialogueDictionary[val]["msg"]
				var marginSize = abs(opNode.get_node("msg").margin_top - opNode.get_node("msg").margin_bottom)
				opNode.position.y += opCount * marginSize
				opNode.set_owner(options_box)
				opNode.show()
				if (opCount != 1):
					opNode.get_node("Selected").hide()
				options_box.add_child(opNode, true)
				opCount += 1
			totalOptions = opCount - 1
			selectedOption = 1
		"""

# Display text letter by letter, speed of character_jump characters per scroll_time
# NOTE: Scroll time cannot be faster than a frame (1/60 seconds per frame)
# Adds a breath delay for each breath mark
# messages num ensures that a coroutine instance ends as soon as there is a competeing instance
func _text_scroll(text, call_number):
	textNode.set_visible_characters(0)
	textNode.text = text
	
	#begin text scroll
	while true:
		# WHETHER OR NOT TO SCROLL TO NEXT LETTER
		if(textNode.get_visible_characters() >= textNode.get_text().length() or 
			call_number != message_counter):
			return
		# PRINT character_jump MORE CHARACTERS
		#scrollAudio.play()
		var initial_visible = textNode.get_visible_characters()
		textNode.set_visible_characters(initial_visible+character_jump)
		
		# PARSE BREATH MARKERS AND DETERMINE WAIT TIME TILL NEXT SCROLL
		var new_scroll_time = scroll_time
		var char_chunk = textNode.text.substr(initial_visible, character_jump)
		if (breath_char in char_chunk):
			# Add breath pause to scroll time
			var first_breath_index = char_chunk.find(breath_char)
			new_scroll_time += breath_pause
			#Erase breath character
			var tempText = textNode.text
			tempText.erase(initial_visible + first_breath_index, 1)
			textNode.text = tempText
			# Display all characters before the breath character
			textNode.set_visible_characters(initial_visible+first_breath_index)
			
		yield(get_tree().create_timer(new_scroll_time, false), "timeout")
		#scrollAudio.stop()
	
	
	
func _close_dialogue_box():
	InputManager.deactivate(self)
	dialogue_box.hide()
	emit_signal("end")
	current_d_id = ""
	message = []
	message_counter = 0
	
	
	
func clear_options():
	inOptions = false
	while totalOptions > 0:
		var opName = "Option" + str(totalOptions)
		var n = options_box.get_node(opName)
		n.queue_free()
		
		totalOptions -= 1
	options_box.hide()
	totalOptions = 1
	
	

	
########################################################################################



const input_data : Dictionary = {
	"loop" : "_process",
	"pressed": {},
	"just_pressed": {
		 "ui_accept" : "ui_accept_pressed",
		 "ui_cancel" : "ui_accept_pressed",
		 "ui_up" : "ui_up_pressed",
		 "ui_down" : "ui_down_pressed"
	},
	"just_released": {},
}
	

#either skips scroll, advances to next line, or selects option
func ui_accept_pressed():
	if inOptions:
		optionAudio.stream = load("res://Assets/Christian_Test_Assets/Option_Selected.wav")
		optionAudio.play()
		clear_options()
		_advance()
	elif textNode.get_visible_characters() < textNode.get_text().length():
		var string_stripped = textNode.text.replace("`", "")
		textNode.text = string_stripped
		textNode.set_visible_characters(string_stripped.length())
	else:
		_advance()
		emit_signal("page_over")

#move up and down in an option
func ui_down_pressed():
	if inOptions:
		optionAudio.stream = load("res://Assets/Christian_Test_Assets/Option_Arrow_Key_Pressed.wav")
		optionAudio.play()
		var opName = "Option" + str(selectedOption) + "/Selected"
		options_box.get_node(opName).hide()
		selectedOption += 1
		if selectedOption > totalOptions:
			selectedOption = 1
		opName = "Option" + str(selectedOption) + "/Selected"
		options_box.get_node(opName).show()

#move up and down in an option
func ui_up_pressed():
	if inOptions:
		optionAudio.stream = load("res://Assets/Christian_Test_Assets/Option_Arrow_Key_Pressed.wav")
		optionAudio.play()
		var opName = "Option" + str(selectedOption) + "/Selected"
		options_box.get_node(opName).hide()
		selectedOption -= 1
		if selectedOption < 1:
			selectedOption = totalOptions
		opName = "Option" + str(selectedOption) + "/Selected"
		options_box.get_node(opName).show()

"""
extends CanvasLayer


signal begin()
signal page_over()
signal end()

var current_area = "Area01"

#MAKE INTO DIRECTORY FILE
var dialogue_areas = {}
var dialogue_files = DialogueFiles.get_data()

enum Mode {Message, Dialogue}
var mode = null
var message = []


var scroll_time := 0.02 #Can't be faster than a frame, 1/60
var character_jump = 2
var breath_pause = 0.25
var breath_char = "`"

# Member variables
var dialogueDictionary = {}
var speakerDictionary = {} #where arr[0] is main, others are reactive
#export var ResFile = "Test_Project_Dialogue"
var displayedID = null
var currentspID = null
var finalWaltz = true
var reactiveID = ""

# Variables for dialogue options
var inOptions = false
var inOptionTree = false
var selectedOption = 1
var totalOptions = 1
var parentBranchNodes = []

# Nodes for ease of access
onready var scrollAudio = get_node("TextAudio")
onready var optionAudio = get_node("OptionAudio")
onready var dialogue_box = $"Control/Dialogue Box"
onready var options_box = $"Control/Options Box"
onready var textNode = dialogue_box.get_node("RichTextLabel")
onready var textTimer = get_node("Timer")

# Called when the node enters the scene tree for the first time.
func _ready():
	for area_name in dialogue_files:
		var file_path = dialogue_files[area_name]
		dialogue_areas[area_name] = {}
		dialogue_areas[area_name]["res_path"] = file_path
		dialogue_areas[area_name]["speakerDictionary"] = {}
		dialogue_areas[area_name]["dialogueDictionary"] = {}

	dialogue_box.hide()
	options_box.hide()
	parse_res_file()
	
func parse_res_file():
	var path = dialogue_areas[current_area]["res_path"]
	
	# Create file, test for existance
	var file = File.new()
	if !(file.file_exists(path)):
		Debugger.dprint("File not found")
		return
	file.open(path, file.READ)
	
	#parse file
	var qParse = []
	var raw = file.get_as_text()
	file.close()
	var rawArray = raw.split("\n", false)
	var prevSequenceID = null
	#Remove Project Name
	rawArray.remove(0)
	var current_speaker = ""
	for val in rawArray:
		var mdLength = val.find("*/")
		if mdLength > -1:
			#get metadata and split into array
			var metaData = val.left(mdLength + 2)
			var metaArray = metaData.split(" ", false)
	
			if metaArray.size() <= 5 || metaArray[1].length() != 5:
				current_speaker = metaArray[1]
				continue
			#check for -z flag, to update speaker dictionary
			if !speakerDictionary.has(current_speaker) && metaArray[3] == "-z":
				speakerDictionary[current_speaker] = [metaArray[2]]
			
			#establish sub dictionary to add as val to dialogueDictionary
			var toInsert = {"msg": val.right(mdLength + 3)}
			var mdIndex = 0
			
			#get parent id for option logic
			if metaArray[metaArray.size() - 2].length() > 5:
				toInsert["pID"] = metaArray[metaArray.size() - 2] 
			
			#manage the flags in the metaArray
			var setPSID = false
			for item in metaArray:
				match item:
					"-s":
						if prevSequenceID != null:
							dialogueDictionary[prevSequenceID]["-s"] = metaArray[2]
						setPSID = true
					"-z":
						setPSID = true
					"-t":
						if prevSequenceID != null:
							dialogueDictionary[prevSequenceID]["-s"] = metaArray[2]
						toInsert["-t"] = true
						prevSequenceID = null
					"-q":
						if !qParse.has(metaArray[mdIndex + 1]):
							qParse.append(metaArray[2])
							toInsert["-q"] = metaArray[mdIndex + 1]
							prevSequenceID = null
						else:
							if qParse.find(mdIndex + 1) > -1:
								qParse.remove(qParse.find(mdIndex + 1))
					"-x":
						toInsert["-x"] = metaArray[mdIndex + 1]
					"-o":
						var optvals = mdIndex+1
						toInsert["-o"] = []
						while optvals < metaArray.size() - 1 && metaArray[optvals].length() > 5:
							toInsert["-o"].append(metaArray[optvals])
							optvals += 1
					"-rct":
						if prevSequenceID != null:
							dialogueDictionary[prevSequenceID]["-t"] = true
							dialogueDictionary[prevSequenceID].erase("-s")
						setPSID = true
						toInsert["-rct"] = metaArray[mdIndex + 1]
						speakerDictionary[current_speaker].append(metaArray[2])
				mdIndex += 1
			if setPSID:
				prevSequenceID = metaArray[2]
				setPSID = false
			
			#add entry with key of msgID and value as metadata subdirectory
			dialogueDictionary[metaArray[2]] = toInsert
			
	#print(dialogueDictionary)
	#print(speakerDictionary)
	
	
const input_data : Dictionary = {
	"loop" : "_process",
	"pressed": {},
	"just_pressed": {
		 "ui_accept" : "ui_accept_pressed",
		 "ui_cancel" : "ui_accept_pressed",
		 "ui_up" : "ui_up_pressed",
		 "ui_down" : "ui_down_pressed"
	},
	"just_released": {},
}
	

#either skips scroll, advances to next line, or selects option
func ui_accept_pressed():
	if inOptions:
		optionAudio.stream = load("res://Assets/Christian_Test_Assets/Option_Selected.wav")
		optionAudio.play()
		displayedID = dialogueDictionary[displayedID]["-o"][selectedOption-1]
		parentBranchNodes.append(displayedID)
		clear_options()
		_advance()
	elif textNode.get_visible_characters() < textNode.get_text().length():
		var string_stripped = textNode.text.replace("`", "")
		textNode.text = string_stripped
		textNode.set_visible_characters(string_stripped.length() - 1)
	elif mode == Mode.Dialogue:
		_advance()
		emit_signal("page_over")
	elif mode == Mode.Message:
		_advance_message()
		emit_signal("page_over")

#move up and down in an option
func ui_down_pressed():
	if inOptions:
		optionAudio.stream = load("res://Assets/Christian_Test_Assets/Option_Arrow_Key_Pressed.wav")
		optionAudio.play()
		var opName = "Option" + str(selectedOption) + "/Selected"
		options_box.get_node(opName).hide()
		selectedOption += 1
		if selectedOption > totalOptions:
			selectedOption = 1
		opName = "Option" + str(selectedOption) + "/Selected"
		options_box.get_node(opName).show()

#move up and down in an option
func ui_up_pressed():
	if inOptions:
		optionAudio.stream = load("res://Assets/Christian_Test_Assets/Option_Arrow_Key_Pressed.wav")
		optionAudio.play()
		var opName = "Option" + str(selectedOption) + "/Selected"
		options_box.get_node(opName).hide()
		selectedOption -= 1
		if selectedOption < 1:
			selectedOption = totalOptions
		opName = "Option" + str(selectedOption) + "/Selected"
		options_box.get_node(opName).show()

func clear_options():
	inOptions = false
	while totalOptions > 0:
		var opName = "Option" + str(totalOptions)
		var n = options_box.get_node(opName)
		n.queue_free()
		
		totalOptions -= 1
	options_box.hide()
	totalOptions = 1

func _beginTransmit(var spID, var toSignal):
	InputManager.activate(self)
	finalWaltz = false
	reactiveID = toSignal
	if !speakerDictionary.has(spID):
		Debugger.dprint("Could not find speaker ID: " + spID + " in dictionary!")
		InputManager.deactivate(self)
		return
	currentspID = spID
	dialogue_box.show()
	mode = Mode.Dialogue
	emit_signal("begin")
	_advance()
	
func item_message(itemId):
	transmit_message("You recieved " + itemId + "!")
	
func transmit_message(message):
	transmit_message(message)
	
func transmit_message(message_param):
	InputManager.activate(self)
	dialogue_box.show()
	mode = Mode.Message
	message = message_param if typeof(message_param) == TYPE_ARRAY else [message_param]
	_advance_message()
	
func _advance_message():
	if dialogue_box.is_visible_in_tree():
		textNode.set_visible_characters(0)	
		
		if(message.size() == 0):
			exec_final_waltz()
			return
		
		textNode.text = message.pop_front()
		
		#begin text scroll
		while true:
			if(textNode.get_visible_characters() >= textNode.get_text().length()):
				break
			#scrollAudio.play()
			var new_scroll_time = scroll_time
			var initial_visible = textNode.get_visible_characters()
			textNode.set_visible_characters(initial_visible+character_jump)
			var char_chunk = textNode.text.substr(initial_visible, textNode.get_visible_characters())
			if (textNode.get_visible_characters() < textNode.get_text().length() and
				breath_char in char_chunk):
				
				var first_breath_index = char_chunk.find(breath_char)
				new_scroll_time += breath_pause
				####
				var tempText = textNode.text
				tempText.erase(initial_visible + first_breath_index, 1)
				textNode.text = tempText
				####
				textNode.set_visible_characters(initial_visible+first_breath_index)
				
			yield(get_tree().create_timer(new_scroll_time, false), "timeout")
			#scrollAudio.stop()
	
func exec_final_waltz():
	emit_signal("end")
	dialogue_box.hide()
	currentspID = null
	displayedID = null
	parentBranchNodes = []
	mode = null
	message = null
	InputManager.deactivate(self)
	
func _advance():
	if dialogue_box.is_visible_in_tree():
		#if this was the final message, close
		if finalWaltz:
			exec_final_waltz()
			return
		
		textNode.set_visible_characters(0)
		
		if displayedID == null:
			if reactiveID != "" && reactiveID != null:
				displayedID = reactiveID
				for v in speakerDictionary[currentspID]:
					if dialogueDictionary[v].has("-rct") && dialogueDictionary[v]["-rct"] == reactiveID:
						displayedID = v
				if displayedID == null:
					displayedID = speakerDictionary[currentspID][0]
			else:
				displayedID = speakerDictionary[currentspID][0]
			textNode.text = dialogueDictionary[displayedID]["msg"]
		else:
			#if a response, obtain the next valid message
			if dialogueDictionary[displayedID].has("-r"):
				var advanceID = dialogueDictionary[displayedID]["-s"]
				textNode.text = dialogueDictionary[advanceID]["msg"]
				displayedID = advanceID
				
			#obtain and display the next item in the sequence
			var advanceable = false
			while !advanceable:
				advanceable = true
				if !dialogueDictionary[displayedID].has("-s"):
					exec_final_waltz()
					return
				var advanceID = dialogueDictionary[displayedID]["-s"]
				textNode.text = dialogueDictionary[advanceID]["msg"]
				displayedID = advanceID
				#if dialogue has a parent, ensure that the parent has been encountered
				if dialogueDictionary[displayedID].has("pID"):
					if !(parentBranchNodes.has(dialogueDictionary[displayedID]["pID"])):
						advanceable = false
							#nothing found before end of file
						if dialogueDictionary[displayedID].has("-t"):
							exec_final_waltz()
							return
		
		#check for a terminal flag and queued message to set
		if dialogueDictionary[displayedID].has("-q"):
			finalWaltz = true
			speakerDictionary[currentspID][0] = dialogueDictionary[displayedID]["-q"]
		if dialogueDictionary[displayedID].has("-t"):
			finalWaltz = true
			
		#begin text scroll
		while true:
			if(textNode.get_visible_characters() >= textNode.get_text().length()):
				break
			#scrollAudio.play()
			var new_scroll_time = scroll_time
			var initial_visible = textNode.get_visible_characters()
			textNode.set_visible_characters(initial_visible+character_jump)
			var char_chunk = textNode.text.substr(initial_visible, textNode.get_visible_characters())
			if (textNode.get_visible_characters() < textNode.get_text().length() and
				breath_char in char_chunk):
				
				var first_breath_index = char_chunk.find(breath_char)
				new_scroll_time += breath_pause
				####
				var tempText = textNode.text
				tempText.erase(initial_visible + first_breath_index, 1)
				textNode.text = tempText
				####
				textNode.set_visible_characters(initial_visible+first_breath_index)
				
			yield(get_tree().create_timer(new_scroll_time, false), "timeout")
			#scrollAudio.stop()
		
		#check for options flag and bring up bar if needed
		if displayedID and dialogueDictionary[displayedID].has("-o"):
			inOptions = true
			options_box.show()
			var opCount = 1
			#create node for each option
			for val in dialogueDictionary[displayedID]["-o"]:
				var opNode = $"Control/Options Box/Option0".duplicate()
				opNode.get_node("msg").text = dialogueDictionary[val]["msg"]
				var marginSize = abs(opNode.get_node("msg").margin_top - opNode.get_node("msg").margin_bottom)
				opNode.position.y += opCount * marginSize
				opNode.set_owner(options_box)
				opNode.show()
				if (opCount != 1):
					opNode.get_node("Selected").hide()
				options_box.add_child(opNode, true)
				opCount += 1
			totalOptions = opCount - 1
			selectedOption = 1
"""
