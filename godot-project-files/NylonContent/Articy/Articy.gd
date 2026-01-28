class_name Articy extends Node

static var global_variables: Dictionary[String,Dictionary] = {}


#region Global Variable Functions

static func get_global_variable(name_space: String, variable: String) -> Variant:
	return global_variables.get(name_space).get(variable)


static func set_global_variable(name_space: String, variable: String, value: Variant):
	if global_variables.get(name_space):
		global_variables.get(name_space).set(variable, value)
	else:
		global_variables.set(name_space, {variable: value})


static func add_global_variable(name_space:String, variable: String, value: int):
	var new_value = value
	if global_variable_exists(name_space, variable):
		new_value += global_variables.get(variable) + value
	set_global_variable(name_space, variable, new_value)


static func mult_global_variable(name_space:String, variable: String, value: float):
	if global_variable_exists(name_space, variable) is int:
		var new_value = round(float(global_variables.get("name_space").get("variable")) * value)
		set_global_variable(name_space, variable, new_value)


static func global_variable_exists(name_space: String, variable: String) -> Variant:
	if global_variables.get(name_space):
		return global_variables.get(name_space).get(variable)
	return false

#endregion
