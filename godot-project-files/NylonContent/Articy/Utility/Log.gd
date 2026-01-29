class_name ArticyLog extends ArticyDataLoader

static var verbose_log: bool = false


static func log_initialize():
	print()
	print("Initiating Articy.json to Nylon.tscn conversion.")
	print()


static func log_all_scenes(scene_array: Array[ArticyScene]):
	if scene_array:
		print('Successfully located objects with Type: "Scene" in *_objects.json.')
		print()
		print("Scenes to process:")
		for scene in scene_array:
			print('->"' + scene.display_name +'"')
		print()
		print("All scenes loaded. Initiate processing.")
		print()
	else:
		print('FATAL ERROR: No objects with Type: "Scene" found in *_objects.json.')


static func log_scene_start(ar: ArticyScene):
	print('Begin processing new scene: ' + '"' + ar.display_name + '".')
	print()
	print('Scene "' + ar.display_name + '" contains the following ArticyResources:')
	print()

static func log_scene_end(path: String):
	var scene_name = str(ArticyNylonConverter.active_scene_root.name)
	print('Successfully processed scene: "' + scene_name + '".')
	print("and saved to path: " + path)
	print()

static func log_ar_properties(ar: ArticyResource):
	if not ar:
		return
	if ar.id:
		print("ID:   " + str(ar.id))
	if ar.type: 
		print("Type: " + str(ar.type))
	if verbose_log:
		if ar.technical_name: 
			print("Technical Name: " + str(ar.technical_name))
		if ar.display_name:
			print("display_name:   " + str(ar.display_name))
		if ar.text:
			print("text:           " + str(ar.text))
		if ar.active_IO:
			match ar.active_IO:
				ArticyResource.IO.INPUT:
					print("active_IO:      INPUT")
				ArticyResource.IO.OUTPUT:
					print("active_IO:      OUTPUT")
		print()
		if ar.active_target:
			print("active_pin_id:             " + str(ar.active_pin.id))
			print("active_target_id:          " + str(ar.active_target.id))
			print("active_target_pin_id:      " + str(ar.active_target_pin.id))
		if ar.main_input_target:
			print("main_input_pin_id:         " + str(ar.main_input_pin.id))
			print("main_input_target_id:      " + str(ar.main_input_target.id))
			print("main_input_target_pin_id:  " + str(ar.main_input_target_pin.id))
		if ar.main_output_target:
			print("main_output_pin_id:        " + str(ar.main_output_pin.id))
			print("main_output_target_id:     " + str(ar.main_output_target.id))
			print("main_output_target_pin_id: " + str(ar.main_output_target_pin.id))
	print()


static func log_target_sequence_assignment(node: NylonNode):
	var goto_name = ArticyParser.get_goto_name(node)
	
	print("Set target_sequence for: " + goto_name)
	print("NylonSequence to target: " + str(node.target_sequence.name))
	print()


static func log_sequence_reassignment(
		goto_node: NylonNode,
		caller: NylonArticySequence,
		old_target_sequence: NylonArticySequence, 
		new_target_sequence: NylonArticySequence):
	
	var goto_name: String = ArticyParser.get_goto_name(goto_node)
	
	if goto_node.target_sequence.name != new_target_sequence.name:
		print("Error: target_sequence reassignment failed.")
	elif  old_target_sequence.name ==  new_target_sequence.name:
		print("Error: new sequence assignment is the same as the old one.")
	else:
		print("Successfully updated target_sequence for goto: " + goto_name)
	
	print("old_target_sequence: " + str(old_target_sequence.name))
	if caller != old_target_sequence:
		print("Error: Old target_sequence is not responsible for reassignment.")
	
	print("new_target_sequence: " + str(new_target_sequence.name))
	
	if verbose_log:
		print("Updated new_target_sequence.incoming_nodes:")
		for goto in new_target_sequence.incoming_nodes:
			if goto:
				print(ArticyParser.get_goto_name(goto))
	
	print()


static func error_childless_sequence(node: NylonSequence):
	print("Error: Childless Sequence.")
	print("Sequence Name: " + str(node.name))
	print("Sequence Nylon ID: " + str(node.node_id))
	print()
