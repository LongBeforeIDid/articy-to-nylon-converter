class_name ArticyConnection extends Resource

var label: String
var target_pin_id: String
var target: String

var target_pin: ArticyPin:
	get:
		return ArticyResource.pin_dict.get(target_pin_id)

var target_ar: ArticyResource:
	get:
		return ArticyResource.flow_dict.get(target)
