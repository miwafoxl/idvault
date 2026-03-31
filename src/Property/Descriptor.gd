extends Property
class_name Descriptor

@export var alias: String = "" # Required: Lowercase, no symbols or spaces
@export var short: String = ""; # Short phrase that defines the descriptor
@export var long: String = ""; # Long explanation, BBCode or Markdown

func _init(__alias: String, __short: String = "", __long: String = "") -> void:
	self.alias = __alias
	self.short = __short
	self.long = __long
