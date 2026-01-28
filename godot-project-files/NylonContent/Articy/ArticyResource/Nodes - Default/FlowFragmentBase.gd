@abstract
class_name ArticyFlowFragmentBase extends ArticyResource


func _get_display_name() -> String:
	return ArticyDataLoader.localize(_get_property("DisplayName"))
