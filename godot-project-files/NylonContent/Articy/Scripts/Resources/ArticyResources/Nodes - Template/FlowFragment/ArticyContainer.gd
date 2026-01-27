class_name ArticyContainer extends ArticyFlowFragmentBase
## Holds all the relevant data for a Container from an Articy JSON export

var container_type: IO


func _generate_nylon() -> Array[ArticyAddToTree]:
	
	return [create_aatt(true, AattTypes.NONE)]


func _generate_process_requests() -> Array[ArticyProcessRequest]:
	for pin in active_pins:
		print(pin.id)
	return [create_apr(active_target_pin)]


func generate_container(type: String) -> Array[ArticyAddToTree]:
	match type:
		"input":
			container_type = IO.INPUT
		"output":
			container_type = IO.OUTPUT
	return _generate_nylon()


func get_pin_suffix(pin_id: String) -> String:
	for pin in input_pins:
		if pin.id == pin_id:
			return "input"
	for pin in output_pins:
		if pin.id == pin_id:
			return "output"
	return ""


#region Active Pin Getters

func _get_active_pins() -> Array[ArticyPin]:
	if container_type == IO.INPUT: return input_pins
	if container_type == IO.OUTPUT: return output_pins
	return []


func _get_active_pin() -> ArticyPin:
	if container_type == IO.INPUT: return main_input_pin
	if container_type == IO.OUTPUT: return main_output_pin
	return


func _get_active_target() -> String:
	if container_type == IO.INPUT: return main_input_target
	if container_type == IO.OUTPUT: return main_output_target
	return ""


func _get_active_target_ar() -> ArticyResource:
	if container_type == IO.INPUT: return main_input_target_ar
	if container_type == IO.OUTPUT: return main_output_target_ar
	return


func  _get_active_target_pin() -> String:
	if container_type == IO.INPUT: return main_input_target_pin
	if container_type == IO.OUTPUT: return main_output_target_pin
	return ""

#endregion
