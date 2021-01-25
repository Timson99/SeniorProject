extends Object


class_name Debugger
	
static func dprint(text):
	var frame = get_stack()[1]
	print( "%30s:%-4d %s" % [frame.source.get_file(), frame.line, text] )




