@abstract
class_name ArticyHubBase extends ArticyResource
## Base class for generic Hub nodes from an Articy JSON export.
## Should not be used directly.

## Stores this hub's connections, in the format [output_target:output_target_pin]
var hub_targets: Array[ArticyHubTarget]:
	get:
		return _get_hub_targets()

var all_targets_with_conditions: Array[ArticyHubTarget]:
	get:
		return _get_all_targets_with_conditions(true)

var all_targets_without_conditions: Array[ArticyHubTarget]:
	get:
		return _get_all_targets_with_conditions(false)

var targets_are_choices: bool:
	get:
		return _get_targets_are_choices()


func _add_pin_sequence_nodes():
	for aatt in _create_pin_aatt_array(input_pins):
		aatt_array.append(aatt)


func _add_goto_nodes():
	pass


func create_choice_aatt_array() -> Array[ArticyAddToTree]:
	var array: Array[ArticyAddToTree]
	
	for target in hub_targets:
		var aatt: ArticyAddToTree = create_aatt()
		
		if target.ar is ArticyDialogueFragment and target.ar.menu_text:
			
			aatt.node = NylonChoice.new()
			aatt.node.label = target.ar.menu_text
			aatt.target_sequence_id = target.pin.id
			if target.condition:
				aatt.node.condition = target.condition
			
			array.append(aatt)
	return array


func create_hub_aatt(targets: Array[ArticyHubTarget]) -> Array[ArticyAddToTree]:
	var array: Array[ArticyAddToTree]
	var hub_aatt: ArticyAddToTree = create_aatt()
	hub_aatt.node = NylonHub.new()
	
	for target in targets:
		var goto_aatt: ArticyAddToTree = create_aatt()
		
		goto_aatt.node = NylonGoToArticy.new()
		goto_aatt.target_sequence_id = target.pin.id
		goto_aatt.parent = hub_aatt.node
		
		if target.condition:
			goto_aatt.node.condition = target.condition
		
		array.append(goto_aatt)
		
	return array


## A target is considered a choice if it is a DialogueFragment with MenuText.
func _get_targets_are_choices() -> bool:
	for target in hub_targets:
		pass
		if target.ar is not ArticyDialogueFragment: return false
		pass
		if not target.ar.menu_text: return false
		pass	
	
	return true


func _get_all_targets_with_conditions(has: bool)->   Array[ArticyHubTarget]:
	var array: Array[ArticyHubTarget]
	
	for target in hub_targets:
		if target.condition:
			if has: array.append(target)
		else:
			if !has: array.append(target)
	return array


func _get_hub_targets() -> Array[ArticyHubTarget]:
	var targets: Array[ArticyHubTarget]
	
	for connection in active_pin.connections:
		var target = ArticyHubTarget.new()
		target.ar = connection.target_ar
		target.pin = connection.target_pin
		if connection.target_ar is ArticyCondition:
			target.ar = connection.target_ar.active_target
			target.condition = connection.target_ar.condition
		targets.append(target)
	return targets
