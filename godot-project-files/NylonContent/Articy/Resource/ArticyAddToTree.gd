class_name ArticyAddToTree extends Resource
## A simple data container that holds the information the converter needs to
## add a single [NylonNode] to the heirarchy.[br][br]
##
## This is how you communicate with the converter. In your custom classes,
## override [method ArticyResource._add_main_nodes] to [method Array.append] 
## your own [ArticyAddToTree] commands into [member ArticyResource.aatt_array].[br][br]
##
## You should create these using [method ArticyResource.create_aatt] instead
## of [method ArticyAddToTree.new], because using the custom method will
## pre-populate the correct value for [member ar].

## Stores the [ArticyResource] that instantiated this [ArticyAddToTree.][br][br]
## If you create the resource via [ArticyResource.create_aatt], this value
## will be automatically populated.[br][br]
## Mostly used for debug logging.
var ar: ArticyResource

## The node that the converter will add to the scene tree. 
var node: Node

## The node's intended parent in the SceneTree.
##
## Will return [member ArticyNylonConverter.active_sequence] if not set.
var parent: NylonNode:
	get:
		return _get_parent()
	set(value):
		_parent = value
var _parent: NylonNode

## The name of the sequence that this node should target. Only relevant for
## [NylonChoice], [NylonGoToArticy], and derived classes that have the
## [code]target_sequence[/code] property.
##
## This should be equal to [member ArticyPin.id] for the pin this node targets.
var target_sequence_id


func _get_parent() -> NylonNode:
	if _parent:
		return _parent
	else:
		return ArticyNylonConverter.active_sequence
