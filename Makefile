# tguard Makefile - 边缘 Linux 与 Windows 64 位编译打包

BINARY_NAME := tguard
VERSION     := $(shell git describe --tags --always --dirty 2>/dev/null || echo "dev")
DIST_DIR    := dist
BUILD_FLAGS := -ldflags "-s -w"

# 默认目标：编译并打包
all: build pack

# 编译：Linux amd64 与 Windows amd64
build: build-linux build-windows

build-linux:
	@echo "==> Building Linux amd64..."
	@mkdir -p $(DIST_DIR)/linux_amd64
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build $(BUILD_FLAGS) -o $(DIST_DIR)/linux_amd64/$(BINARY_NAME) ./main.go

build-windows:
	@echo "==> Building Windows amd64..."
	@mkdir -p $(DIST_DIR)/windows_amd64
	CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build $(BUILD_FLAGS) -o $(DIST_DIR)/windows_amd64/$(BINARY_NAME).exe ./main.go

# 打包：将二进制 + README.md + config.yaml 打成压缩包
pack: pack-linux pack-windows

pack-linux: build-linux
	@echo "==> Packaging Linux amd64..."
	@cp README.md config.yaml $(DIST_DIR)/linux_amd64/
	@cd $(DIST_DIR)/linux_amd64 && tar -czvf ../$(BINARY_NAME)_Linux_x86_64_$(VERSION).tar.gz $(BINARY_NAME) README.md config.yaml
	@echo "    -> $(DIST_DIR)/$(BINARY_NAME)_Linux_x86_64_$(VERSION).tar.gz"

pack-windows: build-windows
	@echo "==> Packaging Windows amd64..."
	@cp README.md config.yaml $(DIST_DIR)/windows_amd64/
	@cd $(DIST_DIR)/windows_amd64 && zip -q ../$(BINARY_NAME)_Windows_x86_64_$(VERSION).zip $(BINARY_NAME).exe README.md config.yaml
	@echo "    -> $(DIST_DIR)/$(BINARY_NAME)_Windows_x86_64_$(VERSION).zip"

# 仅编译不打包
compile: build

# 清理构建产物
clean:
	@echo "==> Cleaning..."
	@rm -rf $(DIST_DIR)
	@echo "    done."

.PHONY: all build build-linux build-windows pack pack-linux pack-windows compile clean
