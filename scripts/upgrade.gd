extends Area2D

var minimum_required_coins = {
	"HP": 10,
	"fire_rate": 15,
	"bullet_damage": 15,
	"crit_rate": 20,
	"crit_damage": 15,
	"speed": 10,
	"healing_rate": 30,
	"coin_multiplier": 50
}

var required_coins = null

var buff_rate = {
	"HP": 1.2,
	"fire_rate": 0.0225,
	"bullet_damage": 10,
	"crit_rate": 0.1,
	"crit_damage": 0.2,
	"speed": 1.1,
	"healing_rate": 0,
	"coin_multiplier": 2
}

var player_data
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position.y = 800
	var tween = create_tween()
	tween.tween_property(self, "position:y", 540, 0.05)
	required_coins = minimum_required_coins.duplicate()
	_update_stat($HP/HP_Upgrade_Bar, "HP", $HP/HP_Button, $HP/Node/HP_Label, 0)
	_update_stat($Fire_Rate/Fire_Rate_Upgrade_Bar, "fire_rate", $Fire_Rate/Fire_Rate_Button, $Fire_Rate/Node2/Label, 1)
	_update_stat($Bullet_Damage/Bullet_Damage_Upgrade_Bar, "bullet_damage", $Bullet_Damage/Bullet_Damage_Button, $Bullet_Damage/Node3/Label, 2)
	_update_stat($Crit_Rate/Crit_Rate_Upgrade_Bar, "crit_rate", $Crit_Rate/Crit_Rate_Button, $Crit_Rate/Node4/Label, 3)
	_update_stat($Crit_Damage/Crit_Damage_Upgrade_Bar, "crit_damage", $Crit_Damage/Crit_Damage_Button, $Crit_Damage/Node5/Label, 4)
	_update_stat($Speed/Speed_Upgrade_Bar, "speed", $Speed/Speed_Button, $Speed/Node6/Label, 5)
	_update_stat($Healing_Rate/Healing_Rate_Upgrade_Bar, "healing_rate", $Healing_Rate/Healing_Rate_Button, $Healing_Rate/Node7/Label, 6)
	_update_stat($Coin_Multiplier/Coin_Multiplier_Upgrade_Bar, "coin_multiplier", $Coin_Multiplier/Coin_Multiplier_Button, $Coin_Multiplier/Node8/Label, 7)
	
	buff_rate["healing_rate"] = player_data["MAX_HP"] * 0.02
	
func _update_stat(texture_bar : TextureProgressBar, name : String, button : Button, label : Label, index : int) -> void:
		texture_bar.value = player_data["upgraded"][index] * 10
		required_coins[name] = pow(2, player_data["upgraded"][index]) * minimum_required_coins[name]
		label.text = str(int(required_coins[name]))
		if (texture_bar.value == 100):
			button.hide()
			label.text = "Maximum"
	
func _on_exit_button_pressed() -> void:
	get_tree().get_first_node_in_group("player_score").show()
	get_tree().get_first_node_in_group("main").player_loaded_data = player_data.duplicate()
	get_tree().get_first_node_in_group("main")._enable_button()
	queue_free()


func _on_hp_button_pressed() -> void:
	if player_data["coins"] >= required_coins["HP"]:
		player_data["MAX_HP"] *= buff_rate["HP"]
		player_data["coins"] -= required_coins["HP"]
		player_data["upgraded"][0] += 1
		_update_stat($HP/HP_Upgrade_Bar, "HP", $HP/HP_Button, $HP/Node/HP_Label, 0)
		$Upgraded.play()
	else:
		_not_enough_coins($HP/Node/HP_Label)
func _on_fire_rate_button_pressed() -> void:
	if player_data["coins"] >= required_coins["fire_rate"]:
		player_data["fire_rate"] -= buff_rate["fire_rate"]
		player_data["coins"] -= required_coins["fire_rate"]
		player_data["upgraded"][1] += 1
		_update_stat($Fire_Rate/Fire_Rate_Upgrade_Bar, "fire_rate", $Fire_Rate/Fire_Rate_Button, $Fire_Rate/Node2/Label, 1)
		$Upgraded.play()
	else:	
		_not_enough_coins($Fire_Rate/Node2/Label)
func _on_bullet_damage_button_pressed() -> void:
	if player_data["coins"] >= required_coins["bullet_damage"]:
		player_data["bullet_damage"] += buff_rate["bullet_damage"]
		player_data["coins"] -= required_coins["bullet_damage"]
		player_data["upgraded"][2] += 1
		_update_stat($Bullet_Damage/Bullet_Damage_Upgrade_Bar, "bullet_damage", $Bullet_Damage/Bullet_Damage_Button, $Bullet_Damage/Node3/Label, 2)
		$Upgraded.play()
	else:
		_not_enough_coins($Bullet_Damage/Node3/Label)
func _on_crit_rate_button_pressed() -> void:
	if player_data["coins"] >= required_coins["crit_rate"]:
		player_data["crit_rate"] += buff_rate["crit_rate"]
		player_data["coins"] -= required_coins["crit_rate"]
		player_data["upgraded"][3] += 1
		_update_stat($Crit_Rate/Crit_Rate_Upgrade_Bar, "crit_rate", $Crit_Rate/Crit_Rate_Button, $Crit_Rate/Node4/Label, 3)
		$Upgraded.play()
	else:
		_not_enough_coins($Crit_Rate/Node4/Label)
func _on_crit_damage_button_pressed() -> void:
	if player_data["coins"] >= required_coins["crit_damage"]:
		player_data["crit_damage"] += buff_rate["crit_damage"]
		player_data["coins"] -= required_coins["crit_damage"]
		player_data["upgraded"][4] += 1
		_update_stat($Crit_Damage/Crit_Damage_Upgrade_Bar, "crit_damage", $Crit_Damage/Crit_Damage_Button, $Crit_Damage/Node5/Label, 4)
		$Upgraded.play()
	else:
		_not_enough_coins($Crit_Damage/Node5/Label)
func _on_speed_button_pressed() -> void:
	if player_data["coins"] >= required_coins["speed"]:
		player_data["speed"] *= buff_rate["speed"]
		player_data["coins"] -= required_coins["speed"]
		player_data["upgraded"][5] += 1
		_update_stat($Speed/Speed_Upgrade_Bar, "speed", $Speed/Speed_Button, $Speed/Node6/Label, 5)
		$Upgraded.play()
	else:
		_not_enough_coins($Speed/Node6/Label)
func _on_healing_rate_button_pressed() -> void:
	if player_data["coins"] >= required_coins["healing_rate"]:
		player_data["healing_rate"] += buff_rate["healing_rate"]
		player_data["coins"] -= required_coins["healing_rate"]
		player_data["upgraded"][6] += 1
		_update_stat($Healing_Rate/Healing_Rate_Upgrade_Bar, "healing_rate", $Healing_Rate/Healing_Rate_Button, $Healing_Rate/Node7/Label, 6)
		$Upgraded.play()
	else:
		_not_enough_coins($Healing_Rate/Node7/Label)
func _on_coin_multiplier_button_pressed() -> void:
	if player_data["coins"] >= required_coins["coin_multiplier"]:
		player_data["coin_multiplier"] += buff_rate["coin_multiplier"]
		player_data["coins"] -= required_coins["coin_multiplier"]
		player_data["upgraded"][7] += 1
		_update_stat($Coin_Multiplier/Coin_Multiplier_Upgrade_Bar, "coin_multiplier", $Coin_Multiplier/Coin_Multiplier_Button, $Coin_Multiplier/Node8/Label, 7)
		$Upgraded.play()
	else:
		_not_enough_coins($Coin_Multiplier/Node8/Label)
func _not_enough_coins(label : Label) -> void:
		var tween = create_tween()
		tween.tween_property(label, "modulate", Color('RED'), 0.1)
		tween.tween_property(label, "modulate", Color(1,1,1,1), 0.1)
		$Failed.play()
