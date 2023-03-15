# Basic joystick controller with a small demo

Has basic "multitouch" support! Just add a second joystick and make them not overlap.

## What's provided

- joystick.tscn and required assets
- demo scene with two joysticks and basic movement.

## How to use.

- Add a CanvasLayer. Allows you
- (optional) Add a control node to anchor and position things where you want.
- Add a instance of the joystick scene (res://addons/joystick/joystick.tscn) or two!
- Hook up to the signal joystick_input. This signal provides 3 pieces of information, strength, direction, and delta passed from process (if it's being held) or 0 if it's just been released

## Notes:

Should be used on a canvas layer for positioning. It's my understanding that's probably best practice, let me know if not ;)
