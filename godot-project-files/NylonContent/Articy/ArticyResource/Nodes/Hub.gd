class_name ArticyHub extends ArticyHubBase

func _add_pin_sequence_nodes():
	super()


func _add_goto_nodes():
	if targets_are_choices:
		for aatt in create_choice_aatt_array():
			aatt_array.append(aatt)
	else:
		for aatt in create_hub_aatt(hub_targets):
			aatt_array.append(aatt)
