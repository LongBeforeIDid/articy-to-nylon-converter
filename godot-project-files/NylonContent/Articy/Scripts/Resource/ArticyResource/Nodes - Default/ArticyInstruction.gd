class_name ArticyInstruction extends ArticyScripter
## Holds all the relevant data for an Instruction from an Articy JSON export

var variable_value: get = _get_variable_value

var variable_namespace: String:
	get:
		return expression.get_slice(".", 0)

var variable_name: String:
	get:
		return expression.get_slice(".", 1).get_slice(" ", 0)

var additive: bool:
	get:
		return _get_additive()

var multiplicative: bool:
	get:
		return _get_multiplicative()


func _process_main():
	super()
	var aatt = create_aatt()
	aatt.node = NylonInstruction.new()
	aatt.node.variable_namespace = variable_namespace
	aatt.node.variable_name = variable_name
	aatt.node.variable_value = variable_value
	aatt_array.append(aatt)



#region Getters

func _get_variable_namespace():
	return expression.get_slice(".", 0)


func _get_variable_name():
		return expression.get_slice(".", 1).get_slice(" ", 0)


func _get_variable_value():
	var value = expression.get_slice(" ", 2)
	if value.to_int():
		value = value.to_int()
	elif value == "true":
		value = true
	elif value == "false":
		value = false
	return value


func _get_additive() -> bool:
	if expression.get_slice(" ", 1) == "+=": return true
	return false


func _get_multiplicative() -> bool:
	if expression.get_slice(" ", 1) == "*=": return true
	return false

#endregion
