extends Base_Bullet

func _cause_effect() -> void:
	get_tree().get_first_node_in_group("player").player_data["speed"] /= 2
	get_tree().get_first_node_in_group("player").player_data["fire_rate"] *= 1.5
	get_tree().get_first_node_in_group("main")._add_effect(10, "debuff")
