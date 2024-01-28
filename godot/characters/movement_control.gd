extends Node2D

@onready var parent = get_parent() as CharacterBody2D

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		parent.set_animation('run')
		parent.velocity.x = direction * parent.SPEED
		var _flip = direction < 0
		for item in [parent.baseSprite, parent.hairSprite, parent.toolsSprite]:
			item.flip_h = _flip
	else:
		parent.set_animation('idle')
		parent.velocity.x = move_toward(parent.velocity.x, 0, parent.SPEED)

	parent.move_and_slide()
