extends Control

onready var multiplayer_config_ui := $MultiplayerConfigure as Control
onready var server_ip_address := $MultiplayerConfigure/VBoxContainer/ServerIpAddress as LineEdit
onready var device_ip_address := $CanvasLayer/DeviceIpAddress as Label

func _ready() -> void:
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_to_server")
	
	device_ip_address.text = Network.ip_address

func _player_connected(id: int) -> void:
	print("Player " + str(id) + " has connected")

func _player_disconnected(id: int) -> void:
	print("Player " + str(id) + " has disconnected")

func _connected_to_server() -> void:
	pass


func _on_CreateServer_pressed() -> void:
	multiplayer_config_ui.hide()
	Network.create_server()


func _on_JoinServer_pressed() -> void:
	if server_ip_address.text != "":
		multiplayer_config_ui.hide()
		Network.ip_address = server_ip_address.text
		Network.join_server()
