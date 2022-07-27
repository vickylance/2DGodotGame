extends KinematicBody2D
class_name Player

export(Resource) var moveData

var velocity := Vector2.ZERO

onready var animatedSprite := $AnimatedSprite

func _ready() -> void:
	animatedSprite.frames = load("res://PlayerGreenSkin.tres")

func _physics_process(delta: float) -> void:
	apply_gravity()
	var input_axis = Vector2.ZERO
	input_axis.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if input_axis.x == 0:
		apply_friction()
		animatedSprite.animation = "Idle"
	else:
		apply_acceleration(input_axis.x)
		animatedSprite.animation = "Run"
		animatedSprite.flip_h = input_axis.x > 0
	
	if is_on_floor():
		if Input.is_action_pressed("ui_up"):
			velocity.y = -moveData.jump_force
	else:
		animatedSprite.animation = "Jump"
		if Input.is_action_just_released("ui_up") and velocity.y < -moveData.jump_release_force:
			velocity.y = -moveData.jump_release_force
		if velocity.y > 0: # Celeste like fast fall
			velocity.y += moveData.additional_fall_gravity
	
	var was_in_air = not is_on_floor()
	velocity = move_and_slide(velocity, Vector2.UP)
	var just_landed = is_on_floor() and was_in_air
	if just_landed:
		animatedSprite.animation = "Run"
		animatedSprite.frame = 1 # To make sure that the first animation frame played on just hitting the floor is frame 2
	pass

func apply_gravity():
	velocity.y += moveData.gravity
	velocity.y = min(velocity.y, 200)
	pass

func apply_friction():
	velocity.x = move_toward(velocity.x, 0, moveData.friction)
	pass

func apply_acceleration(direction):
	velocity.x = move_toward(velocity.x, moveData.max_speed * direction, moveData.acceleration)
	pass
