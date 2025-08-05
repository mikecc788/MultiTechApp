#!/bin/bash

# DealMind Swift 项目设置脚本
# 简化版本，替代复杂的MCP配置

# 设置颜色输出
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 打印消息函数
print_message() {
    echo -e "${GREEN}[SETUP] $1${NC}"
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

# 检查系统要求
check_requirements() {
    print_message "检查系统要求..."
    
    # 检查macOS版本
    local macos_version=$(sw_vers -productVersion)
    print_info "macOS版本: $macos_version"
    
    # 检查Xcode
    if ! command -v xcodebuild &> /dev/null; then
        print_error "Xcode 未安装"
        print_info "请从App Store安装Xcode"
        exit 1
    fi
    
    local xcode_version=$(xcodebuild -version | head -n1)
    print_info "Xcode版本: $xcode_version"
    
    # 检查Swift
    if ! command -v swift &> /dev/null; then
        print_error "Swift 未安装"
        exit 1
    fi
    
    local swift_version=$(swift --version | head -n1)
    print_info "Swift版本: $swift_version"
    
    print_message "系统要求检查完成 ✅"
}

# 安装开发工具
install_tools() {
    print_message "安装开发工具..."
    
    # 检查Homebrew
    if ! command -v brew &> /dev/null; then
        print_warning "Homebrew 未安装"
        print_info "安装Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        print_info "Homebrew 已安装: $(brew --version | head -n1)"
    fi
    
    # 安装SwiftLint
    if ! command -v swiftlint &> /dev/null; then
        print_info "安装SwiftLint..."
        brew install swiftlint
    else
        print_info "SwiftLint 已安装: $(swiftlint version)"
    fi
    
    # 安装SwiftFormat (可选)
    if ! command -v swiftformat &> /dev/null; then
        print_info "安装SwiftFormat..."
        brew install swiftformat
    else
        print_info "SwiftFormat 已安装: $(swiftformat --version)"
    fi
    
    print_message "开发工具安装完成 ✅"
}

# 设置项目结构
setup_project_structure() {
    print_message "设置项目结构..."
    
    # 创建必要的目录
    local directories=(
        "DealMind/Models"
        "DealMind/Views"
        "DealMind/Controllers"
        "DealMind/Services"
        "DealMind/Utilities"
        "DealMind/Resources"
        "DealMind/ViewModels"
        "scripts"
        "docs"
        "tests"
    )
    
    for dir in "${directories[@]}"; do
        if [ ! -d "$dir" ]; then
            mkdir -p "$dir"
            print_info "创建目录: $dir"
        else
            print_info "目录已存在: $dir"
        fi
    done
    
    print_message "项目结构设置完成 ✅"
}

# 配置Git
setup_git() {
    print_message "配置Git..."
    
    # 检查是否已经是Git仓库
    if [ ! -d ".git" ]; then
        print_info "初始化Git仓库..."
        git init
    else
        print_info "Git仓库已存在"
    fi
    
    # 创建.gitignore文件
    if [ ! -f ".gitignore" ]; then
        print_info "创建.gitignore文件..."
        
        cat > .gitignore << 'EOF'
# Xcode
*.xcodeproj/*
!*.xcodeproj/project.pbxproj
!*.xcodeproj/xcshareddata/
!*.xcodeproj/project.xcworkspace/
*.xcworkspace/*
!*.xcworkspace/contents.xcworkspacedata
/*.gcno
**/xcshareddata/WorkspaceSettings.xcsettings

# Build
build/
DerivedData/

# Various settings
*.pbxuser
!default.pbxuser
*.mode1v3
!default.mode1v3
*.mode2v3
!default.mode2v3
*.perspectivev3
!default.perspectivev3
xcuserdata/

# Other
*.moved-aside
*.xccheckout
*.xcscmblueprint

# Obj-C/Swift specific
*.hmap
*.ipa
*.dSYM.zip
*.dSYM

# CocoaPods
Pods/

# Carthage
Carthage/Build/

# fastlane
fastlane/report.xml
fastlane/Preview.html
fastlane/screenshots/**/*.png
fastlane/test_output

# Code Injection
iOSInjectionProject/

# SwiftLint
swiftlint-rules.md

# macOS
.DS_Store
EOF
        
        print_message "已创建.gitignore文件"
    else
        print_info ".gitignore文件已存在"
    fi
    
    print_message "Git配置完成 ✅"
}

# 创建README文件
create_readme() {
    if [ ! -f "README.md" ]; then
        print_info "创建README.md文件..."
        
        cat > README.md << 'EOF'
# DealMind

DealMind 是一个使用 Swift 开发的现代化 iOS 应用程序。

## 项目结构

```
DealMind/
├── DealMind/           # 应用程序源代码
│   ├── Models/         # 数据模型
│   ├── Views/          # 视图文件
│   ├── Controllers/    # 控制器
│   ├── Services/       # 服务层
│   ├── Utilities/      # 工具类
│   ├── Resources/      # 资源文件
│   └── ViewModels/     # 视图模型
├── scripts/            # 构建脚本
├── docs/              # 文档
└── tests/             # 测试文件
```

## 开发环境要求

- macOS 12.0+
- Xcode 14.0+
- Swift 5.8+
- iOS 13.0+

## 快速开始

### 1. 克隆项目
```bash
git clone <repository-url>
cd DealMind
```

### 2. 设置项目
```bash
./scripts/setup.sh
```

### 3. 构建项目
```bash
./scripts/build.sh
```

### 4. 运行测试
```bash
./scripts/test.sh
```

### 5. 代码检查
```bash
./scripts/lint.sh
```

## 开发工具

### 构建脚本
- `scripts/build.sh` - 构建项目
- `scripts/test.sh` - 运行测试
- `scripts/lint.sh` - 代码质量检查
- `scripts/setup.sh` - 项目设置

### 代码质量
- 使用 SwiftLint 进行代码检查
- 遵循 Swift 官方编码规范
- 支持自动代码修复

### 测试
- 单元测试
- UI测试
- 代码覆盖率报告

## 项目规范

### 架构
- 采用 MVC 架构模式
- 使用 Core Data 进行数据持久化
- 支持依赖注入

### 代码风格
- 遵循 Swift API 设计指南
- 使用 SwiftLint 确保代码质量
- 优先使用 `let` 而非 `var`
- 使用 `guard` 语句进行早期退出

### 提交规范
- 使用语义化提交信息
- 每个功能一个分支
- 提交前运行测试和代码检查

## 许可证

[MIT License](LICENSE)

## 贡献

欢迎提交 Pull Request 和 Issue。

## 联系方式

- Email: contact@dealmind.com
- 项目主页: https://github.com/username/DealMind
EOF
        
        print_message "已创建README.md文件"
    else
        print_info "README.md文件已存在"
    fi
}

# 设置脚本权限
setup_script_permissions() {
    print_message "设置脚本执行权限..."
    
    local scripts=(
        "scripts/build.sh"
        "scripts/test.sh"
        "scripts/lint.sh"
        "scripts/setup.sh"
    )
    
    for script in "${scripts[@]}"; do
        if [ -f "$script" ]; then
            chmod +x "$script"
            print_info "已设置执行权限: $script"
        fi
    done
    
    print_message "脚本权限设置完成 ✅"
}

# 显示帮助
show_help() {
    echo "DealMind Swift 项目设置脚本"
    echo ""
    echo "用法: $0 [选项]"
    echo ""
    echo "选项:"
    echo "  -h, --help      显示帮助信息"
    echo "  --check-only    只检查系统要求"
    echo "  --tools-only    只安装开发工具"
    echo "  --git-only      只配置Git"
    echo ""
    echo "示例:"
    echo "  $0              # 完整设置"
    echo "  $0 --check-only # 只检查系统"
    echo "  $0 --tools-only # 只安装工具"
    echo ""
}

# 主函数
main() {
    case "${1:-}" in
        -h|--help)
            show_help
            exit 0
            ;;
        --check-only)
            check_requirements
            ;;
        --tools-only)
            check_requirements
            install_tools
            ;;
        --git-only)
            setup_git
            ;;
        *)
            # 完整设置
            print_message "开始DealMind项目设置..."
            check_requirements
            install_tools
            setup_project_structure
            setup_git
            create_readme
            setup_script_permissions
            print_message "项目设置完成! 🎉"
            print_info "现在您可以开始开发了!"
            print_info "运行 './scripts/build.sh' 来构建项目"
            ;;
    esac
}

# 运行脚本
main "$@" 