@abstract
class_name ArticyFlowFragmentBase extends ArticyResource


func _get_display_name() -> String:
	return ArticyData.localize(get_property("DisplayName"))
