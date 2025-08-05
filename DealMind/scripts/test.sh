#!/bin/bash

# DealMind Swift 项目测试脚本
# 简化版本，替代复杂的MCP配置

# 设置颜色输出
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 打印消息函数
print_message() {
    echo -e "${GREEN}[TEST] $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}[WARNING] $1${NC}"
}

print_error() {
    echo -e "${RED}[ERROR] $1${NC}"
}

print_info() {
    echo -e "${BLUE}[INFO] $1${NC}"
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

# 运行单元测试
run_unit_tests() {
    print_message "开始运行单元测试..."
    
    local coverage_flag=""
    if [ "$1" = "coverage" ]; then
        coverage_flag="-enableCodeCoverage YES"
        print_info "启用代码覆盖率"
    fi
    
    xcodebuild test \
        -project "$WORKSPACE_PATH" \
        -scheme "$SCHEME" \
        -destination 'platform=iOS Simulator,name=iPhone 15' \
        $coverage_flag
    
    if [ $? -eq 0 ]; then
        print_message "单元测试通过! ✅"
    else
        print_error "单元测试失败! ❌"
        exit 1
    fi
}

# 运行UI测试
run_ui_tests() {
    print_message "开始运行UI测试..."
    
    xcodebuild test \
        -project "$WORKSPACE_PATH" \
        -scheme "$SCHEME" \
        -destination 'platform=iOS Simulator,name=iPhone 15' \
        -only-testing:DealMindUITests
    
    if [ $? -eq 0 ]; then
        print_message "UI测试通过! ✅"
    else
        print_error "UI测试失败! ❌"
        exit 1
    fi
}

# 运行所有测试
run_all_tests() {
    print_message "开始运行所有测试..."
    
    local coverage_flag=""
    if [ "$1" = "coverage" ]; then
        coverage_flag="-enableCodeCoverage YES"
        print_info "启用代码覆盖率"
    fi
    
    xcodebuild test \
        -project "$WORKSPACE_PATH" \
        -scheme "$SCHEME" \
        -destination 'platform=iOS Simulator,name=iPhone 15' \
        $coverage_flag
    
    if [ $? -eq 0 ]; then
        print_message "所有测试通过! ✅"
        
        if [ "$1" = "coverage" ]; then
            print_info "代码覆盖率报告已生成"
            print_info "查看路径: ~/Library/Developer/Xcode/DerivedData/DealMind-*/Logs/Test/"
        fi
    else
        print_error "测试失败! ❌"
        exit 1
    fi
}

# 显示帮助
show_help() {
    echo "DealMind Swift 项目测试脚本"
    echo ""
    echo "用法: $0 [测试类型] [选项]"
    echo ""
    echo "测试类型:"
    echo "  unit      只运行单元测试"
    echo "  ui        只运行UI测试"
    echo "  all       运行所有测试 (默认)"
    echo ""
    echo "选项:"
    echo "  coverage  启用代码覆盖率"
    echo ""
    echo "示例:"
    echo "  $0              # 运行所有测试"
    echo "  $0 unit         # 只运行单元测试"
    echo "  $0 ui           # 只运行UI测试"
    echo "  $0 all coverage # 运行所有测试并生成覆盖率报告"
    echo ""
}

# 主函数
main() {
    case "${1:-all}" in
        -h|--help)
            show_help
            exit 0
            ;;
        unit)
            check_project
            run_unit_tests "$2"
            ;;
        ui)
            check_project
            run_ui_tests "$2"
            ;;
        all)
            check_project
            run_all_tests "$2"
            ;;
        *)
            print_error "未知的测试类型: $1"
            show_help
            exit 1
            ;;
    esac
}

# 运行脚本
main "$@" 