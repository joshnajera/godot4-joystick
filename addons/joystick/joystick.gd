@tool
extends TouchScreenButton

@export_range(0.0,1.0) var inner_opacity : float = 0.9
@export_range(0.0,1.0) var outer_opacity : float = 0.5

var direction : Vector2 = Vector2(0,0)
var strength : float = 0.0
var was_pressed : bool = false
var button_index : int = -1
var held : bool = false

@onready var half_width := self.texture_normal.get_width()/2
@onready var half_height := self.texture_normal.get_height()/2
@onready var inner_joystick_image : Sprite2D = $inner
@onready var radius :float = 75.0


signal joystick_input
signal joystick_released

func _ready():
	inner_joystick_image.position = Vector2(half_width,half_height)
	self_modulate = Color(1,1,1,outer_opacity)	
	$inner.modulate = Color(1,1,1,inner_opacity)
	$inner.position = Vector2(half_width,half_height)
	if shape is CircleShape2D:
		radius = shape.radius


func _input(event):
	if not event is InputEventScreenTouch and not event is InputEventScreenDrag: # Not a touch
		return

	if button_index != -1 and button_index != event.index: # No index, or index 
		return
	if event is InputEventScreenTouch and event.pressed == false:
		inner_joystick_image.global_position = global_position + Vector2(half_width,half_height)
		button_index = -1
		emit_signal("joystick_input", 0, Vector2(0,0), 0)
		emit_signal("joystick_released")
		held = false
		return
	if is_pressed(): # Button still in pressed state
		strength = event.position.distance_to(global_position+Vector2(half_width,half_height))
		if strength <= radius:
			button_index = event.index
		if button_index != event.index:
			return
		strength = smoothstep(0,radius,strength)
		direction = event.position.direction_to(global_position+Vector2(half_width,half_height)) * -1
		inner_joystick_image.global_position = clamp_to_circle(global_position+Vector2(half_width,half_height), radius, event.position)
		get_viewport().set_input_as_handled()
		held = true


func clamp_to_circle(point: Vector2, radius: float, value: Vector2) -> Vector2:
	var direction = value - point
	if direction.length_squared() > radius * radius:
		direction = direction.normalized() * radius
	return point + direction

func _process(delta):
	if held:
		emit_signal("joystick_input", strength, direction, delta)
