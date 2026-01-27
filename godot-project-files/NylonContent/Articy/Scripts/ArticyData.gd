@abstract
class_name ArticyData extends Node
## Base class for AtricyNylonConverter, preloads JSON data from files.

static var json_pack = _readJSON(PathConfig.path_pack)
static var json_pack_loc = _readJSON(PathConfig.path_pack_loc)
static var json_def = _readJSON(PathConfig.path_def)
static var json_def_loc = _readJSON(PathConfig.path_def_loc)
static var json_global = _readJSON(PathConfig.path_global)

## stores ArticyResources, access using id String.
static var articy_resources: Dictionary[String,ArticyResource]


## Takes the text_key property of an ArticyResource and returns localized text. 
static func localize(key) -> String:
	if key is String:
		#Parses localization_json for the correct resource and language
		if json_pack_loc.get(key):
			var all_languages = json_pack_loc.get(key)
			var local_language = all_languages.get(PathConfig.locale)
			return local_language.get("Text")
		else:
			return key
	return ""


## Convets JSON data into ArticyResources then stores them in the articy_resources Dictionary.
static func load_nodes_from_json():
	#Iterates through every Articy node in the json file
	for ar_dict: Dictionary in json_pack.get("Objects"):
		var ar: ArticyResource
		
		# Packs the data from each dictionary into the appropriate ArticyResource
		match ar_dict.get("Type"):
			# ~Default Nodes~
			"DialogueFragment":
				ar = ArticyDialogueFragment.new()
			"FlowFragment":
				ar = ArticyFlowFragment.new()
			"Instruction":
				ar = ArticyInstruction.new()
			"Condition":
				ar = ArticyCondition.new()
			# ~FlowFragment Template Nodes~
			"Scene":
				ar = ArticyScene.new()
			"Container":
				ar = ArticyContainer.new()
			# ~Hub Template Nodes~
			"HubChoice":
				ar = ArticyHubChoice.new()
			"HubFate":
				ar = ArticyHubFate.new()
		
		# Propogates the completed Dictionary to the ArticyResources
		if ar:
			ar.ar_dict = ar_dict
			articy_resources.get_or_add(ar.id, ar)
	
	for id in articy_resources:
		articy_resources.get(id).flow_dict = articy_resources


## Converts an array of Node IDs into an Array of ArticyResources.
static func convert_output_ids(ids) -> Array[ArticyResource]:
	var a: Array[ArticyResource]
	if ids:
		for id in ids:
			a.append(articy_resources.get(id))
	return a


static func _readJSON(json_file_path):
	var file = FileAccess.open(json_file_path, FileAccess.READ)
	var content = file.get_as_text()
	var finish = JSON.parse_string(content)
	return finish
