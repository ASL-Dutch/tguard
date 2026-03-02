# tguard

海关/税务相关的 ICP 服务与 Web API，提供 ICP 文件制作、税号维度报表、VAT 票据及审计等能力。

## 功能概览

- **ICP 服务**：按税号/月份生成 ICP 文件，支持追加、下载
- **Web API**：基于 Echo 的 HTTP 服务，默认端口 `7005`，提供 Swagger 文档
- **数据与存储**：MySQL 数据源，可选阿里云 OSS，本地/审计目录可配置

## 环境要求

- Go 1.18+
- MySQL（按 `config.yaml` 配置）

## 配置说明

根目录或当前工作目录放置 `config.yaml`（或通过 `--config` 指定路径），主要字段：

| 配置块 | 说明 |
|--------|------|
| `port` | 服务监听端口，默认 7005 |
| `mysql` | 数据库连接（url、连接池等） |
| `zip.vat-note-*` | VAT 票据开关、目录及下载地址 |
| `icp.save-dir` | ICP 文件保存目录 |
| `audit` | 审计临时目录与保存目录 |
| `oss` | 阿里云 OSS（endpoint、access-key、bucket 等） |

发布包中已包含示例 `config.yaml`，部署前请按实际环境修改。

## 本地运行

```bash
# 安装依赖
go mod download

# 确保存在 config.yaml（或 .tguard.yaml），再启动服务
go run ./main.go

# 指定配置文件
go run ./main.go --config config.yaml
```

启动后访问：

- API 文档：`http://localhost:7005/swagger/index.html`
- 服务默认：`http://localhost:7005`

## 编译

项目使用 Makefile 做跨平台编译与打包，生成 **Linux x86_64** 与 **Windows x86_64** 二进制，并将 `README.md`、`config.yaml` 一并打入发布包。

### 前置条件

- 已安装 Go 1.18+
- 本机可执行 `make`（Linux/macOS 常见环境即可）

### 常用命令

```bash
# 编译并打包（生成 dist 下的 .tar.gz 与 .zip）
make

# 仅编译，不打包
make build

# 仅打包（依赖已有 build 产物）
make pack

# 只编译某一平台
make build-linux
make build-windows

# 清理 dist 目录
make clean
```

### 产物说明

| 目标 | 产物 |
|------|------|
| `make` / `make all` | `dist/tguard_Linux_x86_64_<version>.tar.gz`、`dist/tguard_Windows_x86_64_<version>.zip` |
| 压缩包内容 | 对应平台二进制 + `README.md` + `config.yaml` |

版本号来自 `git describe --tags`（无 tag 时为 `dev`）。

## 发布（GitHub Release）

通过 **Git tag** 触发 GitHub Actions，自动编译并发布到 GitHub Release。

### 步骤

1. **打 tag 并推送**（建议使用语义化版本，如 `v1.0.0`）：

   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```

2. 在仓库 **Actions** 页查看名为 **Release** 的 workflow 是否运行成功。

3. 在 **Releases** 页找到对应 tag，即可看到自动附带的：
   - `tguard_Linux_x86_64_<tag>.tar.gz`
   - `tguard_Windows_x86_64_<tag>.zip`

### 说明

- 触发条件：推送匹配 `v*` 的 tag（如 `v1.0.0`、`v0.2.0`）。
- 构建方式：Actions 中执行 `make`，与本地编译、打包逻辑一致。
- 无需额外配置：使用仓库内置 `GITHUB_TOKEN` 即可创建 Release 并上传附件。

## License

Copyright © 2022 Joker
