extends KinematicBody2D

var direction := Vector2.RIGHT
var velocity := Vector2.ZERO

onready var ledgeCheckLeft := $LedgeCheckLeft as RayCast2D
onready var ledgeCheckRight := $LedgeCheckRight as RayCast2D
onready var sprite := $AnimatedSprite as AnimatedSprite

func _physics_process(delta: float) -> void:
	var found_wall := is_on_wall()
	var found_ledge = not ledgeCheckRight.is_colliding() or not ledgeCheckLeft.is_colliding()
	if found_wall or found_ledge:
		direction *= -1
	
	sprite.flip_h = direction.x > 0
	
	velocity = direction * 25
	move_and_slide(velocity, Vector2.UP)
	pass
