extends Node2D

@onready var fade_overlay = %FadeOverlay
@onready var pause_overlay = %PauseOverlay
@onready var inventory = $InventoryStacked as InventoryStacked
var intro = preload("res://dialogues/intro.dialogue")
var firstDialogue = preload("res://dialogues/first.dialogue")

func _ready() -> void:
	#inventory.set_item_stack_size(inventory.get_item_by_id('fish'), 5)
	fade_overlay.visible = true
	
	if SaveGame.has_save():
		SaveGame.load_game(get_tree())
	
	pause_overlay.game_exited.connect(_save_game)
	get_tree().create_timer(1.5).timeout.connect(func():
		DialogueManager.show_dialogue_balloon(intro)
		DialogueManager.dialogue_ended.connect(dialogue_ended)
	)

func _input(event) -> void:
	if event.is_action_pressed("pause") and not pause_overlay.visible:
		get_viewport().set_input_as_handled()
		get_tree().paused = true
		pause_overlay.grab_button_focus()
		pause_overlay.visible = true
		
func _save_game() -> void:
	SaveGame.save_game(get_tree())

func dialogue_ended(resource):
	if resource == intro:
		%CtrlInventoryStacked.show()
		print('intro ended')
