extends CharacterBody2D

@export var boss_bullet_1 : PackedScene
@export var boss_bullet_2 : PackedScene
@export var laser_scene : PackedScene
@export var warning_scene : PackedScene
@export var indicator : PackedScene
@export var phase  = 1
@export var speed = 5.0
@export var MAX_HP =  7500.0
@export var current_HP = MAX_HP
@export var fire_rate = 0.6
@export var damage = 15
var temp_position = Vector2.ZERO
var destroyed = false
var over_border = false
var bullet_velocity = Vector2(0, 650)
@onready var boss_current_bullet = boss_bullet_1 
@export var power_multiplier = 1.0
func _ready() -> void:
	_adjust_power()
	$EnemyFireRate.start()
	$EnemyFireRate.wait_time = fire_rate
	position = Vector2(360, 0)
	z_index = 4095

func _process(delta: float) -> void:
	#print(bullet_velocity)
	velocity = Vector2.DOWN * speed
	position += velocity * delta
	if (phase == 1 && current_HP <= MAX_HP/2):
		speed = 20
		$Area2D/CollisionPolygon2D.disabled = true
		$HealingDelay.start()
		$EnemyFireRate.stop()
		var tween = create_tween()
		tween.tween_property(get_tree().get_first_node_in_group("boss_health_bar"), "value", 50, 3)
		current_HP = MAX_HP/2
		phase = 2
		boss_current_bullet = boss_bullet_2
		damage = 25
		bullet_velocity *= Vector2(1.5, 1.5)
	if (current_HP <= 0):
		destroyed = true
		$CollisionPolygon2D.disabled = true
		speed = 0
		hide()
	
	if (position.y >= 1450):
		over_border = true
		
	if ($HealingDelay.is_stopped()):
		get_tree().get_first_node_in_group("boss_health_bar").value = current_HP/MAX_HP * 100
		
	
func _on_enemy_fire_rate_timeout() -> void:
	var player = get_tree().get_first_node_in_group("player")
	_create_bullet(Vector2(player.global_position.x - 70, position.y))
	_create_bullet(Vector2(player.global_position.x, position.y))
	_create_bullet(Vector2(player.global_position.x + 70, position.y))
	$EnemyFireRate.start()
		
func _create_bullet(pos : Vector2) -> void:
	var bullet_1 = boss_current_bullet.instantiate()
	var bullet_2 = boss_current_bullet.instantiate()
	var bullet_3 = boss_current_bullet.instantiate()
	bullet_1.position = pos + Vector2(0, 35)
	bullet_2.position = bullet_1.position + Vector2(0, 35)
	bullet_3.position = bullet_2.position + Vector2(0, 35)
	bullet_1.bullet_damage = damage
	bullet_2.bullet_damage = damage
	bullet_3.bullet_damage = damage
	bullet_1.velocity = bullet_velocity
	bullet_2.velocity = bullet_velocity
	bullet_3.velocity = bullet_velocity
	bullet_1.add_to_group("enemies_bullet")
	bullet_2.add_to_group("enemies_bullet")
	bullet_3.add_to_group("enemies_bullet")
	get_tree().get_first_node_in_group("main").add_child(bullet_1)
	get_tree().get_first_node_in_group("main").add_child(bullet_2)
	get_tree().get_first_node_in_group("main").add_child(bullet_3)
	
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_bullet"):
		var random = randf_range(0, 100)
		var player = get_tree().get_first_node_in_group("player")
		var damage_dealt = 0
		if (random <= player.player_data["crit_rate"] * 100):
			damage_dealt = player.player_data["bullet_damage"] * player.player_data["crit_damage"]
		else:
			damage_dealt = player.player_data["bullet_damage"]
		current_HP -= damage_dealt
		_show_indicator(damage_dealt, "- ", Color.RED)	
		area.queue_free()
		$Damaged.play()

func _show_indicator(number : float, text : String, color : Color):
	if (get_tree().get_first_node_in_group("main").settings_data["indicator_enabled"] == true):
		var new_indicator = indicator.instantiate()
		new_indicator.label_name = text + str(int(number))
		new_indicator.color_name = color
		add_child(new_indicator)
	
func _adjust_power() -> void:
	#print(power_multiplier)
	MAX_HP *= power_multiplier
	current_HP = MAX_HP
	bullet_velocity *= Vector2(power_multiplier, power_multiplier)
	#print(bullet_velocity)
	fire_rate /= power_multiplier
	speed *= power_multiplier
	damage *= power_multiplier

func _cause_effect() -> void:
	pass


func _on_healing_delay_timeout() -> void:
	$Area2D/CollisionPolygon2D.disabled = false
	$EnemyFireRate.start()
	speed = 10.0
	current_HP = MAX_HP/2
	$HealingDelay.stop()
	$ChangeBullet.start()


func _on_laser_spawn_timeout() -> void:
	get_tree().call_group("warning_area", "queue_free")
	var laser = laser_scene.instantiate()
	laser.position = temp_position
	laser.bullet_damage = 50
	laser.add_to_group("enemies_bullet")
	laser.add_to_group("laser")
	get_tree().get_first_node_in_group("main").add_child(laser)
	$WarningAreaTimer.start()
	$LaserSpawn.start()


func _on_change_bullet_timeout() -> void:
	$EnemyFireRate.stop()
	$ChangeBullet.stop()
	$LaserPhase.start()
	$WarningAreaTimer.start()
	$LaserSpawn.start()


func _on_laser_phase_timeout() -> void:
	$LaserSpawn.stop()
	$LaserPhase.stop()
	$WarningAreaTimer.stop()
	$EnemyFireRate.start()
	$ChangeBullet.start()


func _on_warning_area_timer_timeout() -> void:
	var warning_area = warning_scene.instantiate()
	warning_area.modulate.a = 0.5
	temp_position.x = get_tree().get_first_node_in_group("player").position.x
	temp_position.y = position.y + 30
	warning_area.position = temp_position
	warning_area.add_to_group("warning_area")
	get_tree().get_first_node_in_group("main").add_child(warning_area)
	$WarningAreaTimer.stop()
	
