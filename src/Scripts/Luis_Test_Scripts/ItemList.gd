extends GridContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	for item in MenuManager.item_data:
		_add_item_entry(item)
		
func _add_item_entry(item):
#	print(item)
	var button = Button.new()
	button.text = item
	add_child(button)
	 

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
