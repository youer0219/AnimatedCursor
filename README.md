# Animated Cursor for Godot 4

[中文文档](README_zh.md) | [English Documentation](README.md)

## Feature Overview
This component implements dynamic mouse cursor effects using `SubViewport` and `AnimationPlayer`. Supports custom animations and cursor mode switching.

---

## Implementation Principle
1. **Rendering Pipeline**  
   • Uses `SubViewport` as canvas for real-time rendering of 2D child node animations.
   • Captures current frame via `ImageTexture` as cursor texture.

2. **Animation Driver**  
   • Controls cursor animations through `AnimationPlayer`, supporting multi-animation switching.
   • Updates cursor texture frame-by-frame during animation playback.

3. **Mode Control**  
   • Supports `Input.CursorShape` defined cursor types.
   • Configurable `MouseMode` for cursor visibility/lock states.

---

## Configuration Guide

### 1. Scene Setup
• Add `SubViewport` node and attach `animated_cursor.gd` script.
• Add **2D nodes** (e.g. Sprite/AnimatedSprite) under SubViewport as cursor graphics.

### 2. Animation Configuration
• Link an `AnimationPlayer` node.
• Create animations:
  • Default animation: Set automatically loaded animation in `AnimationPlayer` as default.
  • Disabled animation: Default named `RESET`.
• Recommended to reference demo animations. Notes:
    ◦ AnimatedCursor's `size` property should match actual graphic size (typically image size * scale factor)
    ◦ Avoid sizes exceeding cursor limits. Max allowed size ≤256×256. Recommended ≤128×128 for stability.
        ▪ Web platforms enforce 128×128 maximum. Cursors >32×32 only display when fully within page boundaries for security.
    ◦ Position Node2D elements (e.g. Sprite2D) at SubViewport center (size/2 coordinates).
    ◦ Use AnimationPlayer's track copy/paste feature for efficient animation setup.
• Preview SubViewport display in-editor to verify animations.

### 3. Parameter Reference (Exported Variables)
| Property | Description |
|------|------|
| `enable` | Master switch - disables component when off |
| `cursor_host_offset` | Texture center offset (positive values = right/down) |
| `disable_anima_name` | Animation name for disabled state |
| `curr_cursor_shape` | Cursor type |
| `curr_cursor_mode` | Cursor mode |

---

## Usage
```gdscript
# Play specific animation (supports speed/blend params)
animated_cursor.play_cursor_animation("anim_name", -1, 2.0)

# Runtime toggle
animated_cursor.enable = false  # Restores system cursor
```

---

## Demo Overview
`animated_cursor_demo.gd` demonstrates:
1. Auto-playing default animation
2. Timed animation switching (with speed variations)
3. Full disable/enable workflow

Runtime console outputs operation logs. Recommended to test directly.

---

## Important Notes
⚠️ **Required Config**
• Must contain at least one 2D child node (typically Sprite2D)
• Must have valid `AnimationPlayer` with properly configured animations

❗ **Troubleshooting**
• Editor preview failure: Test in runtime
• Animation not updating: Verify `UPDATE_ALWAYS` mode
• Missing cursor: Check SubViewport size matches graphic dimensions
• 3D nodes invalid: Component forcibly disables 3D rendering

🔧 Configuration errors show yellow warnings in Godot editor bottom panel!

---

🔧 The content comes from the AI's translation of the Chinese document, hopefully this is accurate.
