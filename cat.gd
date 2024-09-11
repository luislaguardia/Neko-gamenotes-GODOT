class_name Cat
extends Node2D

signal startTimer;

# Initializing some nodes as variables in order to be able to use them in code
@onready var catNameLabel : Label = $CatName
@onready var clickableArea = $ClickableArea
@onready var catStateMachine : CatStateMachine = $CatStateMachine as CatStateMachine
@onready var highlightBorder = $HighlightBorder
@onready var timerBar = $TimerBar

# Cat stat values
@export var catName : String
@export var catHealth : float
@export var catDmg : float 
@export var catDef : float
@export var catModifier : float
@export var catSkills := ["Scratch", "Meow"]
@export var catTempDef : float = catDef;

# Boolean checker for what the current state of the game should be. (I.e. if enemy is getting targeted, etc)
var targettingAlly = false;
var targettingEnemy = false;
var inCollider := false
var canAction = false;
var defending = false;

# This is the template
# Attack variable dictionaries
var meow = { 
	"targetEnemy": true,
	"aoe": true,
	"modifier": 1, #MODIFIER COULD EITHER BE FOR DMG, HEAL, OR BUFFS
	"cooldown": 1
	}

var scratch = {
	"targetEnemy": true,
	"aoe": false,
	"modifier": 1, #MODIFIER COULD EITHER BE FOR DMG, HEAL, OR BUFFS
	"cooldown": 1
}

var defend = {
	"targetEnemy": false,
	"aoe": true,
	"modifier": 5, #MODIFIER COULD EITHER BE FOR DMG, HEAL, OR BUFFS
	"cooldown": 2
}

# Called when the node enters the scene tree for the first time.
func _ready():
	var newString = "Cat %s" % (get_index())
	catNameLabel.text = newString
	catStateMachine.init(self)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.resetCatCooldown :
		timerBar._start_timer()
		targettingAlly = false;
		targettingEnemy = false;
		Global.resetCatCooldown = false;
		
		
	if timerBar.onCooldown:
		canAction = false;
	else:
		if defending:
			catTempDef = catDef
			defending = false;
		canAction = true
	
	if Global.isTargettingAlly == true:
		highlightBorder.visible = true;
	else:
		highlightBorder.visible = false;
	


func _input(event):
	catStateMachine.onInput(event)
	
	for child in get_parent().get_children():
		if event.is_action_pressed("left_mouse") and (targettingAlly and child.inCollider):
			Global.resetCatCooldown = true;
			Global.isTargettingAlly = false;
			catStateMachine.onTransitionRequested(catStateMachine.current_state, CatState.State.BASE)
			break

func _on_clickable_area_mouse_entered():
	inCollider = true

func _on_clickable_area_mouse_exited():
	inCollider = false
	
func _defend() -> void:
	defending = true;
	catTempDef = catDef * catModifier
	Global.resetCatCooldown = true
	catStateMachine.onTransitionRequested(catStateMachine.current_state, CatState.State.BASE)
	
func _scratch() -> void:
	if targettingEnemy:
		targettingEnemy = false;
		Global.isTargettingEnemy = false;
	var dmg = catDmg * catModifier;
	Global.isTargettingAlly = true;
	targettingAlly = true;
	
func _meow() -> void:
	var dmg = catDmg * catModifier;
	if targettingAlly:
		targettingAlly = false;
		Global.isTargettingAlly = false;
	Global.isTargettingEnemy = true;
	targettingEnemy = true;
