extends SubViewport
class_name SubviewAnimationCursor

@export var enable:bool = true:
	set(value):
		enable = value
		
		if not is_node_ready():
			await ready
		
		if not enable:
			## TODO: 恢复默认？
			cursor_animated_sprite2d.stop()

@export var cursor_animated_sprite2d:AnimatedSprite2D:
	set(value):
		cursor_animated_sprite2d = value
		
		if not is_node_ready():
			await ready
		
		if not cursor_animated_sprite2d.animation_changed.is_connected(_on_animated_sprite_2d_animation_changed):
			cursor_animated_sprite2d.animation_changed.connect(_on_animated_sprite_2d_animation_changed)
		if not cursor_animated_sprite2d.animation_finished.is_connected(_on_animated_sprite_2d_animation_finished):
			cursor_animated_sprite2d.animation_changed.connect(_on_animated_sprite_2d_animation_finished)
		_on_animated_sprite_2d_animation_changed()
		_on_animated_sprite_2d_animation_finished()

func _ready() -> void:
	if cursor_animated_sprite2d == null:
		push_error("没有配置 cursor_animated_sprite2d 节点")
	transparent_bg = true
	disable_3d = true
	render_target_update_mode = SubViewport.UPDATE_ALWAYS
	
	await get_tree().create_timer(2.0).timeout
	play("runing")

func _process(_delta: float) -> void:
	if not enable:
		return
	
	var new_texture = ImageTexture.create_from_image(get_texture().get_image())
	## 强制为中心位置，暂无更好解决方法
	Input.set_custom_mouse_cursor(new_texture,Input.CursorShape.CURSOR_ARROW , _get_curr_animtion_frame_texture_size() / 2.0)
	update_mouse_cursor_state()

func play(anima_name:String):
	if not cursor_animated_sprite2d.sprite_frames.get_animation_names().has(anima_name):
		assert(false,"anima_name 不存在！请检查名称！")
		return
	cursor_animated_sprite2d.play(anima_name)

func _get_curr_animtion_frame_texture_size()->Vector2:
	return cursor_animated_sprite2d.sprite_frames.get_frame_texture(cursor_animated_sprite2d.animation,cursor_animated_sprite2d.frame).get_size() * cursor_animated_sprite2d.scale

func _on_animated_sprite_2d_animation_changed() -> void:
	size = _get_curr_animtion_frame_texture_size()

func _on_animated_sprite_2d_animation_finished() -> void:
	pass # Replace with function body.
