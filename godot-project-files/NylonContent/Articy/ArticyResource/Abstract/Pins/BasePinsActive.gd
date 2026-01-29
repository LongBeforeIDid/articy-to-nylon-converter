class_name ArticyResourceBasePinsActive extends ArticyResourceBasePinsIO


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
