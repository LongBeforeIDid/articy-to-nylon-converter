class_name ArticyHubChoice extends ArticyHub


func _generate_nylon() -> Array[ArticyAddToTree]:
	var aatt_array: Array[ArticyAddToTree]
	var connection_counter: int = 0
	
	for connection in active_pin.connections:
		var target_ar: ArticyResource = ar_from_id(connection.target)
		var aatt = create_aatt(false, AattTypes.GOTO)
		aatt.node = NylonConditionalChoice.new()
		connection_counter += 1
		
		aatt.sequence_id = target_ar.id
		
		if target_ar is ArticyCondition:
			var nylon_condition = NylonConditionExpression.new()
			nylon_condition.condition_expression = ArticyParser.parse_condition(target_ar.expression)
			aatt.node.condition = nylon_condition
			target_ar = ar_from_id(target_ar.active_target)
			
		if target_ar is ArticyDialogueFragment:
			aatt.node.label = target_ar.menu_text
		else:
			print("Graceful error: non-DialogueFragment spoke on hub.")
			aatt.node.label = target_ar.text
			
		if connection_counter == active_pin.connections.size():
			aatt.finished = true
			
		aatt_array.append(aatt)
	return aatt_array



func _generate_process_requests() -> Array[ArticyProcessRequest]:
	var apr_array: Array[ArticyProcessRequest]
	
	for connection in active_pin.connections:
		apr_array.append(create_apr(connection.target_pin))
	
	return apr_array
