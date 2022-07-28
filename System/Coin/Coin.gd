extends Area2D
class_name Coin

func _on_Coin_body_entered(body: Node) -> void:
	if body is Player:
		Score.coins_collected += 1
		queue_free()
