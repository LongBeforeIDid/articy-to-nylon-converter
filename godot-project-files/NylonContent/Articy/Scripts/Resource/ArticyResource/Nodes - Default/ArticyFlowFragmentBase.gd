@abstract
class_name ArticyFlowFragmentBase extends ArticyResource


func _get_display_name() -> String:
	return ArticyData.localize(_get_property("DisplayName"))
