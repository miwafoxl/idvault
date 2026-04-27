extends PanelContainer
class_name DefaultUI_InlinkButton

@export var alias: String
@export var title: String
@export var count: int = 0

var related_item: Item = null
var linker_item: Item = null

func update() -> void:
	if not title:
		title = related_item.id
	%TXT_TITLE.set_text(title)
	%TXT_COUNT.set_text(str(count))
	if alias: 
		%TXT_ALIAS.set_text("%s →" % alias)
		%TXT_ALIAS.set_visible(true)
	else:
		%TXT_ALIAS.set_visible(false)
