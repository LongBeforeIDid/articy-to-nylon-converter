class_name ArticyResourceBase extends Resource

static var flow_dict: Dictionary[String,ArticyResource]:
	get:
		return ArticyData.flow_dict


static func ar_from_id(id: String) -> ArticyResource:
	if flow_dict:
		return flow_dict.get(id)
	return


static func ar_from_pin(pin: ArticyPin) -> ArticyResource:
	for key in flow_dict:
		var ar = ar_from_id(key)
		for p in ar.all_pins:
			if p.id == pin.id:
				return ar
	return
