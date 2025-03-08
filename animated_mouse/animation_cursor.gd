@tool
extends SubViewport

@export var enable:bool = true:
	set(value):
		enable = value
		
		if not is_node_ready():
			await ready
		
		#if not enable:
			### TODO: 恢复默认？
			#cursor_animated_sprite2d.stop()

@export var sprite_frames:SpriteFrames = SpriteFrames.new()

@onready var cursor_animated_sprite_2d: AnimatedSprite2D = $CursorAnimatedSprite2D


func _ready() -> void:
	transparent_bg = true
	disable_3d = true
	render_target_update_mode = SubViewport.UPDATE_ALWAYS
	
	cursor_animated_sprite_2d.sprite_frames = sprite_frames
	cursor_animated_sprite_2d.animation_changed.connect(_on_animated_sprite_2d_animation_changed)
	#cursor_animated_sprite_2d.animation_changed.connect(_on_animated_sprite_2d_animation_finished)
	_on_animated_sprite_2d_animation_changed()
	#_on_animated_sprite_2d_animation_finished()
	
	play("runing")

func _process(_delta: float) -> void:
	if not enable:
		return
	
	if Engine.is_editor_hint():
		if cursor_animated_sprite_2d.sprite_frames != sprite_frames:
			cursor_animated_sprite_2d.sprite_frames = sprite_frames
	
	if sprite_frames == null:
		return
	
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

func _get_configuration_warnings():
	var warnings = []
	
	return warnings

## 目前问题：希望有一个简单的易配置的动画节点完成动画工作
## 与外界通信的方式
## 我现在可以不需要连续执行动画的能力，但我需要配置不同动画的不同鼠标特性
