class_name ArticyContainer extends ArticyFlowFragmentBase
## Holds all the relevant data for a Container from an Articy JSON export

var container_type: IO

func _process_incoming():
	for pin in input_pins:
		for aatt in pin.create_aatt_array(true):
			aatt_array.append(aatt)
	for pin in output_pins:
		for aatt in pin.create_aatt_array(true):
			aatt_array.append(aatt)


# Containers don't have any main content to process, so the base function
# should be overriden to prevent generating an unnecessary NylonSequence.
func _process_main():
	pass


# Similar to above, ArticyPin handles the outgoing connections for Containers.
func _process_outgoing():
	pass
