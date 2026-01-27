class_name ArticyHubFate extends ArticyHub


func _process_outgoing():
	
	for connection in active_pin.connections:
		var target_ar: ArticyResource = ar_from_id(connection.target)
		var aatt = create_aatt()
		
		aatt.node = NylonConditionalGoToSequence.new()
		aatt.target_sequence_id = connection.target_pin_id
		
		if target_ar is ArticyCondition:
			var nylon_condition = NylonConditionExpression.new()
			var expression = ArticyParser.parse_condition(target_ar.expression)
			
			nylon_condition.condition_expression = expression
			aatt.node.condition = nylon_condition
		else:
			aatt.node.label = target_ar.text
			
		aatt_array.append(aatt)
