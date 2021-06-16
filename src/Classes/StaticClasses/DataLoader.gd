"""
DATA LOADER
	Contains Functions for Loading Text Data
	Used for Scene Id's, Enemy Data,  
"""

extends Object

class_name DataLoader

static func json_to_dict( path : String, int_cast_numerics := false):
	var file = File.new()
	if !file.file_exists(path):
		Debugger.dprint("!!! Error - JSON path does not exist : %s" % path)
	file.open(path, file.READ)
	var text = file.get_as_text()
	var dict = parse_json(text) 
	file.close()
	if !dict:
		Debugger.dprint("!!! Error - JSON at path has invalid formatting : %s" % path)
	return dict
	
