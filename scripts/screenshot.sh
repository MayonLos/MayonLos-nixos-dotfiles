#!/usr/bin/env bash
# DWM 截图脚本 - 优化版
# 绑定到 Print Screen 键，支持选区截图、自动复制、通知

set -euo pipefail

# ================================
# 配置区
# ================================
BASE_DIR="$HOME/Pictures/Screenshots"
DATE_FORMAT="%Y-%m-%d"
TIME_FORMAT="%H%M%S"

# ================================
# 检查依赖
# ================================
check_deps() {
  for cmd in maim xclip; do
    command -v "$cmd" >/dev/null 2>&1 || {
      notify-send -u critical "截图失败" "缺少依赖: $cmd" 2>/dev/null || \
        echo "错误: 缺少 $cmd" >&2
      exit 1
    }
  done
}

# ================================
# 创建保存目录
# ================================
setup_directory() {
  local today
  today="$(date +"$DATE_FORMAT")"
  SAVE_DIR="$BASE_DIR/$today"
  mkdir -p "$SAVE_DIR"
}

# ================================
# 生成文件名
# ================================
generate_filename() {
  local timestamp
  timestamp="$(date +"$TIME_FORMAT")"
  FILE="$SAVE_DIR/screenshot_${timestamp}.png"
}

# ================================
# 清理空文件（截图取消时）
# ================================
cleanup() {
  if [[ -f $FILE && ! -s $FILE ]]; then
    rm -f "$FILE"
  fi
}

# ================================
# 主截图逻辑
# ================================
take_screenshot() {
  # 选区截图（-u 隐藏选区边框，-m 指定显示器）
  if maim -s -u -m 10 "$FILE" 2>/dev/null; then
    # 复制到剪贴板
    xclip -selection clipboard -t image/png -i "$FILE" &
    
    # 获取相对路径（更快的方式）
    local rel_path="${FILE#$HOME/}"
    
    # 发送通知（使用原始格式）
    notify-send -u low "📸 截图完成" \
      "保存: ~/$rel_path\n已复制到剪贴板"
    
    return 0
  else
    # 用户取消截图
    return 1
  fi
}

# ================================
# 主流程
# ================================
main() {
  check_deps
  setup_directory
  generate_filename
  
  trap cleanup EXIT
  
  take_screenshot
}

main "$@"
