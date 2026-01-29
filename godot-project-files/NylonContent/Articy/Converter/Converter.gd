class_name ArticyNylonConverter extends ArticyDataLoader
## A helper node that converts JSON data from


## The NylonScene node root of the scene being processed.
static var active_scene_root: NylonScene


## Returns an array of all [NylonArticySequence] nodes
## that are owned by [member active_scene_root].
static var all_sequences: Array[NylonArticySequence]:
	get:
		return _get_all_sequences()

## The currently active sequence. Updates when a new sequence is created.
## New NylonNodes will be created as children of the active sequence.
static var active_sequence: NylonSequence

## A dictionary of NylonNodes 
## that have the 'target_sequence' property,
## storing the String ID 
## of the sequence they're meant to target.
static var goto_dict: Dictionary[NylonNode,String]

static var garbage_collector: Node

#region Core Logic

func _ready() -> void:
	
	await get_tree().process_frame
	ArticyLog.log_initialize()
	
	garbage_collector = Node.new()
	get_tree().root.add_child.call_deferred(garbage_collector)
	
	# Populate flow_dict 
	# by converting JSON objects into ArticyResources
	load_nodes_from_json()
	
	ArticyLog.log_all_scenes(_get_scene_array())
	# Iterate through every ArticyScene node in the export.
	for scene in _get_scene_array():
		ArticyLog.log_scene_start(scene)
		
		# Process the [ArticyScene] before anything else
		# in order to:
		# 1. Set the [NylonScene] root
		# 2. Add the first  [NylonSequence] child.
		_process_aatt_array(scene._generate_nylon())
		
		# Create an [Array] containing 
		# only nodes that are nested, according to the Articy Flow,
		# inside of the [AtricyScene] that's being processed.
		var ar_array = _get_ar_array_from_scene(scene)
		
		# Process each member of the [Array]
		# thereby building the scene of dialogue.
		if ar_array: for ar in ar_array:
			_process_aatt_array(ar._generate_nylon())
		
		
		# Once the Scene has been constructed
		# assign the appropriate target_sequence 
		# to any NylonGoToArticy or NylonChoice nodes.
		_process_goto_dict(goto_dict)
		
		# Removes any [NylonArticySequence] nodes 
		# that have only one child
		# if that child is a [GoToNylonSequence] node.
		
		_remove_unnecessary_sequences()
		
		_save_scene()


# Processes an array of [ArticyAddToTree] commands sequentially.
func _process_aatt_array(aatt_array: Array[ArticyAddToTree]):
	for aatt in aatt_array:
		_process_aatt(aatt)


## Adds [NylonNode]s to the [SceneTree] according to the contents of an 
## an [ArticyAddToTree].
##
## Calls [method ArticyResource._process_apr_array] on the same 
## [ArticyResource] once completed.
func _process_aatt(aatt: ArticyAddToTree):
	if not aatt: return
	if not aatt.node: return
	
	if aatt.node is NylonScene:
		get_tree().root.add_child.call_deferred(aatt.node)
		active_scene_root = aatt.node
	
	elif aatt.node is NylonArticySequence:
		set_parent_and_owner(aatt.node, active_scene_root)
		active_sequence = aatt.node
	
	else:
		set_parent_and_owner(aatt.node, aatt.parent)
		if aatt.target_sequence_id:
			goto_dict.get_or_add(aatt.node, aatt.target_sequence_id)


## After adding all nodes to SceneTree, set all
## [member NylonGoToArticy.target_sequence] values as needed.
func _process_goto_dict(dict: Dictionary[NylonNode,String]):
	
	for node in dict:
		if node and get_sequence_from_id(dict.get(node)):
			var target_id = dict.get(node)
			var target_sequence = get_sequence_from_id(target_id)
			
			target_sequence.incoming_nodes.append(node)
			node.target_sequence = target_sequence
			
			ArticyLog.log_target_sequence_assignment(node)
	return


## Eliminates any superfluous [NylonArticySequence] nodes from the scene,
## then assigns new target_node values to maintain the scene's structure.
## [br][br]
## Superfluous sequences those whose only child is a [NylonGoToArticy].
func _remove_unnecessary_sequences():
	
	var scene_has_unneccessary_sequences = true
	while scene_has_unneccessary_sequences:
		scene_has_unneccessary_sequences = false
		
	for sequence in all_sequences:
		if sequence.only_child_is_goto:
			if sequence.get_parent() == active_scene_root:
				scene_has_unneccessary_sequences = true
				sequence.cut_out_the_middleman()


## Packs [member active_scene_root]
## and all of it's descendants
## into a .tscn file and saves it
## to the directory specified in 
## res://NylonContent/Articy/Config/ArticyPathConfig.gd
func _save_scene():
	var scene = PackedScene.new()
	var error = scene.pack(active_scene_root)
	
	if error != OK:
		print("SCENE PACK ERROR: " + error_string(error))
		return
	
	var path = ArticyPathConfig.scene_path
	path = path + str(active_scene_root.name) +  ".tscn"
	
	error = ResourceSaver.save(scene, path)
	if error != OK:
		print("SCENE SAVE ERROR: " + error_string(error))
		return
	
	ArticyLog.log_scene_end(path)

#endregion


func set_parent_and_owner(node: Node, 
		parent: Node = active_sequence, 
		root: Node = active_scene_root):
	
	if parent:
		parent.add_child(node)
		node.owner = root


#region Getters

func get_sequence_from_id(seq_id: String) -> NylonSequence:
	for sequence in active_scene_root.get_children():
		if str(sequence.name) == seq_id:
			return sequence
	return


static func _get_scene_array() -> Array[ArticyScene]:
	var array: Array[ArticyScene] = []
	for key in flow_dict:
		if flow_dict.get(key) is ArticyScene:
			array.append(flow_dict.get(key))
	return array


static func _get_ar_array_from_scene(scene: ArticyScene) -> Array:
	var ar_array = []
	
	for key in flow_dict:
		var parent_id = flow_dict.get(key).parent
		
		while parent_id != "":
			if parent_id == scene.id:
				ar_array.append(flow_dict.get(key))
			if flow_dict.get(parent_id):
				parent_id = flow_dict.get(parent_id).parent
			else:
				parent_id = ""
	return ar_array


static func _get_all_sequences() -> Array[NylonArticySequence]:
	var sequences: Array[NylonArticySequence] = []
	for child in active_scene_root.get_children():
		if child is NylonArticySequence:
			if child.owner == active_scene_root:
				sequences.append(child)
	return sequences

#endregion
