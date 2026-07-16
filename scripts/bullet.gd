
class_name Base_Bullet extends Area2D
var velocity = Vector2.ZERO
var bullet_damage = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += velocity * delta
	if position.y < 0 || position.y > 1080:
		queue_free()

func _cause_effect() -> void:
	pass
