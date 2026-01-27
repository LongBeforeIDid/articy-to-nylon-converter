@tool
class_name NylonInstruction extends NylonNode
## A custom node to handle changes to global bools from Articy.
## 
## Global variables are added to dictionaries within the Proarche autoload.

## The "Namespace" of the global variable within Articy.
## Used to determine which Proarche dictionary the variable gets added to.
@export var variable_namespace: String

## The name of the variable this node will set.
## Determined by the name of the global variable within Articy.
@export var variable_name: String

## The value this node will set.
@export var variable_value: Variant


@export var addative: bool
@export var multiplicative: bool

# Overrides NylonNode, but is currently identical. Change later for custom naming.
func _update_name() -> void:
	var custom_name: String = get_custom_name()
	if not custom_name:
		custom_name = get_class_name()
	name = _get_prefix() + " " + custom_name


# Overrides NylonNode.
func _run() -> void:
	
	send_debug_message(get_custom_name())
	
	if variable_value is String:
		addative = false
		multiplicative = false
	
	if addative:
		Articy.add_global_variable(variable_namespace, variable_name, variable_value)
	elif multiplicative:
		Articy.mult_global_variable(variable_namespace, variable_name, variable_value)
	else:
		Articy.set_global_variable(variable_namespace, variable_name, variable_value)
	
	_complete()
	return


# Handles variables within the "traits" NameSpace in Articy
func _set_trait(n: String, v: Variant):
	
	if v is not bool:
		print("ERROR! Failed to add trait, recieved unexpected non-bool value.")
		return
	
