extends Base_Enemy

func _ready() -> void:
	speed = 35.0
	MAX_HP = 400.0
	current_HP = MAX_HP
	fire_rate = 2.5
	damage = 15
	_adjust_power()
	_on_enemy_fire_rate_timeout()
		
func _on_enemy_fire_rate_timeout() -> void:
	var bullet = bullet_scene.instantiate()
	bullet.bullet_damage = damage
	bullet.velocity = Vector2(0, 500)
	bullet.position = position + Vector2(0, 35) 
	bullet.show()
	bullet.add_to_group("enemies_bullet")
	get_tree().get_first_node_in_group("main").add_child(bullet)
	$EnemyFireRate.start()
