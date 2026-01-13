# 蜂群驯化师 - 技术架构设计

## 一、饥荒 Mod 开发基础

### 1.1 Mod 基本结构

每个饥荒 Mod 是一个独立文件夹，包含以下核心文件：

```
mod-folder/
├── modinfo.lua      # Mod 元信息（名称、版本、描述等）
├── modmain.lua      # Mod 入口文件（主要代码）
├── modicon.tex      # Mod 图标（可选）
├── modicon.xml      # Mod 图标配置（可选）
├── scripts/         # Lua 脚本目录
│   ├── prefabs/     # 游戏物体定义（物品、生物等）
│   └── components/  # 组件定义（行为、属性等）
└── images/          # 图片资源
    └── inventoryimages/  # 物品图标
```

### 1.2 核心文件说明

| 文件 | 作用 |
|------|------|
| `modinfo.lua` | Mod 的"身份证"，定义名称、作者、版本、配置选项等 |
| `modmain.lua` | Mod 的入口，游戏加载时执行的主脚本 |
| `scripts/prefabs/` | 定义新的游戏物体（Prefab），如物品、生物 |
| `scripts/components/` | 定义新的组件，用于给物体添加行为 |

### 1.3 饥荒的核心概念

| 概念 | 说明 | 例子 |
|------|------|------|
| **Prefab** | 游戏中的"物体模板" | 蜜蜂、长矛、玩家 |
| **Component** | 物体的"功能模块" | 可堆叠、可装备、有血量 |
| **Entity** | Prefab 的实例 | 地图上的某一只蜜蜂 |
| **StateGraph** | 物体的状态机 | 蜜蜂的飞行、攻击、死亡状态 |
| **Brain** | AI 行为树 | 蜜蜂如何寻敌、跟随主人 |

---

## 二、蜂群驯化师 Mod 架构

### 2.1 目录结构

```
mods/bee-tamer/
├── modinfo.lua                 # Mod 信息和配置
├── modmain.lua                 # 入口文件
├── modicon.tex                 # Mod 图标
├── modicon.xml
│
├── scripts/
│   ├── prefabs/                # 物体定义
│   │   ├── bee_taming_flute.lua    # 驯蜂笛
│   │   ├── beehive_bag.lua         # 蜂巢袋
│   │   ├── bee_command_wand.lua    # 指挥棒
│   │   └── pet_bee.lua             # 宠物蜜蜂
│   │
│   ├── components/             # 组件定义
│   │   ├── beetamer.lua            # 蜂群管理器（核心）
│   │   ├── petbee_leveling.lua     # 蜜蜂升级系统
│   │   └── petbee_combat.lua       # 蜜蜂战斗系统
│   │
│   ├── brains/                 # AI 行为
│   │   └── petbeebrain.lua         # 宠物蜜蜂 AI
│   │
│   ├── stategraphs/            # 状态机
│   │   └── SGpetbee.lua            # 宠物蜜蜂状态
│   │
│   └── widgets/                # UI 组件
│       └── beetamer_hud.lua        # 蜂群状态面板
│
└── images/
    └── inventoryimages/        # 物品图标
        ├── bee_taming_flute.tex
        ├── bee_taming_flute.xml
        ├── beehive_bag.tex
        ├── beehive_bag.xml
        ├── bee_command_wand.tex
        └── bee_command_wand.xml
```

### 2.2 模块划分

```
┌─────────────────────────────────────────────────────────────┐
│                        modmain.lua                          │
│                    (入口 + 配置 + 注册)                       │
└─────────────────────────────────────────────────────────────┘
                              │
        ┌─────────────────────┼─────────────────────┐
        ▼                     ▼                     ▼
┌───────────────┐   ┌───────────────┐   ┌───────────────┐
│   Prefabs     │   │  Components   │   │    Widgets    │
│   (物体)       │   │   (组件)      │   │    (UI)       │
├───────────────┤   ├───────────────┤   ├───────────────┤
│ 驯蜂笛        │   │ beetamer      │   │ beetamer_hud  │
│ 蜂巢袋        │   │ (蜂群管理器)   │   │ (状态面板)     │
│ 指挥棒        │   │               │   │               │
│ 宠物蜜蜂      │   │ petbee_level  │   └───────────────┘
└───────────────┘   │ (升级系统)     │
                    │               │
                    │ petbee_combat │
                    │ (战斗系统)     │
                    └───────────────┘
```

---

## 三、核心模块设计

### 3.1 beetamer 组件（蜂群管理器）

这是整个 Mod 的核心，挂载在玩家身上，管理所有宠物蜜蜂。

```lua
-- 数据结构
beetamer = {
    -- 收纳袋中的蜜蜂（按品阶分类存储）
    stored_bees = {
        [1] = {},  -- 兵级
        [2] = {},  -- 将级
        [3] = {},  -- 王级
        [4] = {},  -- 皇级
        [5] = {},  -- 帝级
    },

    -- 已释放的蜜蜂（Entity 引用列表）
    released_bees = {},

    -- 战斗模式
    combat_mode = "auto",  -- "auto" 或 "command"

    -- 当前攻击目标
    attack_target = nil,

    -- 配置
    max_capacity = 1000,
}

-- 主要方法
beetamer:TameBee(bee)           -- 驯化蜜蜂
beetamer:CollectAllBees()       -- 收取所有蜜蜂
beetamer:ReleaseBees(count, rank)  -- 释放蜜蜂
beetamer:ToggleCombatMode()     -- 切换战斗模式
beetamer:SetAttackTarget(target) -- 设置攻击目标
beetamer:GetTotalBeeCount()     -- 获取存活蜜蜂总数
beetamer:OnSave() / OnLoad()    -- 存档/读档
```

### 3.2 pet_bee Prefab（宠物蜜蜂）

基于游戏蜜蜂创建的独立 Prefab，有经验和品阶系统。

```lua
-- 数据结构
pet_bee = {
    exp = 0,           -- 经验值
    rank = 0,          -- 品阶 (0=未升级, 1-5=兵将王皇帝)
    owner = nil,       -- 所属玩家
}

-- 品阶配置
RANKS = {
    [1] = { name = "兵", exp = 10,    scale = 1.1, color = {1,1,0},     damage = 10, health = 50  },
    [2] = { name = "将", exp = 100,   scale = 1.2, color = {1,0.5,0},   damage = 20, health = 100 },
    [3] = { name = "王", exp = 500,   scale = 1.3, color = {1,0,0},     damage = 35, health = 180 },
    [4] = { name = "皇", exp = 2000,  scale = 1.4, color = {0.5,0,0.5}, damage = 55, health = 300 },
    [5] = { name = "帝", exp = 10000, scale = 1.5, color = {1,0.84,0},  damage = 80, health = 500 },
}
```

### 3.3 道具 Prefabs

#### 驯蜂笛 (bee_taming_flute)
```lua
-- 组件
inst:AddComponent("finiteuses")      -- 有限使用次数
inst:AddComponent("inventoryitem")   -- 可放入背包

-- 使用效果
OnUse = function(inst, doer)
    -- 1. 播放音效和动画
    -- 2. 搜索 10 格内的普通蜜蜂
    -- 3. 调用 beetamer:TameBee() 驯化
    -- 4. 扣除耐久
end
```

#### 蜂巢袋 (beehive_bag)
```lua
-- 组件
inst:AddComponent("inventoryitem")

-- 右键菜单
inst.components.inventoryitem:SetOnDroppedFn(OnDropped)  -- 丢弃时释放蜜蜂

-- 右键动作
ACTIONS = {
    "收取全部",
    "释放 1 只", "释放 5 只",
    "释放兵级", "释放将级", "释放王级", "释放皇级", "释放帝级"
}
```

#### 指挥棒 (bee_command_wand)
```lua
-- 组件
inst:AddComponent("weapon")          -- 武器（攻击力 34）
inst:AddComponent("finiteuses")      -- 有限使用次数
inst:AddComponent("equippable")      -- 可装备

-- 装备效果
OnEquip = function()
    -- 启动精神回复定时器
end

OnUnequip = function()
    -- 停止精神回复定时器
end

-- 右键菜单
ACTIONS = { "切换模式" }
```

### 3.4 UI 组件 (beetamer_hud)

```lua
-- 显示内容
HUD = {
    position = {x, y},    -- 可拖拽位置

    -- 显示数据
    total_count = 0,      -- 总数量
    capacity = 1000,      -- 容量
    released_count = 0,   -- 已释放数量
    combat_mode = "auto", -- 当前模式

    -- 各品阶数量
    rank_counts = {0, 0, 0, 0, 0},
}

-- 功能
HUD:Update()          -- 刷新显示
HUD:OnDragStart()     -- 开始拖拽
HUD:OnDragEnd()       -- 结束拖拽
HUD:SavePosition()    -- 保存位置
```

---

## 四、关键流程

### 4.1 驯化流程

```
玩家使用驯蜂笛
       │
       ▼
搜索 10 格内的普通蜜蜂
       │
       ▼
对每只蜜蜂：
  ├── 移除原 Entity
  ├── 创建 pet_bee Prefab
  ├── 初始化 exp=0, rank=0
  ├── 播放驯化特效 (hearts)
  └── 如果蜂巢袋有空间 → 收入袋中
      否则 → 作为跟随者存在
       │
       ▼
扣除驯蜂笛耐久
```

### 4.2 战斗流程

```
自主模式:
  玩家被攻击 → 检测仇恨 → 蜜蜂自动攻击

指挥模式:
  玩家用指挥棒点击敌人 → 设置攻击目标 → 所有蜜蜂攻击该目标
```

### 4.3 经验获取流程

```
蜜蜂攻击敌人
       │
       ▼
敌人死亡（由该蜜蜂最后一击）
       │
       ▼
计算经验值：
  敌人血量 < 100 → +1 exp
  敌人血量 >= 100 → +5 + 血量*0.01 exp
       │
       ▼
累加到蜜蜂 exp
       │
       ▼
检查是否达到下一品阶
  是 → 升级，更新颜色/大小/属性，播放特效
  否 → 继续
```

---

## 五、数据持久化

### 5.1 存储键名

| 键名 | 内容 |
|------|------|
| `beetamer_stored_bees` | 收纳袋中的蜜蜂数据（exp, rank） |
| `beetamer_combat_mode` | 战斗模式 |
| `beetamer_ui_position` | UI 位置 |

### 5.2 存档格式

```lua
-- 蜜蜂数据格式
stored_bees = {
    { exp = 15, rank = 1 },   -- 一只兵级
    { exp = 230, rank = 2 },  -- 一只将级
    ...
}
```

---

## 六、开发顺序建议

### 第一阶段：基础框架
1. 创建 `modinfo.lua` 和 `modmain.lua`
2. 创建基础 prefab（先用复用的图标/动画）
3. 实现物品可制作、可拾取

### 第二阶段：核心功能
4. 实现 `pet_bee` prefab（宠物蜜蜂）
5. 实现 `beetamer` 组件（蜂群管理器）
6. 实现驯化功能

### 第三阶段：收纳释放
7. 实现蜂巢袋收纳/释放
8. 实现右键菜单
9. 实现数据持久化

### 第四阶段：战斗系统
10. 实现宠物蜜蜂 AI
11. 实现战斗模式切换
12. 实现经验/升级系统

### 第五阶段：UI 和打磨
13. 实现状态面板 UI
14. 实现拖拽功能
15. 添加特效和音效
16. 测试和修复 bug

---

## 七、参考资源

- [Don't Starve Wiki - Modding](https://dontstarve.wiki.gg/)
- [Steam Workshop - Mod 教程](https://steamcommunity.com/sharedfiles/filedetails/?id=2678636521)
- [GitHub - DST Mod 示例](https://github.com/topics/dont-starve-together-mod)

---

## 八、下一步

完成技术架构设计后，下一步是：
1. 创建 `modinfo.lua` 基础配置
2. 创建 `modmain.lua` 入口文件
3. 开始第一阶段开发
