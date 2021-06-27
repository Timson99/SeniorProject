extends Node

class_name DialogueParser


########
# Public
########
static func parse(dialogue_src : String):
	
	var splitted : Array = dialogue_src.split("\n", false)
	var stack = [ [] ]
	var last_indent = 0
	while splitted.size() > 0:
		var line = splitted.pop_front()
		var indent_level = parse_indent_level(line)
		if indent_level != 2 && line.strip_edges().length() == 0:
			continue
			
		var content = line.strip_edges(false, true)
		if indent_level != 2: content = content.dedent()
		else: content = content.substr(2) if content[0] == "\t" else content.substr(8)
		
		var line_dict = {"content" : content, "children" : [], "indent" : indent_level}
		
		if last_indent < indent_level:
			stack.push_back( [] )
		elif last_indent > indent_level:
			while last_indent > indent_level:
				var lines = stack.pop_back()
				stack.back().back()["children"] = lines
				last_indent -= 1
		stack.back().push_back(line_dict)
		last_indent = indent_level
		
	while stack.size() > 1:
		var lines = stack.pop_back()
		stack.back().back()["children"] = lines
		
		
	var parsed_lines = stack[0]
	var current_id = ""
	var dialogue_dictionary = {}
	
	
	for line in parsed_lines:
		var content = line["content"]
	
		var d_id = validate_id_declaration(content)
		if d_id:
			current_id = d_id
			dialogue_dictionary[current_id] = {}
			continue
			
		var context_name = validate_context_declaration(content)
		if context_name:
			dialogue_dictionary[current_id][context_name] = parse_context(line["children"])
			continue
			
		Debugger.dprint("INDENT ERROR: Unexpected line at Indent Level 0:  %s" % content )

	# Makes sure every dialogue has a MAIN default context
	for id in dialogue_dictionary.keys():
		if !dialogue_dictionary[id].has("MAIN"):
			Debugger.dprint("CONTEXT ERROR: NO 'MAIN' CONTEXT UNDER ID '%s'" % id)

	#print(dialogue_dictionary)
	return dialogue_dictionary
	


########
# Private
########	
	
static func parse_indent_level(line : String):
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
	

static func parse_context(line_list : Array):
	var context_list : Array = []
	
	var last_speaker = ""
	
	for speaker_line in line_list:
		
		var content = speaker_line["content"]
		if content == "OPTION":
			var result = {"type" : "OPTION", "options" : []}
			for child in speaker_line["children"]:
				var option_data = validate_option_declaration(child["content"])
				if option_data:
					result["options"].push_back(
						{"text" : option_data[0], "destination" : option_data[1]} 
					)
			context_list.push_back(result)
			continue
			
		var queued_context = validate_queue_declaration(content)
		if queued_context:
			var result = {"type" : "QUEUE", "queued_context" : queued_context}
			context_list.push_back(result)
			continue
			
		var event_id = validate_execute_declaration(content)
		if event_id:
			var result = {"type" : "EXECUTE", "event_id" : event_id}
			context_list.push_back(result)
			continue
		
		var speaker_parsed = validate_speaker_declaration(content)
		if speaker_parsed:
			var speaker = speaker_parsed[0]
			var speaker_flags = speaker_parsed[1]
			
			if speaker == "-":
				speaker = last_speaker
			last_speaker = speaker
			
			var result = {"type" : "TEXT", "speaker" : speaker, "text" : "", "VAR" : speaker_flags["VAR"]}
			for child in speaker_line["children"]:
				var connector_type = "\n" if speaker_flags["RAW"] else " "
				var connector = connector_type if result["text"].length() > 0 else ""
				result["text"] += connector + child["content"]
			context_list.push_back(result)
			continue
		
		Debugger.dprint("INDENT ERROR: Unexpected line at Indent Level 1:  %s" % speaker_line["content"]  )
			
	return context_list
	
	
	
static func validate_option_declaration(content):
	var option_re = RegEx.new()
	option_re.compile("^\\s*((\\s*[^\\s~]+)*)\\s+->\\s+(\\S+)\\s*$")
	var result = option_re.search(content)
	if result:
		var text = result.get_string(1)
		var destination = result.get_string(3)
		return [text, destination]
	else:
		Debugger.dprint("COULD NOT VALIDATE OPTION") 
		return null


static func validate_speaker_declaration(content):
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
	else:
		return null
		
		
static func validate_queue_declaration(content):
	var queue_re = RegEx.new()
	queue_re.compile("^\\s*QUEUE\\s+(\\S+)\\s*$")
	var result = queue_re.search(content)
	if result:
		var queued_context = result.get_string(1)
		return queued_context
	else:
		return null
		
static func validate_execute_declaration(content):
	var queue_re = RegEx.new()
	queue_re.compile("^\\s*EXECUTE\\s+(\\S+)\\s*$")
	var result = queue_re.search(content)
	if result:
		var queued_context = result.get_string(1)
		return queued_context
	else:
		return null

	
static func validate_id_declaration(content):
	var id_re = RegEx.new()
	id_re.compile("^d_id\\s*=\\s*(\\S+)\\s*$")
	var result = id_re.search(content)
	if result:
		return result.get_string(1)
	else: 
		return null
	
static func validate_context_declaration(content):
	var context_re = RegEx.new()
	context_re.compile("^CONTEXT\\s+(\\S+)\\s*$") 
	var result = context_re.search(content)
	if result:
		return result.get_string(1)
	else: 
		return null
	
	
	

	
static func no_id_declared(context_name):
	Debugger.dprint(
		"CONTEXT ERROR: d_id has not been declared before context '%s'" % context_name 
	)
	
static func no_duplicate_context(context_name, current_id):
	Debugger.dprint(
		"CONTEXT ERROR: CONTEXT '%s' duplicate in id '%s'" 
					% [context_name, current_id] 
	)
					
		

