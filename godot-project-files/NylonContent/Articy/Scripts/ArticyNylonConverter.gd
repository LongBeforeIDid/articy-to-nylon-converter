class_name ArticyNylonConverter extends ArticyData
## A helper node that is used to convert Articy JSON exports into NylonSceneNodes.
## "Articy node" refers generically to any dictionary contained within Objects[]

## Enables verbose debug logging.
static var verbose_log: bool = true

## The NylonScene node root of the scene being processed
static var active_scene_root: NylonScene

## The ID of the active_scene_root's associated ArticyResource
static var active_scene_id: String

## The currently active sequence. Updates when a new sequence is created.
## New NylonNodes will be created as children of the active sequence.
static var active_sequence: NylonSequence
static var active_sequence_id: String:
	get:
		return str(active_sequence.name)

## A dictionary of NylonNodes that have the 'target_sequence' property,
## storing the name/ID of their associated sequence.
static var goto_dict: Dictionary[NylonNode,String]


func _ready() -> void:
	# Populate articy_resources by converting JSON objects into ArticyResources
	load_nodes_from_json()
	
	# Finds the starting node of the dialogue scene, initiates parsing
	for id in articy_resources:
		if articy_resources.get(id) is ArticyScene:
			_process_aatt_array(articy_resources.get(id)._generate_nylon())
			_process_goto_dict(goto_dict)
			_save_scene()


#region Utility Functions

## Creates a new NylonSequence, names it, adds it to the tree, and returns it.
func create_sequence(sequence_id: String) -> NylonSequence:
	var sequence: NylonSequence = NylonSequence.new()
	sequence.name = sequence_id
	set_parent_and_owner(sequence, active_scene_root)
	return sequence


## Returns a NylonSequence from the SceneTree, if it exists.
func sequence_already_exists(sequence_id: String) -> NylonSequence:
	for child in active_scene_root.get_children():
		if String(child.name) == sequence_id:
			if child is NylonSequence:
				return child
	return


## Adds a new NylonNode to the specified location in the SceneTree.
func set_parent_and_owner(n: Node, parent: Node = active_sequence, root: Node = active_scene_root):
	parent.add_child(n)
	n.owner = root

#endregion


#region Main Logic

## Process an array of ArticyAddToTree commands sequentially.
## Is called by _process_apr().
func _process_aatt_array(aatt_array: Array[ArticyAddToTree]):
	for aatt in aatt_array:
		_process_aatt(aatt)


## Process an ArticyAddToTree command, adding NylonNodes to the scene tree.
## Calls _process_apr_array() on the same ArticyResource once completed.
func _process_aatt(aatt: ArticyAddToTree):
	ArticyDebug.log_aatt_properties(aatt)

	match aatt.type:
		# Add to the same sequence as the previous node.
		ArticyResource.AattTypes.IBID:
			set_parent_and_owner(aatt.node)
		
		# Same as ibid, but save instructions to set target_sequence later
		ArticyResource.AattTypes.GOTO:
			set_parent_and_owner(aatt.node)
			goto_dict.get_or_add(aatt.node, aatt.sequence_id)
		
		# Add as a child of the (NylonScene node) scene root
		ArticyResource.AattTypes.ROOT:
			set_parent_and_owner(aatt.node, active_scene_root)
		
		# Add node directly as child of SceneTree
		ArticyResource.AattTypes.TREE:
			get_tree().root.add_child.call_deferred(aatt.node)
			active_scene_root = aatt.node
		
		# Don't add a node.
		ArticyResource.AattTypes.NONE:
			pass
	
	# Once the last node from aatt has been added to the tree,
	# begin determining the next ar to process.
	if aatt.finished: 
		_process_apr_array(aatt.ar._generate_process_requests())


## Process an array of ArticyProcessRequest commands sequentially.
func _process_apr_array(apr_array: Array[ArticyProcessRequest]):
	for apr in apr_array:
		_process_apr(apr)


## Process an ArticyAddToTree command, determining the next ArticyResource.
## Calls _process_aatt() on the new ArticyResource once completed.
func _process_apr(apr: ArticyProcessRequest):
	ArticyDebug.log_arp_properties(apr)
	
	# Saftey check
	if not apr:
		return
	if not apr.target_ar:
		return
	
	# Handle sequence generation/duplication
	if apr.target_ar.generates_sequence:
		var sequence_name = apr.target_ar.id
		
		# Give unique name to the sequences representing each pin on a container
		if apr.target_ar is ArticyContainer:
			sequence_name = sequence_name + "_" + apr.target_ar.get_pin_suffix(apr.target_pin)
		
		# Abort process if sequence exists, otherwise create and activate new sequence.
		if sequence_already_exists(apr.target_ar.id): return
		active_sequence = create_sequence(sequence_name)
	
	# Handle containers seperately, to account for multiple possible connecting pins
	if _handle_container(apr):
		return
	# Start adding more nodes to the tree.
	_process_aatt_array(apr.target_ar._generate_nylon())


## Called by _process_apr(). Used to call generate_container("pin_type")
## instead of _process_nylon() to handle ArticyContainer's specific pin. 
func _handle_container(apr: ArticyProcessRequest) -> bool:
	if apr.target_ar is ArticyContainer:
			if apr.container_type == ArticyProcessRequest.ContainerTypes.INPUT:
				_process_aatt_array(apr.target_ar.generate_container("input"))
				return true
			elif apr.container_type == ArticyProcessRequest.ContainerTypes.OUTPUT:
				_process_aatt_array(apr.target_ar.generate_container("output"))
				return true
	return false


## After adding all nodes to SceneTree, set target_sequence values.
func _process_goto_dict(dict: Dictionary[NylonNode,String]):
	for node in dict:
		print("found a goto " + str(dict.get(node)))
		node.target_sequence = sequence_already_exists(dict.get(node))


## Packs the currently active scene root into a .tscn file and saves it to
## the path specified in res://NylonContent/Articy/Config/PathConfig.gd
func _save_scene():
	var scene = PackedScene.new()
	scene.pack(active_scene_root)
	ResourceSaver.save(scene, PathConfig.scene_path + String(active_scene_root.name) + ".tscn")

#endregion
