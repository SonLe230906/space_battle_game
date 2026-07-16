extends Area2D
@export var label_name = "Label"
@export var color_name = Color.AQUA
var original_position = Vector2(0,0)
var counter = 20

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label.text = label_name
	$Label.modulate = color_name
	position.x += 30
	position.y -= 30 - randf_range(0, 15)
	$Timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if counter != 0:
		position.y -= 1
		counter -= 1

func _on_timer_timeout() -> void:
	queue_free()
