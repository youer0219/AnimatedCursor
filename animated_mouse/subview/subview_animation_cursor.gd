@tool
extends SubViewport
class_name SubviewAnimationCursor

@export var enable:bool = true:
	set(value):
		enable = value
		
		if not is_node_ready():
			await ready
		
		#if not enable:
			### TODO: 恢复默认？
			#cursor_animated_sprite2d.stop()

@export var sprite_frames:SpriteFrames = SpriteFrames.new()
@export var cursor_animation_data_array:Array[CursorAnimationData]

@onready var cursor_animated_sprite_2d: AnimatedSprite2D = $CursorAnimatedSprite2D


func _ready() -> void:
	transparent_bg = true
	disable_3d = true
	render_target_update_mode = SubViewport.UPDATE_ALWAYS

	cursor_animated_sprite_2d.animation_changed.connect(_on_animated_sprite_2d_animation_changed)
	cursor_animated_sprite_2d.animation_changed.connect(_on_animated_sprite_2d_animation_finished)
	_on_animated_sprite_2d_animation_changed()
	_on_animated_sprite_2d_animation_finished()

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
	if not cursor_animated_sprite_2d.sprite_frames.get_animation_names().has(anima_name):
		assert(false,"anima_name 不存在！请检查名称！")
		return
	cursor_animated_sprite_2d.play(anima_name)

func _get_curr_animtion_frame_texture_size()->Vector2:
	return cursor_animated_sprite_2d.sprite_frames.get_frame_texture(cursor_animated_sprite_2d.animation,cursor_animated_sprite_2d.frame).get_size() * cursor_animated_sprite_2d.scale

func _on_animated_sprite_2d_animation_changed() -> void:
	size = _get_curr_animtion_frame_texture_size()

func _on_animated_sprite_2d_animation_finished() -> void:
	pass # Replace with function body.

func _get_cursor_animation_data_names()->Array[StringName]:
	var cursor_animation_data_names:Array[StringName] = []
	for cursor_animation_data:CursorAnimationData in cursor_animation_data_array:
		cursor_animation_data_names.append(cursor_animation_data.name)
	return cursor_animation_data_names

func _get_configuration_warnings():
	var warnings = []
	
	## 检查 sprite_frames 配置 和 name 是否统一
	if sprite_frames == null:
		warnings.append("请生成一个 sprite_frames ")
	else:
		var anima_names = sprite_frames.get_animation_names()
		if anima_names.size() == 0:
			warnings.append("请在 sprite_frames 中配置动画效果")
		else:
			for corsor_anima_name:StringName in _get_cursor_animation_data_names():
				if not anima_names.has(corsor_anima_name):
					warnings.append("错误的name！请检查数据配置！")
					break
		
	
	## 可能的检查： 纹理大小 * 缩放系数 后是否满足条件
	
	return warnings
