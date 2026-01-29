class_name ArticyInstruction extends ArticyScripter
## Holds all the relevant data for an Instruction from an Articy JSON export

var manual_expression: String

var variable_value: 
	get:
		if manual_expression:
			return _get_variable_value(manual_expression)
		return _get_variable_value()

var variable_namespace: String:
	get:
		if manual_expression:
			return _get_variable_namespace(manual_expression)
		return _get_variable_namespace()

var variable_name: String:
	get:
		if manual_expression:
			return _get_variable_name(manual_expression)
		return _get_variable_name()

var additive: bool:
	get:
		if manual_expression:
			return _get_additive(manual_expression)
		return _get_additive()

var multiplicative: bool:
	get:
		if manual_expression:
			return _get_multiplicative(manual_expression)
		return _get_multiplicative()


func _add_main_nodes():
	var aatt = create_aatt()
	aatt.node = NylonInstruction.new()
	aatt.node.variable_namespace = variable_namespace
	aatt.node.variable_name = variable_name
	aatt.node.variable_value = variable_value	
	aatt_array.append(aatt)



#region Getters

func _get_variable_namespace(express: String = expression):
	return express.get_slice(".", 0)


func _get_variable_name(express: String = expression):
		return express.get_slice(".", 1).get_slice(" ", 0)



func _get_variable_value(express: String = expression):
	var value = express.get_slice(" ", 2)
	if value.to_int():
		value = value.to_int()
	elif value == "true":
		value = true
	elif value == "false":
		value = false
	return value


func _get_additive(express: String = expression) -> bool:
	if express.get_slice(" ", 1) == "+=": return true
	return false


func _get_multiplicative(express: String = expression) -> bool:
	if express.get_slice(" ", 1) == "*=": return true
	return false

#endregion
