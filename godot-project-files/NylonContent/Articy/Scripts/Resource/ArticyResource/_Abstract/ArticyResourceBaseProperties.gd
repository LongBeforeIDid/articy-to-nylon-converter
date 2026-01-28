class_name ArticyResourceBaseProperties extends ArticyResourceBase

## Assigned first
var _ar_dict: Dictionary

## The node's type. This will be a template name, if it has one
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
		return ArticyData.localize(_get_property("Text"))

## Internal version of display_name without type hint, for _get_display_name override.
## Override is used by ArticyResources that need to localize the returned [String].
## 
var _display_name: get = _get_display_name

## The non-unique, descriptive name for this Articy Node
var display_name: String:
	get:
		return _display_name


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


func _get_display_name() -> String:
	return _get_property("DisplayName")
