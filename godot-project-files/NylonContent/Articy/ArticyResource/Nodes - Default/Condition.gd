class_name ArticyCondition extends ArticyScripter

var condition: NylonConditionExpression:
	get:
		return _get_condition()

var binary_node: NylonBranchBinaryGeneric

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


func _add_main_nodes():
	if is_hub_spoke:
		aatt_array.append(create_aatt())
	else:
		var aatt = create_aatt()
		binary_node = NylonBranchBinaryGeneric.new()
		aatt.node = binary_node
		aatt.node.condition = condition
		aatt_array.append(aatt)

func _add_goto_nodes():
	if is_hub_spoke:
		super()
	else:
		var aatt_true = create_condition_goto_aatt(true)
		var aatt_false = create_condition_goto_aatt(false)
		
		aatt_array.append(aatt_true)
		aatt_array.append(aatt_false)


func create_condition_goto_aatt(condition_met: bool) -> ArticyAddToTree:
	var aatt: ArticyAddToTree = create_aatt()
	aatt.parent = binary_node
	aatt.node = NylonGoToArticy.new()
	if condition_met:
		aatt.target_sequence_id = true_pin.target_pin_id
	else:
		aatt.target_sequence_id = false_pin.target_pin_id
	return aatt
	


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


func _get_condition() -> NylonConditionExpression:
	var con: NylonConditionExpression = NylonConditionExpression.new()
	con.condition_expression = parsed_expression
	return con
