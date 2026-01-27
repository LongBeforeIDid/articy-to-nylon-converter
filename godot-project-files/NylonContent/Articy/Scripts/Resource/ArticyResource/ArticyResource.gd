@abstract
class_name ArticyResource extends ArticyResourceBaseSources
## The base class for resources containing the data from an Arcity node.

var assigned_sequence: NylonSequence

var aatt_array: Array[ArticyAddToTree] = []

var creates_node: bool = true

func _generate_nylon() -> Array[ArticyAddToTree]:
	ArticyDebug.log_ar_properties(self)
	_process_incoming()
	_process_main()
	_process_outgoing()
	
	return aatt_array

func _process_incoming():
	_create_pin_aatt_array()

func _process_main():
	aatt_array.append(_create_sequence_aatt())

func _process_outgoing():
	aatt_array.append(create_goto_aatt())


func create_aatt() -> ArticyAddToTree:
	var aatt = ArticyAddToTree.new()
	aatt.ar = self
	return aatt


func create_goto_aatt() -> ArticyAddToTree:
	var aatt_goto: ArticyAddToTree = create_aatt()
	aatt_goto.node = NylonGoToSequence.new()
	
	if active_target_pin:
		aatt_goto.target_sequence_id = active_target_pin.id
	
	return aatt_goto


func _create_sequence_aatt() -> ArticyAddToTree:
	var aatt = create_aatt()
	aatt.node = NylonSequence.new()
	aatt.node.name = id
	return aatt


func _create_pin_aatt_array(pins: Array[ArticyPin] = input_pins):
	for pin in pins:
		for aatt in pin.create_aatt_array():
			aatt_array.append(aatt)
