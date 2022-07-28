extends Node

signal health_changed(new_health)
signal killed()

export var max_health := 6
onready var health := max_health setget _set_health

func _set_health(new_value: int) -> void:
	var prev_health := health
	health = int(clamp(new_value, 0, max_health))
	if health != prev_health:
		emit_signal("health_changed", health)
		if health == 0:
			emit_signal("killed")
