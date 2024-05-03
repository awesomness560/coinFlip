extends Node2D

@export_multiline var headsResult : String
@export_multiline var tailsResult : String

@export_group("References")
@export var headsSprite : Sprite2D
@export var tailsSprite : Sprite2D
@export var coinAnimations : AnimationPlayer

@export_group("UI References")
@export var spinButton : Button
@export var resultLabel : RichTextLabel
@export var headTailsMenu : Control
@export var usernameTextEdit : LineEdit
@export var thanksMenu : Control

var rand : RandomNumberGenerator = RandomNumberGenerator.new()

var username : String
var randomHeads : bool = true

func _input(event):
	if event.is_action_pressed("enter") and usernameTextEdit.has_focus():
		coinFlipInput()

func coinFlipInput():
	username = usernameTextEdit.text
	usernameTextEdit.visible = false
	
	#spinButton.visible = true
	coinFlip()
	resultLabel.visible = true

func _on_spin_pressed():
	spinButton.visible = false
	coinFlip()

func coinFlip():
	randomHeads = randb()
	coinAnimations.play("coin_flip_2")
	
	if randomHeads: #We rolled heads
		await get_tree().create_timer(2).timeout
		
		resultLabel.text = headsResult
		resultLabel.visible = true
		coinAnimations.stop(true)
		headTailsMenu.visible = true
	else: #We rolled tails
		await get_tree().create_timer(2.5).timeout
		
		resultLabel.text = tailsResult
		resultLabel.visible = true
		coinAnimations.stop(true)
		headTailsMenu.visible = true



func randb() -> bool:
	return rand.randi() & 0x01

func sendResult(result : String):
	var initalFlip : String
	if randomHeads:
		initalFlip = "Heads"
	else:
		initalFlip = "Tails"
	
	Analytics.add_event("Coin Flip", {"name":username, "shownFlip":initalFlip, "chosenFlip":result})

func _on_heads_pressed():
	sendResult("Heads")
	switchToThanksMenu()

func _on_tails_pressed():
	sendResult("Tails")
	switchToThanksMenu()

func switchToThanksMenu():
	headTailsMenu.visible = false
	thanksMenu.visible = true

func _on_try_again_pressed():
	thanksMenu.visible = false
	resultLabel.text = "[b]Result:[/b]"
	#spinButton.visible = true
	usernameTextEdit.visible = true
