class_name ArticyDialogueFragment extends ArticyResource
## Holds all the relevant data for a DialogueFragment from an Articy JSON export

## The id of the character entity assigned to this Articy node
var speaker: String:
	get:
		return get_property("Speaker")

var menu_text: String:
	get:
		return get_property("MenuText")

var stage_directions: String:
	get:
		return get_property("StageDirections")


func _generate_nylon() -> Array[ArticyAddToTree]:
	var aatt_array: Array[ArticyAddToTree]
	var aatt: ArticyAddToTree = create_aatt()
	
	aatt.node = NylonText.new()
	aatt.node.name = text.left(50)
	aatt.node.text = text
	
	if target_generates_sequence:
		aatt_array.append(aatt)
		aatt_array.append(create_goto())
	else:
		aatt.finished = true
		aatt_array.append(aatt)
	
	return aatt_array


func _generate_process_requests() -> Array[ArticyProcessRequest]:
	return [create_apr()]
