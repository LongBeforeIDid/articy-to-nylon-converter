class_name ArticyLog extends ArticyDataLoader

static var verbose_log: bool = true


static func log_ar_properties(ar: ArticyResource):
	if not ar:
		return
	print("--------ArticyResource " + str(ar.id) + "---------")
	print("Type: " + str(ar.type))
	print("Technical Name: " + str(ar.technical_name))
	print("display_name: " + str(ar.display_name))
	print("text: " + ar.text)
	print("Sources: " + str(ar.sources))
	print("active_IO: " + str(ar.active_IO))
	print()
	if ar.active_target:
		print("active_pin_id: " + str(ar.active_pin.id))
		print("active_target_id: " + str(ar.active_target.id))
		print("active_target_pin_id: " + str(ar.active_target_pin.id))
	if ar.main_input_target:
		print("main_input_pin_id: " + str(ar.main_input_pin.id))
		print("main_input_target_id: " + str(ar.main_input_target.id))
		print("main_input_target_pin_id: " + str(ar.main_input_target_pin.id))
	if ar.main_output_target:
		print("main_output_pin_id: " + str(ar.main_output_pin.id))
		print("main_output_target_id: " + str(ar.main_output_target.id))
		print("main_output_target_pin_id: " + str(ar.main_output_target_pin.id))
	print("------------END-------------")
	print()


static func log_target_sequence_assignment(node: NylonNode):
	print("Setting target_sequence for NylonNode: " + str(node.node_id))
	print("NylonSequence targeted: " + str(node.target_sequence))
	print()


static func log_sequence_reassignment(
		goto_node: NylonNode,
		caller: NylonArticySequence,
		old_target_sequence: NylonArticySequence, 
		new_target_sequence: NylonArticySequence):
	
	var goto_name: String = ArticyParser.get_goto_name(goto_node)
	print("Reassigning target_sequence for goto: " + goto_name)
	
	print("new_target_sequence: " + str(old_target_sequence.name))
	if caller != old_target_sequence:
		print("Error: Old target_sequence is not responsible for reassignment.")
	
	print("new_target_sequence: " + str(new_target_sequence.name))
	if goto_node.target_sequence.name != new_target_sequence.name:
		print("Error: target_sequence reassignment failed.")
	
	print("Updated new_target_sequence.incoming_nodes:")
	for goto in new_target_sequence.incoming_nodes:
		print(ArticyParser.get_goto_name(goto))
	
	print()


static func error_childless_sequence(node: NylonSequence):
	print("Error: Childless Sequence.")
	print("Sequence Name: " + str(node.name))
	print("Sequence Nylon ID: " + str(node.node_id))
	print()
