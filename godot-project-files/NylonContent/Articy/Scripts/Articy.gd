class_name Articy extends Node

static var articy_variables: Dictionary[String,Dictionary] = {}


static func get_value(name_space: String, variable: String) -> Variant:
	return articy_variables.get(name_space).get(variable)


static func set_variable(name_space: String, variable: String, value: Variant):
	if articy_variables.get(name_space):
		articy_variables.get(name_space).set(variable, value)
	else:
		articy_variables.set(name_space, {variable: value})
	print("Updated Articy Global Variables: " + str(articy_variables))


static func add_variable(name_space:String, variable: String, value: int):
	if variable_exists(name_space, variable):
		var new_value = articy_variables.get(variable) + value
		set_variable(name_space, variable, new_value)
	else:
		set_variable(name_space, variable, value)


static func mult_variable(name_space:String, variable: String, value: float):
	if variable_exists(name_space, variable) is int:
		var new_value
		new_value = round(float(articy_variables.get("name_space").get("variable")) * value)
		set_variable(name_space, variable, new_value)


static func variable_exists(name_space: String, variable: String) -> Variant:
	if articy_variables.get(name_space):
		return articy_variables.get(name_space).get(variable)
	return false
