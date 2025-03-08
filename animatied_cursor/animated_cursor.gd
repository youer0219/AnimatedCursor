@tool
extends SubViewport
# name AnimatedCursor

@export var enable:bool = true:set = _set_enable

@export var animation_player:AnimationPlayer

## 与图像中心的偏移大小
@export var cursor_host_offect:Vector2 = Vector2.ZERO
## 默认的禁用动画的名称
@export var disable_anima_name:String = "RESET"


func _ready() -> void:
	_set_subviewport()
	
	await get_tree().create_timer(4.0).timeout
	animation_player.play("example")

func play_cursor_animation(animation_name:StringName = &"", custom_blend: float = -1, custom_speed: float = 1.0, from_end: bool = false):
	## 缺少对 animation_name 的检查。暂时没有好的方法。但不会造成崩溃。
	animation_player.play(animation_name,custom_blend,custom_speed,from_end)

func _process(_delta: float) -> void:
	_update_cursor()

func _update_cursor():
	if not enable:
		return
	
	## TODO:如何检查图像是否为空白，避免无光标？
	
	## TODO:目前只考虑了默认的指向鼠标，没有考虑好如何利用不同种类的鼠标
	## 补充：无思路。统一为 CURSOR_ARROW 类型设置自定义鼠标可能更好。

	var new_texture = ImageTexture.create_from_image(get_texture().get_image())
	Input.set_custom_mouse_cursor(new_texture,Input.CursorShape.CURSOR_ARROW,new_texture.get_size()/2.0 + cursor_host_offect)
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
		animation_player.play(animation_player.autoplay)

func _get_configuration_warnings():
	var warnings = []
	
	if animation_player.autoplay == "":
		warnings.append("animation_player 应该指定自动加载动画作为默认鼠标动画")
	
	return warnings

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_EDITOR_POST_SAVE:
			update_configuration_warnings()
