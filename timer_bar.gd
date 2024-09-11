extends Line2D

var onCooldown := false # true for testing purposes
var timerRate : float = 1.0;

func _ready() -> void:
	#if get_parent().startTimer != null:	
		#get_parent().startTimer.connect(_start_timer);
	pass;

func _physics_process(delta: float) -> void:
	if onCooldown:
		_decrease();
	

func _decrease() -> void:
	points[1].x -= timerRate;

	if points[1].x <= 0:
		points[1].x = 100
		onCooldown = false
		
func _start_timer() -> void:
	onCooldown = true;
