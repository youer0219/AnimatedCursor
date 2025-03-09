extends Node

## 如果是通过这种方式访问，建议设置全局类名。
@onready var animated_cursor: SubViewport = $AnimatedCursor

func _ready() -> void:
	_test_animated_cursor()

func _test_animated_cursor():
	print("======  开始测试  ======")
	print("默认鼠标动画（example01）自动加载")
	print("===  等待5S后切换鼠标动画  ===")
	print("")
	await get_tree().create_timer(5.0).timeout
	animated_cursor.play_cursor_animation("example02")
	print("切换到 example02 动画")
	print("特点： 切换了鼠标模式。鼠标无法移出屏幕外。")
	print("===  等待5S后切换鼠标动画  ===")
	print("")
	await get_tree().create_timer(5.0).timeout
	animated_cursor.play_cursor_animation("example03")
	print("特点： 动画持续0.6s。播放完毕后调用方法跳转到example02动画")
	print("===  等待5S后切换鼠标动画  ===")
	print("")
	await get_tree().create_timer(5.0).timeout
	animated_cursor.play_cursor_animation("example01",-1,2.0)
	print("重新切换到 example01 动画，并添加新的参数")
	print("特点： 动画速度翻倍")
	print("===  等待5S后禁用动画鼠标功能  ===")
	print("")
	await get_tree().create_timer(5.0).timeout
	animated_cursor.enable = false
	print("已禁用动画鼠标功能")
	print("===  等待5S后启动动画鼠标功能  ===")
	print("")
	await get_tree().create_timer(5.0).timeout
	animated_cursor.enable = true
	print("已启动动画鼠标功能")
	print("默认从自动加载的鼠标动画开始")
	await get_tree().create_timer(1.0).timeout
	print("")
	print("======  测试结束  ======")
