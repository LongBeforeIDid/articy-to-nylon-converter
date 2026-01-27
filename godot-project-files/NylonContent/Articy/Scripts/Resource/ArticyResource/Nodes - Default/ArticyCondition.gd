class_name ArticyCondition extends ArticyScripter

var is_hub_spoke: get = _get_is_hub_spoke

var parsed_expression: String:
	get:
		return ArticyParser.parse_condition(expression)

var true_pin: ArticyPin:
	get:
		return _get_pin_from_index(0)

var false_pin: ArticyPin:
	get:
		return _get_pin_from_index(1)


func _process_main():
	super()
	
	if is_hub_spoke:
		aatt_array.append(create_aatt())
	else:
		var aatt = create_aatt()
		aatt.node = NylonBranchBinaryGeneric.new()
		aatt.node.condition = NylonConditionExpression.new()
		aatt.node.condition.condition_expression = parsed_expression
		
		aatt_array.append(aatt)



func _get_pin_from_index(i: int) -> ArticyPin:
	if output_pins[i] is ArticyPin:
		return output_pins[i]
	return


func _get_is_hub_spoke() -> bool:
	if sources:
		for key in sources:
			if sources.get(key) is ArticyHub:
				return true
	return false
