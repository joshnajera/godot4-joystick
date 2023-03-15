extends CharacterBody2D


const SPEED = 300.0
const TURN_SENSITIVITY = 2
var direction : Vector2 = Vector2(0,0)


func _physics_process(delta):
	if direction:
		velocity.x = direction.x * SPEED
		velocity.y = direction.y * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
	move_and_slide()


func _on_joystick_joystick_input(strength, dir, delta):
	direction = dir

func _on_joystick_2_joystick_input(strength, dir, delta):
	rotation = rotation + (dir.x)*delta*TURN_SENSITIVITY

