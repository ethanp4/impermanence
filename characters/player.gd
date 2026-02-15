extends CharacterBody2D

const SPEED = 500.0
const JUMP_VELOCITY = -600.0
const ACCELERATION = 0.1
const DECELERATION = 0.1

@onready var animated_sprite = $AnimatedSprite2D
@onready var hc := $HookController2


var limits_manager: Node

func _ready() -> void:
	limits_manager = ManagerManager.limits_manager
	
func _physics_process(delta: float) -> void:
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().name == "TileMapHazardous":
			die()
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and (is_on_floor() || hc.launched) and limits_manager.can_jump():
		limits_manager.use_jump()
		velocity.y += JUMP_VELOCITY
		hc.retract()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = lerp(velocity.x, SPEED * direction, ACCELERATION)
		animated_sprite.flip_h = direction < 0
	else:
		velocity.x = lerp(velocity.x, 0.0, DECELERATION)

	move_and_slide()
	
func die():
	if get_tree():
		get_tree().reload_current_scene()
