class_name ArticyHubChoice extends ArticyHub


func _process_outgoing():
	var connection_counter: int = 0
	
	for connection in active_pin.connections:
		connection_counter += 1
		
		var target_ar: ArticyResource = ar_from_id(connection.target)
		var aatt = create_aatt()
		
		aatt.node = NylonConditionalChoice.new()
		aatt.target_sequence_id = connection.target_pin_id
		
		if target_ar is ArticyCondition:
			var nylon_condition = NylonConditionExpression.new()
			nylon_condition.condition_expression = ArticyParser.parse_condition(target_ar.expression)
			aatt.node.condition = nylon_condition
			target_ar = target_ar.active_target
		
		if target_ar is ArticyDialogueFragment:
			aatt.node.label = target_ar.menu_text
		else:
			print("Graceful error: non-DialogueFragment spoke on hub.")
			aatt.node.label = target_ar.text
		
		aatt_array.append(aatt)
