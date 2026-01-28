class_name ArticyParser extends Resource


static func parse_condition(string: String):
	var con_ex: String = ""
	var logical_operator
	
	if string.contains(" && "):
		logical_operator = " && "
	if string.contains(" || "):
		logical_operator = " || "
	
	if logical_operator:
		for i in range(0, string.count(logical_operator) + 1):
			
			con_ex = con_ex + _parse_condition_sub_expression(string.get_slice(logical_operator, i))
			
			# Add a logical operator to the string if this is not the last expression.
			if i != string.count(logical_operator):
				con_ex = con_ex + logical_operator
	else:
		con_ex = _parse_condition_sub_expression(string)
	return con_ex


static func get_goto_name(goto: NylonNode) -> String:
	if not goto: return ""
	if not goto.get_parent(): return ""
	
	var parent_name = str(goto.get_parent().name)
	var node_index = str(goto.get_index())
	
	var goto_name = parent_name + "_" + node_index
	return goto_name


static func _parse_condition_sub_expression(string: String) -> String:
	var modified_string = ""
	var temp_string = string
	if string.begins_with("!"):
		modified_string = "not "
		temp_string = temp_string.replace("!", "")
	
	var name_space = temp_string.get_slice(" ", 0).get_slice(".",0)
	var variable = temp_string.get_slice(" ", 0).get_slice(".",1)
	modified_string = modified_string + "Articy.get_global_variable('" + name_space + "', '" + variable + "')"
	
	if temp_string.contains(" "):
		modified_string = modified_string + temp_string.get_slice(variable, 1)
	return modified_string
