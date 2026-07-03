# Codex Persist

一个用于在容器或临时开发环境中持久化 Codex 配置、登录状态和安装目录的脚本。

This script persists Codex configuration, login state, and installation files in a container or temporary development environment.

## 中文说明

### 解决什么问题

在很多容器环境中，默认的 home 目录或工具安装目录可能会在容器重启后丢失。`setup_codex_persist.sh` 会把 Codex 的关键文件放到一个持久化目录中：

- `home/`: Codex 配置、登录缓存、会话状态等。
- `bin/`: Codex 安装目录。
- `codex_env.sh`: 可被 shell 加载的环境变量文件。

默认情况下，持久化目录就是 `setup_codex_persist.sh` 所在目录。你也可以在运行脚本时指定其他目录。

### 第一次使用

1. 克隆仓库：

```bash
git clone https://github.com/lzt2323/codex_persist.git
cd codex_persist
```

2. 运行初始化脚本：

```bash
./setup_codex_persist.sh
```

默认会在当前脚本目录下创建或使用：

```text
bin/
home/
codex_env.sh
```

如果想把持久化文件放到其他目录，可以传入路径：

```bash
./setup_codex_persist.sh /mnt/data/lzt/codex_persist
```

3. 让当前终端立即生效：

```bash
source ./codex_env.sh
```

脚本也会自动把 `source ".../codex_env.sh"` 写入当前用户的 shell 启动文件中，例如 `~/.bashrc` 或 `~/.zshrc`。所以后续新开的终端一般不需要再手动 source。

4. 登录 Codex：

```bash
codex login --device-auth
```

如果 `device-auth` 不可用，可以使用：

```bash
codex login
```

登录完成后，认证信息会保存到：

```text
home/auth.json
```

注意：`auth.json` 相当于登录凭据，不要提交到 Git，也不要发给别人。

### 后续使用

新开终端后，通常可以直接运行：

```bash
codex
```

如果当前终端没有自动加载环境变量，可以手动执行：

```bash
source /path/to/codex_persist/codex_env.sh
```

检查环境是否生效：

```bash
which codex
codex --version
echo "$CODEX_HOME"
```

重新运行初始化脚本是安全的：

```bash
./setup_codex_persist.sh
```

脚本会复用已有目录，并且不会重复向 shell 启动文件追加相同的 `source` 配置。

### 常见问题

如果新终端中找不到 `codex`，先检查 shell 启动文件是否包含类似内容：

```bash
source "/path/to/codex_persist/codex_env.sh"
```

如果登录状态丢失，确认当前使用的 `CODEX_HOME` 是否指向持久化目录：

```bash
echo "$CODEX_HOME"
```

## English

### What This Solves

In many container or temporary development environments, the default home directory or tool installation directory may be lost after the environment restarts. `setup_codex_persist.sh` keeps the important Codex files in a persistent directory:

- `home/`: Codex configuration, login cache, session state, and related files.
- `bin/`: Codex installation directory.
- `codex_env.sh`: Shell environment file.

By default, the persistent directory is the directory containing `setup_codex_persist.sh`. You can also pass a custom directory when running the script.

### First-Time Setup

1. Clone the repository:

```bash
git clone https://github.com/lzt2323/codex_persist.git
cd codex_persist
```

2. Run the setup script:

```bash
./setup_codex_persist.sh
```

By default, the script creates or reuses these files and directories under the script directory:

```text
bin/
home/
codex_env.sh
```

To use a custom persistent directory, pass it as the first argument:

```bash
./setup_codex_persist.sh /mnt/data/lzt/codex_persist
```

3. Load the environment in the current terminal:

```bash
source ./codex_env.sh
```

The script also adds `source ".../codex_env.sh"` to the current user's shell startup file, such as `~/.bashrc` or `~/.zshrc`. New terminals should load the Codex environment automatically.

4. Log in to Codex:

```bash
codex login --device-auth
```

If device auth is not available, use:

```bash
codex login
```

After login, credentials are stored at:

```text
home/auth.json
```

Warning: `auth.json` is a credential file. Do not commit it to Git or share it with anyone.

### Daily Usage

After opening a new terminal, you can usually run:

```bash
codex
```

If the environment was not loaded automatically, source it manually:

```bash
source /path/to/codex_persist/codex_env.sh
```

Check that the environment is active:

```bash
which codex
codex --version
echo "$CODEX_HOME"
```

It is safe to run the setup script again:

```bash
./setup_codex_persist.sh
```

The script reuses existing directories and does not append duplicate `source` lines to the shell startup file.

### Troubleshooting

If `codex` is not found in a new terminal, check whether your shell startup file contains a line like:

```bash
source "/path/to/codex_persist/codex_env.sh"
```

If login state is missing, confirm that `CODEX_HOME` points to the persistent directory:

```bash
echo "$CODEX_HOME"
```
