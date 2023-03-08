@icon("res://addons/joystick/joystick.svg")
extends TouchScreenButton
class_name Joystick


@export var inner_icon : Sprite2D
@onready var inner_joy : Sprite2D = inner_icon if inner_icon else $inner

var direction : Vector2 = Vector2(0,0)
var strength : float = 0.0
var was_pressed : bool = false

@onready var radius = shape.radius
@onready var width := self.texture_normal.get_width()/2
@onready var height := self.texture_normal.get_height()/2

signal joystick_input
signal joystick_released

func _ready():
	inner_joy.position = Vector2(width,height)

func _input(event):
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		if is_pressed():
			strength = event.position.distance_to(global_position+Vector2(width,height))
			strength = smoothstep(0,radius,strength)
			direction = event.position.direction_to(global_position+Vector2(width,height))
			emit_signal("joystick_input", strength, direction)
			inner_joy.global_position = clamp_to_circle(global_position+Vector2(width,height), radius, event.position)

	if event is InputEventScreenTouch and event.pressed == false:
		inner_joy.global_position = global_position + Vector2(width,height)
		emit_signal("joystick_released")

func clamp_to_circle(point: Vector2, radius: float, value: Vector2) -> Vector2:
	var direction = value - point
	if direction.length_squared() > radius * radius:
		direction = direction.normalized() * radius
	return point + direction
