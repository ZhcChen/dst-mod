-- 蜂群驯化师 (Bee Tamer)
-- 驯化蜜蜂成为战斗宠物

name = "蜂群驯化师"
description = [[
驯化蜜蜂成为你的战斗宠物！

功能特点：
- 使用驯蜂笛驯化普通蜜蜂
- 蜂巢袋收纳和释放蜜蜂
- 指挥棒控制蜜蜂战斗
- 蜜蜂可通过战斗升级（兵→将→王→皇→帝）
]]

author = "Chen"
version = "0.1.0"

-- 兼容饥荒联机版
dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = false
shipwrecked_compatible = false

-- 仅客户端 Mod 还是服务器 Mod
-- 正式发布需要设为 true
all_clients_require_mod = true
client_only_mod = false

-- Mod 图标
icon_atlas = "modicon.xml"
icon = "modicon.tex"

-- API 版本
api_version = 10

-- 优先级（默认 0）
priority = 0

-- 服务器过滤标签
server_filter_tags = {"蜂群驯化师", "bee tamer", "pet bee"}

-- 配置选项
configuration_options = {
    {
        name = "bag_capacity",
        label = "蜂巢袋容量",
        hover = "蜂巢袋最多可容纳的蜜蜂数量",
        options = {
            {description = "100", data = 100},
            {description = "500", data = 500},
            {description = "1000（默认）", data = 1000},
            {description = "2000", data = 2000},
            {description = "5000", data = 5000},
            {description = "9999", data = 9999},
        },
        default = 1000,
    },
}
