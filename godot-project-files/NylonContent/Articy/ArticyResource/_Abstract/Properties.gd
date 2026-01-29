class_name ArticyResourceBaseProperties extends ArticyResourceBase
## A base class of [ArticyResource] containing 


## A [Dictionary] of [member ArticyResourceBaseProperties.id] 
## keys storing the corresponding [ArticyResource] for the entire 
## Flow of an Articy project.
static var flow_dict: Dictionary[String,ArticyResource]:
	get:
		return ArticyDataLoader.flow_dict

## The [Dictionary] that is assigned to this [ArticyResource] from the
## [code]*_objects.json[/code] file at [member ArticyPathConfig.path_pack].
var _ar_dict: Dictionary

## The node's type. This will be a template name if the node has one.
var type: String:
	get:
		if _ar_dict: return _ar_dict.get("Type")
		return "EMPTY"

## An array containing all of the node's properties
var properties: Dictionary:
	get:
		if _ar_dict: return _ar_dict.get("Properties")
		return {}

## The human-readable, modifiable identifier for this Articy node
var technical_name: String:
	get:
		return _get_property("TechnicalName")

## The auto-generated, unmodifyable identifier for this Articy node
var id: String:
	get:
		return _get_property("Id")

## The id for this node's parent within the Articy Flow.
var parent: String:
	get:
		return _get_property("Parent")

## The (localized) main text of the node.
var text: String:
	get:
		return ArticyDataLoader.localize(_get_property("Text"))

# Internal version of display_name without type hint, for _get_display_name override.
# Override is used by ArticyResources that need to localize the returned [String]. 
var _display_name: get = _get_display_name

## The non-unique, descriptive name for this Articy Node
var display_name: String:
	get:
		return _display_name

## This is just a more descriptive way to write [code]flow_dict.get(id)[/code]
static func ar_from_id(ar_id: String) -> ArticyResource:
	if flow_dict:
		return flow_dict.get(ar_id)
	return


func _get_property(property: String, expected_return: String = "String") -> Variant:
	if properties.get(property):
		return properties.get(property)
	match expected_return:
		"String":
			return ""
		"Array":
			return []
		"Dictionary":
			return {}
	return

# See above
func _get_display_name() -> String:
	return _get_property("DisplayName")
