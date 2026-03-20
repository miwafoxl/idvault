extends Widget
class_name ItemDisplayWidget

@export var related_id: int = 0
@export var title: String = "";
@export var subtitle: String = "";

@export var node_title: Label 
@export var node_subtitle: Label

signal click
signal hover

func update() -> void:
	node_title.set_text(self.title)
	node_subtitle.set_text(self.subtitle)
