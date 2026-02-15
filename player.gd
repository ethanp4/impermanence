extends CharacterBody2D





func _on_chain_hooked(hooked_position):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", hooked_position, 0.75)
	
