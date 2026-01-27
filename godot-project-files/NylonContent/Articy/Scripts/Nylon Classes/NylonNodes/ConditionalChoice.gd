@tool
class_name NylonConditionalChoice extends NylonChoice


@export var required_traits: Dictionary[String, bool]



func _run() -> void:
	var message: NylonMessageChoice = NylonMessageChoice.new()
	message.idx = get_index()
	message.label = label
	message.condition_fulfilled = true
	message.chosen_before = Nylon.scene_data.get_flag(scene.scene_id, scene.get_path_to(self))
	
	if required_traits:
		var are_requirements_met: bool = true
		
		for t in required_traits:
			if Proarche.player_traits.get(t) != required_traits.get(t):
				are_requirements_met = false
				
		message.condition_fulfilled = are_requirements_met
	
	message.hidden_if_unfulfilled = hidden_if_unfulfilled
	
	awaiting_choice = message
	awaiting_choice.chosen.connect(_on_choice_chosen)
	
	send_message(awaiting_choice)
	
	send_debug_message("Choice offered -> %s" % label)
	
	scene.add_node_in_waiting(self)
	
	_complete()
