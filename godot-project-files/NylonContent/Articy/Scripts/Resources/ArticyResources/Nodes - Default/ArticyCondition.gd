class_name ArticyCondition extends ArticyScripter

var is_hub_spoke: get = _get_is_hub_spoke

var parsed_expression: String:
	get:
		return ArticyParser.parse_condition(expression)

var true_pin: ArticyPin:
	get:
		return _get_pin(0)

var false_pin: ArticyPin:
	get:
		return _get_pin(1)


func _generate_nylon() -> Array[ArticyAddToTree]:
	var aatt_array: Array[ArticyAddToTree]
	if is_hub_spoke:
		aatt_array = [create_aatt(true, AattTypes.NONE)]
	else:
		var condition = NylonConditionExpression.new()
		condition.condition_expression = parsed_expression
		var node = NylonBranchBinaryGeneric.new()
		node.condition = condition
		var aatt = create_aatt(true)
		aatt.node = node
		aatt_array = [aatt]
	
	
	return aatt_array


func _generate_process_requests() -> Array[ArticyProcessRequest]:
	return [create_apr()]


func _get_pin(i: int) -> ArticyPin:
	if output_pins[i] is ArticyPin:
		return output_pins[i]
	return


func _get_is_hub_spoke() -> bool:
	if sources:
		for key in sources:
			if sources.get(key) is ArticyHub:
				return true
	return false
