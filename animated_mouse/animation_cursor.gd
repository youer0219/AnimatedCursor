@tool
extends SubViewport


@export var sprite_frames:SpriteFrames = SpriteFrames.new()
@export var default_cursor_image:Texture2D
@onready var cursor_animated_sprite_2d: AnimatedSprite2D = $CursorAnimatedSprite2D


func _ready() -> void:
	transparent_bg = true
	disable_3d = true
	render_target_update_mode = SubViewport.UPDATE_ALWAYS
	
	Input.set_custom_mouse_cursor(default_cursor_image,Input.CURSOR_ARROW,default_cursor_image.get_size()/2.0)
	
	cursor_animated_sprite_2d.sprite_frames = sprite_frames
	cursor_animated_sprite_2d.animation_changed.connect(_on_animated_sprite_2d_animation_changed)
	_on_animated_sprite_2d_animation_changed()
	
	play("runing")

func _process(_delta: float) -> void:
	
	if Engine.is_editor_hint():
		if cursor_animated_sprite_2d.sprite_frames != sprite_frames:
			cursor_animated_sprite_2d.sprite_frames = sprite_frames
	
	if sprite_frames == null:
		return
	
	if cursor_animated_sprite_2d.is_playing():
		var new_texture = ImageTexture.create_from_image(get_texture().get_image())
		## 强制为中心位置，暂无更好解决方法
		Input.set_custom_mouse_cursor(new_texture,Input.CursorShape.CURSOR_ARROW , _get_curr_animtion_frame_texture_size() / 2.0)
		update_mouse_cursor_state()

func play(anima_name:String):
	if not sprite_frames.get_animation_names().has(anima_name):
		push_warning("无效的动画名称！请检查代码！")
		return
	
	cursor_animated_sprite_2d.play(anima_name)

func _get_curr_animtion_frame_texture_size()->Vector2:
	return cursor_animated_sprite_2d.sprite_frames.get_frame_texture(cursor_animated_sprite_2d.animation,cursor_animated_sprite_2d.frame).get_size() * cursor_animated_sprite_2d.scale

func _on_animated_sprite_2d_animation_changed() -> void:
	size = _get_curr_animtion_frame_texture_size()
