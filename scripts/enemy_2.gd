extends Area2D
var velocity = Vector2.ZERO
@export var speed = 200.0
@export var MAX_HP = 150
@export var current_HP = MAX_HP
@export var damage = 75
@export var destroyed = false
@export var indicator : PackedScene
var power_multiplier = 1
var over_border = false
func _ready() -> void:
	_adjust_power()
	current_HP = MAX_HP
	$AnimatedSprite2D.play()
	$Red_Area.hide()

func _process(delta: float) -> void:
	#print(MAX_HP)
	#print(damage)
	velocity.y += 1
	if (velocity.length() > 0):
		velocity = velocity.normalized() * speed
	position += velocity * delta
	
	$HealthBar.value = float(current_HP)/ float(MAX_HP) * 100
	if position.y > 200 && position.y < 220 && $DelayFullSpeed.is_stopped() == true:
		speed = 0
		$Red_Area.show()
		$DelayFullSpeed.start()
		
	if current_HP <= 0:
		$Explode.play()
		speed = 0
		$HitBox.disabled
		destroyed = true
		hide()
		
	if (position.y > 1440):
		over_border = true
		
func _on_delay_full_speed_timeout() -> void:
	$Red_Area.hide()
	speed = 1500

func _on_area_entered(area: Area2D) -> void:
	var damage_dealt = 0
	if area.is_in_group("player_bullet"):
		var player = get_tree().get_first_node_in_group("player")
		var random = randf_range(0, 100)
		if (random <= player.player_data["crit_rate"] * 100):
			damage_dealt = player.player_data["bullet_damage"] * player.player_data["crit_damage"]
		else:
			damage_dealt = player.player_data["bullet_damage"]
		current_HP -= damage_dealt
		_show_indicator(damage_dealt, "- ", Color.RED)
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
	speed *= power_multiplier
	damage *= power_multiplier
