@tool
class_name NylonHub extends NylonBranch

var targets_and_conditions: Dictionary[NylonArticySequence,NylonConditionExpression]


var all_targets_with_conditions: Dictionary[NylonArticySequence,NylonConditionExpression]:
	get:
		return _get_all_targets_with_conditions(true)

var all_targets_without_conditions: Dictionary[NylonArticySequence,NylonConditionExpression]:
	get:
		return _get_all_targets_with_conditions(false)

var valid_targets: Dictionary[NylonArticySequence,NylonConditionExpression]:
	get:
		return _get_valid_targets()

var random_valid_target: NylonArticySequence:
	get:
		return _get_random_valid_target()


func _get_configuration_warnings() -> PackedStringArray:
	var a: PackedStringArray = super._get_configuration_warnings()
	match get_child_count():
		0:
			a.append("Must have at least one child node to continue to.")
	return a


func _run() -> void:
	send_debug_message(get_custom_name())
	
	_complete([random_valid_target])
	
	return


func _get_valid_targets(
)          -> Dictionary[NylonArticySequence,NylonConditionExpression]:
	var dict: Dictionary[NylonArticySequence,NylonConditionExpression]
	
	for target in all_targets_without_conditions:
		dict.get_or_add(target, targets_and_conditions.get(target))
	
	for target in all_targets_with_conditions:
		
		var condition: NylonConditionExpression
		condition = all_targets_with_conditions.get(target)
		
		if condition.is_true(scene):
			dict.get_or_add(target, targets_and_conditions.get(target))	
	
	return dict


func _get_all_targets_with_conditions(has: bool
		)->   Dictionary[NylonArticySequence,NylonConditionExpression]:
	var dict: Dictionary[NylonArticySequence,NylonConditionExpression]
	
	for target in targets_and_conditions:
		if targets_and_conditions.get(target):
			if has: dict.get_or_add(target, targets_and_conditions.get(target))
		else:
			if !has: dict.get_or_add(target)
	return dict


func _get_random_valid_target() -> NylonArticySequence:
	var upper: int = len(valid_targets) - 1
	var rand = randi_range(0, upper)
	
	var i = 0
	for target in valid_targets:
		if i == rand: return target
		i += 1
	
	return
