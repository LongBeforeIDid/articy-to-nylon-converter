@tool
class_name NylonArticySequence extends NylonSequence

var incoming_nodes: Array[NylonNode]

var only_child_is_goto: bool:
	get:
		return _get_only_child_is_goto()


## Removes this Sequence from the SceneTree if it's superfluous.
## Superfluous sequences those whose only child is a [NylonGoToSequence].
func cut_out_the_middleman():
	if  not only_child_is_goto:
		return
	
	for node in incoming_nodes:
		if not node:
			return
		
		var old_target_sequence = node.target_sequence
		var new_target_sequence = get_child(0).target_sequence
		
		node.target_sequence = new_target_sequence
		new_target_sequence.incoming_nodes.append(node)
		
		ArticyLog.log_sequence_reassignment(
			node, 
			self,  
			old_target_sequence, 
			new_target_sequence)
	owner = null
	queue_free()


func _get_only_child_is_goto() -> bool:
	if get_child_count() == 1:
		var only_child = get_child(0)
		if only_child is NylonGoToSequence:
			return true
		else:
			return false
	elif get_child_count() == 1:
		ArticyLog.error_childless_sequence(self)
		return false
	else:
		return false
