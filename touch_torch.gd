extends Node2D

@onready var highlightBorder := $HighlightBorder

var inEnemyCollider = false;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if Global.isTargettingEnemy:
		highlightBorder.visible = true;
	else:
		highlightBorder.visible = false;

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse") and (inEnemyCollider and Global.isTargettingEnemy):
		print("Targetting Enemy")
		Global.isTargettingEnemy = false;
		Global.resetCatCooldown = true;

func _on_clickable_area_mouse_entered() -> void:
	inEnemyCollider = true;


func _on_clickable_area_mouse_exited() -> void:
	inEnemyCollider = false;
