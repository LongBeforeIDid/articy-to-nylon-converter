class_name ArticyScene extends ArticyFlowFragmentBase
## Holds all the relevant data for a ArcityScene from an Articy JSON export

var is_being_processed: bool


func _generate_nylon() -> Array[ArticyAddToTree]:
	var aatt_array: Array[ArticyAddToTree]
	var aatt = create_aatt()
	
	if not is_being_processed:
		var aatt_seq = create_aatt()
		#Start Scene
		is_being_processed = true
		aatt.node = NylonScene.new()
		aatt.node.name = display_name
		aatt.type = AattTypes.TREE
		aatt_array.append(aatt)
		
		aatt_seq = create_aatt()
		aatt_seq.node = NylonSequence.new()
		aatt_seq.node.name = "START_SEQUENCE"
		aatt_seq.type = AattTypes.ROOT
		aatt_seq.finished = true
		aatt_array.append(aatt_seq)
		ArticyNylonConverter.active_sequence = aatt_seq.node
	else:
		# End Scene
		aatt.node = NylonEndScene.new()
		aatt.type = AattTypes.IBID
		aatt_array.append(aatt)
	
	return aatt_array


func _generate_process_requests() -> Array[ArticyProcessRequest]:
	
	print("Generating process request for " + id)
	var apr: ArticyProcessRequest = ArticyProcessRequest.new()
	apr.target_ar = main_input_target_ar
	apr.target_pin = main_input_target_pin
	ArticyDebug.log_ar_properties(apr.target_ar)
	return [apr]


## Overrides base class. There's no reason for "End Scene" to generate a new sequence.
func _set_generates_sequence() -> bool:
	return false
