# Animated Cursor for Godot 4

[中文文档](README_zh.md) | [English Documentation](README.md)

## 功能简介
本组件通过`SubViewport`和`AnimationPlayer`实现动态鼠标光标效果。支持自定义动画、光标模式切换。

---

## 工作原理
1. **渲染流程**  
   - 使用`SubViewport`作为画布，实时渲染2D子节点的动画内容。
   - 通过`ImageTexture`将当前帧画面捕获为鼠标贴图。

2. **动画驱动**  
   - 通过`AnimationPlayer`控制光标的动态效果，支持多动画切换。
   - 播放动画时，每帧更新鼠标贴图实现动态效果。

3. **模式控制**  
   - 支持`Input.CursorShape`定义光标类型。
   - 可设置`MouseMode`控制光标可见性/锁定状态。

---

## 配置步骤

### 1. 场景配置
- 添加`SubViewport`节点并挂载`animated_cursor.gd`脚本。
- 在SubViewport下添加**2D节点**（如Sprite/AnimatedSprite）作为光标图形。

### 2. 动画配置
- 关联一个`AnimationPlayer`节点。
- 创建动画：
  - 默认动画：设置`AnimationPlayer`自动加载的动画作为默认鼠标动画。
  - 禁用动画：默认命名为`RESET`。
- 建议参考demo的动画进行配置，注意：
    - AnimatedCursor 的 size 属性应该与实际表现的图像大小一致，一般是图像实际大小 * 缩放系数
    - 避免size超过鼠标光标的限制大小。其实际大小必须小于等于 256×256。为了避免渲染问题，建议使用小于等于 128×128 的大小。
        - 在网络平台上，光标图像允许的最大尺寸为 128×128。 出于安全原因  ，只有当鼠标光标图像完全位于页面内时，大于 32×32 的光标图像才会显示。
    - 合理设置要显示的Node2D（一般是Sprite2D）节点的位置，要求位于subviewport显示的正中央，也就是size的中心位置。
    - 可以利用AnimationPlayer自带的复制粘贴轨道功能来快速完成动画设置
- 可以在编辑器中实时查看 subviewport 的显示以确定动画配置是否正确。

### 3. 参数说明（导出变量）
| 属性 | 说明 |
|------|------|
| `enable` | 总开关，禁用时恢复系统光标 |
| `cursor_host_offect` | 贴图中心偏移量（向右下为正） |
| `disable_anima_name` | 默认的禁用时的鼠标动画名称 |
| `curr_cursor_shape` | 光标类型 |
| `curr_cursor_mode` | 光标模式 |

---

## 使用方法
```gdscript
# 播放指定动画（支持速度/混合参数）
animated_cursor.play_cursor_animation("anim_name", -1, 2.0)

# 动态切换开关
animated_cursor.enable = false  # 恢复系统光标
```


---

## 示例说明
`animated_cursor_demo.gd`演示了：
1. 自动播放默认动画
2. 定时切换不同动画（含变速播放）
3. 禁用/启用的完整流程

运行示例后，控制台将输出操作日志，建议直接体验效果。

---

## 注意事项
⚠️ **必需配置**
- 必须包含至少一个2D子节点。一般是Sprite2D节点。
- 必须指定有效的`AnimationPlayer`并正确配置动画

❗ **常见问题**
- 编辑器内不生效：确保在运行时测试
- 动画不更新：检查`UPDATE_ALWAYS`模式是否启用
- 无光标显示：检查subviewport的size大小是否匹配图像
- 3D节点无效：组件强制禁用3D渲染

🔧 配置错误会在Godot编辑器下方显示黄色警告提示！
