extends Node

@export var _jumps_remaining: int = 3

#func _ready() -> void:
	#ManagerManager.limits_manager = self

func can_jump() -> int:
	return get_jumps() != 0

func get_jumps() -> int:
	return _jumps_remaining
	
func use_jump() -> void:
	_jumps_remaining -= 1
