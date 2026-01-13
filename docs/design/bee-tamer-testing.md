# 蜂群驯化师 - 测试指南

## 测试架构

```
mods/bee-tamer/
├── tests/
│   └── unit/                    # 单元测试（busted 框架）
│       ├── test_exp_rank.lua    # 经验和品阶计算测试
│       └── test_capacity_sanity.lua  # 容量和精神恢复测试
└── scripts/
    ├── beetamer_logic.lua       # 可测试的纯逻辑模块
    └── tests/
        └── test_runner.lua      # 游戏内集成测试运行器
```

---

## 一、单元测试（本地运行）

使用 busted 框架测试纯逻辑函数，无需启动游戏。

### 1.1 安装 busted

```bash
# macOS
brew install luarocks
luarocks install busted
```

### 1.2 运行测试

```bash
cd /Users/chen/code/dst-mod/mods/bee-tamer

# 运行所有单元测试
busted tests/unit/

# 运行指定测试文件
busted tests/unit/test_exp_rank.lua
busted tests/unit/test_capacity_sanity.lua

# 显示详细输出
busted tests/unit/ --verbose
```

### 1.3 测试覆盖

| 测试文件 | 测试内容 |
|----------|----------|
| `test_exp_rank.lua` | 经验计算、品阶判定、升级阈值 |
| `test_capacity_sanity.lua` | 容量检查、精神恢复、群体伤害 |

---

## 二、集成测试（游戏内运行）

通过控制台命令触发自动化测试链路。

### 2.1 准备工作

1. 将 Mod 链接到游戏目录：

```bash
ln -sf /Users/chen/code/dst-mod/mods/bee-tamer \
    ~/Documents/Klei/DoNotStarveTogether/client_save/mods/bee-tamer
```

2. 启动游戏，启用 Mod，进入存档

### 2.2 测试命令

在游戏控制台（按 `~` 打开）中输入：

```lua
-- 运行所有集成测试
beetamer_test()

-- 运行指定测试套件
beetamer_test("Prefab 生成测试")
beetamer_test("玩家组件测试")
beetamer_test("驯化流程测试")
beetamer_test("收纳释放测试")
beetamer_test("宠物蜜蜂升级测试")

-- 列出所有可用测试套件
beetamer_test_list()

-- 快捷命令
bt_test()      -- 等同于 beetamer_test()
bt_list()      -- 等同于 beetamer_test_list()
```

### 2.3 测试套件说明

| 测试套件 | 测试内容 |
|----------|----------|
| Prefab 生成测试 | 驯蜂笛、蜂巢袋、指挥棒、宠物蜜蜂的生成和组件检查 |
| 玩家组件测试 | beetamer 组件存在性、初始状态、容量设置、模式切换 |
| 驯化流程测试 | 驯化普通蜜蜂、边界条件处理 |
| 收纳释放测试 | 释放蜜蜂、收取蜜蜂 |
| 宠物蜜蜂升级测试 | 经验累加、自动升级、属性变化 |

### 2.4 测试输出示例

```
============================================================
        蜂群驯化师 - 集成测试
============================================================

[测试套件] Prefab 生成测试
--------------------------------------------------
  ✓ 驯蜂笛可以生成
  ✓ 蜂巢袋可以生成
  ✓ 指挥棒可以生成
  ✓ 宠物蜜蜂可以生成

[测试套件] 玩家组件测试
--------------------------------------------------
  ✓ 玩家拥有 beetamer 组件
  ✓ beetamer 初始状态正确
  ✓ 可以设置容量
  ✓ 可以切换战斗模式

============================================================
测试完成: 8 通过, 0 失败
============================================================
```

---

## 三、添加新测试

### 3.1 添加单元测试

编辑 `tests/unit/` 下的文件或创建新文件：

```lua
-- tests/unit/test_new_feature.lua
package.path = package.path .. ";../../scripts/?.lua"
local BeetamerLogic = require("beetamer_logic")

describe("新功能测试", function()
    it("测试用例描述", function()
        assert.equals(期望值, BeetamerLogic.新函数())
    end)
end)
```

### 3.2 添加集成测试

编辑 `scripts/tests/test_runner.lua`：

```lua
TestRunner.RegisterSuite("新功能测试", {

    ["测试用例名称"] = function()
        -- 测试代码
        assert_true(条件, "失败消息")
        assert_equals(期望值, 实际值, "失败消息")
    end,

})
```

---

## 四、测试策略

| 测试类型 | 方法 | 自动化 | 说明 |
|----------|------|--------|------|
| 纯逻辑测试 | busted | ✅ 全自动 | 本地运行，无需游戏 |
| Prefab 测试 | 游戏内命令 | ✅ 全自动 | 需进入游戏执行命令 |
| 组件测试 | 游戏内命令 | ✅ 全自动 | 需进入游戏执行命令 |
| 流程测试 | 游戏内命令 | ✅ 全自动 | 需进入游戏执行命令 |
| UI 测试 | 手动 | ❌ 手动 | 目视检查 |
| 性能测试 | 手动 | ❌ 手动 | 需观察 FPS |

---

## 五、CI 集成（可选）

可以将单元测试集成到 CI 流程：

```yaml
# .github/workflows/test.yml
name: Unit Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Install Lua
        run: sudo apt-get install -y lua5.3 luarocks
      - name: Install busted
        run: sudo luarocks install busted
      - name: Run tests
        run: cd mods/bee-tamer && busted tests/unit/
```
