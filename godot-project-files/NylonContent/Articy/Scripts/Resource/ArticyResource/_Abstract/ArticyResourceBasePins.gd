class_name ArticyResourceBasePins extends ArticyResourceBaseProperties

enum IO {INPUT, OUTPUT}

var active_IO: IO = IO.OUTPUT

var all_pins: Array[ArticyPin]:
	get:
		return _get_all_pins()

## Used to determine which pin should be used for Containers
var targeted_pin: String


#region Active Pins

var _active_pins: get = _get_active_pins
var _active_pin: get = _get_active_pin
var _active_target: get = _get_active_target
var _active_target_pin: get = _get_active_target_pin

## Returns [member output_pins] by default.
## Override [method _get_active_pins] to change this behaviour.
var active_pins: Array[ArticyPin]:
	get:
		return _active_pins

## Returns [member main_output_pin] by default.
## Override [method _get_active_pin] to change this behaviour.
var active_pin: ArticyPin:
	get:
		return _active_pin

## Returns [member main_output_target] by default.
## Override [method _get_active_target] to change this behaviour.
var active_target: ArticyResource:
	get:
		return _active_target

## Returns [member main_output_target_pin] by default. 
## Override [method _get_active_target_pin] to change this behaviour.
var active_target_pin: ArticyPin:
	get:
		return _active_target_pin

#endregion


#region Input Pins
## An array of this [ArticyResource]'s input [ArticyPin]s.
var input_pins: Array[ArticyPin]:
	get:
		return _get_pins("InputPins")

## The first ArticyPin found in [member input_pins].
var main_input_pin: ArticyPin:
	get:
		return _get_first_pin(input_pins)

## The [ArticyResource] targeted by this [ArticyResource]'s [member main_input_pin].
var main_input_target: ArticyResource:
	get:
		return _get_main_pin_target(main_input_pin)

## The [ArticyPin] representing the specific pin on [member main_input_target]
## that this [ArticyResource] is targeting.
var main_input_target_pin: ArticyPin:
	get:
		return _get_main_pin_target_pin(main_input_pin)

#endregion


#region Output Pins

## An array of this [ArticyResource]'s output [ArticyPin]s.
var output_pins: Array[ArticyPin]:
	get:
		return _get_pins("OutputPins")

## The first [ArticyPin] found in [member output_pins].
var main_output_pin: ArticyPin:
	get:
		return _get_first_pin(output_pins)

## The [ArticyResource] targeted by this [ArticyResource]'s [member main_output_pin].
var main_output_target: ArticyResource:
	get:
		return _get_main_pin_target(main_output_pin)

## The [ArticyPin] representing the specific pin on [member main_out_target]
## that this [ArticyResource] is targeting.
var main_output_target_pin: ArticyPin:
	get:
		return _get_main_pin_target_pin(main_output_pin)

#endregion


func get_pin_from_id(pin_id: String) -> ArticyPin:
	for pin in all_pins:
		if pin.id == pin_id:
			return pin
	return


#region Pin Getters

func _get_all_pins() -> Array[ArticyPin]:
	var pins: Array[ArticyPin]
	for pin in input_pins:
		pins.append(pin)
	for pin in output_pins:
		pins.append(pin)
	return pins


func _get_pins(pins_type: String) -> Array[ArticyPin]:
	var pins: Array[ArticyPin]
	
	if properties.get(pins_type):
		for pin in properties.get(pins_type):
			pins.append(_get_pin(pin, pins_type))
	
	return pins


func _get_pin(pin: Dictionary, pin_type: String) -> ArticyPin:
	var new_pin = ArticyPin.new()
	var connections: Array[ArticyConnection]
	
	if pin.get("Connections"):
		for connection in pin.get("Connections"):
			connections.append(_get_connection(connection))
	
	if pin_type == "InputPins": new_pin.io_type = IO.INPUT
	if pin_type == "OutputPins": new_pin.io_type = IO.OUTPUT
	
	new_pin.id = pin.get("Id")
	new_pin.owner_id = pin.get("Owner")
	new_pin.connections = connections
	
	return new_pin


func _get_connection(connection: Dictionary) -> ArticyConnection:
	var new_connection = ArticyConnection.new()
	
	new_connection.label = connection.get("Label")
	new_connection.target_pin_id = connection.get("TargetPin")
	new_connection.target = connection.get("Target")
	
	return new_connection


func _get_first_pin(pins: Array[ArticyPin]) -> ArticyPin:
	if pins: 
		return pins.front()
	return


func _get_main_pin_target(main_pin: ArticyPin) -> ArticyResource:
	if main_pin.connections:
		if main_pin.connections.front().target:
			return ar_from_id(main_pin.connections.front().target)
	return


func _get_main_pin_target_pin(main_pin: ArticyPin) -> ArticyPin:
	var target = _get_main_pin_target(main_pin)
	if target:
		for pin in target.all_pins:
			if pin.id == main_pin.connections.front().target_pin_id:
				return pin
	return

#endregion


#region Active Pin Getters

func _get_active_pins() -> Array[ArticyPin]:
	return output_pins


func _get_active_pin() -> ArticyPin:
	return main_output_pin


func _get_active_target() -> ArticyResource:
	return main_output_target


func  _get_active_target_pin() -> ArticyPin:
	return main_output_target_pin

#endregion
