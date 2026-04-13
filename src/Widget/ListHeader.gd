extends Button
class_name ListHeader

@onready var header_text_node: Label = $HBoxContainer/LeftAnchor/HeaderText
@onready var collapse_button: Button = $HBoxContainer/LeftAnchor/ButtonHide

@export var collapsible: Control
@export var header_text: StringName
var collapsed: bool = false

signal property_options

func update_collapse() -> void:
	collapsible.set_visible(not collapsed)
	if collapsed:
		collapse_button.set_text(tr(&"WIDGET.LIST_HEADER.SHOW"))
	else:
		collapse_button.set_text(tr(&"WIDGET.LIST_HEADER.COLLAPSE"))

func _on_button_hide_button_down() -> void:
	collapsed = not collapsed
	update_collapse()

func _on_button_options_button_down() -> void:
	property_options.emit()

func _ready() -> void:
	header_text_node.set_text(tr(header_text))
