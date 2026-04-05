extends Resource
class_name Query

const QUERY_SPACER: String = " ";
const QUERY_PARAMETER: String = ":";
const QUERY_NEGATOR: String = "!";

@export var raw_query: String = "";
var error_at_splice: Array # [Splice index, QueryError or ParseError]
var parsed_query: Array[Subquery] = []

var available_items: Array[Item] = []
var available_descriptors: Array = []
var available_parameters: Array = []
var available_links: Array = []

signal done(selected_items: Array[Item])

class Subquery: 
	var alias: String = "";
	var parameters: Array[String] = []
	var negate: bool = false
	func _init(__alias: String, __params: Array[String] = [],
			 __negate: bool = false):
		self.alias = __alias
		self.parameters = __params
		self.negate = __negate
	
enum ParseError {
	UNKNOWN,
	EMPTY_SPLICE,
	INVALID_PARAMETER,
}

enum ComputeError {
	UNKNOWN,
	EMPTY_QUERY,
	DESCRIPTOR_UNKNOWN,
	PARAMETER_UNKNOWN,
	PARAMETER_TYPE_MISMATCH
}

enum ComparisonMode {
	COMPARASION,
	MATCH,
	NEARBY,
	GREATER_THAN,
	GREATER_OR_EQUALS_TO,
	LESSER_THAN,
	LESSER_OR_EQUALS_TO,
}
# [0: [0: [0: bla, 1: bla]]]
# [0: [0: bla, 1: bla], 1: [0: bla]]..
func check_descriptor_availability(__alias: String) -> bool:
	for __descriptor_arr: Array in available_descriptors:
		if __descriptor_arr[2] == __alias:
			return true
	return false

func item_via_descriptor_alias(__alias: String) -> Item:
	for __descriptor_arr: Array in available_descriptors:
		if __descriptor_arr[2] == __alias:
			return (__descriptor_arr[0] as WeakRef).get_ref()
	return null

func parse_raw() -> bool:
	var __subqueries: Array[Subquery] = []
	var __spliced_query: PackedStringArray = raw_query.split(QUERY_SPACER, false)
	if __spliced_query.is_empty():
		error_at_splice = [0, ParseError.EMPTY_SPLICE]
		printerr("QParsing: splice returned an empty string")
		return false
	for i: int in __spliced_query.size():
		var __splice: String = __spliced_query[i]
		var __descriptor: String = ""
		var __parameter: String = ""
		var __negator: bool = false
		match __splice.count(QUERY_PARAMETER):
			0:
				__descriptor = __splice
			1: 
				var __spliced_splice: PackedStringArray = __splice.split(QUERY_PARAMETER)
				__descriptor = __spliced_splice[0]
				__parameter = __spliced_splice[1]
			_:
				printerr("QParsing: too many parameter separators in splice %s" % i)
				error_at_splice = [i, ParseError.INVALID_PARAMETER]
				return false
		if __descriptor.begins_with(QUERY_NEGATOR):
			__negator = true
		__subqueries.append(Subquery.new(
			__descriptor, [], __negator
		))
	parsed_query = __subqueries
	return true

# TODO: Separate thread (please)
func compute(__subqueries: Array[Subquery] = parsed_query) -> void:
	var __unsorted_items: Array[Item] = []
	if __subqueries.is_empty():
		printerr("QCompute: empty subquery array provided")
		error_at_splice = [0, ComputeError.EMPTY_QUERY]
		done.emit.call_deferred(__unsorted_items)
		return
	for i: int in __subqueries.size():
		var __alias: String = __subqueries[i].alias
		if not check_descriptor_availability(__alias):
			printerr("QCompute: unknown item with descriptor '%s'" % __alias)
			error_at_splice = [0, ComputeError.DESCRIPTOR_UNKNOWN]
			break 
		var __item: Item = item_via_descriptor_alias(__alias)
		if __item in __unsorted_items: continue
		var __param: Parameter = __item.retrieve_parameters(0)[0] # TODO: support multiple param
		var __parameter_parse: Array = []
		if not __subqueries[i].parameters.is_empty(): 
			__parameter_parse = parse_parameter(__subqueries[i].parameters[0])
			if __parameter_parse.is_empty(): 
				printerr("QCompute: item with descriptor '%s' has no parameters" % __alias)
				error_at_splice = [0, ComputeError.PARAMETER_UNKNOWN]
				break
			if not __param.type == __parameter_parse[0]:
				printerr("QCompute: type mismatch while querying item with descriptor '%s'" % __alias)
				error_at_splice = [0, ComputeError.PARAMETER_TYPE_MISMATCH]
				break
		for u: int in available_links.size():
			var __linked_item_id: int = (available_links[u])[2][0] # Linking item ID
			var __linked_parameter_value: Variant = (available_links[u])[3] \
					as Dictionary[String, Variant].get(__param.id)
			if not __item.id == __linked_item_id: continue
			if not __parameter_parse.is_empty() and not solve_parameter(\
					__parameter_parse, __linked_parameter_value):
				continue # Not passed
			__unsorted_items.append(__item)
	done.emit.call_deferred(__unsorted_items)

func solve_parameter(__parsed_parameter: Array, __link_value: Variant) -> bool:
	var __passed_value: Variant = __parsed_parameter[2]
	match __parsed_parameter[1]:
		ComparisonMode.MATCH:
			match __parsed_parameter[0]:
				Parameter.ParameterTypes.NUMBER:
					if int(__passed_value) == int(__link_value): return true
				Parameter.ParameterTypes.STRING:
					if String(__passed_value) == String(__link_value): return true
		ComparisonMode.NEARBY:
			match __parsed_parameter[0]:
				Parameter.ParameterTypes.NUMBER:
					const __DIST: int = 20 # TODO: make this configurable
					if int(__passed_value) in range(__link_value - __DIST, \
							__link_value + __DIST): return true
		ComparisonMode.GREATER_THAN:
			match __parsed_parameter[0]:
				Parameter.ParameterTypes.NUMBER:
					if int(__passed_value) > int(__link_value): return true
		ComparisonMode.GREATER_OR_EQUALS_TO:
			match __parsed_parameter[0]:
				Parameter.ParameterTypes.NUMBER:
					if int(__passed_value) >= int(__link_value): return true
		ComparisonMode.LESSER_THAN:
			match __parsed_parameter[0]:
				Parameter.ParameterTypes.NUMBER:
					if int(__passed_value) < int(__link_value): return true
		ComparisonMode.LESSER_OR_EQUALS_TO:
			match __parsed_parameter[0]:
				Parameter.ParameterTypes.NUMBER:
					if int(__passed_value) <= int(__link_value): return true
	return false

func parse_parameter(__parameter: String) -> Array: # [ParameterType, Mode, Value]
	var __param_type: Parameter.ParameterTypes
	var __param_mode: ComparisonMode
	var __param_value: Variant = null
	if __parameter.substr(1).is_valid_int():
		__param_type = Parameter.ParameterTypes.NUMBER
		if __parameter.is_valid_int():
			__param_mode = ComparisonMode.MATCH
			__param_value = int(__parameter)
	if __param_value == null:
		match __parameter.substr(0, 1):
			"=": 
				__param_mode = ComparisonMode.MATCH # String and Number
				if __param_type == null:
					__param_type = Parameter.ParameterTypes.STRING
					__param_value = String(__parameter.substr(1))
			"~":  # TODO: '~' (Nearby) Can be implemented to strings if use String.match
				__param_mode = ComparisonMode.NEARBY # Number 
				if __param_type == null:
					__param_mode = ComparisonMode.MATCH
					__param_type = Parameter.ParameterTypes.STRING
					__param_value = String(__parameter.substr(1))
					printerr("QParseParameter: parameter '%s' has a number comparison, but \
					a string was provided instead. Using ComparisonMode.MATCH instead." % __parameter)
			">": 
				__param_mode = ComparisonMode.GREATER_OR_EQUALS_TO # Number
				if __param_type == null:
					__param_mode = ComparisonMode.MATCH
					__param_type = Parameter.ParameterTypes.STRING
					__param_value = String(__parameter.substr(1))
					printerr("QParseParameter: parameter '%s' has a number comparison, but \
					a string was provided instead. Using ComparisonMode.MATCH instead." % __parameter)
			"<": 
				__param_mode = ComparisonMode.LESSER_OR_EQUALS_TO # Number
				if __param_type == null:
					__param_mode = ComparisonMode.MATCH
					__param_type = Parameter.ParameterTypes.STRING
					__param_value = String(__parameter.substr(1))
					printerr("QParseParameter: parameter '%s' has a number comparison, but \
					a string was provided instead. Using ComparisonMode.MATCH instead." % __parameter)
			_: # TODO: Implement 2-char (>=, <=) comparison modes
				__param_type = Parameter.ParameterTypes.STRING
				__param_mode = ComparisonMode.MATCH
				__param_value = String(__parameter)
	return [__param_type, __param_mode, __param_value]

func _init(__raw_query: String, __items: Array[Item], __descr_cx: Array,
		__param_cx: Array, __links_cx: Array, __parse: bool = false) -> void:
	self.raw_query = __raw_query.strip_edges().strip_escapes()
	self.available_items = __items
	self.available_descriptors = __descr_cx
	self.available_parameters = __param_cx
	self.available_links = __links_cx
	if __parse:
		var _p: bool = parse_raw()
