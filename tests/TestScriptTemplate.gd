extends Object

var procedures: Array[Callable] = []

## Describe a test here
func run(__mod_item: ItemModule, __mod_action: ActionModule) -> int:
	#region PROCEDURES
	procedures = []
	print("Populate the procedures array with callables that return bool.")
	#endregion PROCEDURES
	#region CALL PROCEDURES
	for i in procedures.size():
		var __call: Callable = procedures[i]
		if not __call.call():
			return i
	#endregion CALL PROCEDURES
	return -1
