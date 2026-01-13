# 蜂群驯化师 - 开发任务清单

## 任务状态说明

| 状态 | 说明 |
|------|------|
| ✅ | 已完成 |
| 🔄 | 进行中 |
| ⏳ | 待开始 |

---

## 第一阶段：基础框架 ✅

创建 Mod 基础结构和核心文件。

### 1.1 Mod 配置文件 ✅

| 任务 | 状态 | 文件 |
|------|------|------|
| 创建 modinfo.lua | ✅ | `modinfo.lua` |
| - 设置 Mod 名称和版本 | ✅ | |
| - 设置 DST 兼容性标识 | ✅ | |
| - 添加 bag_capacity 配置选项 | ✅ | |
| - 设置服务器过滤标签 | ✅ | |
| 创建 modmain.lua | ✅ | `modmain.lua` |
| - 加载 Assets 资源 | ✅ | |
| - 注册 PrefabFiles | ✅ | |
| - 调用 RegisterInventoryImages | ✅ | |
| - 调用 AddRecipes 注册配方 | ✅ | |
| - AddPlayerPostInit 注入 beetamer 组件 | ✅ | |

### 1.2 目录结构 ✅

| 任务 | 状态 | 路径 |
|------|------|------|
| 创建 scripts/prefabs | ✅ | `scripts/prefabs/` |
| 创建 scripts/components | ✅ | `scripts/components/` |
| 创建 scripts/brains | ✅ | `scripts/brains/` |
| 创建 scripts/stategraphs | ✅ | `scripts/stategraphs/` |
| 创建 scripts/widgets | ✅ | `scripts/widgets/` |
| 创建 images/inventoryimages | ✅ | `images/inventoryimages/` |

### 1.3 驯蜂笛 Prefab ✅

| 任务 | 状态 | 文件 |
|------|------|------|
| 创建 bee_taming_flute.lua | ✅ | `scripts/prefabs/bee_taming_flute.lua` |
| - 复用排箫 (panflute) 动画 | ✅ | |
| - 添加 inventoryitem 组件 | ✅ | |
| - 添加 finiteuses 组件（20次） | ✅ | |
| - 实现 FindNearbyBees 搜索逻辑 | ✅ | |
| - 实现 OnPlay 驯化逻辑 | ✅ | |
| - 驯化范围 10 格 | ✅ | |
| - 只驯化普通蜜蜂（排除杀人蜂） | ✅ | |

### 1.4 蜂巢袋 Prefab ✅

| 任务 | 状态 | 文件 |
|------|------|------|
| 创建 beehive_bag.lua | ✅ | `scripts/prefabs/beehive_bag.lua` |
| - 复用背包 (backpack) 动画 | ✅ | |
| - 添加 inventoryitem 组件 | ✅ | |
| - 定义右键菜单 ACTIONS 列表 | ✅ | |
| - 实现 CollectAll 收取全部 | ✅ | |
| - 实现 Release 释放指定数量 | ✅ | |
| - 实现 ReleaseByRank 按品阶释放 | ✅ | |
| - 实现 OnDropped 丢弃处理 | ✅ | |
| - 实现 OnRemoved 销毁处理 | ✅ | |

### 1.5 指挥棒 Prefab ✅

| 任务 | 状态 | 文件 |
|------|------|------|
| 创建 bee_command_wand.lua | ✅ | `scripts/prefabs/bee_command_wand.lua` |
| - 复用长矛 (spear) 动画 | ✅ | |
| - 添加 weapon 组件（34伤害） | ✅ | |
| - 添加 finiteuses 组件（100次） | ✅ | |
| - 添加 equippable 组件（武器槽） | ✅ | |
| - 实现 OnEquip 装备回调 | ✅ | |
| - 实现 OnUnequip 卸下回调 | ✅ | |
| - 实现 StartSanityAura 精神恢复 | ✅ | |
| - 实现 ToggleCombatMode 模式切换 | ✅ | |
| - 实现 OnAttack 设置攻击目标 | ✅ | |

### 1.6 宠物蜜蜂 Prefab ✅

| 任务 | 状态 | 文件 |
|------|------|------|
| 创建 pet_bee.lua | ✅ | `scripts/prefabs/pet_bee.lua` |
| - 复用蜜蜂 (bee) 动画 | ✅ | |
| - 定义 RANKS 品阶配置表 | ✅ | |
| - 品阶0：普通（基础属性） | ✅ | |
| - 品阶1：兵（10exp，黄色，1.1x） | ✅ | |
| - 品阶2：将（100exp，橙色，1.2x） | ✅ | |
| - 品阶3：王（500exp，红色，1.3x） | ✅ | |
| - 品阶4：皇（2000exp，紫色，1.4x） | ✅ | |
| - 品阶5：帝（10000exp，金色，1.5x） | ✅ | |
| - 添加 health 组件 | ✅ | |
| - 添加 combat 组件 | ✅ | |
| - 添加 locomotor 组件 | ✅ | |
| - 实现 AddExp 添加经验 | ✅ | |
| - 实现 CheckRankUp 检查升级 | ✅ | |
| - 实现 CalculateKillExp 经验计算 | ✅ | |
| - 实现 OnKill 击杀回调 | ✅ | |
| - 实现 OnAttacked 被攻击回调 | ✅ | |
| - 实现 OnDeath 死亡回调 | ✅ | |
| - 实现 FollowOwner 跟随主人 | ✅ | |
| - 实现 OnSave/OnLoad 存档 | ✅ | |

### 1.7 beetamer 组件 ✅

| 任务 | 状态 | 文件 |
|------|------|------|
| 创建 beetamer.lua | ✅ | `scripts/components/beetamer.lua` |
| - 定义 stored_bees 按品阶存储 | ✅ | |
| - 定义 released_bees 已释放列表 | ✅ | |
| - 定义 combat_mode 战斗模式 | ✅ | |
| - 定义 attack_target 攻击目标 | ✅ | |
| - 实现 SetCapacity/GetCapacity | ✅ | |
| - 实现 GetStoredBeeCount | ✅ | |
| - 实现 GetReleasedBeeCount | ✅ | |
| - 实现 GetTotalBeeCount | ✅ | |
| - 实现 GetRankCounts | ✅ | |
| - 实现 TameBee 驯化蜜蜂 | ✅ | |
| - 实现 StoreBee 存入收纳袋 | ✅ | |
| - 实现 CollectAllBees 收取全部 | ✅ | |
| - 实现 ReleaseBees 释放指定数量 | ✅ | |
| - 实现 ReleaseBeesByRank 按品阶释放 | ✅ | |
| - 实现 ReleaseAllStoredBees | ✅ | |
| - 实现 SpawnBee 生成蜜蜂实体 | ✅ | |
| - 实现 GetCombatMode | ✅ | |
| - 实现 ToggleCombatMode | ✅ | |
| - 实现 SetAttackTarget | ✅ | |
| - 实现 OnBeeKilled | ✅ | |
| - 实现 OnSave/OnLoad | ✅ | |

### 1.8 物品图标 ✅

| 任务 | 状态 | 文件 |
|------|------|------|
| AI 生成图标原图 | ✅ | - |
| 调整为 64x64 像素 | ✅ | - |
| ImageMagick 处理透明背景 | ✅ | - |
| bee_taming_flute.png | ✅ | `images/inventoryimages/bee_taming_flute.png` |
| beehive_bag.png | ✅ | `images/inventoryimages/beehive_bag.png` |
| bee_command_wand.png | ✅ | `images/inventoryimages/bee_command_wand.png` |

---

## 第二阶段：资源转换与配方验证 ⏳

将 PNG 图标转换为游戏可识别的 TEX/XML 格式。

### 2.1 安装转换工具 ⏳

| 任务 | 状态 | 说明 |
|------|------|------|
| 安装 Steam | ⏳ | 如未安装 |
| 安装 Don't Starve Mod Tools | ⏳ | Steam 库 → 工具 → Don't Starve Mod Tools |
| 验证 autocompiler 可用 | ⏳ | 运行 Mod Tools 目录下的 autocompiler |
| （备选）安装 ktools | ⏳ | `brew install ktools` 或从 GitHub 下载 |

### 2.2 图标格式转换 ⏳

| 任务 | 状态 | 输入 | 输出 |
|------|------|------|------|
| 转换驯蜂笛图标 | ⏳ | `bee_taming_flute.png` | `.tex` + `.xml` |
| 转换蜂巢袋图标 | ⏳ | `beehive_bag.png` | `.tex` + `.xml` |
| 转换指挥棒图标 | ⏳ | `bee_command_wand.png` | `.tex` + `.xml` |
| 验证 TEX 文件大小 | ⏳ | 应为几 KB |
| 验证 XML 文件内容 | ⏳ | 包含正确的 Element 定义 |

### 2.3 配方验证 ⏳

| 任务 | 状态 | 说明 |
|------|------|------|
| 启动游戏进入测试存档 | ⏳ | |
| 打开制作栏检查配方显示 | ⏳ | 魔法栏/战斗栏 |
| 验证驯蜂笛配方材料 | ⏳ | 红蓝绿宝石×1 + 黄金×10 + 蜜脾×2 |
| 验证蜂巢袋配方材料 | ⏳ | 红蓝宝石×1 + 扣血100 |
| 验证指挥棒配方材料 | ⏳ | 黄金×10 + 扣血100 |
| 验证无科技需求 | ⏳ | 不需要解锁任何科技 |
| 制作物品测试 | ⏳ | 消耗材料，生成物品 |
| 验证物品图标显示 | ⏳ | 背包中显示正确图标 |

---

## 第三阶段：右键菜单与动作系统 ⏳

实现道具的右键菜单功能，让玩家可以操作蜜蜂。

### 3.1 自定义动作定义 ⏳

| 任务 | 状态 | 动作名 | 说明 |
|------|------|--------|------|
| 创建 TAME_BEES 动作 | ⏳ | `TAME_BEES` | 使用驯蜂笛驯化蜜蜂 |
| 创建 COLLECT_BEES 动作 | ⏳ | `COLLECT_BEES` | 收取全部蜜蜂 |
| 创建 RELEASE_BEES_1 动作 | ⏳ | `RELEASE_BEES_1` | 释放 1 只蜜蜂 |
| 创建 RELEASE_BEES_5 动作 | ⏳ | `RELEASE_BEES_5` | 释放 5 只蜜蜂 |
| 创建 RELEASE_RANK_1 动作 | ⏳ | `RELEASE_RANK_1` | 释放兵级蜜蜂 |
| 创建 RELEASE_RANK_2 动作 | ⏳ | `RELEASE_RANK_2` | 释放将级蜜蜂 |
| 创建 RELEASE_RANK_3 动作 | ⏳ | `RELEASE_RANK_3` | 释放王级蜜蜂 |
| 创建 RELEASE_RANK_4 动作 | ⏳ | `RELEASE_RANK_4` | 释放皇级蜜蜂 |
| 创建 RELEASE_RANK_5 动作 | ⏳ | `RELEASE_RANK_5` | 释放帝级蜜蜂 |
| 创建 TOGGLE_COMBAT_MODE 动作 | ⏳ | `TOGGLE_COMBAT_MODE` | 切换战斗模式 |

### 3.2 动作处理器 ⏳

| 任务 | 状态 | 说明 |
|------|------|------|
| 添加 TAME_BEES ActionHandler | ⏳ | 播放使用动画 |
| 添加 COLLECT_BEES ActionHandler | ⏳ | 播放收取动画 |
| 添加 RELEASE_BEES ActionHandler | ⏳ | 播放释放动画 |
| 添加 TOGGLE_COMBAT_MODE ActionHandler | ⏳ | 无动画，立即执行 |

### 3.3 组件动作绑定 ⏳

| 任务 | 状态 | 物品 | 动作列表 |
|------|------|------|----------|
| 驯蜂笛右键菜单 | ⏳ | `bee_taming_flute` | TAME_BEES |
| 蜂巢袋右键菜单 | ⏳ | `beehive_bag` | COLLECT, RELEASE×2, RANK×5 |
| 指挥棒右键菜单 | ⏳ | `bee_command_wand` | TOGGLE_COMBAT_MODE |

### 3.4 动作测试 ⏳

| 任务 | 状态 | 说明 |
|------|------|------|
| 测试驯蜂笛右键使用 | ⏳ | 范围内有蜜蜂时驯化 |
| 测试蜂巢袋收取全部 | ⏳ | 收回所有已释放蜜蜂 |
| 测试蜂巢袋释放 1 只 | ⏳ | 释放低品阶优先 |
| 测试蜂巢袋释放 5 只 | ⏳ | 连续释放 |
| 测试按品阶释放 | ⏳ | 释放指定品阶 |
| 测试模式切换 | ⏳ | 自主↔指挥 |
| 测试动作提示文本 | ⏳ | 显示正确的中文 |

---

## 第四阶段：AI 行为与战斗系统 ⏳

实现宠物蜜蜂的智能行为和战斗逻辑。

### 4.1 行为树 (Brain) ⏳

| 任务 | 状态 | 文件 |
|------|------|------|
| 创建 petbeebrain.lua | ⏳ | `scripts/brains/petbeebrain.lua` |
| - 引入 Brain 基类 | ⏳ | |
| - 引入行为节点类 | ⏳ | |
| 实现 OnStart 构建行为树 | ⏳ | |
| - PriorityNode 优先级节点 | ⏳ | |

### 4.2 行为节点实现 ⏳

| 任务 | 状态 | 优先级 | 说明 |
|------|------|--------|------|
| 攻击目标节点 | ⏳ | 1 | 有目标时追击攻击 |
| 自主攻击检测 | ⏳ | 2 | 检测对主人有仇恨的敌人 |
| 跟随主人节点 | ⏳ | 3 | 保持在主人 2-8 格范围 |
| 传送归位节点 | ⏳ | 4 | 距离超过 30 格时传送 |
| 闲置漫游节点 | ⏳ | 5 | 无事时在主人附近漫游 |

### 4.3 状态机 (StateGraph) ⏳

| 任务 | 状态 | 文件 |
|------|------|------|
| 创建 SGpetbee.lua | ⏳ | `scripts/stategraphs/SGpetbee.lua` |
| 实现 idle 状态 | ⏳ | 悬停动画 |
| 实现 fly 状态 | ⏳ | 飞行动画 |
| 实现 attack 状态 | ⏳ | 攻击动画 + 伤害判定 |
| 实现 hit 状态 | ⏳ | 受击动画 |
| 实现 death 状态 | ⏳ | 死亡动画 + 移除 |
| 定义状态转换事件 | ⏳ | attacked, killed, etc |

### 4.4 战斗模式逻辑 ⏳

| 任务 | 状态 | 模式 | 说明 |
|------|------|------|------|
| 自主模式目标选择 | ⏳ | auto | 攻击对主人有仇恨的敌人 |
| 自主模式范围检测 | ⏳ | auto | 10 格范围内 |
| 指挥模式目标锁定 | ⏳ | command | 攻击玩家指定的目标 |
| 指挥模式集火逻辑 | ⏳ | command | 所有蜜蜂攻击同一目标 |
| 目标死亡处理 | ⏳ | both | 目标死亡后重新选择 |

### 4.5 经验与升级测试 ⏳

| 任务 | 状态 | 说明 |
|------|------|------|
| 测试击杀 <100HP 获得 1 经验 | ⏳ | 兔子、鸟等 |
| 测试击杀 >=100HP 获得 5+HP*0.01 | ⏳ | 猪人、蜘蛛等 |
| 测试品阶升级触发 | ⏳ | 经验达到阈值 |
| 测试升级属性变化 | ⏳ | 颜色、大小、攻击、血量 |
| 测试升级特效播放 | ⏳ | electrichitsparks |

---

## 第五阶段：UI 系统 ⏳

实现蜂群状态面板，显示蜜蜂信息。

### 5.1 HUD Widget 基础 ⏳

| 任务 | 状态 | 文件 |
|------|------|------|
| 创建 beetamer_hud.lua | ⏳ | `scripts/widgets/beetamer_hud.lua` |
| - 继承 Widget 类 | ⏳ | |
| - 设置初始位置（状态栏附近） | ⏳ | |
| - 创建背景 Image | ⏳ | |
| - 创建文本 Text 组件 | ⏳ | |

### 5.2 显示内容 ⏳

| 任务 | 状态 | 显示项 | 格式示例 |
|------|------|--------|----------|
| 蜜蜂总数 | ⏳ | 存储/容量 | `蜜蜂: 156/1000` |
| 已释放数量 | ⏳ | 当前在外 | `出战: 10` |
| 品阶分布 | ⏳ | 各品阶数量 | `兵:100 将:50 王:5 皇:1 帝:0` |
| 战斗模式 | ⏳ | 当前模式 | `模式: 自主攻击` |

### 5.3 拖拽功能 ⏳

| 任务 | 状态 | 说明 |
|------|------|------|
| 实现 OnMouseDown 开始拖拽 | ⏳ | 记录鼠标偏移 |
| 实现 OnMouseUp 结束拖拽 | ⏳ | 保存位置 |
| 实现 OnUpdate 拖拽移动 | ⏳ | 跟随鼠标 |
| 边界检测 | ⏳ | 不超出屏幕 |

### 5.4 位置记忆 ⏳

| 任务 | 状态 | 说明 |
|------|------|------|
| 使用 TheSim:SetPersistentString | ⏳ | 保存位置到本地 |
| 使用 TheSim:GetPersistentString | ⏳ | 读取位置 |
| 默认位置设置 | ⏳ | 首次显示位置 |

### 5.5 HUD 注册 ⏳

| 任务 | 状态 | 说明 |
|------|------|------|
| AddClassPostConstruct 注入 | ⏳ | 注入 PlayerHud |
| 创建并添加 Widget | ⏳ | 添加到 HUD 层 |
| 显示/隐藏逻辑 | ⏳ | 有蜂巢袋时显示 |

---

## 第六阶段：场景处理与数据持久化 ⏳

处理特殊场景，确保数据正确保存。

### 6.1 玩家事件处理 ⏳

| 任务 | 状态 | 事件 | 处理 |
|------|------|------|------|
| 玩家死亡 | ⏳ | `death` | 收回所有蜜蜂 |
| 玩家重生 | ⏳ | `respawn` | 恢复状态 |
| 进入洞穴 | ⏳ | `ms_playerdespawnandmigrate` | 收回所有蜜蜂 |
| 退出洞穴 | ⏳ | `ms_playerjoined` | 恢复蜜蜂 |

### 6.2 物品事件处理 ⏳

| 任务 | 状态 | 事件 | 处理 |
|------|------|------|------|
| 蜂巢袋被丢弃 | ⏳ | `ondropped` | 释放所有存储的蜜蜂 |
| 蜂巢袋被销毁 | ⏳ | `onremove` | 释放所有存储的蜜蜂 |
| 蜂巢袋被拾取 | ⏳ | `onpickup` | 检查是否需要恢复蜜蜂 |

### 6.3 存档数据结构 ⏳

| 任务 | 状态 | 组件 | 存储内容 |
|------|------|------|----------|
| beetamer OnSave | ⏳ | `beetamer` | stored_bees, combat_mode |
| beetamer OnLoad | ⏳ | `beetamer` | 恢复存储数据 |
| pet_bee OnSave | ⏳ | `pet_bee` | exp, rank, owner_userid |
| pet_bee OnLoad | ⏳ | `pet_bee` | 恢复经验品阶 |

### 6.4 多人游戏兼容 ⏳

| 任务 | 状态 | 说明 |
|------|------|------|
| 每个玩家独立 beetamer | ⏳ | 组件挂载在各自玩家 |
| 蜜蜂 owner 正确绑定 | ⏳ | pet_bee.owner 指向正确玩家 |
| 网络同步测试 | ⏳ | 主客机蜜蜂状态同步 |
| 存档/读档测试 | ⏳ | 多人存档正确保存 |

---

## 第七阶段：特效与音效 ⏳

添加视觉和听觉反馈，提升游戏体验。

### 7.1 视觉特效 ⏳

| 任务 | 状态 | 场景 | 特效 |
|------|------|------|------|
| 驯蜂笛使用 | ⏳ | 吹奏时 | musicnotes 音符 |
| 驯化成功 | ⏳ | 蜜蜂被驯化 | hearts 爱心 |
| 释放蜜蜂 | ⏳ | 从袋中释放 | puff_spawning |
| 收回蜜蜂 | ⏳ | 收入袋中 | puff |
| 品阶提升 | ⏳ | 升级时 | electrichitsparks |
| 蜜蜂死亡 | ⏳ | 死亡时 | 小爆炸 + 蜂蜜掉落 |

### 7.2 音效 ⏳

| 任务 | 状态 | 场景 | 音效 |
|------|------|------|------|
| 驯蜂笛吹奏 | ⏳ | 使用时 | panflute 音效 |
| 蜜蜂飞行 | ⏳ | 飞行时 | bee_wing 音效 |
| 蜜蜂攻击 | ⏳ | 攻击时 | bee_attack 音效 |
| 收取/释放 | ⏳ | 操作时 | puff 音效 |
| 品阶提升 | ⏳ | 升级时 | levelup 音效 |

---

## 第八阶段：测试与修复 ⏳

全面测试，修复问题，发布准备。

### 8.1 单人模式测试 ⏳

| 任务 | 状态 | 测试项 |
|------|------|--------|
| 制作所有道具 | ⏳ | 配方正确，消耗正确 |
| 驯化普通蜜蜂 | ⏳ | 只驯化普通蜜蜂 |
| 收纳/释放蜜蜂 | ⏳ | 右键菜单正常 |
| 蜜蜂跟随主人 | ⏳ | 距离和传送正常 |
| 自主攻击模式 | ⏳ | 自动攻击敌对目标 |
| 指挥攻击模式 | ⏳ | 攻击指定目标 |
| 经验和升级 | ⏳ | 正确获得经验和升级 |
| 品阶外观变化 | ⏳ | 颜色、大小正确 |
| UI 面板显示 | ⏳ | 数据正确，拖拽正常 |
| 存档/读档 | ⏳ | 数据正确保存恢复 |

### 8.2 多人模式测试 ⏳

| 任务 | 状态 | 测试项 |
|------|------|--------|
| 多玩家各自驯化 | ⏳ | 蜜蜂独立归属 |
| 蜜蜂不跟随他人 | ⏳ | 只跟随主人 |
| 多人战斗 | ⏳ | 各自蜜蜂攻击目标 |
| 主机/客机同步 | ⏳ | 状态同步正确 |
| 玩家下线处理 | ⏳ | 蜜蜂正确处理 |

### 8.3 性能测试 ⏳

| 任务 | 状态 | 测试项 |
|------|------|--------|
| 100 只蜜蜂 | ⏳ | FPS 正常 |
| 500 只蜜蜂 | ⏳ | FPS 可接受 |
| 1000 只蜜蜂 | ⏳ | 测试极限 |
| 长时间运行 | ⏳ | 无内存泄漏 |

### 8.4 兼容性测试 ⏳

| 任务 | 状态 | 测试 Mod |
|------|------|----------|
| Combined Status | ⏳ | UI 不冲突 |
| Geometric Placement | ⏳ | 功能正常 |
| Global Positions | ⏳ | 功能正常 |
| 常用 Mod 合集 | ⏳ | 无明显冲突 |

### 8.5 发布准备 ⏳

| 任务 | 状态 | 说明 |
|------|------|------|
| 创建 modicon | ⏳ | Mod 图标 |
| 编写 README | ⏳ | 使用说明 |
| Steam 创意工坊发布 | ⏳ | 上传 Mod |
| 收集用户反馈 | ⏳ | 修复问题 |

---

## 开发进度总览

| 阶段 | 任务数 | 完成数 | 状态 |
|------|--------|--------|------|
| 第一阶段：基础框架 | 9 | 9 | ✅ 100% |
| 第二阶段：资源转换 | 12 | 0 | ⏳ 0% |
| 第三阶段：右键菜单 | 21 | 0 | ⏳ 0% |
| 第四阶段：AI 战斗 | 20 | 0 | ⏳ 0% |
| 第五阶段：UI 系统 | 15 | 0 | ⏳ 0% |
| 第六阶段：场景处理 | 12 | 0 | ⏳ 0% |
| 第七阶段：特效音效 | 11 | 0 | ⏳ 0% |
| 第八阶段：测试修复 | 25 | 0 | ⏳ 0% |

---

## 当前阻塞项

| 阻塞项 | 说明 | 解决方案 | 优先级 |
|--------|------|----------|--------|
| PNG 转 TEX | 需要 Klei 工具转换图标格式 | 安装 Steam Don't Starve Mod Tools | 高 |

---

## 更新日志

| 日期 | 更新内容 |
|------|----------|
| 2026-01-05 | 完成第一阶段基础框架开发 |
| 2026-01-05 | 创建开发任务清单文档 |
| 2026-01-05 | 细化所有阶段任务为具体子任务 |
