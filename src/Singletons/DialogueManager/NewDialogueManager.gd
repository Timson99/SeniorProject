extends Node

class_name NewDialogueManager



func parse(dialogue_src : String):
	
	var splitted : Array = dialogue_src.split("\n", false)
	var stack = [ [] ]
	
	
	var last_indent = 0
	while splitted.size() > 0:
		var line = splitted.pop_front()
		if line.strip_edges().length() == 0:
			continue
		var indent_level = parse_indent_level(line)
		var content = line.dedent().strip_edges()
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
	
	return stack[0]
	
func parse_indent_level(line : String):
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
	return indent_level
	

func parse_context(line_list : Array):
	var context_list : Array = []
	
	for speaker_line in line_list:
		var speaker = speaker_line["content"]
		if speaker != "OPTION" and speaker_line["children"]:
			var result = {"type" : "TEXT", "speaker" : speaker,"text" : ""}
			for child in speaker_line["children"]:
				var space : String = " " if result["text"].length() > 0 else ""
				result["text"] += space + child["content"]
			context_list.push_back(result)
		elif speaker == "OPTION":
			var result = {"type" : "OPTION", "options" : []}
			for child in speaker_line["children"]:
				var option_data = validate_option_declaration(child["content"])
				if option_data:
					result["options"].push_back(
						{"text" : option_data[0], "destination" : option_data[1]} 
					)
			context_list.push_back(result)
	return context_list
	
	
	
func validate_option_declaration(content):
	var option_re = RegEx.new()
	option_re.compile("^\\s*(.+)\\s+->\\s+(\\S+)\\s*$")
	var result = option_re.search(content)
	if result:
		var text = result.get_string(1)
		var destination = result.get_string(2)
		return [text, destination]
	else:
		Debugger.dprint("COULD NOT VALIDATE OPTION") 
		return null

	
func validate_id_declaration(content):
	var id_re = RegEx.new()
	id_re.compile("^d_id\\s*=\\s*(\\S+)\\s*$")
	var result = id_re.search(content)
	if result:
		return result.get_string(1)
	else: 
		return null
	
func validate_context_declaration(content):
	var context_re = RegEx.new()
	context_re.compile("^CONTEXT\\s+(\\S+)\\s*$") 
	var result = context_re.search(content)
	if result:
		return result.get_string(1)
	else: 
		return null
	
	
	

	
func no_id_declared(context_name):
	Debugger.dprint(
		"CONTEXT ERROR: d_id has not been declared before context '%s'" % context_name 
	)
	
func no_duplicate_context(context_name, current_id):
	Debugger.dprint(
		"CONTEXT ERROR: CONTEXT '%s' duplicate in id '%s'" 
					% [context_name, current_id] 
	)
					
		

