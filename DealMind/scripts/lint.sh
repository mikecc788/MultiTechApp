#!/bin/bash

# DealMind Swift 项目代码检查脚本
# 简化版本，替代复杂的MCP配置

# 设置颜色输出
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 打印消息函数
print_message() {
    echo -e "${GREEN}[LINT] $1${NC}"
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

# 检查SwiftLint是否安装
check_swiftlint() {
    if ! command -v swiftlint &> /dev/null; then
        print_error "SwiftLint 未安装"
        print_info "请运行: brew install swiftlint"
        exit 1
    fi
    print_message "SwiftLint 已安装: $(swiftlint version)"
}

# 创建SwiftLint配置文件
create_swiftlint_config() {
    if [ ! -f ".swiftlint.yml" ]; then
        print_warning "未找到 .swiftlint.yml 配置文件"
        print_info "创建基本配置文件..."
        
        cat > .swiftlint.yml << EOF
# SwiftLint 配置文件
# 包含的文件路径
included:
  - DealMind/
  - DealMindTests/
  - DealMindUITests/

# 排除的文件路径
excluded:
  - Pods/
  - DealMind.xcodeproj/
  - DealMind/Resources/

# 启用的规则
opt_in_rules:
  - empty_count
  - force_unwrapping
  - private_outlet
  - redundant_nil_coalescing
  - first_where
  - contains_over_first_not_nil

# 禁用的规则
disabled_rules:
  - line_length
  - function_body_length
  - type_body_length
  - file_length

# 规则配置
empty_count:
  severity: error

force_unwrapping:
  severity: warning

private_outlet:
  allow_private_set: true

trailing_whitespace:
  ignores_empty_lines: true
  ignores_comments: true
EOF
        
        print_message "已创建 .swiftlint.yml 配置文件"
    else
        print_message "找到 .swiftlint.yml 配置文件"
    fi
}

# 运行SwiftLint检查
run_lint() {
    local path="${1:-.}"
    local strict="${2:-false}"
    
    print_message "开始代码检查..."
    print_info "检查路径: $path"
    
    local strict_flag=""
    if [ "$strict" = "true" ]; then
        strict_flag="--strict"
        print_info "启用严格模式"
    fi
    
    swiftlint lint $strict_flag "$path"
    
    local exit_code=$?
    if [ $exit_code -eq 0 ]; then
        print_message "代码检查通过! ✅"
    else
        print_error "发现代码问题! ❌"
        print_info "请查看上面的详细信息"
        return $exit_code
    fi
}

# 自动修复代码问题
auto_fix() {
    local path="${1:-.}"
    
    print_message "开始自动修复代码问题..."
    print_info "修复路径: $path"
    
    swiftlint --fix "$path"
    
    if [ $? -eq 0 ]; then
        print_message "自动修复完成! ✅"
        print_info "请检查修复后的代码"
    else
        print_error "自动修复失败! ❌"
        return 1
    fi
}

# 生成规则文档
generate_rules_doc() {
    print_message "生成SwiftLint规则文档..."
    
    swiftlint rules > swiftlint-rules.md
    
    if [ $? -eq 0 ]; then
        print_message "规则文档已生成: swiftlint-rules.md ✅"
    else
        print_error "生成规则文档失败! ❌"
        return 1
    fi
}

# 显示帮助
show_help() {
    echo "DealMind Swift 项目代码检查脚本"
    echo ""
    echo "用法: $0 [命令] [选项]"
    echo ""
    echo "命令:"
    echo "  check     检查代码质量 (默认)"
    echo "  fix       自动修复可修复的问题"
    echo "  rules     生成规则文档"
    echo "  config    创建配置文件"
    echo ""
    echo "选项:"
    echo "  --path <路径>     指定检查路径 (默认: .)"
    echo "  --strict          启用严格模式"
    echo ""
    echo "示例:"
    echo "  $0                      # 检查所有代码"
    echo "  $0 check --strict       # 严格模式检查"
    echo "  $0 fix                  # 自动修复问题"
    echo "  $0 --path DealMind/     # 检查特定目录"
    echo "  $0 rules                # 生成规则文档"
    echo ""
}

# 主函数
main() {
    local command="check"
    local path="."
    local strict="false"
    
    # 解析参数
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            check|fix|rules|config)
                command="$1"
                shift
                ;;
            --path)
                path="$2"
                shift 2
                ;;
            --strict)
                strict="true"
                shift
                ;;
            *)
                if [[ "$1" =~ ^-- ]]; then
                    print_error "未知选项: $1"
                    show_help
                    exit 1
                else
                    # 如果不是选项，假设是命令
                    command="$1"
                    shift
                fi
                ;;
        esac
    done
    
    # 检查SwiftLint
    check_swiftlint
    
    # 执行相应命令
    case "$command" in
        check)
            create_swiftlint_config
            run_lint "$path" "$strict"
            ;;
        fix)
            create_swiftlint_config
            auto_fix "$path"
            ;;
        rules)
            generate_rules_doc
            ;;
        config)
            create_swiftlint_config
            ;;
        *)
            print_error "未知命令: $command"
            show_help
            exit 1
            ;;
    esac
}

# 运行脚本
main "$@" 