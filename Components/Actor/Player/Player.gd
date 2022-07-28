extends KinematicBody2D
class_name Player

enum {
	MOVE,
	CLIMB,
}

export(Resource) var moveData
export(Resource) var skin

var velocity := Vector2.ZERO
var state := MOVE

onready var animatedSprite := $AnimatedSprite as AnimatedSprite
onready var ladder_check := $LaddderCheck as RayCast2D


func _ready() -> void:
	animatedSprite.frames = skin


func _physics_process(_delta: float) -> void:
	var input_axis := Vector2.ZERO
	input_axis.x = Input.get_axis("ui_left", "ui_right")
	input_axis.y = Input.get_axis("ui_up", "ui_down")

	match state:
		MOVE:
			move_state(input_axis)
		CLIMB:
			climb_state(input_axis)


func move_state(input_axis: Vector2) -> void:
	if is_on_ladder() and Input.is_action_pressed("ui_up"):
		state = CLIMB

	apply_gravity()
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
		if velocity.y > 0:  # Celeste like fast fall
			velocity.y += moveData.additional_fall_gravity

	var was_in_air = not is_on_floor()
	velocity = move_and_slide(velocity, Vector2.UP)
	var just_landed = is_on_floor() and was_in_air
	if just_landed:
		animatedSprite.animation = "Run"
		animatedSprite.frame = 1  # To make sure that the first animation frame played on just hitting the floor is frame 2
	pass


func climb_state(input_axis: Vector2) -> void:
	if not is_on_ladder():
		state = MOVE

	if input_axis.length() != 0:
		animatedSprite.animation = "Run"
	else:
		animatedSprite.animation = "Idle"
	velocity = input_axis * 50
	velocity = move_and_slide(velocity, Vector2.UP)
	pass


func is_on_ladder():
	if not ladder_check.is_colliding():
		return false
	var collider := ladder_check.get_collider()
	if not collider is Ladder:
		return false
	return true


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


func take_damage(dmg_value):
	pass
