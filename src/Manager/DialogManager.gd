extends Manager
class_name DialogManager

@export var spawn_node: Node
@export var manager: ItemManager
@export var default: Dictionary[StringName, PackedScene]
@export var returning_values: Dictionary[StringName, Array]
var loaded: Dictionary[StringName, PackedScene] = {}; # {dialog alias: packed scene}

signal received_return(__id: String)

func append_dialog_return(__id: String, __return_args: Array) -> void:
	if __id.is_empty():
		printerr("DialogManager: failed to append dialog return because __id is empty.")
	returning_values.set(__id, __return_args)
	received_return.emit(__id)

func append_dialog(__dialog: Dictionary[StringName, PackedScene], __log: bool = false) -> void:
	if __dialog.is_empty(): return
	var __loaded_dialogs: PackedStringArray
	for __alias: StringName in __dialog.keys():
		if __alias.is_empty():
			printerr("DialogManager: dialog with no alias. Skipping it.")
			continue
		if __dialog[__alias] == null:
			printerr("DialogManager: dialog '%s' has no scene. Skipping it." % __alias)
			continue
		if __alias in __loaded_dialogs:
			printerr("DialogManager: dialog '%s' has the same alias as a previously loaded action. Please unload that one then append it." % __alias)
			continue
		loaded.set(__alias, __dialog[__alias])
		__loaded_dialogs.append(__alias)
	loaded.sort()
	if __log:
		__loaded_dialogs.sort()
		print("DialogManager: %s loaded:\n- %s" % [__loaded_dialogs.size(), \
			"\n- ".join(__loaded_dialogs)
		])

func remove_dialogs(__rm_dialog_aliases: Array[StringName]) -> void:
	if __rm_dialog_aliases.is_empty(): return
	for __alias: StringName in loaded.keys():
		if __alias in __rm_dialog_aliases:
			loaded.erase(__alias)

func access_returned_value(__return_id: String, __erase: bool = true) -> Array:
	if __return_id not in returning_values.keys():
		printerr("DialogManager: no return id '%s' found." % __return_id)
		return []
	var __value: Array = returning_values[__return_id]
	if __erase: returning_values.erase(__return_id)
	return __value

func open(__alias: StringName, ...args) -> bool:
	var __scn: PackedScene = loaded.get(__alias)
	if __scn == null:
		printerr("DialogManager: dialog '%s' not found or loaded." % __alias)
		return false
	var __dialog: Dialog = __scn.instantiate()
	if __dialog.returns:
		push_warning("DialogManager: dialog '%s' can return but it was called used open() instead of open_return()" % __alias)
	__dialog.args = args
	spawn_node.add_child.call_deferred(__dialog)
	__dialog.pop.call_deferred()
	return true

func open_return(__alias: StringName, ...args: Array) -> String:
	var __scn: PackedScene = loaded.get(__alias)
	if __scn == null:
		printerr("DialogManager: dialog '%s' not found or loaded." % __alias)
		return ""
	var __dialog: Dialog = __scn.instantiate()
	if not __dialog.returns:
		push_warning("DialogManager: no-return dialog '%s' called used open_return() instead of open()" % __alias)
	var __return_id: String = RandomString.new("d_").value
	__dialog.args = args
	__dialog.return_id = __return_id
	__dialog.returning.connect(append_dialog_return)
	spawn_node.add_child.call_deferred(__dialog)
	__dialog.pop.call_deferred()
	return __return_id
