extends Node2D

@onready var main = get_tree().get_first_node_in_group("main")
var difficulty_text = ["Easy", "Normal", "Hard"]
var mode = {false : "Off", true : "On"}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("settings")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (main.settings_data != null):
		$Difficulty/Label.text = "Difficulty: " + difficulty_text[main.settings_data["difficulty"]]
		$ShowIndicator/Label.text = "Show Indicator: " + mode[main.settings_data["indicator_enabled"]]
		$Sound/Label.text = "Sound: " + mode[main.settings_data["sound_enabled"]]
		
	if Input.is_action_just_pressed("quit"):
		_on_exit_pressed()
	
	if (get_tree().get_first_node_in_group("main").started == true):
		$Difficulty.disabled = true
	else:
		$Difficulty.disabled = false
	
func _on_difficulty_pressed() -> void:
	if (main.settings_data != null):
		main.settings_data["difficulty"] += 1
		if (main.settings_data["difficulty"] >= 3):
			main.settings_data["difficulty"] = 0

func _on_show_indicator_pressed() -> void:
	if (main.settings_data["indicator_enabled"] == false):
		main.settings_data["indicator_enabled"] = true
	else:
		main.settings_data["indicator_enabled"] = false

func _on_sound_pressed() -> void:
	if (main.settings_data["sound_enabled"] == false):
		main.settings_data["sound_enabled"] = true
	else:
		main.settings_data["sound_enabled"] = false

func _on_exit_pressed() -> void:
	if (get_tree().paused == true):
		get_tree().get_first_node_in_group("pause").show()
	else:
		get_tree().get_first_node_in_group("main")._enable_button()
	queue_free()
