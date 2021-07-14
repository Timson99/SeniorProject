"""
	DialogueManager
		Manager for a global Dialogue System
		
	Features
		Display a Dialogue Stream from a Dialogue Parse Result (See Dialogue Parser)
		Display a array of strings
		Scroll out text at a given speed/char interval, stopping at breath marks
		
	Dependencies
		SaveManager ( to save queued contexts )
		ActorManager ( to register self as an actor )
		
"""
extends CanvasLayer


# TODO? make Dialogue Box and standalone instantiable object by the Dialogue Manager/UI Manager

# SIGNALS
signal begin()
signal page_over()
signal end()

# DIALOGUE STREAM DATA
# d_id dictionary of context dictionaries ( Parsed Dialogue File(s) 
var dialogue_dictionary := {}
# Dictionary for starting contexts -> d_id : Starting Context for d_id 
var queued_contexts := {}  
# List of Dialogue Files to Parse
var dialogue_files := ["res://Resources/Dialogue/Area01_NEW.res"] 

# CONFIGURABLE GLOBAL SCROLL OPTIONS -> CHANGE THROUGH FUNCTION CALLS
#Seconds per characters jumped, Can't be faster than a frame, 1/60 (0.016 sec)
var default_scroll_time := 0.02
var scroll_time := default_scroll_time
# When scrolling, characters to display every scroll_time seconds
var default_character_jump := 2
var character_jump := default_character_jump
# When breath char in scroll, it is removed and scroll is paused for breath_pause seconds
var breath_char := "`"
var breath_pause := 0.5

# Counts how many messages this object has displayed, identifies a unique dialogue message
var message_counter := 0

# Dilogue Specific members
var transmitting := false
var dialogue_stream := []
var current_d_id := "" #For queueing to a specific d_id


#	TREE NODE ACCESS
onready var scrollAudio := get_node("TextAudio")
onready var optionAudio := get_node("OptionAudio")
onready var dialogue_box := $"Control/Dialogue Box"
onready var options_box := $Control/OptionsBox
onready var options_selection := $Control/OptionsBox/OptionList
onready var textNode := dialogue_box.get_node("RichTextLabel")


##############
#  CALLBACKS
##############

func _ready():
	
	options_selection.connect("selection_made", self, "option_picked")
	
	# Parse master dialogue file
	var dialogue_master_file = ""
	for file_path in dialogue_files:
		dialogue_master_file += "\n" + FileTools.file_to_string(file_path)
	dialogue_dictionary = DialogueParser.parse(dialogue_master_file)
	
	# Registrations
	SaveManager.register(self)
	ActorManager.register(self)
	
	# Initial Node Settings
	dialogue_box.hide()
	options_box.hide()
	textNode.bbcode_enabled = true
	
	
func save():
	return  { "queued_contexts" : queued_contexts }
	
	
###########
#  PUBLIC
###########

# Set scroll_time and character_jump
func set_scroll_settings(new_scroll_time : float, new_character_jump : int):
	scroll_time = new_scroll_time
	character_jump = new_character_jump

# Restore scroll_time and character_jump to defaults	
func restore_scroll_settings():
	scroll_time = default_scroll_time
	character_jump = default_character_jump

# Sends an item message
func item_message(itemId):
	transmit_message("You recieved " + itemId + "!")

# Trasmits a dialogue stream from a d_id
func transmit_dialogue(var d_id):
	# Only Transmit if not currently transmitting
	if transmitting: 
		Debugger.dprint("CANNOT TRANSMIT d_id '%s' - Dialogue in progess " % d_id,2)
		return
	transmitting = true
	# Queue up dialogue stream from starting contexts
	if !dialogue_dictionary.has(d_id):
		Debugger.dprint("Could not find speaker ID: " + d_id + " in dictionary!")
		return
	if queued_contexts.has(d_id):
		var context = queued_contexts[d_id]
		dialogue_stream = dialogue_dictionary[d_id][context].duplicate()
	elif dialogue_dictionary[d_id].has("MAIN"):
		dialogue_stream = dialogue_dictionary[d_id]["MAIN"].duplicate()
	else:
		Debugger.dprint("No MAIN Context for d_id %s" % d_id)
		return
	# Initialize Settings
	emit_signal("begin")
	current_d_id = d_id
	InputManager.activate(self)
	dialogue_box.show()
	_advance()
	
# Display a message or an array of messages
func transmit_message(input_message):
	# Only Transmit if not currently transmitting
	if transmitting: 
		Debugger.dprint("CANNOT TRANSMIT MESSAGE - Dialogue in progess",3)
		return
	transmitting = true
	# Queue up dialogue stream from starting contexts
	var message_array = input_message.duplicate() if typeof(input_message) == TYPE_ARRAY else [input_message]
	for str_message in message_array:
		dialogue_stream.push_back({"type" : "TEXT", "text" : str_message})
	# Initialize Settings
	emit_signal("begin")
	InputManager.activate(self)
	dialogue_box.show()
	_advance()


###########
#  PRIVATE
###########
	
# Advance dialogue to next message or carry out action
func _advance():
	while true:
		# FETCH MESSAGE
		################
		if(dialogue_stream.size() == 0):
			_close_dialogue_box()
			return	
		var line_dict = dialogue_stream.pop_front()
		# INTERPRET MESSAGE TYPE
		########################
		if line_dict["type"] == "QUEUE":
			queued_contexts[current_d_id] = line_dict["queued_context"]
		elif line_dict["type"] == "EXECUTE":
			EventManager.execute_event(line_dict["event_id"])
		elif line_dict["type"] == "OPTIONS":
			options_box.show()
			options_selection.create_and_activate(line_dict["options"])
			return
		elif line_dict["type"] == "TEXT":
			message_counter += 1
			_text_scroll( line_dict["text"], message_counter )
			return
		else:
			Debugger.dprint("Unrecognized Line Dict Type: %s" % line_dict)
			
			
func option_picked(option_dict):
	var selected_context = option_dict["destination"]
	dialogue_stream = dialogue_dictionary[current_d_id][selected_context] + dialogue_stream
	options_box.hide()
	_advance()



# Display text letter by letter, speed of character_jump characters per scroll_time
# NOTE: Scroll time cannot be faster than a frame (1/60 seconds per frame)
# Adds a breath delay for each breath mark
# messages num ensures that a coroutine instance ends as soon as there is a competeing instance
func _text_scroll(text, call_number):
	textNode.set_visible_characters(0)
	textNode.bbcode_text = text
	# Text Scroll Loop
	while true:
		# WHETHER OR NOT TO SCROLL TO NEXT LETTER
		if(textNode.get_visible_characters() >= textNode.get_text().length() or 
			call_number != message_counter):
			return
		#scrollAudio.play()
		
		# Scrolls forward as many characters as defined in character_jump
		var initial_visible = textNode.get_visible_characters()
		textNode.set_visible_characters(initial_visible+character_jump)
		
		# PARSE BREATH MARKERS AND DETERMINE WAIT TIME TILL NEXT SCROLL
		var new_scroll_time = scroll_time
		var char_chunk = textNode.bbcode_text.substr(initial_visible, character_jump)
		if (breath_char in char_chunk):
			# Add breath pause to scroll time
			var first_breath_index = char_chunk.find(breath_char)
			new_scroll_time += breath_pause
			#Erase breath character
			var tempText = textNode.bbcode_text
			tempText.erase(initial_visible + first_breath_index, 1)
			textNode.bbcode_text = tempText
			# Display all characters before the breath character
			textNode.set_visible_characters(initial_visible+first_breath_index)
			
		yield(get_tree().create_timer(new_scroll_time, false), "timeout")
		#scrollAudio.stop()
	
# Terminate Dialogue Stream and reset settings
func _close_dialogue_box():
	InputManager.deactivate(self)
	dialogue_box.hide()
	current_d_id = ""
	dialogue_stream = []
	emit_signal("end")
	transmitting = false
	
	
###################
#  INPUT MAPPINGS
###################

const input_data : Dictionary = {
	"loop" : "_process",
	"pressed": {},
	"just_pressed": {
		 "ui_accept" : "ui_accept_pressed",
		 "ui_cancel" : "ui_accept_pressed",
	},
	"just_released": {},
}
	
#When accept: Skips scroll, Advances to next line, or Selects Option
func ui_accept_pressed():
	if textNode.get_visible_characters() < textNode.get_text().length():
		var string_stripped = textNode.bbcode_text.replace("`", "")
		textNode.bbcode_text = string_stripped
		textNode.set_visible_characters(string_stripped.length())
	else:
		_advance()
		emit_signal("page_over")




