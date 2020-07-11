extends RichTextLabel

var dd = {} #dictionary for dialogue
var content #line by line res file content
var filepath = "res://raw.res" #path to dialogue res file

var key #key to entry being inserted into dd
var val #value of entry being inserted into dd
var splitpos #marker for end of key and start of value

var scrollaudio #audio node

# Called when the node enters the scene tree for the first time.
func _ready():
	get_parent().hide()
	get_node("Scroller").connect("timeout", self, "_advance")
	scrollaudio = get_node("AudioStreamPlayer")
	
	var file = File.new()
	
	#check for and open file; abort if none found
	if !(file.file_exists(filepath)):
		print("File not found\n")
		return
	file.open(filepath, file.READ)
	
	#extract line, separate to val/key, add
	while !(file.eof_reached()):
		content = file.get_line()
		splitpos = content.find(" ", 0)
		
		#newline or no key
		if splitpos == -1:
			continue
			
		#set dictionary entries
		key = content.substr(0, splitpos)
		val = content.substr(splitpos + 1, content.length())
		if dd.has(key):
			
			dd[key] += val
		else:
			dd[key] = val
		dd[key] += "\n"
	
#Display dialogue given key
func _display(dispkey):
	#print("dispkey: " + dispkey)
	get_parent().show()
	if !dd.has(dispkey):
		text = "If you see this, something's wrong."
		return
		
	text = dd[dispkey]
	visible_characters = 0
	get_node("Scroller").start()
	
#Set one more visible character of textscroll
func _advance():
	if (visible_characters >= text.length() - 1) || (text[visible_characters] == '\n'):
		get_node("Scroller").stop()
		return
	scrollaudio.play()
	visible_characters += 1
		
#Handle a left click
func _process(delta):
	if Input.is_action_just_pressed("left_click"):
		if get_node("Scroller").is_stopped():
			if !(visible_characters >= text.length() - 1):
				#Left clicked, more lines to be read
				text = text.substr(visible_characters + 1, text.length() - 1)
				visible_characters = 0
				get_node("Scroller").start()
			else:
				#Left clicked, no more lines
				get_parent().hide()
		else:
			#Left clicked while reading a line
			get_node("Scroller").stop()
			visible_characters = text.find('\n')
			