extends Node
class_name PriorityQueue

var queue = null

func _init(starting_array):
	if starting_array == null:
		queue = []
	else:
		queue = starting_array


func _ready():
	pass


# Clears all values from priority queue
func clear() -> void:
	self.queue.clear()
	return
	
	
# Checks to see if priority queue contains given values	
func contains(value) -> bool:
	return self.queue.has(value)


func get_at_index(index):
	return self.queue[index]


# Add new value to priority queue
func insert(value) -> void:
	self.queue.append(value)
	return	
	
	
# Checks but does not pop highest priority values
func peek():
	return self.queue[0]
	
	
# Pops off and returns highest priority value
func poll():
	return self.queue.pop_front()
	

# Returns the size of the queue
func size() -> int:
	return self.queue.size()
	
# Sorts queue according to SortLogic
func sort() -> void:
	self.queue.sort_custom(SortLogic, "sort")
	return
	
# Min values first
class SortLogic:
	static func sort(value_1, value_2):
		if value_1 < value_2:
			return true
		return false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

