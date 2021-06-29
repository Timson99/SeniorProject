"""
	Dialogue Parser
		Takes a dialogue resource file and transforms it into a dictionary
		
	ID Declaration: ID that unlocks a single dialogue stream (Must have a MAIN context)
	Context Declaration: Context that holds dialogue expressions
		Speaker Expression: Display Name of Speaking Character 
							Can have ~RAW flag -> Include Newlines in Dialogue Block
							Can have ~VAR flag -> Indicates var to replace
			Dialogue Block: Block of Dialogue Text
		Option Expression: Indicates following expressions are option choices
			Option Choice Expression: Option Text and Context to Jump to
		Queue Expression: Indicates Context to queue next time dialogue is initiated
		Execute Expression: Indicates event to execute immediately with EventManager
	
	Example of Dialogue File
	
		d_id = Dialogue01
		
		CONTEXT MAIN
			Player
				Hi
			QUEUE PATH1
			EXECUTE Event01
			OPTIONS
				Try This -> PATH2
				No This  -> PATH3
		
	Example of Dialogue Dictionary: 
		{ "Dialogue01" : 
			{ "MAIN" : 
				[ 
					{ "type": "TEXT", "speaker" : "Player", "text" : "Hi", "VAR" : false },
					{ "type": "QUEUE", "queued_context" : "PATH1" },
					{ "type": "EXECUTE", "event_id" : "Event01" },
					{ "type": "OPTIONS", "options" : 
						[
							{ "text" : "Try This", "destination" : "PATH2" }, 
							{ "text" : "No This",  "destination" : "PATH3" }, 
						] 
					},
				] 
				...
			},  
			...
		} 
"""
extends Object

class_name DialogueParser

#########
# Public
#########

# Parses a dialogue file into a dialogue dictionary
static func parse(dialogue_src : String):
	var splitted : Array = dialogue_src.split("\n", false)
	var indent_trees = _format_and_create_indent_trees(splitted)
	
	var dialogue_dict = {}
	var current_id = ""
	
	for zero_indent_line in indent_trees:
		var content = zero_indent_line["content"]
		## D_ID LINE
		##############
		var d_id = _validate_id_declaration(content)
		if d_id:
			if dialogue_dict.has(d_id): _no_duplicate_d_id(d_id)
			current_id = d_id
			dialogue_dict[current_id] = {}
			continue
		## CONTEXT LINE	
		###############
		var context_name = _validate_context_declaration(content)
		if context_name:
			if dialogue_dict[current_id].has(context_name): 
				_no_duplicate_context(d_id, context_name)
			dialogue_dict[current_id][context_name] = (
				_parse_context(zero_indent_line["children"]) 
			)
			continue
		## UNRECOGNIZED LINE	
		####################
		Debugger.dprint("INDENT ERROR: Unexpected line at Indent Level 0:  %s" % content )
		
	_need_main_context(dialogue_dict)
	return dialogue_dict


######################
#	Debugging Tools
######################

#For a given dialogue dict, list all speakers
func get_speakers_list(dialogue_dict : Dictionary):
	var speaker_list = []
	for d_id in dialogue_dict.values():
		for context in d_id.values():
			for line in context:
				if line.has("speaker") and !speaker_list.has(line["speaker"]):
					speaker_list.push_back(line["speaker"])
	return speaker_list


########
# Private
########	
	
# Calculate indent for a given file line, (Accepts tabs or 4 space indentation)
static func _calculate_indent_level(line : String):
	var indent_level = 0
	var char_index = 0
	while true:
		if line.substr(char_index, 4) == "    ": 
			indent_level+=1
			char_index+=4
		elif line.substr(char_index, 1) == "\t":
			indent_level+=1
			char_index+=1
		else: break
	return min(2, indent_level)

# Format line contents and arrange into a dialogue dictionary tree
static func _format_and_create_indent_trees(splitted : Array):
	#Stack of Indent blocks, which is a array of statements at a given indent level
	var stack = [ [] ] 
	var last_indent = 0
	while splitted.size() > 0:
		var line = splitted.pop_front()
		var indent_level = _calculate_indent_level(line)
		# FORMAT CONTENT
		################
		# If Indent 0 or 1, remove edges and ignore line entirely if all whitespace 
		var content : String
		if indent_level == 0 || indent_level == 1: 
			content = line.strip_edges()
			if content.length() == 0:
				continue
		# If Indent 2, strip right edge and remove two levels of indent from right
		else: 
			content = line.strip_edges(false, true)
			content = ( content.substr(2) if content[0] == "\t" else content.substr(8) )
		# BUILD INDENT TREE
		####################
		var line_dict = {"content" : content, "children" : []}
		if last_indent < indent_level: # Indent out, create indent block
			stack.push_back( [] )
		elif last_indent > indent_level: # Indent in, nest within last line of parent block
			while last_indent > indent_level:
				var lines = stack.pop_back()
				stack.back().back()["children"] = lines
				last_indent -= 1
		stack.back().push_back(line_dict) # Add line to current block
		last_indent = indent_level
	# COLLAPSE INDENT STACK
	########################
	while stack.size() > 1:
		var lines = stack.pop_back()
		stack.back().back()["children"] = lines
	return stack[0]
	
# Parse a dialogue context
static func _parse_context(line_list : Array):
	var context_list := []
	var last_speaker := ""
	for speaker_line in line_list:
		var content = speaker_line["content"]
		## OPTION LINE
		##############
		if content == "OPTIONS":
			var result = {"type" : "OPTIONS", "options" : []}
			for child in speaker_line["children"]:
				var option_data = _validate_option_choice(child["content"])
				if option_data:
					result["options"].push_back(
						{"text" : option_data[0], "destination" : option_data[1]} 
					)
			context_list.push_back(result)
			continue
		## QUEUE LINE
		##############
		var queued_context = _validate_queue_expression(content)
		if queued_context:
			var result = {"type" : "QUEUE", "queued_context" : queued_context}
			context_list.push_back(result)
			continue
		## EXECUTE LINE
		##############	
		var event_id = _validate_execute_expression(content)
		if event_id:
			var result = {"type" : "EXECUTE", "event_id" : event_id}
			context_list.push_back(result)
			continue
		## SPEAKER LINE
		###############
		var speaker_parsed = _validate_speaker_expression(content)
		if speaker_parsed:
			var speaker = speaker_parsed[0]
			var speaker_flags = speaker_parsed[1]
			# Dashes Replaced with last speaker
			if speaker == "-":
				speaker = last_speaker
			last_speaker = speaker
			# Change line connector depending on flags
			var result = {"type" : "TEXT", "speaker" : speaker, "text" : "", "VAR" : speaker_flags["VAR"]}
			for child in speaker_line["children"]:
				var connector_type = "\n" if speaker_flags["RAW"] else " "
				var connector = connector_type if result["text"].length() > 0 else ""
				result["text"] += connector + child["content"]
			context_list.push_back(result)
			continue
		## UNRECOGNIZED LINE	
		####################
		Debugger.dprint("INDENT ERROR: Unexpected line at Indent Level 1:  %s" % 
			speaker_line["content"]  
		)
	return context_list
	
###############################
#	Syntax Regex Validation
###############################
	
	
static func _validate_id_declaration(content):
	var id_re = RegEx.new()
	id_re.compile("^d_id\\s*=\\s*(\\S+)\\s*$")
	var result = id_re.search(content)
	if result: return result.get_string(1)
	else: return null
	
	
static func _validate_context_declaration(content):
	var context_re = RegEx.new()
	context_re.compile("^CONTEXT\\s+(\\S+)\\s*$") 
	var result = context_re.search(content)
	if result: return result.get_string(1)
	else: return null


static func _validate_speaker_expression(content):
	var speaker_re = RegEx.new()
	speaker_re.compile("^\\s*((\\s*[^\\s~]+)*)(\\s+~(RAW|VAR))?(\\s+~(RAW|VAR))?\\s*$")
	var result = speaker_re.search(content)
	if result:
		var speaker = result.get_string(1)
		var flags = [result.get_string(4), result.get_string(6)]
		var flag_dict = {"RAW" : false, "VAR" : false}
		for flag in flags:
			if   flag == "RAW": flag_dict["RAW"] = true
			elif flag == "VAR": flag_dict["VAR"] = true
		return [speaker, flag_dict]
	else: return null
		
		
static func _validate_queue_expression(content):
	var queue_re = RegEx.new()
	queue_re.compile("^\\s*QUEUE\\s+(\\S+)\\s*$")
	var result = queue_re.search(content)
	if result: return result.get_string(1)
	else: return null
		
		
static func _validate_execute_expression(content):
	var execute_re = RegEx.new()
	execute_re.compile("^\\s*EXECUTE\\s+(\\S+)\\s*$")
	var result = execute_re.search(content)
	if result: return result.get_string(1)
	else: return null
		
		
static func _validate_option_choice(content):
	var option_re = RegEx.new()
	option_re.compile("^\\s*((\\s*\\S+)*)\\s+->\\s+(\\S+)\\s*$")
	var result = option_re.search(content)
	if result:
		var text = result.get_string(1)
		var destination = result.get_string(3)
		return [text, destination]
	else:
		Debugger.dprint("COULD NOT VALIDATE OPTION CHOICE") 
		return null


######################
#	Parsing Errors
######################

# Print ERROR there is a duplicate context
static func _no_duplicate_context(current_id, context_name):
	Debugger.dprint(
		"CONTEXT ERROR: CONTEXT '%s' duplicate in id '%s'" 
					% [context_name, current_id] 
	)

# Print ERROR there is a duplicate d_id
static func _no_duplicate_d_id(current_id):
	Debugger.dprint(
		"CONTEXT ERROR: ID '%s' has been declared twice '%s'" % [current_id] 
	)

# Print ERROR if no MAIN context
static func _need_main_context(dialogue_dict):
	for id in dialogue_dict.keys():
		if !dialogue_dict[id].has("MAIN"):
			Debugger.dprint("CONTEXT ERROR: NO 'MAIN' CONTEXT UNDER ID '%s'" % id)
					
		

