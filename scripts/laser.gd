extends Base_Bullet

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale:x", 1.25, 0.025)


func _on_timer_timeout() -> void:
	queue_free()
