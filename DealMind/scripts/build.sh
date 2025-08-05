#!/bin/bash

# DealMind Swift 项目构建脚本
# 简化版本，替代复杂的MCP配置

# 设置颜色输出
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 打印消息函数
print_message() {
    echo -e "${GREEN}[BUILD] $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}[WARNING] $1${NC}"
}

print_error() {
    echo -e "${RED}[ERROR] $1${NC}"
}

# 项目配置
PROJECT_NAME="DealMind"
SCHEME="DealMind"
WORKSPACE_PATH="DealMind.xcodeproj"

# 检查Xcode项目
check_project() {
    if [ ! -d "$WORKSPACE_PATH" ]; then
        print_error "找不到Xcode项目: $WORKSPACE_PATH"
        exit 1
    fi
    print_message "找到Xcode项目: $WORKSPACE_PATH"
}

# 构建项目
build_project() {
    local scheme="${1:-$SCHEME}"
    local configuration="${2:-Debug}"
    
    print_message "开始构建项目..."
    print_message "方案: $scheme"
    print_message "配置: $configuration"
    
    # 清理项目
    if [ "$3" = "clean" ]; then
        print_message "清理项目..."
        xcodebuild clean -project "$WORKSPACE_PATH" -scheme "$scheme" -configuration "$configuration"
    fi
    
    # 构建项目
    xcodebuild build -project "$WORKSPACE_PATH" -scheme "$scheme" -configuration "$configuration" -destination 'platform=iOS Simulator,name=iPhone 15'
    
    if [ $? -eq 0 ]; then
        print_message "构建成功! ✅"
    else
        print_error "构建失败! ❌"
        exit 1
    fi
}

# 显示帮助
show_help() {
    echo "DealMind Swift 项目构建脚本"
    echo ""
    echo "用法: $0 [方案] [配置] [clean]"
    echo ""
    echo "参数:"
    echo "  方案      构建方案 (默认: $SCHEME)"
    echo "  配置      构建配置 Debug/Release (默认: Debug)"
    echo "  clean     构建前清理项目"
    echo ""
    echo "示例:"
    echo "  $0                    # 使用默认配置构建"
    echo "  $0 DealMind Debug     # 指定方案和配置"
    echo "  $0 DealMind Release   # Release版本"
    echo "  $0 DealMind Debug clean # 清理后构建"
    echo ""
}

# 主函数
main() {
    case "${1:-}" in
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            check_project
            build_project "$1" "$2" "$3"
            ;;
    esac
}

# 运行脚本
main "$@" 