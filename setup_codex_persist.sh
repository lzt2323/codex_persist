#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 默认在本脚本所在目录创建持久化；也可以通过第一个参数指定目录。
PERSIST_ROOT="${1:-$SCRIPT_DIR}"

CODEX_BIN_DIR="$PERSIST_ROOT/bin"
CODEX_HOME_DIR="$PERSIST_ROOT/home"
ENV_FILE="$PERSIST_ROOT/codex_env.sh"

mkdir -p "$CODEX_BIN_DIR" "$CODEX_HOME_DIR"

chmod 700 "$CODEX_HOME_DIR" || true

echo "[1/5] 设置 Codex 持久化目录..."
cat > "$ENV_FILE" <<EOF
# Codex persistent environment
export CODEX_HOME="$CODEX_HOME_DIR"
export CODEX_INSTALL_DIR="$CODEX_BIN_DIR"
export PATH="$CODEX_BIN_DIR:\$PATH"
EOF

# 当前 shell 也立即生效
export CODEX_HOME="$CODEX_HOME_DIR"
export CODEX_INSTALL_DIR="$CODEX_BIN_DIR"
export PATH="$CODEX_BIN_DIR:$PATH"

echo "[2/5] 写入 Codex 配置..."
CONFIG_FILE="$CODEX_HOME_DIR/config.toml"

if [ ! -f "$CONFIG_FILE" ]; then
  cat > "$CONFIG_FILE" <<'EOF'
# Codex user config
# 把登录缓存放到 CODEX_HOME/auth.json，避免容器重启后丢失
cli_auth_credentials_store = "file"

# 常用配置，可按需修改
approval_policy = "on-request"

# 如果你确定自己的 Codex 支持某个模型，可以取消注释
# model = "gpt-5.5"
EOF
else
  if ! grep -q '^cli_auth_credentials_store' "$CONFIG_FILE"; then
    echo '' >> "$CONFIG_FILE"
    echo 'cli_auth_credentials_store = "file"' >> "$CONFIG_FILE"
  fi
fi

echo "[3/5] 检查 Codex 是否已安装..."
if command -v codex >/dev/null 2>&1; then
  echo "已找到 codex: $(command -v codex)"
else
  echo "未找到 codex，开始安装到挂载目录：$CODEX_BIN_DIR"
  curl -fsSL https://chatgpt.com/codex/install.sh | CODEX_NON_INTERACTIVE=1 sh
fi

echo "[4/5] 检查版本..."
codex --version || true

echo "[5/5] 完成。"

echo
echo "以后进入新容器后执行："
echo "  source $ENV_FILE"
echo
echo "第一次使用需要登录："
echo "  source $ENV_FILE"
echo "  codex login --device-auth"
echo
echo "如果 device-auth 不可用，也可以用："
echo "  codex login"
echo
echo "登录成功后，登录信息会保存在："
echo "  $CODEX_HOME_DIR/auth.json"
echo
echo "注意：auth.json 相当于密码，不要提交到 Git，不要发给别人。"
