extends Node2D

@export var rest_length = 200.0
@export var stiffness = 15.0
@export var damping = 1.0
@export var hook_extend_speed = 1000.0

@onready var player := get_parent()
@onready var ray := $Hook
@onready var rope := $Rope


var launched = false
var extending = false
var target: Vector2
var rope_tween: Tween

func _process(delta):
	ray.look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("Hook"):
		launch()
	if Input.is_action_just_released("Hook"):
		retract()
	
	if launched and not extending:
		handle_grapple(delta)
	elif extending:
		update_rope()
	
		
func launch():
	if ray.is_colliding():
		launched = true
		target = ray.get_collision_point()
		rope.show()
		
		rope.set_point_position(0, Vector2.ZERO)
		rope.set_point_position(1, Vector2.ZERO)
		
		extending = true
		var distance = global_position.distance_to(target)
		var duration = distance / hook_extend_speed
		
		if rope_tween:
			rope_tween.kill()
			
		rope_tween = create_tween()
		rope_tween.tween_method(animate_hook_ext, 0.0, 1.0, duration)
		rope_tween.finished.connect(func():
			extending = false
			launched = true
		)
		
func animate_hook_ext(progress: float):
	var local_target = to_local(target)
	rope.set_point_position(1, Vector2.ZERO.lerp(local_target, progress))
		
func retract():
	launched = false
	extending = false
	if rope_tween:
		rope_tween.kill()
	rope.hide()
	
func handle_grapple(delta):
	var target_dir = player.global_position.direction_to(target)
	var target_dist = player.global_position.distance_to(target)
	
	var displacement = target_dist - rest_length
	
	var force = Vector2.ZERO
	
	if displacement > 0:
		var spring_force_magnitude = stiffness * displacement
		var spring_force = target_dir * spring_force_magnitude
		
		var vel_dot = player.velocity.dot(target_dir)
		var damping = -damping * vel_dot * target_dir
		
		force = spring_force + damping
		
	player.velocity += force * delta
	update_rope()
	
func update_rope():
	rope.set_point_position(1, to_local(target))
