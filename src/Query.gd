extends Resource
class_name Query

var raw_query: String = "";
var manager: ItemManager
var items: Array[Item]

var filtered: Array[Item]
var error_query: Array # [Relevant Descriptor, ParseError]

var start_ms: int

enum ComparisonMode {
	COMPARASION,
	MATCH,
	NEARBY,
	GREATER_THAN,
	GREATER_OR_EQUALS_TO,
	LESSER_THAN,
	LESSER_OR_EQUALS_TO,
}

enum ParseError {
	OK,
	EMPTY_SPLIT,
	DESCRIPTOR_NOT_FOUND,
	PARAMETER_TOO_MANY_PARAM_DELIMITERS,
	PARAMETER_EXPECTED_CLOSING_QUOTES,
	PARAMETER_INVALID_SYMBOL_USE,
}

class Parsed:
	var descriptor_cx: Array
	var parameters: Dictionary = {}
	var is_negated: bool = false
	var error: ParseError = ParseError.OK
	func _init(__cx: Array, __negated: bool = false, \
			__parameters: Dictionary = {}) -> void:
		self.descriptor_cx = __cx
		self.is_negated = __negated
		self.parameters = __parameters

func print_parsed(__parsed: Array[Parsed]) -> void:
	for __parse: Parsed in __parsed:
		print({
			"descriptor_id": __parse.descriptor_cx[2],
			"parameters": __parse.parameters,
			"is_negated": __parse.is_negated,
			"error": ParseError.keys()[__parse.error],
		})

func process(__exclusive: bool = true) -> void:
	start_ms = Time.get_ticks_usec()
	var __query_descriptors: PackedStringArray = raw_query.split(" ")
	var __parse_query: Dictionary[String, Parsed] = parse_split(__query_descriptors); # print_parsed(__parse)
	filtered = filter_items_by_parsed(items, __parse_query, __exclusive)
	return 
	

func parse_split(__split: PackedStringArray) -> Dictionary[String, Parsed]:
	var __parsed: Dictionary[String, Parsed] = {}
	if __split.is_empty(): 
		error_query = ["parse_split", ParseError.EMPTY_SPLIT]
	for __query_str: String in __split:
		var __negated: bool = false
		var __descriptor_str: String
		var __parameters_str: String
		var __descriptor_cx: Array
		var __parameters: Dictionary = {}
		if __query_str.count(":") == 1:
			__descriptor_str = __query_str.get_slice(":", 0)
			__parameters_str = __query_str.get_slice(":", 1)
			__parameters = parse_parameter(__parameters_str)
		elif __query_str.count(":") > 1:
			error_query = [__query_str, ParseError.PARAMETER_TOO_MANY_PARAM_DELIMITERS]
			break
		else: __descriptor_str = __query_str
		if __descriptor_str.left(1) in ["-", "!"]:
			__negated = true
			__descriptor_str = __descriptor_str.right(-1)
		__descriptor_cx = manager.get_from_cache("by_descriptor_alias", __descriptor_str)
		if __descriptor_cx.is_empty():
			error_query = [__query_str, ParseError.DESCRIPTOR_NOT_FOUND]
			break
		__parsed.set(__descriptor_cx[2], Parsed.new(
			__descriptor_cx, __negated, __parameters
		))
	return __parsed

func parse_parameter(__parameter_str: String) -> Dictionary:
	var __param: Dictionary = {}
	var __value: String
	if __parameter_str.left(1) in [":", ";", "(", ")", "?", "@", "#", "$", "%"]:
		__param.set("Error", ParseError.PARAMETER_INVALID_SYMBOL_USE)
	match __parameter_str.left(1):
		">" when __parameter_str.substr(1, 1) == "=":
			__param.set("ComparisonMode", ComparisonMode.GREATER_OR_EQUALS_TO)
			__value = __parameter_str.substr(2)
		"<" when __parameter_str.substr(1, 1) == "=":
			__param.set("ComparisonMode", ComparisonMode.LESSER_OR_EQUALS_TO)
			__value = __parameter_str.substr(2)
		">":
			__param.set("ComparisonMode", ComparisonMode.GREATER_THAN)
			__value = __parameter_str.substr(1)
		"<":
			__param.set("ComparisonMode", ComparisonMode.LESSER_THAN)
			__value = __parameter_str.substr(1)
		"~" when __parameter_str.substr(1, 1) == '"':
			if not __parameter_str.right(1) == '"':
				__param.set("Error", ParseError.PARAMETER_EXPECTED_CLOSING_QUOTES)
			__param.set("Type", Parameter.ParameterTypes.STRING)
			__param.set("ComparisonMode", ComparisonMode.NEARBY)
			__value = __parameter_str.substr(2).remove_chars('"')
		"~":
			__param.set("ComparisonMode", ComparisonMode.NEARBY)
			__value = __parameter_str.substr(1)
		'"':
			if not __parameter_str.right(1) == '"':
				__param.set("Error", ParseError.PARAMETER_EXPECTED_CLOSING_QUOTES)
			__param.set("ComparisonMode", ComparisonMode.MATCH)
			__param.set("Type", Parameter.ParameterTypes.STRING)
			__value = __parameter_str.substr(1).remove_chars('"')
		_:
			__param.set("ComparisonMode", ComparisonMode.MATCH)
			__value = __parameter_str
	if __value.is_valid_int():
		__param.set("Type", Parameter.ParameterTypes.NUMBER)
		__param.set("Value", __value.to_int())
	else:
		__param.set("Type", Parameter.ParameterTypes.STRING)
		__param.set("Value", __value)
	return __param

# Exclusive: Matches only if all descriptors are present
# Inclusive: Matches if at least one descriptor query is present
func filter_items_by_parsed(__items: Array[Item], \
		__parsed_query: Dictionary[String, Parsed], \
		__exclusive: bool = true, __log: bool = true) -> Array[Item]:
	var __filtered: Array[Item]
	var __miss: int = 0
	for __item: Item in __items:
		var __remaining_matches: Array = __parsed_query.keys()
		var __cx: Array = manager.get_from_cache_matched("by_links", ["@%s" % __item.id])
		if (__cx.is_empty()): # or (__cx[3] not in __remaining_matches): 
			__miss += 1
			continue
		var __from: String = __cx[3] # Link.from
		__remaining_matches.erase(__from)
		if __exclusive and not __remaining_matches.is_empty(): continue
		__filtered.append(__item)
	if __log:
		var __usec: int = Time.get_ticks_usec() - start_ms
		var __took_string: String = "Took %s %s" % [__usec, ["usec", "ms"][(__usec >= 1000) as int]]
		print_debug("Query: Filtered %s items with %s misses. Took %s usec." % [
			__filtered.size(), __miss, Time.get_ticks_usec() - start_ms
		])
		print_parsed(__parsed_query.values())
	return __filtered

func _init(__raw_query: String, __items: Array[Item], \
		__manager: ItemManager, __exclusive: bool = true) -> void:
	self.raw_query = __raw_query.strip_edges().strip_escapes()
	self.items = __items
	self.manager = __manager
	if __items.is_empty():
		printerr("Query: received no items to filter")
	else: process(__exclusive)
