@abstract
class_name ArticyDataLoader extends Articy
## Base class for AtricyNylonConverter, preloads JSON data from files.

## stores ArticyResources, access using id String.
static var flow_dict: Dictionary[String,ArticyResource]

static var _json_pack = _readJSON(ArticyPathConfig.path_pack)
static var _json_pack_loc = _readJSON(ArticyPathConfig.path_pack_loc)
static var _json_def = _readJSON(ArticyPathConfig.path_def)
static var _json_def_loc = _readJSON(ArticyPathConfig.path_def_loc)
static var _json_global = _readJSON(ArticyPathConfig.path_global)


## Takes the text_key property of an ArticyResource and returns localized text. 
static func localize(key) -> String:
	if key is String:
		#Parses localization_json for the correct resource and language
		if _json_pack_loc.get(key):
			var all_languages = _json_pack_loc.get(key)
			var local_language = all_languages.get(ArticyPathConfig.locale)
			return local_language.get("Text")
		else:
			return key
	return ""


## Convets JSON data into ArticyResources 
## then appends each one to [member flow_dict],
## in the format 
## [Dictionary][[[member ArticyResource.id],[ArticyResource]]
static func load_nodes_from_json():
	#Iterates through every Articy node in the json file
	for _ar_dict: Dictionary in _json_pack.get("Objects"):
		var ar: ArticyResource
		
		# Packs the data from each dictionary into the appropriate ArticyResource
		var template_name = _ar_dict.get("Type")
		ar = ArticyTemplateConfig.articy_resource_from_template(template_name)
			
		# Propogates the completed Dictionary to the ArticyResources
		if ar:
			ar._ar_dict = _ar_dict
			flow_dict.get_or_add(ar.id, ar)
			for pin in ar.all_pins:
				ArticyResourceBasePins.pin_dict.get_or_add(pin.id, pin)
	for id in flow_dict:
		flow_dict.get(id).flow_dict = flow_dict


static func _readJSON(json_file_path):
	var file = FileAccess.open(json_file_path, FileAccess.READ)
	var content = file.get_as_text()
	var finish = JSON.parse_string(content)
	return finish
