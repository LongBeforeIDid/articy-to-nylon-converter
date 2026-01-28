@tool
class_name NylonConditionalGoToSequence extends NylonGoToSequence
## Custom node that initiates a sequence only if its conditions are met.
##
## Remember that NylonSequences will nest. This means that:
## IF there are multiple GoToSequences in a row with satisfied requirements
## THEN all sequences will play, consecutively, which you probably don't want.

@export var required_traits: Dictionary[String, bool]

@export var condition: NylonCondition

# Overrides NylonGoToSequence.
func _run() -> void:
	send_debug_message(get_custom_name())
	
	if condition.is_true(scene):
		_complete([target_sequence])
	_complete([])
	return
