@tool
class_name NylonConditionExpression extends NylonCondition

@export var condition_expression: String = "true"


func is_true(_scene: NylonScene) -> bool:
	var expression = Expression.new()
	var error = expression.parse(condition_expression)
	if error != OK:
		print(expression.get_error_text())
	if expression.execute([], _scene):
		return true
	else:
		return false


## Override this to change what is displayed in Branch nodes names.
func get_string() -> String:
	return "Complex Condition"
