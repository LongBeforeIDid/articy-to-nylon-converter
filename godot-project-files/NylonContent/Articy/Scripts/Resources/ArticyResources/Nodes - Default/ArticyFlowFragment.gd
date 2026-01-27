class_name ArticyFlowFragment extends ArticyFlowFragmentBase


func _generate_nylon() -> Array[ArticyAddToTree]:
	
	return [create_aatt(true, AattTypes.NONE)]


func _generate_process_requests() -> Array[ArticyProcessRequest]:

	return [create_apr()]
