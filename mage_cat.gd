extends "res://Scripts/Cat/cat.gd"

var firebolt = { 
	"targetEnemy": true,
	"aoe": false,
	"modifier": 3, #MODIFIER COULD EITHER BE FOR DMG, HEAL, OR BUFFS
	"cooldown": 2
	}
	
var blizzard = {
	"targetEnemy": true,
	"aoe": true,
	"modifier": 2,
	"cooldown": 2
	}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	catStateMachine.init(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if timerBar.onCooldown:
		canAction = false;
	else:
		canAction = true
	
	if Global.isTargettingAlly:
		highlightBorder.visible = true;
	else:
		highlightBorder.visible = false;
	
	if Global.resetCatCooldown and (targettingEnemy or targettingAlly):
		timerBar._start_timer()
		targettingAlly = false;
		targettingEnemy = false;
		Global.resetCatCooldown = false;

func _input(event: InputEvent) -> void:
	catStateMachine.onInput(event)
	
	for child in get_parent().get_children():
		if event.is_action_pressed("left_mouse") and (targettingAlly and child.inCollider):
			if targettingEnemy:
				targettingEnemy = false;
				Global.isTargettingEnemy = false;
			print("Targetting Ally")
			Global.resetCatCooldown = true;
			Global.isTargettingAlly = false;
			catStateMachine.onTransitionRequested(catStateMachine.current_state, CatState.State.BASE)
			break

func _call_skill(name: String) -> void:
	if name == "Firebolt":
		_cat_action_handler(firebolt)
	else:
		_cat_action_handler(blizzard)

func _cat_action_handler(action: Dictionary) -> void:
	if (action["targetEnemy"] == true):
		print("targetting enemy")
	else:
		print("targetting Ally")
	pass
