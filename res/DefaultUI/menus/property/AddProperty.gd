extends Object

## Describe your menu here
func build(__param: Dictionary) -> ContextMenu:
	var __menu: ContextMenu = ContextMenu.new()
	var __callback: Callable
	var __item_id: String
	#region Parameter processing
	for __key: String in __param:
		var __value: Variant = __param[__key]
		match __key:
			"callback" when __value is Callable:
				__callback = __value
				if not __callback.is_valid():
					push_warning("property.menu: invalid callback '%s'" % __callback.get_method())
			"item_id" when __value is String:
				__item_id = __value
			_:
				push_warning("property.menu: invalid key '%s'\
				-> callback, item_id" % __key)
	if __callback.is_null():
		printerr("property.menu: callback cannot be null")
		return
	#endregion Parameter processing
	__menu.add_item(tr(&"MENU.ADD_PROPERTY.ADD_DISPLAY"))
	__menu.set_item_metadata(-1, {__callback: 
		[
			DefaultUI_PropertyHolder.new(
				Display.new(""), __item_id, true
			)
		]
	})
	#__menu.set_item_metadata(-1, {&"property.append.selected": 
		#{
		#"properties": [
			#Display.new("")
		#]} 
	#})
	
	__menu.add_item(tr(&"MENU.ADD_PROPERTY.ADD_DESCRIPTOR"))
	__menu.set_item_metadata(-1, {__callback: 
		[
			DefaultUI_PropertyHolder.new(
				Descriptor.new(""), __item_id, true
			)
		]
	})
	
	__menu.add_item(tr(&"MENU.ADD_PROPERTY.ADD_DATE"))
	__menu.set_item_metadata(-1, {__callback: 
		[
			DefaultUI_PropertyHolder.new(
				Date.new(Vector3i(1999, 1, 1)), __item_id, true
			)
		]
	})
	
	__menu.add_item(tr(&"MENU.ADD_PROPERTY.ADD_RANGED_DATE"))
	__menu.set_item_metadata(-1, {__callback: 
		[
			DefaultUI_PropertyHolder.new(
				RangedDate.new([
					Vector3i(1999, 1, 1),
					Vector3i.ZERO
				]), __item_id, true
			)
		]
	})
	
	__menu.add_item(tr(&"MENU.ADD_PROPERTY.ADD_LINK"))
	__menu.set_item_metadata(-1, {__callback: 
		[
			DefaultUI_PropertyHolder.new(
				Link.new(""), __item_id, true
			)
		]
	})
	
	__menu.add_separator()
	
	__menu.add_item(tr(&"MENU.ADD_PROPERTY.LOAD_PROPERTY"))
	__menu.set_item_metadata(-1, {&"property.import": {} })
	return __menu
