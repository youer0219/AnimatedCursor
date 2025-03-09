@tool
extends SubViewport
# class_name AnimatedCursor

## 未启动时恢复默认鼠标样式。注意，如果animation_player配置有误，即使启动也可能不工作！
@export var enable:bool = true:set = _set_enable
## 配置鼠标动画的节点
@export var animation_player:AnimationPlayer
## 默认的禁用动画的名称
@export var disable_anima_name:String = "RESET"

@export_group("通过 AnimationPlayer 配置")
## 与图像中心的偏移大小。向右向下为正。
@export var cursor_host_offect:Vector2 = Vector2.ZERO
## 鼠标类型
@export var curr_cursor_shape:Input.CursorShape = Input.CursorShape.CURSOR_ARROW
## 控制鼠标模式
@export var curr_cursor_mode:Input.MouseMode = Input.MouseMode.MOUSE_MODE_VISIBLE

func _ready() -> void:
	assert(animation_player,"未配置 AnimationPlayer 节点。无法正常工作！")
	_set_subviewport()

func play_cursor_animation(animation_name:StringName = &"", custom_blend: float = -1, custom_speed: float = 1.0, from_end: bool = false):
	## 缺少对 animation_name 的检查。暂时没有好的方法。但不会造成崩溃。
	animation_player.play(animation_name,custom_blend,custom_speed,from_end)

func _process(_delta: float) -> void:
	_update_cursor()

func _update_cursor():
	## 避免影响编辑器中的鼠标
	if Engine.is_editor_hint():
		return
	
	if not enable:
		return
	
	if animation_player == null:
		push_warning(name + " animation_player 为空。无法正常工作！")
		return
	
	## 禁用动画播放时不启动功能。默认的无效动画名称（""）表明没有启动动画，也不启动功能。
	if animation_player.current_animation == disable_anima_name or animation_player.current_animation == "":
		return
	
	var new_texture = ImageTexture.create_from_image(get_texture().get_image())
	## WARNING: 需要确保 size 的大小与实际要展示的 texture 匹配。
	Input.set_custom_mouse_cursor(new_texture,curr_cursor_shape,size/2.0 + cursor_host_offect)
	assert(curr_cursor_mode != 5,"错误的 curr_cursor_mode 数据！请不要设置为 MOUSE_MODE_MAX 模式")
	Input.mouse_mode = curr_cursor_mode
	update_mouse_cursor_state()

func _set_subviewport():
	transparent_bg = true
	disable_3d = true
	render_target_update_mode = SubViewport.UPDATE_ALWAYS

func _set_enable(value:bool):
	enable = value
	
	if not is_node_ready():
		await ready
	
	if not enable:
		animation_player.play(disable_anima_name)
		Input.set_custom_mouse_cursor(null)
	else:
		## 目前禁用后重新启用，使用的是场景自动加载动画
		## 如有需求，也可以使用 assigned_animation 属性，其可以用来记录上一次运行的动画
		animation_player.play(animation_player.autoplay)

func _get_configuration_warnings():
	var warnings = []
	
	if get_children().size() == 0:
		warnings.append("请添加一个用于显示的2D节点")
	else:
		var has_node_2d_child:bool = false
		var has_node_3d_child:bool = false
		
		for child in get_children():
			if child.is_class("Node2D"):
				has_node_2d_child = true
			if child.is_class("Node3D"):
				has_node_3d_child = true
		
		if not has_node_2d_child:
			warnings.append("请添加一个用于显示的2D节点")
		
		if has_node_3d_child:
			warnings.append("3D渲染已被禁用，不建议使用Node3D节点")
	
	if animation_player == null:
		warnings.append("应当指定 animation_player,否则无法正常工作")
	else:
		if animation_player.autoplay == "":
			warnings.append("animation_player 应该指定自动加载动画作为默认鼠标动画并保存")
	
	return warnings

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_EDITOR_POST_SAVE:
			update_configuration_warnings()
