class_name ArticyProcessRequest extends Resource

enum ContainerTypes {NONE, INPUT, OUTPUT}

var container_type: ContainerTypes = ContainerTypes.NONE

var target_ar: ArticyResource

var target_pin: ArticyPin

var sequence_id: String
