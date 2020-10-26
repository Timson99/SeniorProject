extends CanvasLayer

var submenu = null
var parent = null

func back():
	if submenu:
		submenu.back()
	else:
		queue_free()
		parent.submenu = null
		
func accept():
	if submenu:
		submenu.accept()
	else:
		pass
	
func up():
	if submenu:
		submenu.up()
	else:
		pass
		
	
func down():
	if submenu:
		submenu.down()
	else:
		pass

func left():
	if submenu:
		submenu.left()
	else:
		pass
	
func right():
	if submenu:
		submenu.right()
	else:
		pass
		
			





