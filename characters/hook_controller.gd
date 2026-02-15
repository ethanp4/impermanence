extends Node2D

@export var rest_length = 2.0
@export var stiffness = 10.0
@export var damping = 2.0

@onready var player := get_parent()
@onready var ray := $Hook

var launched = false
var target: Vector2

func _process(delta):
	ray.look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("Hook"):
		launch()
	if Input.is_action_just_released("Hook"):
		retract()
	
	if launched:
		handle_grapple(delta)
		
func launch():
	if ray.is_colliding():
		launched = true
		target = ray.get_collision_point()
		
func retract():
	launched = false
	
func handle_grapple(delta):
	var target_dir = player.global_position.direction_to(target)
	var target_dist = player.global_position.distance_to(target)
	
	var displacement = target_dist - rest_length
	
	var force = Vector2.ZERO
	
	if displacement > 0:
		var spring_force_magnitude = stiffness * displacement
		var spring_force = target_dir * spring_force_magnitude
		
		var vel_dot = player.velocity.dot(target)
		var damping = -damping * vel_dot * target_dir
		
		force = spring_force * damping
		
	player.velocity += force * delta
