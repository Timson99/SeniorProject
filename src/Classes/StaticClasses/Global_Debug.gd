extends Object


class_name Debugger
	
static func dprint(text, num_traceback = 1):
	for i in range(1, min(num_traceback+1, get_stack().size() ) ):
		var frame = get_stack()[i]
		print( "%30s:%-4d %s" % [frame.source.get_file(), frame.line, text] )




