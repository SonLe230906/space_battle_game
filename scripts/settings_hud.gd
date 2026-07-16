extends Node2D

@onready var main = get_tree().get_first_node_in_group("main")
var difficulty_text = ["Easy", "Normal", "Hard"]
var mode = {false : "Off", true : "On"}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("settings")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Difficulty/Label.text = "Difficulty: " + difficulty_text[main.difficulty]
	$ShowIndicator/Label.text = "Show Indicator: " + mode[main.indicator_enabled]
	$Sound/Label.text = "Sound: " + mode[main.sound_enabled]
	
	if Input.is_action_just_pressed("quit"):
		_on_exit_pressed()
	
	if (get_tree().get_first_node_in_group("main").started == true):
		$Difficulty.disabled = true
	else:
		$Difficulty.disabled = false
	
func _on_difficulty_pressed() -> void:
	main.difficulty += 1
	if (main.difficulty >= 3):
		main.difficulty = 0

func _on_show_indicator_pressed() -> void:
	if (main.indicator_enabled == false):
		main.indicator_enabled = true
	else:
		main.indicator_enabled = false

func _on_sound_pressed() -> void:
	if (main.sound_enabled == false):
		main.sound_enabled = true
	else:
		main.sound_enabled = false

func _on_exit_pressed() -> void:
	if (get_tree().paused == true):
		get_tree().get_first_node_in_group("pause").show()
	else:
		get_tree().get_first_node_in_group("main")._enable_button()
	queue_free()
	
