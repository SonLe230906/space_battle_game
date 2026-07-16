class_name Base_Button extends Button

var played = false
var is_clicked = 0
var sound = 2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (disabled == false && self.is_hovered() && played == false):
		self.self_modulate = Color(1.211, 1.211, 1.211)
		if (sound == 1):
			$HoverSound_1.play()
		elif (sound == 2):
			$HoverSound_2.play()
		played = true
	elif (!self.is_hovered()):
		if (self.name != "PauseButton"):
			self.self_modulate = Color(1, 1, 1, 1)
			played = false
		
	if (self.button_pressed == true):
		self.modulate = Color(0.500, 0.500, 0.500)
		$ClickSound.play()
		is_clicked = true
	elif (self.button_pressed == false):
		self.modulate = Color(1,1,1,1)
		is_clicked = false
		
