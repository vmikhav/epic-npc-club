extends Node


signal character_started_talking(character_name)
signal character_finished_talking(character_name)

signal update_inventory(id: String, amount: int)

var strength = 5
var constitution = 5
var dexterity = 5
var intelligence = 5
var wisdom = 5
var charisma = 5
var level = 1
var quest_cost = 20
var quest_result = 0

var gold = 500
var food = 0
var chair = 0
var joke = 0
var invitation = 0
var total_score = 0

func generate_adventurer():
	level = randi_range(1, 15)
	quest_cost = 20 + level * 3
	var points_pool = 4*level
	var _point = 0
	_point = randi_range(0, min(17, points_pool))
	points_pool -= _point
	strength = 3 + _point
	_point = randi_range(0, min(17, points_pool))
	points_pool -= _point
	constitution = 3 + _point
	_point = randi_range(0, min(17, points_pool))
	points_pool -= _point
	dexterity = 3 + _point
	_point = randi_range(0, min(17, points_pool))
	points_pool -= _point
	intelligence = 3 + _point
	_point = randi_range(0, min(17, points_pool))
	points_pool -= _point
	wisdom = 3 + _point
	_point = randi_range(0, min(17, points_pool))
	points_pool -= _point
	charisma = 3 + _point

func process_food_quest():
	var result = randi_range(1, 20) + max(ability_bonus(dexterity), ability_bonus(intelligence))
	quest_result = max(0, result)
	print(quest_result)
	if quest_result > 0:
		update_inventory.emit('food', quest_result)
	return quest_result

func process_chair_quest():
	var result = randi_range(1, 20) + max(ability_bonus(strength), ability_bonus(constitution))
	quest_result = max(0, result)
	print(quest_result)
	if quest_result > 0:
		update_inventory.emit('chair', quest_result)
	return quest_result

func process_joke_quest():
	var result = randi_range(1, 20) + max(ability_bonus(charisma), ability_bonus(wisdom))
	quest_result = max(0, result)
	print(quest_result)
	if quest_result > 0:
		update_inventory.emit('joke', quest_result)
	return quest_result

func process_invitation_quest():
	var result = randi_range(1, 20) + max(ability_bonus(charisma), ability_bonus(constitution))
	quest_result = max(0, result)
	print(quest_result)
	if quest_result > 0:
		update_inventory.emit('invitation', quest_result)
	return quest_result

func pay_reward():
	update_inventory.emit('gold', -quest_cost)

func ability_bonus(points: int) -> int:
	return (points - 10) / 2

func calc_score():
	var _visitors = min(invitation, chair)
	var total_score = round(joke * (_visitors - min(0, food - _visitors) * .25) + max(0, invitation - _visitors) * .25)
