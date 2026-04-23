extends Object

## Describe your menu here
func build(__param: Dictionary) -> ContextMenu:
	var __menu: ContextMenu = ContextMenu.new()
	var __item_id: String
	#region Parameter processing
	for __key: String in __param:
		var __value: Variant = __param[__key]
		match __key:
			"item_id" when __value is String:
				__item_id = __value
			_:
				push_warning("dialog.item_properties.property_menu: invalid key '%s'\
				-> item_id, param_idx" % __key)
	#endregion Parameter processing
	__menu.add_item(tr(&"MENU.ADD_PROPERTY.ADD_DISPLAY"))
	__menu.set_item_metadata(-1, {&"property.append.selected": 
		{
		"properties": [
			Display.new()
		]} 
	})
	
	__menu.add_item(tr(&"MENU.ADD_PROPERTY.ADD_DESCRIPTOR"))
	__menu.set_item_metadata(-1, {&"property.append.selected": 
		{
		"properties": [
			Descriptor.new("")
		]} 
	})
	
	__menu.add_item(tr(&"MENU.ADD_PROPERTY.ADD_DATE"))
	__menu.set_item_metadata(-1, {&"property.append.selected": 
		{
		"properties": [
			Date.new(Vector3i(1999, 1, 1))
		]}
	})
	
	__menu.add_item(tr(&"MENU.ADD_PROPERTY.ADD_RANGED_DATE"))
	__menu.set_item_metadata(-1, {&"property.append.selected": 
		{
		"properties": [
			RangedDate.new([
				Vector3i(1999, 1, 1),
				Vector3i.ZERO
			])
		]} 
	})
	
	__menu.add_item(tr(&"MENU.ADD_PROPERTY.ADD_LINK"))
	__menu.set_item_metadata(-1, {&"property.append.selected": 
		{
		"properties": [
			Link.new("")
		]} 
	})
	
	__menu.add_separator()
	
	__menu.add_item(tr(&"MENU.ADD_PROPERTY.LOAD_PROPERTY"))
	__menu.set_item_metadata(-1, {&"property.import": {} })
	return __menu
