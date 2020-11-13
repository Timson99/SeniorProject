extends Control

#InputEngine
var input_id = "Battle_Dialogue"
onready var text_node = $RichTextLabel
	
var message = []

var scroll_time := 0.01 #Can't be faster than a frame, 1/60
var character_jump = 5
var breath_pause = 0.25
var breath_char = "`"
enum Mode {Input, Display}
var mode = null

	

#either skips scroll, advances to next line, or selects option
func ui_accept_pressed():
	if text_node.get_visible_characters() < text_node.get_text().length():
		text_node.set_visible_characters(text_node.get_text().length() - 1)
	else:
		_advance_message()

	
func display_message(message_param, input=false):
	if input:
		mode = Mode.Input
		InputEngine.activate_receiver(self)
	else:
		mode = Mode.Display
	message = message_param if typeof(message_param) == TYPE_ARRAY else [message_param]
	_advance_message()

	
func _advance_message():
	text_node.set_visible_characters(0)	
	
	if(message.size() == 0):
		clear()
		return
	
	text_node.text = message.pop_front()
	
	while true:
		if(text_node.get_visible_characters() >= text_node.get_text().length()):
			break
		#scrollAudio.play()
		var new_scroll_time = scroll_time
		text_node.set_visible_characters(text_node.get_visible_characters()+character_jump)
		if (text_node.get_visible_characters() < text_node.get_text().length() and
			text_node.text[text_node.get_visible_characters()] == breath_char):
			new_scroll_time += breath_pause
			var tempText = text_node.text
			tempText.erase(text_node.get_visible_characters(), 1)
			text_node.text = tempText
		yield(get_tree().create_timer(new_scroll_time, false), "timeout")	
		#scrollAudio.stop()
	
func clear():
	text_node.set_visible_characters(0)	
	if mode == Mode.Input:
		InputEngine.deactivate_receiver(self)
	mode = null
	message = null

