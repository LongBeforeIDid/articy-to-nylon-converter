@abstract
class_name ArticyResource extends Resource
## The base class for resources containing the data from an Arcity node.

enum IO {INPUT, OUTPUT}

enum AattTypes {IBID, NONE, ROOT, TREE, NEW, GOTO}

var active_IO: IO = IO.OUTPUT

## Assigned first
var ar_dict: Dictionary

## Assigned second
var flow_dict: Dictionary[String,ArticyResource]:
	set(value):
		flow_dict = value
		_populate_sources()

## The node's type. This will be a template name, if it has one
var type: String:
	get:
		if ar_dict:
			return ar_dict.get("Type")
		return "EMPTY"

## An array containing all of the node's properties
var properties: Dictionary:
	get:
		if ar_dict:
			return ar_dict.get("Properties")
		return {}

#region Properties

## The human-readable, modifiable identifier for this Articy node
var technical_name: String:
	get:
		return get_property("TechnicalName")

## The auto-generated, unmodifyable identifier for this Articy node
var id: String:
	get:
		return get_property("Id")

## The id for this node's parent within Articy (nested)
var parent: String:
	get:
		return get_property("Parent")

## The non-unique, descriptive name for this Articy Node
var display_name: get = _get_display_name

## The (localized) main text of the node.
var text: String:
	get:
		return ArticyData.localize(get_property("Text"))

var sources: Dictionary[String,ArticyResource] = {}

var has_multiple_sources: bool:
	get:
		if sources.size() > 1: return true
		return false

var generates_sequence: get = _set_generates_sequence

var target_generates_sequence: bool:
	get:
		if active_target_ar:
			return active_target_ar.generates_sequence
		return false

var assigned_sequence: NylonSequence
#endregion

#region Pins
# ~~~~~~~~~~ACTIVE~~~~~~~~~~~
var _active_pins: get = _get_active_pins
var active_pins: Array[ArticyPin]:
	get:
		return _active_pins

var _active_pin: get = _get_active_pin
var active_pin: ArticyPin:
	get:
		return _active_pin

var _active_target: get = _get_active_target
var active_target: String:
	get:
		return _active_target

var _active_target_ar: get = _get_active_target_ar
var active_target_ar: ArticyResource:
	get:
		return _active_target_ar

var _active_target_pin: get = _get_active_target_pin
var active_target_pin: String:
	get:
		return _active_target_pin

# ~~~~~~~~~~INPUT~~~~~~~~~~~
var input_pins: Array[ArticyPin]:
	get:
		return get_pins("InputPins")

var main_input_pin: ArticyPin:
	get:
		return get_first_pin(input_pins)

var main_input_target: String:
	get:
		if main_input_pin.connections:
			return main_input_pin.connections.front().target
		return ""

var main_input_target_ar: ArticyResource:
	get:
		return ar_from_id(main_input_target)

var main_input_target_pin: String:
	get:
		if main_input_pin.connections:
			return main_input_pin.connections.front().target_pin
		return ""

# ~~~~~~~~~~OUTPUT~~~~~~~~~~
var output_pins: Array[ArticyPin]:
	get:
		return get_pins("OutputPins")

var main_output_pin: ArticyPin:
	get:
		return get_first_pin(output_pins)

var main_output_target: String:
	get:
		if main_output_pin.connections:
			return main_output_pin.connections.front().target
		return ""

var main_output_target_ar: ArticyResource:
	get:
		return ar_from_id(main_output_target)

var main_output_target_pin: String:
	get:
		if main_output_pin.connections:
			return main_output_pin.connections.front().target_pin
		return ""

var all_pins: Array[ArticyPin]:
	get:
		var pins: Array[ArticyPin]
		for pin in input_pins:
			pins.append(pin)
		for pin in output_pins:
			pins.append(pin)
		return pins

## Used to determine which pin should be used for Containers
var targeted_pin: String
#endregion


@abstract
func _generate_nylon() -> Array[ArticyAddToTree]

@abstract
func _generate_process_requests() -> Array[ArticyProcessRequest]


func create_aatt(is_finished: bool = false, aatt_type: AattTypes = AattTypes.IBID) -> ArticyAddToTree:
	var aatt = ArticyAddToTree.new()
	
	aatt.ar = self
	aatt.type = aatt_type
	if is_finished:
		aatt.finished = true
	return aatt


func create_apr(target_pin_id: String = active_target_pin) -> ArticyProcessRequest:
	var apr = ArticyProcessRequest.new()
	apr.target_ar = ar_from_pin_id(target_pin_id)
	apr.target_pin = target_pin_id
	if apr.target_ar is ArticyContainer:
		print("matching")
		match apr.target_ar.get_pin_suffix(target_pin_id):
			"input":
				apr.container_type = ArticyProcessRequest.ContainerTypes.INPUT
			"output":
				apr.container_type = ArticyProcessRequest.ContainerTypes.OUTPUT
		return apr
	apr.container_type = ArticyProcessRequest.ContainerTypes.NONE
	return apr


func create_goto(is_finished = true) -> ArticyAddToTree:
	var aatt_goto: ArticyAddToTree = create_aatt(is_finished, AattTypes.GOTO)
	aatt_goto.node = NylonGoToSequence.new()
	var container_suffix = ""
	if active_target_ar is ArticyContainer:
		print(active_target_pin)
		print("savannah   " + active_target_ar.get_pin_suffix(active_target_pin))
		container_suffix = "_" + active_target_ar.get_pin_suffix(active_target_pin)
	aatt_goto.sequence_id = active_target + container_suffix
	return aatt_goto


func has_pin_id(pin_id: String, ar: ArticyResource) -> String:
	for pin in ar.input_pins:
		if pin.id == pin_id:
			return "input"
	for pin in ar.output_pins:
		if pin.id == pin_id:
			return "output"
	return ""


func ar_from_pin_id(pin_id: String) -> ArticyResource:
	for key in flow_dict:
		var ar = ar_from_id(key)
		for pin in ar.all_pins:
			if pin.id == pin_id:
				return ar
	return


func ar_from_id(id: String) -> ArticyResource:
	if flow_dict:
		return flow_dict.get(id)
	return


func get_property(property: String, expected_return: String = "String") -> Variant:
	if properties.get(property):
		return properties.get(property)
	match expected_return:
		"String":
			return ""
		"Array":
			return []
		"Dictionary":
			return {}
	return


func get_pins(pins_type: String) -> Array[ArticyPin]:
	var pins: Array[ArticyPin]
	
	if properties.get(pins_type):
		for pin in properties.get(pins_type):
			pins.append(get_pin(pin))
	
	return pins


func get_pin(pin: Dictionary ) -> ArticyPin:
	var new_pin = ArticyPin.new()
	var connections: Array[ArticyConnection]
	
	if pin.get("Connections"):
		for connection in pin.get("Connections"):
			connections.append(get_connection(connection))
	
	new_pin.id = pin.get("Id")
	new_pin.owner = pin.get("Owner")
	new_pin.connections = connections
	
	return new_pin


func get_connection(connection: Dictionary) -> ArticyConnection:
	var new_connection = ArticyConnection.new()
	
	new_connection.label = connection.get("Label")
	new_connection.target_pin = connection.get("TargetPin")
	new_connection.target = connection.get("Target")
	
	return new_connection


func get_first_pin(pins: Array[ArticyPin]) -> ArticyPin:
	if pins: 
		return pins.front()
	return


func _populate_sources():
	for id in flow_dict:
		var ar: ArticyResource = ar_from_id(id)
		for pin in ar.all_pins:
			for connection in pin.connections:
				if connection.target == self.id:
					sources.get_or_add(ar.id, ar)


func _set_generates_sequence() -> bool:
	for key in sources:
		if sources.get(key) is ArticyHub:
			return true
	return has_multiple_sources


func _get_display_name() -> String:
	return get_property("DisplayName")

#region Active Pin Getters

func _get_active_pins() -> Array[ArticyPin]:
	return output_pins


func _get_active_pin() -> ArticyPin:
	return main_output_pin


func _get_active_target() -> String:
	return main_output_target


func _get_active_target_ar() -> ArticyResource:
	return main_output_target_ar


func  _get_active_target_pin() -> String:
	return main_output_target_pin

#endregion
