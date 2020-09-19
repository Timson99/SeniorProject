extends Button

var presscount = 0
var totalalts = 3
var toSend

#Button press, connect to _display with given alt key
func _pressed():
	if totalalts > presscount:
		presscount += 1
		toSend = "1-" + str(presscount)
		if is_connected("pressed", get_node("../Popup/DBox"), "_display"):
			disconnect("pressed", get_node("../Popup/DBox"), "_display")
		connect("pressed", get_node("../Popup/DBox"), "_display", [toSend])
		#print("connected with toSend: " + toSend)
		
