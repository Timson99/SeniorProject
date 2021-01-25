extends Node
class_name TestPQ



class ExamplePriorityObj:
	var priority: int = 0
	func _init(prio):
		priority = prio
	

static func run_unit_tests():
	print("Priority Queue Tests: Starting\n")
	
	var test_queue = PriorityQueue.new()
	assert(test_queue.size() == 0)
	
	var menu = ExamplePriorityObj.new(4)
	var cutscene = ExamplePriorityObj.new(1)
	var dialogue = ExamplePriorityObj.new(3)
	var bogus = ExamplePriorityObj.new(7)
	print("Property value of menu is %d" % menu.priority)
	test_queue.insert(menu)
	test_queue.insert(cutscene)
	test_queue.insert(dialogue)
	test_queue.insert(bogus)
	assert(test_queue.size() == 4)
	
	assert(test_queue.contains(menu))
	assert(test_queue.contains(cutscene))
	assert(test_queue.contains(dialogue))
	assert(test_queue.contains(bogus))
	print("FIRST PRIORITY IS APPARENTLY %d" % test_queue.get_at_index(0).priority)
	test_queue.sort()
	print("FIRST PRIORITY IS APPARENTLY %d" % test_queue.get_at_index(0).priority)
	print("SECOND PRIORITY IS APPARENTLY %d" % test_queue.get_at_index(1).priority)
	print("THIRD PRIORITY IS APPARENTLY %d" % test_queue.get_at_index(2).priority)
	print("FOURTH PRIORITY IS APPARENTLY %d" % test_queue.get_at_index(3).priority)
	assert(test_queue.peek() == bogus) 
	test_queue.poll()
	assert(test_queue.peek() == cutscene)
	
	test_queue.clear()
	assert(test_queue.size() == 0)
	print("Priority Queue Tests: Passed\n")

