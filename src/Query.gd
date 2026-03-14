extends Resource
class_name Query

@export var raw_query: String = "";
var computed_query: Array[Subquery] = []

class Subquery: 
	var descriptor_alias: String = "";
	var parameters: Array = []
	var negate: bool = false

func _init(__raw_query: String, __cx_parameters) -> void:
	pass
