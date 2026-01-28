class_name ArticyPathConfig extends Node

const locale = "en-CA"

const articy_directory = "res://NylonContent/Articy/"
const json_path = articy_directory + "JSON Exports/"

## Where the NylonScene.tscn will be saved.
const scene_path = "res://Output/"

static var path_pack = _fetch_json_path("package_*_objects.json")
static var path_pack_loc = _fetch_json_path("package_*_localization.json")
static var path_def = _fetch_json_path("object_definitions.json")
static var path_def_loc = _fetch_json_path("object_definitions_localization.json")
static var path_global = _fetch_json_path("global_variables.json")


static func _fetch_json_path(filename: String) -> String:
	return json_path + Array(DirAccess.get_files_at(json_path)).filter(func(file: String) -> bool: return file.match(filename)).front()
