class_name ArticyDialogueFragment extends ArticyResource
## Holds all the relevant data for a DialogueFragment from an Articy JSON export

## The id of the character entity assigned to this Articy node
var speaker: String:
	get:
		return _get_property("Speaker")

var menu_text: String:
	get:
		return _get_property("MenuText")

var stage_directions: String:
	get:
		return _get_property("StageDirections")


func _add_main_nodes():
	var aatt: ArticyAddToTree = create_aatt()
	aatt.node = NylonText.new()
	aatt.node.name = text.left(50)
	aatt.node.text = text
	
	aatt_array.append(aatt)
