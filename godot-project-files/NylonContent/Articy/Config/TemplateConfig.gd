class_name ArticyTemplateConfig extends Articy


static func articy_resource_from_template(template_name: String) -> ArticyResource:
	var ar: ArticyResource
	match template_name:
		
		# ~Default Nodes~
		"DialogueFragment":
			ar = ArticyDialogueFragment.new()
		"FlowFragment":
			ar = ArticyFlowFragment.new()
		"Instruction":
			ar = ArticyInstruction.new()
		"Condition":
			ar = ArticyCondition.new()
		"Hub":
			ar = ArticyHub.new()
		"Dialogue":
			ar = ArticyScene.new()
		_:
			ar = ArticyResource.new()
	
	return ar
