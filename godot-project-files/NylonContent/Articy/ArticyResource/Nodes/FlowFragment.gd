class_name ArticyFlowFragment extends ArticyResource


func _add_main_nodes():
	super()


func _get_display_name() -> String:
	return ArticyDataLoader.localize(_get_property("DisplayName"))
