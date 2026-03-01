extends Control

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# Prevents the user from spamming the button while the fade is happening
var is_transitioning: bool = false 

func _on_continue_pressed() -> void:
	# Ignore clicks if an animation is currently playing
	if is_transitioning:
		return
		
	if animated_sprite_2d.frame < 5:
		_fade_to_next_frame()
	else:
		get_tree().change_scene_to_file("res://scenes/game.tscn")

func _fade_to_next_frame() -> void:
	is_transitioning = true
	
	# 1. Create a temporary Sprite2D to hold the current image
	var temp_sprite = Sprite2D.new()
	var current_anim = animated_sprite_2d.animation
	var current_frame = animated_sprite_2d.frame
	
	# Extract the texture of the frame we are currently looking at
	temp_sprite.texture = animated_sprite_2d.sprite_frames.get_frame_texture(current_anim, current_frame)
	
	# Match the temporary sprite's transform to the AnimatedSprite2D
	temp_sprite.global_position = animated_sprite_2d.global_position
	temp_sprite.scale = animated_sprite_2d.scale
	temp_sprite.centered = animated_sprite_2d.centered
	
	# Add it to the scene tree right above the AnimatedSprite2D
	add_child(temp_sprite)
	
	# 2. Advance the actual AnimatedSprite2D to the next panel (hidden behind temp_sprite)
	animated_sprite_2d.frame += 1
	
	# 3. Create the Tween to fade out the temporary sprite
	var tween = create_tween()
	# Tweens the alpha (transparency) to 0.0 over 0.5 seconds
	tween.tween_property(temp_sprite, "modulate:a", 0.0, 0.5) 
	
	# 4. Clean up once the fade is done
	tween.finished.connect(func():
		temp_sprite.queue_free()
		is_transitioning = false
	)
	
