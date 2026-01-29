class_name ArticyScene extends ArticyFlowFragment
## Holds all the relevant data for a Dialogue from an Articy JSON export


func _add_pin_sequence_nodes():
	var aatt = create_aatt()
	aatt.node = NylonScene.new()
	aatt.node.name = display_name
	aatt_array.append(aatt)


func _add_main_sequence_node():
	super()
	aatt_array.back().node.name = "SCENE_START"


func _add_main_nodes():	
	var goto = create_aatt()
	goto.node = NylonGoToArticy.new()
	goto.target_sequence_id = main_input_target_pin.id
	
	aatt_array.append(goto)


func _add_goto_nodes():
	var aatt_seq = create_aatt()
	aatt_seq.node = NylonArticySequence.new()
	aatt_seq.node.name = main_output_pin.id
	aatt_array.append(aatt_seq)
	
	var aatt_end = create_aatt()
	aatt_end.node = NylonEndScene.new()
	aatt_array.append(aatt_end)
