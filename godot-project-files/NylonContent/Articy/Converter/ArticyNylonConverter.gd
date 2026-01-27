class_name ArticyNylonConverter extends ArticyData
## A helper node that is used to convert Articy JSON exports into NylonSceneNodes.
## "Articy node" refers generically to any dictionary contained within Objects[]

## Enables verbose debug logging.
static var verbose_log: bool = true

## The NylonScene node root of the scene being processed
static var active_scene_root: NylonScene

## The currently active sequence. Updates when a new sequence is created.
## New NylonNodes will be created as children of the active sequence.
static var active_sequence: NylonSequence

## A dictionary of NylonNodes that have the 'target_sequence' property,
## storing the name/ID of their associated sequence.
static var goto_dict: Dictionary[NylonNode,String]


#region Core Logic

func _ready() -> void:
	# Populate flow_dict by converting JSON objects into ArticyResources
	load_nodes_from_json()
	
	for scene in _get_scene_array():
		_process_aatt_array(scene._generate_nylon())
		
		var ar_array = _get_ar_array_from_scene(scene)
		for ar in ar_array:
			_process_aatt_array(ar._generate_nylon())
		
		_process_goto_dict(goto_dict)
		
		_save_scene()


## Process an array of [ArticyAddToTree] commands sequentially.
## Is called by _process_apr().
func _process_aatt_array(aatt_array: Array[ArticyAddToTree]):
	for aatt in aatt_array:
		_process_aatt(aatt)


## Adds [NylonNode]s to the [SceneTree] according to the contents of an 
## an [ArticyAddToTree].
##
## Calls [method ArticyResource._process_apr_array] on the same 
## [ArticyResource] once completed.
func _process_aatt(aatt: ArticyAddToTree):
	ArticyDebug.log_aatt_properties(aatt)
	if not aatt.node:
		return
	
	if aatt.node is NylonScene:
		get_tree().root.add_child.call_deferred(aatt.node)
		active_scene_root = aatt.node
	elif aatt.node is NylonSequence:
		set_parent_and_owner(aatt.node, active_scene_root)
		active_sequence = aatt.node
	else:
		set_parent_and_owner(aatt.node)
		if aatt.target_sequence_id:
			goto_dict.get_or_add(aatt.node, aatt.target_sequence_id)


## After adding all nodes to SceneTree, set all
## [member NylonGoToSequence.target_sequence] values as needed.
func _process_goto_dict(dict: Dictionary[NylonNode,String]):
	for node in dict:
		node.target_sequence = get_sequence_from_id(dict.get(node))
			


## Packs [member active_scene_root] and all of it's descendants 
## into a .tscn file, saving it to the directory specified in 
## res://NylonContent/Articy/Config/PathConfig.gd
func _save_scene():
	var scene = PackedScene.new()
	scene.pack(active_scene_root)
	ResourceSaver.save(scene, PathConfig.scene_path + String(active_scene_root.name) + ".tscn")

#endregion

func set_parent_and_owner(node: Node, parent: Node = active_sequence, root: Node = active_scene_root):
	print(active_scene_root)
	if parent:
		parent.add_child(node)
		node.owner = root

#region Getters

func get_sequence_from_id(seq_id: String) -> NylonSequence:
	for sequence in active_scene_root.get_children():
		if str(sequence.name) == seq_id:
			return sequence
	return


static func _get_scene_array() -> Array:
	var array = []
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

#endregion
