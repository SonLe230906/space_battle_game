extends Node2D
var quit = false
@export var settings_scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("pause")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("quit") && get_tree().get_nodes_in_group("settings").size() == 0:
		get_tree().paused = false
		queue_free()

func _on_continue_button_pressed() -> void:
	get_tree().paused = false
	queue_free()


func _on_quit_button_pressed() -> void:
	quit = true
	get_tree().paused = false


func _on_setting_button_pressed() -> void:
	hide()
	var settings = settings_scene.instantiate()
	get_tree().get_first_node_in_group("main").add_child(settings)
