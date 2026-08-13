#!/usr/bin/env bash

set -Eeuo pipefail

# ============================================================
# Ubuntu 24.04 VPS 初始化脚本
#
# 仅适用于 root 用户
#
# 安装内容：
#   - apt update / upgrade
#   - git
#   - curl
#   - wget
#   - vim
#   - tmux
#   - zsh
#   - Oh My Zsh
#   - zsh-autosuggestions
#   - zsh-syntax-highlighting
#   - bira 主题
#   - Docker CE
#   - Docker Buildx
#   - Docker Compose V2
#
# 注意：
#   - 不创建或修改 ~/.tmux.conf
#   - 默认将 root Shell 设置为 zsh
# ============================================================

export DEBIAN_FRONTEND=noninteractive

readonly ROOT_HOME="/root"
readonly OH_MY_ZSH_DIR="${ROOT_HOME}/.oh-my-zsh"
readonly ZSHRC="${ROOT_HOME}/.zshrc"

info() {
    printf '\n\033[1;34m============================================================\033[0m\n'
    printf '\033[1;34m>>> %s\033[0m\n' "$1"
    printf '\033[1;34m============================================================\033[0m\n'
}

success() {
    printf '\033[1;32m[OK]\033[0m %s\n' "$1"
}

warn() {
    printf '\033[1;33m[WARN]\033[0m %s\n' "$1"
}

error() {
    printf '\033[1;31m[ERROR]\033[0m %s\n' "$1" >&2
}

on_error() {
    local exit_code=$?
    error "执行失败，退出码：${exit_code}"
    error "出错行号：${BASH_LINENO[0]}"
    error "出错命令：${BASH_COMMAND}"
    exit "$exit_code"
}

trap on_error ERR

# ------------------------------------------------------------
# 检查 root 权限
# ------------------------------------------------------------

if [ "$(id -u)" -ne 0 ]; then
    error "请使用 root 用户执行此脚本。"
    error "例如：sudo bash init-vps.sh"
    exit 1
fi

# ------------------------------------------------------------
# 检查操作系统
# ------------------------------------------------------------

if [ ! -f /etc/os-release ]; then
    error "找不到 /etc/os-release，无法识别操作系统。"
    exit 1
fi

# shellcheck disable=SC1091
source /etc/os-release

if [ "${ID:-}" != "ubuntu" ]; then
    error "当前系统不是 Ubuntu。"
    error "检测结果：${PRETTY_NAME:-未知}"
    exit 1
fi

if [ "${VERSION_ID:-}" != "24.04" ]; then
    error "该脚本仅支持 Ubuntu 24.04。"
    error "当前系统：${PRETTY_NAME:-未知}"
    exit 1
fi

info "系统信息"

echo "系统：${PRETTY_NAME}"
echo "架构：$(dpkg --print-architecture)"
echo "用户：$(whoami)"
echo "HOME：${ROOT_HOME}"

# ------------------------------------------------------------
# 更新系统
# ------------------------------------------------------------

info "更新系统软件包"

apt-get update
apt-get upgrade -y

success "系统更新完成"

# ------------------------------------------------------------
# 安装基础软件和依赖
# ------------------------------------------------------------

info "安装基础软件"

apt-get install -y \
    ca-certificates \
    curl \
    wget \
    git \
    vim \
    tmux \
    zsh \
    gnupg

success "基础软件安装完成"

# ------------------------------------------------------------
# 安装 Oh My Zsh
# ------------------------------------------------------------

info "安装 Oh My Zsh"

if [ ! -d "${OH_MY_ZSH_DIR}/.git" ]; then
    rm -rf "${OH_MY_ZSH_DIR}"

    RUNZSH=no \
    CHSH=no \
    KEEP_ZSHRC=yes \
    sh -c \
        "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
        "" --unattended

    success "Oh My Zsh 安装完成"
else
    warn "Oh My Zsh 已安装，跳过安装"
fi

# ------------------------------------------------------------
# 安装 Zsh 插件
# ------------------------------------------------------------

info "安装 Zsh 插件"

readonly ZSH_CUSTOM="${OH_MY_ZSH_DIR}/custom"
readonly AUTOSUGGESTIONS_DIR="${ZSH_CUSTOM}/plugins/zsh-autosuggestions"
readonly SYNTAX_HIGHLIGHTING_DIR="${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting"

mkdir -p "${ZSH_CUSTOM}/plugins"

if [ ! -d "${AUTOSUGGESTIONS_DIR}/.git" ]; then
    rm -rf "${AUTOSUGGESTIONS_DIR}"

    git clone \
        --depth=1 \
        https://github.com/zsh-users/zsh-autosuggestions.git \
        "${AUTOSUGGESTIONS_DIR}"

    success "zsh-autosuggestions 安装完成"
else
    warn "zsh-autosuggestions 已安装，跳过安装"
fi

if [ ! -d "${SYNTAX_HIGHLIGHTING_DIR}/.git" ]; then
    rm -rf "${SYNTAX_HIGHLIGHTING_DIR}"

    git clone \
        --depth=1 \
        https://github.com/zsh-users/zsh-syntax-highlighting.git \
        "${SYNTAX_HIGHLIGHTING_DIR}"

    success "zsh-syntax-highlighting 安装完成"
else
    warn "zsh-syntax-highlighting 已安装，跳过安装"
fi

# ------------------------------------------------------------
# 配置 .zshrc
# ------------------------------------------------------------

info "配置 Zsh"

if [ ! -f "${ZSHRC}" ]; then
    cp \
        "${OH_MY_ZSH_DIR}/templates/zshrc.zsh-template" \
        "${ZSHRC}"
fi

# 配置 Oh My Zsh 安装路径
if grep -qE '^[[:space:]]*export ZSH=' "${ZSHRC}"; then
    sed -i \
        's|^[[:space:]]*export ZSH=.*|export ZSH="$HOME/.oh-my-zsh"|' \
        "${ZSHRC}"
else
    sed -i \
        '1i export ZSH="$HOME/.oh-my-zsh"' \
        "${ZSHRC}"
fi

# 配置 bira 主题
if grep -qE '^[[:space:]]*ZSH_THEME=' "${ZSHRC}"; then
    sed -i \
        's/^[[:space:]]*ZSH_THEME=.*/ZSH_THEME="bira"/' \
        "${ZSHRC}"
else
    echo 'ZSH_THEME="bira"' >> "${ZSHRC}"
fi

# 配置插件
if grep -qE '^[[:space:]]*plugins=' "${ZSHRC}"; then
    sed -i \
        's/^[[:space:]]*plugins=.*/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' \
        "${ZSHRC}"
else
    cat >> "${ZSHRC}" <<'EOF'

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
EOF
fi

chown root:root "${ZSHRC}"
chmod 644 "${ZSHRC}"

success "Zsh 配置完成"

# ------------------------------------------------------------
# 设置默认 Shell
# ------------------------------------------------------------

info "设置 root 默认 Shell"

readonly ZSH_PATH="$(command -v zsh)"
readonly CURRENT_SHELL="$(getent passwd root | cut -d: -f7)"

if [ "${CURRENT_SHELL}" != "${ZSH_PATH}" ]; then
    chsh -s "${ZSH_PATH}" root
    success "root 默认 Shell 已设置为 ${ZSH_PATH}"
else
    warn "root 默认 Shell 已经是 ${ZSH_PATH}"
fi

# ------------------------------------------------------------
# 安装 Docker
# ------------------------------------------------------------

info "安装 Docker 官方版本"

# 移除可能与 Docker 官方软件包冲突的包
readonly DOCKER_CONFLICT_PACKAGES=(
    docker.io
    docker-compose
    docker-compose-v2
    docker-doc
    docker-buildx
    podman-docker
    containerd
    runc
)

installed_conflict_packages=()

for package in "${DOCKER_CONFLICT_PACKAGES[@]}"; do
    if dpkg-query \
        -W \
        -f='${db:Status-Abbrev}' \
        "${package}" 2>/dev/null | grep -q '^ii'; then

        installed_conflict_packages+=("${package}")
    fi
done

if [ "${#installed_conflict_packages[@]}" -gt 0 ]; then
    warn "移除 Docker 冲突软件包：${installed_conflict_packages[*]}"
    apt-get remove -y "${installed_conflict_packages[@]}"
else
    success "未发现 Docker 冲突软件包"
fi

# 创建 Docker GPG key 目录
install -m 0755 -d /etc/apt/keyrings

# 下载 Docker 官方 GPG key
curl -fsSL \
    https://download.docker.com/linux/ubuntu/gpg \
    -o /etc/apt/keyrings/docker.asc

chmod a+r /etc/apt/keyrings/docker.asc

# 添加 Docker 官方 APT 仓库
readonly ARCH="$(dpkg --print-architecture)"
readonly UBUNTU_CODENAME="${UBUNTU_CODENAME:-${VERSION_CODENAME}}"

cat > /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: ${UBUNTU_CODENAME}
Components: stable
Architectures: ${ARCH}
Signed-By: /etc/apt/keyrings/docker.asc
EOF

apt-get update

apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

success "Docker 软件包安装完成"

# ------------------------------------------------------------
# 启动 Docker
# ------------------------------------------------------------

info "启动 Docker 服务"

systemctl enable --now docker

if systemctl is-active --quiet docker; then
    success "Docker 服务运行正常"
else
    error "Docker 服务未正常运行"
    systemctl status docker --no-pager || true
    exit 1
fi

# ------------------------------------------------------------
# 验证安装
# ------------------------------------------------------------

info "验证安装结果"

echo
echo "Git："
git --version

echo
echo "Curl："
curl --version | head -n 1

echo
echo "Wget："
wget --version | head -n 1

echo
echo "Vim："
vim --version | head -n 1

echo
echo "Zsh："
zsh --version

echo
echo "tmux："
tmux -V

echo
echo "Docker："
docker --version

echo
echo "Docker Compose："
docker compose version

echo
echo "Docker Buildx："
docker buildx version

# ------------------------------------------------------------
# 清理
# ------------------------------------------------------------

info "清理无用软件包和缓存"

apt-get autoremove -y
apt-get autoclean -y

# ------------------------------------------------------------
# 完成
# ------------------------------------------------------------

echo
echo "============================================================"
echo "Ubuntu 24.04 VPS 初始化完成"
echo "============================================================"
echo
echo "已完成："
echo
echo "  ✓ apt update"
echo "  ✓ apt upgrade"
echo "  ✓ git"
echo "  ✓ curl"
echo "  ✓ wget"
echo "  ✓ vim"
echo "  ✓ tmux"
echo "  ✓ zsh"
echo "  ✓ Oh My Zsh"
echo "  ✓ bira 主题"
echo "  ✓ zsh-autosuggestions"
echo "  ✓ zsh-syntax-highlighting"
echo "  ✓ Docker CE"
echo "  ✓ Docker Compose V2"
echo "  ✓ Docker Buildx"
echo
echo "tmux："
echo
echo "  ✓ 仅安装 tmux"
echo "  ✓ 未创建或修改 /root/.tmux.conf"
echo
echo "执行下面的命令立即进入 Zsh："
echo
echo "  exec zsh"
echo

if [ -f /var/run/reboot-required ]; then
    echo "注意：系统更新后需要重启。"
    echo
    echo "  reboot"
    echo
fi
