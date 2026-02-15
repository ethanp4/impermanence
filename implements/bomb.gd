extends Node2D

@export var throw_speed: float = 400.0
@export var gravity: float = 980.0  # match your project gravity
@export var trajectory_points: int = 30
@export var time_step: float = 0.05  # time between each predicted point

@onready var trajectory_line: Line2D = $TrajectoryLine

const EXPLOSIVE = preload("uid://be6ylkwa6r8id")

func update_trajectory(start_pos: Vector2, direction: Vector2) -> void:
	var points: PackedVector2Array = []
	var pos = start_pos
	var velocity = direction.normalized() * throw_speed

	for i in trajectory_points:
		points.append(trajectory_line.to_local(pos))
		velocity.y += gravity * time_step
		pos += velocity * time_step

	trajectory_line.points = points
	
func throw_bomb() -> void:
	var aim_dir = (get_global_mouse_position() - global_position).normalized()
	
	var bomb = EXPLOSIVE.instantiate()
	get_tree().root.add_child(bomb)          # add to root, NOT the player
	bomb.global_position = global_position   # start at player position
	bomb.linear_velocity = aim_dir * throw_speed

func _ready() -> void:
	trajectory_line.width = 2.0
	trajectory_line.default_color = Color(1, 1, 0, 0.6) 

func _process(delta: float) -> void:
	if Input.is_action_pressed("Hook"):
		trajectory_line.visible = true
		var aim_dir = (get_global_mouse_position() - global_position).normalized()
		update_trajectory(global_position, aim_dir)
	else:
		trajectory_line.visible = false
	if Input.is_action_just_released("Hook"):
		throw_bomb()
		
