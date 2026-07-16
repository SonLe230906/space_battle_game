extends Area2D

var collected = false
@export var animation_name = "coin_default"
@export var collision = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.animation = animation_name

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$AnimatedSprite2D.play()
	#print("Collision: ", $CollisionShape2D.disabled)
	#print("Collected: ", collected)
func _on_area_entered(area: Area2D) -> void:
	if area.name == "Player_Area":
		collected = true
