class_name Base_Enemy extends CharacterBody2D
var destroyed = false
var over_border = false
@export var MAX_HP  = 100
@export var fire_rate = 2.5
@export var damage = 15
@export var speed = 50
@export var current_HP = MAX_HP
@export var power_multiplier = 1
@export var indicator : PackedScene
@export var bullet_scene : PackedScene
var hide_health_bar = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_HP = MAX_HP
	_adjust_power()
	$AnimatedSprite2D.animation = "default"
	
	if hide_health_bar:
		$HealthBar.hide()
	_on_enemy_fire_rate_timeout()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print("HP: ", HP)
	velocity = Vector2.DOWN
	if (velocity.length() > 0):
		velocity = velocity.normalized() * speed
	position += velocity * delta
	$EnemyFireRate.wait_time = fire_rate
	$HealthBar.value = float(current_HP)/float(MAX_HP) * 100
	#print(HP/MAX_HP * 100)
	#print("Health: ", $HealthBar.value)
	$AnimatedSprite2D.play()
	
	if current_HP <= 0:
		$Explode.play()
		velocity = Vector2.ZERO
		$Area2D/HitBox.disabled = true
		
		destroyed = true
		hide()
		
	if position.y > 1150:
		over_border = true
 
func _set_collision_scale(scale_stat : Vector2):
		$Area2D/HitBox.scale = scale_stat
func _on_area_2d_area_entered(area: Area2D) -> void:
	var damage_dealt = 0
	if area.is_in_group("player_bullet"):
		var player = get_tree().get_first_node_in_group("player")
		var random = randf_range(0, 100)
		if (random <= player.player_data["crit_rate"] * 100):
			damage_dealt = player.player_data["bullet_damage"] * player.player_data["crit_damage"]
			current_HP -= damage_dealt
		else:
			damage_dealt = player.player_data["bullet_damage"]
			current_HP -= damage_dealt
		_show_indicator(damage_dealt, "- ", Color.RED)
		$Damaged.play()
		area.queue_free()
	if area.is_in_group("player"):
		damage_dealt = 50
		current_HP -= damage_dealt
		_show_indicator(damage_dealt, "- ", Color.RED)
		$Damaged.play()

func _show_indicator(number : float, text : String, color : Color):
	if (get_tree().get_first_node_in_group("main").indicator_enabled == true):
		var damage_indicator = indicator.instantiate()
		damage_indicator.label_name = text + str(int(number))
		damage_indicator.color_name = color
		add_child(damage_indicator)

func _on_enemy_fire_rate_timeout() -> void:
	var bullet_1 = bullet_scene.instantiate()
	var bullet_2 = bullet_scene.instantiate()
	var bullet_3 = bullet_scene.instantiate()
	bullet_1.position = position
	bullet_2.position = bullet_1.position + Vector2(0, 35)
	bullet_3.position = bullet_2.position + Vector2(0, 35)
	bullet_1.velocity = Vector2(0, 500)
	bullet_2.velocity = Vector2(0, 500)
	bullet_3.velocity = Vector2(0, 500)
	bullet_1.bullet_damage = damage
	bullet_2.bullet_damage = damage
	bullet_3.bullet_damage = damage
	bullet_1.add_to_group("enemies_bullet")
	bullet_2.add_to_group("enemies_bullet")
	bullet_3.add_to_group("enemies_bullet")
	get_tree().get_first_node_in_group("main").add_child(bullet_1)
	get_tree().get_first_node_in_group("main").add_child(bullet_2)
	get_tree().get_first_node_in_group("main").add_child(bullet_3)
	$EnemyFireRate.start()

func _adjust_power() -> void:
	#print("current:", power_multiplier)
	MAX_HP *= power_multiplier
	current_HP = MAX_HP
	fire_rate /= power_multiplier
	damage *= power_multiplier
	speed *= power_multiplier 
	
func _cause_effect(object : CharacterBody2D) -> void:
	pass
