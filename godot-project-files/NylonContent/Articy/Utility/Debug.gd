class_name ArticyDebug extends ArticyDataLoader

static var verbose_log: bool = true


static func log_ar_properties(ar: ArticyResource):
	if ar:
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
