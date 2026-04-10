extends Object

## Get property changes and apply
func run(__manager: ItemManager, __param: Dictionary) -> bool:
	var __changes: Dictionary = {}
	#region Parameter processing
	for __key: String in __param:
		var __value: Variant = __param[__key]
		match __key:
			"changes" when __value is Dictionary:
				__changes = __value
				if __changes.is_empty(): 
					return false
			_:
				push_warning("property.edit.apply_bulk: invalid key '%s'\
				-> changes" % __key)
	#endregion Parameter processing
	var __items_updated: bool = false
	for __prop_id: String in __changes.keys():
		var __get_prop: Array = __manager.get_from_cache("by_property_id", __prop_id)
		var __get_modified_prop: Property = __changes[__prop_id]
		var __prop: Property = (__get_prop[1] as WeakRef).get_ref()
		if __prop == null:
			push_warning("property.edit.apply_bulk: Failed to get reference to property id '%s'." % __prop_id)
			continue
		__prop.serialize(__get_modified_prop.deserialized(false))
		__items_updated = true
	if __items_updated: __manager.stage_updated.emit()
	return __items_updated
