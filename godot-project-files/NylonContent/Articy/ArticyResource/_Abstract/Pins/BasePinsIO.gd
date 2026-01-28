class_name ArticyResourceBasePinsIO extends ArticyResourceBasePins

var all_pins: Array[ArticyPin]:
	get:
		return _get_all_pins()


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
	return input_pins + output_pins


func _get_first_pin(pins: Array[ArticyPin]) -> ArticyPin:
	if pins: return pins.front()
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
