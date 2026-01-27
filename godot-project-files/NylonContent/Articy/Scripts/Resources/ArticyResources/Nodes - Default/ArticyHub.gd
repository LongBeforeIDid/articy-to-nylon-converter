@abstract
class_name ArticyHub extends ArticyResource
## Base class for generic Hub nodes from an Articy JSON export.
## Should not be used directly.

## Stores this hub's connections, in the format [output_target:output_target_pin]
var hub_targets: Dictionary[String,String]:
	get:
		var targets: Dictionary[String,String] = {}
		for connection in main_output_pin.connections:
			targets.get_or_add(connection.target, connection.target_pin)
		return targets
