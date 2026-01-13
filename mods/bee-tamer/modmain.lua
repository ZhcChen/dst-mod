-- 蜂群驯化师 (Bee Tamer) - 入口文件
-- 驯化蜜蜂成为战斗宠物

---------------------------------------------------------------------------
-- 全局变量和配置
---------------------------------------------------------------------------

-- 获取 Mod 配置
local BAG_CAPACITY = GetModConfigData("bag_capacity") or 1000

-- Mod 资源路径
local MODROOT = MODROOT or ""

---------------------------------------------------------------------------
-- 资源加载
---------------------------------------------------------------------------

-- 加载物品图标
Assets = {
    Asset("IMAGE", "images/inventoryimages/bee_taming_flute.tex"),
    Asset("ATLAS", "images/inventoryimages/bee_taming_flute.xml"),
    Asset("IMAGE", "images/inventoryimages/beehive_bag.tex"),
    Asset("ATLAS", "images/inventoryimages/beehive_bag.xml"),
    Asset("IMAGE", "images/inventoryimages/bee_command_wand.tex"),
    Asset("ATLAS", "images/inventoryimages/bee_command_wand.xml"),
}

---------------------------------------------------------------------------
-- Prefab 注册
---------------------------------------------------------------------------

-- 注册新的 Prefab
PrefabFiles = {
    "bee_taming_flute",     -- 驯蜂笛
    "beehive_bag",          -- 蜂巢袋
    "bee_command_wand",     -- 指挥棒
    "pet_bee",              -- 宠物蜜蜂
}

---------------------------------------------------------------------------
-- 配方注册
---------------------------------------------------------------------------

-- 添加图标到物品图库
local function RegisterInventoryImages()
    RegisterInventoryItemAtlas("images/inventoryimages/bee_taming_flute.xml", "bee_taming_flute.tex")
    RegisterInventoryItemAtlas("images/inventoryimages/beehive_bag.xml", "beehive_bag.tex")
    RegisterInventoryItemAtlas("images/inventoryimages/bee_command_wand.xml", "bee_command_wand.tex")
end

-- 添加制作配方
local function AddRecipes()
    -- 引用全局变量
    local TECH = GLOBAL.TECH
    local CHARACTER_INGREDIENT = GLOBAL.CHARACTER_INGREDIENT

    -- 驯蜂笛：魔法栏，无科技需求
    -- 配方：红宝石×1 + 蓝宝石×1 + 绿宝石×1 + 黄金×10 + 蜜脾×2
    AddRecipe2(
        "bee_taming_flute",                           -- 物品名
        {                                              -- 配方
            Ingredient("redgem", 1),
            Ingredient("bluegem", 1),
            Ingredient("greengem", 1),
            Ingredient("goldnugget", 10),
            Ingredient("honeycomb", 2),
        },
        TECH.NONE,                                     -- 无科技需求
        {
            atlas = "images/inventoryimages/bee_taming_flute.xml",
            image = "bee_taming_flute.tex",
        },
        {"MAGIC"}                                      -- 魔法栏
    )

    -- 蜂巢袋：魔法栏，无科技需求
    -- 配方：红宝石×1 + 蓝宝石×1 + 扣血100（通过配方中的 HealthIngredient 实现）
    AddRecipe2(
        "beehive_bag",
        {
            Ingredient("redgem", 1),
            Ingredient("bluegem", 1),
            Ingredient(CHARACTER_INGREDIENT.HEALTH, 100),  -- 扣血100
        },
        TECH.NONE,
        {
            atlas = "images/inventoryimages/beehive_bag.xml",
            image = "beehive_bag.tex",
        },
        {"MAGIC"}
    )

    -- 指挥棒：战斗栏，无科技需求
    -- 配方：黄金×10 + 扣血100
    AddRecipe2(
        "bee_command_wand",
        {
            Ingredient("goldnugget", 10),
            Ingredient(CHARACTER_INGREDIENT.HEALTH, 100),
        },
        TECH.NONE,
        {
            atlas = "images/inventoryimages/bee_command_wand.xml",
            image = "bee_command_wand.tex",
        },
        {"WEAPONS"}                                    -- 战斗栏
    )
end

---------------------------------------------------------------------------
-- 玩家组件添加
---------------------------------------------------------------------------

-- 给玩家添加 beetamer 组件
local function OnPlayerPostInit(inst)
    if not TheWorld.ismastersim then
        return
    end

    -- 添加蜂群管理器组件
    if not inst.components.beetamer then
        inst:AddComponent("beetamer")
        inst.components.beetamer:SetCapacity(BAG_CAPACITY)
    end
end

-- 监听玩家生成
AddPlayerPostInit(OnPlayerPostInit)

---------------------------------------------------------------------------
-- 初始化
---------------------------------------------------------------------------

-- 注册图标
RegisterInventoryImages()

-- 添加配方
AddRecipes()

---------------------------------------------------------------------------
-- 测试命令注册
---------------------------------------------------------------------------

-- 注册全局测试命令，在游戏控制台中使用
-- 用法:
--   beetamer_test()        -- 运行所有测试
--   beetamer_test("Prefab 生成测试")  -- 运行指定测试套件
--   beetamer_test_list()   -- 列出所有测试套件

GLOBAL.beetamer_test = function(suite_name)
    local TestRunner = require("tests/test_runner")
    return TestRunner.Run(suite_name)
end

GLOBAL.beetamer_test_list = function()
    local TestRunner = require("tests/test_runner")
    TestRunner.ListSuites()
end

-- 快速测试命令
GLOBAL.bt_test = GLOBAL.beetamer_test
GLOBAL.bt_list = GLOBAL.beetamer_test_list

---------------------------------------------------------------------------
-- 调试信息
---------------------------------------------------------------------------

print("[蜂群驯化师] Mod 加载完成")
print("[蜂群驯化师] 蜂巢袋容量: " .. BAG_CAPACITY)
print("[蜂群驯化师] 测试命令已注册: beetamer_test(), beetamer_test_list()")
