extends Node2D

@onready var fade_overlay = %FadeOverlay
@onready var pause_overlay = %PauseOverlay
@onready var inventory = $InventoryStacked as InventoryStacked
var intro = preload("res://dialogues/intro.dialogue")
var baradumDialogue = preload("res://dialogues/baradum.dialogue")
var firstDialogue = preload("res://dialogues/first.dialogue")
var routineDialogue = preload("res://dialogues/routine.dialogue")
var finalDialogue = preload("res://dialogues/final.dialogue")

var quests_limit = 10
var dialogues_number = 0
var is_final = false

func _ready() -> void:
	fade_overlay.visible = true
	Events.gold = 500
	
	if SaveGame.has_save():
		SaveGame.load_game(get_tree())
	
	pause_overlay.game_exited.connect(_save_game)
	get_tree().create_timer(1.5).timeout.connect(func():
		DialogueManager.show_dialogue_balloon(intro)
		DialogueManager.dialogue_ended.connect(dialogue_ended)
	)
	Events.update_inventory.connect(func(item, amount):
		var _current_amount = inventory.get_item_stack_size(inventory.get_item_by_id(item))
		if item == 'gold':
			_current_amount = Events.gold
		_current_amount += amount
		inventory.set_item_stack_size(inventory.get_item_by_id(item), _current_amount)
		Events[item] = _current_amount
		
		if item == 'gold':
			print('money paid ', amount, ', total ', Events.gold, ', ', inventory.get_item_stack_size(inventory.get_item_by_id(item)))
			quests_limit -= 1
			if _current_amount < 30:
				quests_limit = 0
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
	if is_final:
		get_tree().change_scene_to_file("res://scenes/menu/main_menu_scene.tscn")
		return
	dialogues_number += 1
	if resource == intro:
		%CtrlInventoryStacked.show()
	
	await get_tree().create_timer(randf_range(1.5, 3)).timeout
	if dialogues_number == 1:
		DialogueManager.show_dialogue_balloon(firstDialogue)
	elif dialogues_number == 6:
		DialogueManager.show_dialogue_balloon(baradumDialogue)
		$Music.play()
	elif quests_limit <= 0:
		Events.calc_score()
		is_final = true
		DialogueManager.show_dialogue_balloon(finalDialogue)
		$Music.play()
	else:
		DialogueManager.show_dialogue_balloon(routineDialogue)
