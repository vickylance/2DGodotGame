extends Node

const DEFAULT_PORT := 28960
const MAX_CLIENTS := 6

var server: NetworkedMultiplayerENet = null
var client: NetworkedMultiplayerENet = null

var ip_address := ""


func _ready() -> void:
	if OS.get_name() == "Windows":
		ip_address = IP.get_local_addresses()[3]
	elif OS.get_name() == "Android":
		ip_address = IP.get_local_addresses()[0]
	else:
		ip_address = IP.get_local_addresses()[3]
	
	for ip in IP.get_local_addresses():
		if ip.begins_with("192.168."):
			ip_address = ip
	
	assert(get_tree().connect("connected_to_server", self, "_connected_to_server") == OK)
	assert(get_tree().connect("server_disconnected", self, "_server_disconnected") == OK)


func create_server() -> void:
	server = NetworkedMultiplayerENet.new()
	assert(server.create_server(DEFAULT_PORT, MAX_CLIENTS) == OK)
	get_tree().set_network_peer(server)

func join_server() -> void:
	client = NetworkedMultiplayerENet.new()
	assert(client.create_client(ip_address, DEFAULT_PORT) == OK)
	get_tree().set_network_peer(client)

func _connected_to_server():
	print("Successfully connected to server")


func _server_disconnected():
	print("Disconnected from the server")

