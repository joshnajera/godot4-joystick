@tool
@icon("res://addons/joystick/joystick.svg")
extends TouchScreenButton


@export_range(0.0,1.0) var inner_opacity : float = 0.9
@export_range(0.0,1.0) var outer_opacity : float = 0.5


var direction : Vector2 = Vector2(0,0)
var strength : float = 0.0
var was_pressed : bool = false

@onready var radius = shape.radius
@onready var half_width := self.texture_normal.get_width()/2
@onready var half_height := self.texture_normal.get_height()/2
@onready var inner_joystick_image = $inner


signal joystick_input
signal joystick_released

func _ready():
	inner_joystick_image.position = Vector2(half_width,half_height)
	self_modulate = Color(1,1,1,outer_opacity)	
	$inner.modulate = Color(1,1,1,inner_opacity)
	$inner.position = Vector2(half_width,half_height)


func _input(event):
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		if is_pressed():
			strength = event.position.distance_to(global_position+Vector2(half_width,half_height))
			strength = smoothstep(0,radius,strength)
			direction = event.position.direction_to(global_position+Vector2(half_width,half_height))
			emit_signal("joystick_input", strength, direction)
			inner_joystick_image.global_position = clamp_to_circle(global_position+Vector2(half_width,half_height), radius, event.position)

	if event is InputEventScreenTouch and event.pressed == false:
		inner_joystick_image.global_position = global_position + Vector2(half_width,half_height)
		emit_signal("joystick_released")

func clamp_to_circle(point: Vector2, radius: float, value: Vector2) -> Vector2:
	var direction = value - point
	if direction.length_squared() > radius * radius:
		direction = direction.normalized() * radius
	return point + direction
