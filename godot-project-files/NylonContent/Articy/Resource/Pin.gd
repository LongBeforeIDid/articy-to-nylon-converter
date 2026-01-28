class_name ArticyPin extends Resource
## Holds the data from a "Pin" dictionary within an Articy JSON export.
##
##

var id: String
var owner_id: String
var owner: ArticyResource:
	get:
		return ArticyResource.ar_from_id(owner_id)
var connections: Array[ArticyConnection]
var io_type: ArticyResource.IO


func create_aatt_array(is_container: bool = false) -> Array[ArticyAddToTree]:
	var aatt_array: Array[ArticyAddToTree]
	var aatt_seq = owner.create_aatt()
	var aatt_goto = owner.create_goto_aatt()
	
	aatt_seq.node = NylonSequence.new()
	aatt_seq.node.name = id
	
	aatt_goto.ar = owner
	aatt_goto.node = NylonGoToSequence.new()
	
	if is_container:
		aatt_goto.target_sequence_id = connections.front().target_pin_id
	else:
		aatt_goto.target_sequence_id = owner_id
	
	aatt_array.append(aatt_seq)
	aatt_array.append(aatt_goto)
	return aatt_array
