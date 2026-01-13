#!/bin/bash
# 同步 Mod 到游戏目录
# 用法: ./sync_to_game.sh

SRC_DIR="/Users/chen/code/dst-mod/mods/bee-tamer"
DST_DIR="/Users/chen/Library/Application Support/Steam/steamapps/common/Don't Starve Together/dontstarve_steam.app/Contents/mods/bee-tamer"

echo "同步 Mod 到游戏目录..."
echo "源: $SRC_DIR"
echo "目标: $DST_DIR"

# 删除旧文件
rm -rf "$DST_DIR"

# 复制新文件
cp -r "$SRC_DIR" "$DST_DIR"

echo "同步完成！"
echo ""
echo "现在可以启动游戏进行测试："
echo "1. 启动 Don't Starve Together"
echo "2. 进入 Mods 界面，启用 '蜂群驯化师'"
echo "3. 创建/进入存档测试"
echo ""
echo "游戏内测试命令："
echo "  beetamer_test()     - 运行所有集成测试"
echo "  beetamer_test_list() - 列出所有测试套件"
