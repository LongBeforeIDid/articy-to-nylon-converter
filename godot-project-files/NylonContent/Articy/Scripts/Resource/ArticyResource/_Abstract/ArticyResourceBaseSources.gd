class_name ArticyResourceBaseSources extends ArticyResourceBasePins

## A dictionary of ar.id keys that contains every other ArticyResource 
## that targets this ArticyResource.
var sources: Dictionary[String,ArticyResource]:
	get:
		return _get_sources()


func _get_sources() -> Dictionary[String, ArticyResource]:
	var sources_to_return: Dictionary[String, ArticyResource] = {}
	for id in flow_dict:
		var ar: ArticyResource = ar_from_id(id)
		for pin in ar.all_pins:
			for connection in pin.connections:
				if connection.target == self.id:
					sources_to_return.get_or_add(ar.id, ar)
	return sources_to_return
