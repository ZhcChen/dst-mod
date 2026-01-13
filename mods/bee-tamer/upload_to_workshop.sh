#!/bin/bash
# 上传 Mod 到 Steam 创意工坊
# 用法: ./upload_to_workshop.sh

echo "=========================================="
echo "  蜂群驯化师 - Steam 创意工坊上传工具"
echo "=========================================="
echo ""
echo "注意：首次上传会创建新的 Workshop 物品"
echo "      后续上传会更新现有物品（需要在 .vdf 中添加 publishedfileid）"
echo ""
echo "可见性设置："
echo "  0 = 公开"
echo "  1 = 仅好友可见"
echo "  2 = 隐藏（仅自己可见）"
echo ""
echo "当前设置为：隐藏（仅自己可见）"
echo ""

# 检查 steamcmd
if ! command -v steamcmd &> /dev/null; then
    echo "错误: steamcmd 未安装"
    echo "请运行: brew install steamcmd"
    exit 1
fi

# VDF 文件路径
VDF_FILE="/Users/chen/code/dst-mod/mods/bee-tamer/workshop_upload.vdf"

echo "即将使用 SteamCMD 上传..."
echo "你需要输入 Steam 账号和密码"
echo ""

# 运行 steamcmd 上传
steamcmd +login "$1" +workshop_build_item "$VDF_FILE" +quit

echo ""
echo "上传完成！"
echo ""
echo "如果成功，请记下输出的 Workshop ID"
echo "然后将其添加到 workshop_upload.vdf 中的 publishedfileid 字段"
