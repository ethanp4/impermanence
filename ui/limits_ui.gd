extends VBoxContainer

@onready var jump_limit_label: Label = $VBoxContainer/JumpLimitLabel

@onready var limits_manager: Node = $"../../LimitsManager"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	jump_limit_label.text = "%s jumps remaining" % limits_manager.get_jumps()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	jump_limit_label.text = "%s jumps remaining" % limits_manager.get_jumps()
	pass
