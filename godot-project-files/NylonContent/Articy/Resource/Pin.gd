class_name ArticyPin extends Resource
## Holds the data from a "Pin" dictionary within an Articy JSON export.
##
##
var text: String

var id: String

var owner: ArticyResource:
	get:
		return ArticyResource.ar_from_id(owner_id)

var owner_id: String

var connections: Array[ArticyConnection]

var target_pin: String:
	get:
		return ArticyResource.pin_dict.get(target_pin_id)

var target_pin_id: String:
	get:
		if connections: return connections.front().target_pin_id
		return ""

var io_type: ArticyResource.IO

var inbound_pins: Array[ArticyPin]:
	get:
		return _get_incoming()


func create_aatt_array() -> Array[ArticyAddToTree]:
	if not connections and not inbound_pins: return []
	var aatt_array: Array[ArticyAddToTree]
	
	aatt_array.append(_get_sequence_aatt())
	
	if text: aatt_array.append(_handle_instruction())
	
	aatt_array.append(_get_goto_aatt())
	
	return aatt_array


func _handle_instruction() -> ArticyAddToTree:
	var instruction = ArticyInstruction.new()
	instruction.manual_expression = text
	
	var aatt = owner.create_aatt()
	aatt.node = NylonInstruction.new()
	aatt.node.variable_namespace = instruction.variable_namespace
	aatt.node.variable_name = instruction.variable_name
	aatt.node.variable_value = instruction.variable_value
	aatt.node.addative = instruction.additive
	aatt.node.multiplicative = instruction.multiplicative
	return aatt


func _get_sequence_aatt() -> ArticyAddToTree:
	var aatt_seq = owner.create_aatt()
	aatt_seq.node = NylonArticySequence.new()
	aatt_seq.node.name = id
	return aatt_seq


func _get_goto_aatt() -> ArticyAddToTree:
	var aatt_goto: ArticyAddToTree = owner.create_goto_aatt()
	aatt_goto.ar = owner
	aatt_goto.node = NylonGoToArticy.new()
	
	if target_pin_id:
		aatt_goto.target_sequence_id = target_pin_id
	elif io_type == ArticyResource.IO.INPUT:
		aatt_goto.target_sequence_id = owner.id
	else:
		aatt_goto.node = null
	
	return aatt_goto


func _get_incoming():
	var pins: Array[ArticyPin]
	var pin_dict = ArticyResource.pin_dict
	
	for pin_id in pin_dict:
		var pin = pin_dict.get_or_add(pin_id)
		var pin_is_connected = false
		
		for connection: ArticyConnection in pin.connections:
			if connection.target_pin_id == id:
				pin_is_connected = true
		
		if pin_is_connected:
			pins.append(pin)
	return pins
