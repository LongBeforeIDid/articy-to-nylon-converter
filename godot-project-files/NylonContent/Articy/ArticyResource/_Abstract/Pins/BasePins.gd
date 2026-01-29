class_name ArticyResourceBasePins extends ArticyResourceBaseProperties

## Key: [member ArticyPin.id], Value: [ArticyPin].
static var pin_dict: Dictionary[String,ArticyPin]

var active_IO: IO = IO.OUTPUT

enum IO {INPUT, OUTPUT}

func _get_pins(pins_type: String) -> Array[ArticyPin]:
	var pins: Array[ArticyPin]
	
	if properties.get(pins_type):
		for pin in properties.get(pins_type):
			pins.append(_get_pin(pin, pins_type))
	return pins


func _get_pin(pin: Dictionary, pin_type: String) -> ArticyPin:
	var new_pin = ArticyPin.new()
	var connections: Array[ArticyConnection]
	
	if pin.get("Connections"):
		for connection in pin.get("Connections"):
			connections.append(_get_connection(connection))
	
	if pin_type == "InputPins": new_pin.io_type = IO.INPUT
	if pin_type == "OutputPins": new_pin.io_type = IO.OUTPUT
	
	new_pin.text = pin.get("Text")
	new_pin.id = pin.get("Id")
	new_pin.owner_id = pin.get("Owner")
	new_pin.connections = connections
	if new_pin.id == "0x0100000000000956":
		print("processing pin:")
		print(new_pin)
		pass
	pin_dict.get_or_add(new_pin.id, new_pin)
	return new_pin


func _get_connection(connection: Dictionary) -> ArticyConnection:
	var new_connection = ArticyConnection.new()
	
	new_connection.label = connection.get("Label")
	new_connection.target_pin_id = connection.get("TargetPin")
	new_connection.target = connection.get("Target")
	
	return new_connection


func _get_incoming():
	var incoming_pins: Dictionary
	for pin_id in pin_dict:
		var pin = pin_dict.get_or_add(pin_id)
		var pin_is_connected = false
		
		for connection in pin.connections:
			if connection.target_pin_id == id:
				pin_is_connected = true
		
		if pin_is_connected:
			incoming_pins.get_or_add(pin)
