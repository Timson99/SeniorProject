extends Control

#InputEngine
var input_id = "Battle_Dialogue"
onready var text_node = $RichTextLabel
	
var message = []

var scroll_time := 0.0 #Can't be faster than a frame, 1/60
var character_jump = 1
var breath_pause = 0.25
var breath_char = "`"
enum Mode {Input, Display}
var mode = null

signal begin()
signal page_over()
signal end()	

#either skips scroll, advances to next line, or selects option
func ui_accept_pressed():
	if text_node.get_visible_characters() < text_node.get_text().length():
		text_node.set_visible_characters(text_node.get_text().length() - 1)
	else:
		emit_signal("page_over")
		_advance_message()

	
func display_message(message_param, input=false, scroll_time=0.0, character_jump=1000):
	
	self.scroll_time = scroll_time
	self.character_jump = character_jump
	
	if input:
		mode = Mode.Input
		InputEngine.activate_receiver(self)

	else:
		mode = Mode.Display
	message = message_param if typeof(message_param) == TYPE_ARRAY else [message_param]
	emit_signal("begin")
	_advance_message()

	
func _advance_message():
	text_node.set_visible_characters(0)	
	
	if(message.size() == 0):
		clear()
		return
	
	text_node.text = message.pop_front()
	
	#begin text scroll
	while true:
		if(text_node.get_visible_characters() >= text_node.get_text().length()):
			break
		#scrollAudio.play()
		var new_scroll_time = scroll_time
		var initial_visible = text_node.get_visible_characters()
		text_node.set_visible_characters(initial_visible+character_jump)
		var char_chunk = text_node.text.substr(initial_visible, text_node.get_visible_characters())
		if (text_node.get_visible_characters() < text_node.get_text().length() and
			breath_char in char_chunk):
			
			var first_breath_index = char_chunk.find(breath_char)
			new_scroll_time += breath_pause
			####
			var tempText = text_node.text
			tempText.erase(initial_visible + first_breath_index, 1)
			text_node.text = tempText
			####
			text_node.set_visible_characters(initial_visible+first_breath_index)
			
		yield(get_tree().create_timer(new_scroll_time, false), "timeout")
		#scrollAudio.stop()
	
func clear():
	text_node.set_visible_characters(0)	
	if mode == Mode.Input:
		InputEngine.deactivate_receiver(self)
	mode = null
	message = null
	scroll_time = 0.0
	character_jump = 1000
	emit_signal("end")

