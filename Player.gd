extends KinematicBody2D

var velocity := Vector2.ZERO

func _physics_process(delta: float) -> void:
	velocity.y += 8
	if Input.is_action_pressed("ui_left"):
		velocity.x = -50
	elif Input.is_action_pressed("ui_right"):
		velocity.x = 50
	else:
		velocity.x = 0
	
	if Input.is_action_just_pressed("ui_up"):
		velocity.y = -150
	velocity = move_and_slide(velocity)
	pass
