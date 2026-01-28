class_name ArticyScene extends ArticyFlowFragmentBase
## Holds all the relevant data for a ArcityScene from an Articy JSON export

func _process_incoming():
	var aatt = create_aatt()
	aatt.node = NylonScene.new()
	aatt.node.name = display_name
	aatt_array.append(aatt)

func _process_main():
	var aatt = create_aatt()
	aatt.node = NylonArticySequence.new()
	aatt.node.name = "START_SEQUENCE"
	aatt_array.append(aatt)
	
	var goto = create_aatt()
	goto.node = NylonGoToSequence.new()
	goto.target_sequence_id = main_input_target_pin.id
	
	aatt_array.append(goto)

func _process_outgoing():
	var aatt_seq = create_aatt()
	aatt_seq.node = NylonArticySequence.new()
	aatt_seq.node.name = main_output_pin.id
	aatt_array.append(aatt_seq)
	
	var aatt_end = create_aatt()
	aatt_end.node = NylonEndScene.new()
	aatt_array.append(aatt_end)


## Overrides base class. There's no reason for "End Scene" to generate a new sequence.
func _set_generates_sequence() -> bool:
	return false
