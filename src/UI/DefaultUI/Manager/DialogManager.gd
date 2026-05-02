extends Manager
class_name DefaultUI_DialogManager

@export var spawn_node: Control
@export var default: Dictionary[StringName, PackedScene]
@export var active_dialogs: Dictionary[StringName, DefaultUI_Dialog]
var loaded: Dictionary[StringName, PackedScene] = {}; # {dialog alias: packed scene}

@warning_ignore("unused_signal")
signal trigger(tr: Trigger)

func append_dialog(__dialog: Dictionary[StringName, PackedScene], __log: bool = false) -> void:
	if __dialog.is_empty(): return
	var __loaded_dialogs: PackedStringArray
	for __alias: StringName in __dialog.keys():
		if __alias.is_empty():
			printerr("DefaultUI_DialogManager: dialog with no alias. Skipping it.")
			continue
		if __dialog[__alias] == null:
			printerr("DefaultUI_DialogManager: dialog '%s' has no scene. Skipping it." % __alias)
			continue
		if __alias in __loaded_dialogs:
			printerr("DefaultUI_DialogManager: dialog '%s' has the same alias as a previously loaded action. Please unload that one then append it." % __alias)
			continue
		loaded.set(__alias, __dialog[__alias])
		__loaded_dialogs.append(__alias)
	loaded.sort()
	if __log:
		__loaded_dialogs.sort()
		print("DefaultUI_DialogManager: %s loaded:\n- %s" % [__loaded_dialogs.size(), \
			"\n- ".join(__loaded_dialogs)
		])

func remove_dialogs(__rm_dialog_aliases: Array[StringName]) -> void:
	if __rm_dialog_aliases.is_empty(): return
	for __alias: StringName in loaded.keys():
		if __alias in __rm_dialog_aliases:
			loaded.erase(__alias)

func open(__alias: StringName, __param: Dictionary) -> bool:
	var __scn: PackedScene = loaded.get(__alias)
	if __scn == null:
		printerr("DefaultUI_DialogManager: dialog '%s' not found or loaded." % __alias)
		return false
	var __dialog: DefaultUI_Dialog = active_dialogs.get(__alias, null)
	if __dialog == null:
		__dialog = __scn.instantiate()
		__dialog.alias = __alias
		__dialog.trigger.connect(trigger.emit)
		__dialog.handle_close_request.connect(close_request)
		active_dialogs.set(__alias, __dialog)
		spawn_node.add_child.call_deferred(__dialog)
		__dialog.pop.call_deferred()
	__dialog.args.merge(__param, true)
	__dialog._update_arguments()
	return true

func update_dialog(__alias: StringName) -> void:
	var __dialog: DefaultUI_Dialog = active_dialogs.get(__alias, null)
	if __dialog == null: return
	__dialog._update_arguments()

func close_request(__alias: StringName) -> void:
	var __dialog: DefaultUI_Dialog = active_dialogs.get(__alias, null)
	if __dialog == null: return
	active_dialogs.erase(__alias)
	__dialog.queue_free()
