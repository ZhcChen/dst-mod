-- 集成测试运行器
-- 在游戏内执行，通过控制台命令 beetamer_test() 触发

local TestRunner = {}

---------------------------------------------------------------------------
-- 测试结果记录
---------------------------------------------------------------------------

local results = {
    passed = 0,
    failed = 0,
    errors = {},
    current_suite = "",
}

local function reset_results()
    results.passed = 0
    results.failed = 0
    results.errors = {}
    results.current_suite = ""
end

---------------------------------------------------------------------------
-- 断言函数
---------------------------------------------------------------------------

local function assert_true(condition, message)
    if condition then
        results.passed = results.passed + 1
        return true
    else
        results.failed = results.failed + 1
        table.insert(results.errors, {
            suite = results.current_suite,
            message = message or "断言失败: 期望 true"
        })
        return false
    end
end

local function assert_false(condition, message)
    return assert_true(not condition, message or "断言失败: 期望 false")
end

local function assert_equals(expected, actual, message)
    if expected == actual then
        results.passed = results.passed + 1
        return true
    else
        results.failed = results.failed + 1
        table.insert(results.errors, {
            suite = results.current_suite,
            message = (message or "断言失败") .. string.format(": 期望 %s, 实际 %s", tostring(expected), tostring(actual))
        })
        return false
    end
end

local function assert_not_nil(value, message)
    return assert_true(value ~= nil, message or "断言失败: 期望非 nil")
end

local function assert_nil(value, message)
    return assert_true(value == nil, message or "断言失败: 期望 nil")
end

---------------------------------------------------------------------------
-- 测试套件定义
---------------------------------------------------------------------------

local test_suites = {}

--- 注册测试套件
function TestRunner.RegisterSuite(name, tests)
    test_suites[name] = tests
end

--- 运行单个测试套件
local function run_suite(name, tests)
    results.current_suite = name
    print(string.format("\n[测试套件] %s", name))
    print(string.rep("-", 50))

    for test_name, test_fn in pairs(tests) do
        local success, err = pcall(test_fn)
        if success then
            print(string.format("  ✓ %s", test_name))
        else
            results.failed = results.failed + 1
            table.insert(results.errors, {
                suite = name,
                message = string.format("%s: %s", test_name, tostring(err))
            })
            print(string.format("  ✗ %s: %s", test_name, tostring(err)))
        end
    end
end

---------------------------------------------------------------------------
-- 测试用例：Prefab 生成
---------------------------------------------------------------------------

TestRunner.RegisterSuite("Prefab 生成测试", {

    ["驯蜂笛可以生成"] = function()
        local inst = SpawnPrefab("bee_taming_flute")
        assert_not_nil(inst, "驯蜂笛生成失败")
        if inst then
            assert_not_nil(inst.components.inventoryitem, "缺少 inventoryitem 组件")
            assert_not_nil(inst.components.finiteuses, "缺少 finiteuses 组件")
            inst:Remove()
        end
    end,

    ["蜂巢袋可以生成"] = function()
        local inst = SpawnPrefab("beehive_bag")
        assert_not_nil(inst, "蜂巢袋生成失败")
        if inst then
            assert_not_nil(inst.components.inventoryitem, "缺少 inventoryitem 组件")
            inst:Remove()
        end
    end,

    ["指挥棒可以生成"] = function()
        local inst = SpawnPrefab("bee_command_wand")
        assert_not_nil(inst, "指挥棒生成失败")
        if inst then
            assert_not_nil(inst.components.weapon, "缺少 weapon 组件")
            assert_not_nil(inst.components.equippable, "缺少 equippable 组件")
            assert_equals(34, inst.components.weapon.damage, "武器伤害不正确")
            inst:Remove()
        end
    end,

    ["宠物蜜蜂可以生成"] = function()
        local inst = SpawnPrefab("pet_bee")
        assert_not_nil(inst, "宠物蜜蜂生成失败")
        if inst then
            assert_not_nil(inst.components.health, "缺少 health 组件")
            assert_not_nil(inst.components.combat, "缺少 combat 组件")
            assert_not_nil(inst.components.locomotor, "缺少 locomotor 组件")
            assert_equals(0, inst.rank, "初始品阶应为 0")
            assert_equals(0, inst.exp, "初始经验应为 0")
            inst:Remove()
        end
    end,

})

---------------------------------------------------------------------------
-- 测试用例：玩家组件
---------------------------------------------------------------------------

TestRunner.RegisterSuite("玩家组件测试", {

    ["玩家拥有 beetamer 组件"] = function()
        assert_not_nil(ThePlayer, "ThePlayer 不存在")
        assert_not_nil(ThePlayer.components.beetamer, "玩家缺少 beetamer 组件")
    end,

    ["beetamer 初始状态正确"] = function()
        local beetamer = ThePlayer.components.beetamer
        assert_not_nil(beetamer, "beetamer 组件不存在")
        if beetamer then
            assert_equals(0, beetamer:GetStoredBeeCount(), "初始存储蜜蜂数应为 0")
            assert_equals("auto", beetamer:GetCombatMode(), "初始战斗模式应为 auto")
        end
    end,

    ["可以设置容量"] = function()
        local beetamer = ThePlayer.components.beetamer
        if beetamer then
            beetamer:SetCapacity(500)
            assert_equals(500, beetamer:GetCapacity(), "容量设置失败")
            beetamer:SetCapacity(1000)  -- 恢复默认
        end
    end,

    ["可以切换战斗模式"] = function()
        local beetamer = ThePlayer.components.beetamer
        if beetamer then
            local mode = beetamer:ToggleCombatMode()
            assert_equals("command", mode, "切换后应为 command 模式")
            mode = beetamer:ToggleCombatMode()
            assert_equals("auto", mode, "再次切换应为 auto 模式")
        end
    end,

})

---------------------------------------------------------------------------
-- 测试用例：驯化流程
---------------------------------------------------------------------------

TestRunner.RegisterSuite("驯化流程测试", {

    ["可以驯化普通蜜蜂"] = function()
        local beetamer = ThePlayer.components.beetamer
        if not beetamer then return end

        -- 生成一只普通蜜蜂
        local bee = SpawnPrefab("bee")
        assert_not_nil(bee, "无法生成普通蜜蜂")
        if not bee then return end

        bee.Transform:SetPosition(ThePlayer.Transform:GetWorldPosition())
        local before = beetamer:GetTotalBeeCount()

        -- 执行驯化
        local success = beetamer:TameBee(bee)
        assert_true(success, "驯化应该成功")

        local after = beetamer:GetTotalBeeCount()
        assert_equals(before + 1, after, "蜜蜂数量应该增加 1")
    end,

    ["不能驯化 nil"] = function()
        local beetamer = ThePlayer.components.beetamer
        if beetamer then
            local success = beetamer:TameBee(nil)
            assert_false(success, "驯化 nil 应该失败")
        end
    end,

})

---------------------------------------------------------------------------
-- 测试用例：收纳释放
---------------------------------------------------------------------------

TestRunner.RegisterSuite("收纳释放测试", {

    ["可以释放蜜蜂"] = function()
        local beetamer = ThePlayer.components.beetamer
        if not beetamer then return end

        -- 确保有蜜蜂可释放
        if beetamer:GetStoredBeeCount() == 0 then
            -- 先驯化一只
            local bee = SpawnPrefab("bee")
            if bee then
                bee.Transform:SetPosition(ThePlayer.Transform:GetWorldPosition())
                beetamer:TameBee(bee)
            end
        end

        local storedBefore = beetamer:GetStoredBeeCount()
        if storedBefore > 0 then
            local released = beetamer:ReleaseBees(1)
            assert_equals(1, released, "应该释放 1 只蜜蜂")
            assert_equals(storedBefore - 1, beetamer:GetStoredBeeCount(), "存储数量应该减少 1")
        end
    end,

    ["可以收取所有蜜蜂"] = function()
        local beetamer = ThePlayer.components.beetamer
        if not beetamer then return end

        local releasedBefore = beetamer:GetReleasedBeeCount()
        if releasedBefore > 0 then
            local collected = beetamer:CollectAllBees()
            assert_true(collected >= 0, "收取数量应该 >= 0")
        end
    end,

})

---------------------------------------------------------------------------
-- 测试用例：宠物蜜蜂升级
---------------------------------------------------------------------------

TestRunner.RegisterSuite("宠物蜜蜂升级测试", {

    ["经验可以累加"] = function()
        local bee = SpawnPrefab("pet_bee")
        if not bee then return end

        assert_equals(0, bee.exp, "初始经验应为 0")
        bee:AddExp(5)
        assert_equals(5, bee.exp, "经验应为 5")
        bee:AddExp(10)
        assert_equals(15, bee.exp, "经验应为 15")
        bee:Remove()
    end,

    ["达到阈值自动升级"] = function()
        local bee = SpawnPrefab("pet_bee")
        if not bee then return end

        assert_equals(0, bee.rank, "初始品阶应为 0")
        bee:AddExp(10)
        assert_equals(1, bee.rank, "达到 10 经验应升为兵级")
        bee:AddExp(90)
        assert_equals(2, bee.rank, "达到 100 经验应升为将级")
        bee:Remove()
    end,

    ["升级后属性变化"] = function()
        local bee = SpawnPrefab("pet_bee")
        if not bee then return end

        local initialDamage = bee.components.combat.defaultdamage
        bee:AddExp(100)  -- 升到将级
        local newDamage = bee.components.combat.defaultdamage
        assert_true(newDamage > initialDamage, "升级后伤害应该增加")
        bee:Remove()
    end,

})

---------------------------------------------------------------------------
-- 主运行函数
---------------------------------------------------------------------------

function TestRunner.Run(suite_name)
    reset_results()

    print("\n" .. string.rep("=", 60))
    print("        蜂群驯化师 - 集成测试")
    print(string.rep("=", 60))

    if suite_name then
        -- 运行指定套件
        local suite = test_suites[suite_name]
        if suite then
            run_suite(suite_name, suite)
        else
            print("[错误] 未找到测试套件: " .. suite_name)
            return
        end
    else
        -- 运行所有套件
        for name, tests in pairs(test_suites) do
            run_suite(name, tests)
        end
    end

    -- 打印结果
    print("\n" .. string.rep("=", 60))
    print(string.format("测试完成: %d 通过, %d 失败", results.passed, results.failed))

    if #results.errors > 0 then
        print("\n失败详情:")
        for i, err in ipairs(results.errors) do
            print(string.format("  [%s] %s", err.suite, err.message))
        end
    end

    print(string.rep("=", 60))

    return results.failed == 0
end

--- 列出所有测试套件
function TestRunner.ListSuites()
    print("\n可用的测试套件:")
    for name, tests in pairs(test_suites) do
        local count = 0
        for _ in pairs(tests) do count = count + 1 end
        print(string.format("  - %s (%d 个测试)", name, count))
    end
end

return TestRunner
