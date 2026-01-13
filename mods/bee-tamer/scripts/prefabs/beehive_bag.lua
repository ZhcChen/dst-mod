-- 蜂巢袋 (Beehive Bag)
-- 用于收纳和释放宠物蜜蜂

local assets = {
    -- 不需要声明游戏内置动画资源，直接使用即可
}

local prefabs = {
    "puff_spawning",  -- 释放特效
    "puff",           -- 收回特效
}

---------------------------------------------------------------------------
-- 右键菜单动作
---------------------------------------------------------------------------

-- 定义右键菜单选项
local ACTIONS = {
    {name = "收取全部", fn = "CollectAll"},
    {name = "释放 1 只", fn = "Release", args = {count = 1}},
    {name = "释放 5 只", fn = "Release", args = {count = 5}},
    {name = "释放兵级", fn = "ReleaseByRank", args = {rank = 1}},
    {name = "释放将级", fn = "ReleaseByRank", args = {rank = 2}},
    {name = "释放王级", fn = "ReleaseByRank", args = {rank = 3}},
    {name = "释放皇级", fn = "ReleaseByRank", args = {rank = 4}},
    {name = "释放帝级", fn = "ReleaseByRank", args = {rank = 5}},
}

-- 收取所有蜜蜂
local function CollectAll(inst, doer)
    local beetamer = doer.components.beetamer
    if beetamer then
        local count = beetamer:CollectAllBees()
        if doer.components.talker then
            if count > 0 then
                doer.components.talker:Say("收取了 " .. count .. " 只蜜蜂")
            else
                doer.components.talker:Say("没有蜜蜂需要收取")
            end
        end
    end
end

-- 释放指定数量的蜜蜂
local function Release(inst, doer, count)
    local beetamer = doer.components.beetamer
    if beetamer then
        local released = beetamer:ReleaseBees(count)
        if doer.components.talker then
            if released > 0 then
                doer.components.talker:Say("释放了 " .. released .. " 只蜜蜂")
            else
                doer.components.talker:Say("没有可释放的蜜蜂")
            end
        end
    end
end

-- 释放指定品阶的蜜蜂
local function ReleaseByRank(inst, doer, rank)
    local beetamer = doer.components.beetamer
    if beetamer then
        local released = beetamer:ReleaseBeesByRank(rank, 1)
        local rankNames = {"兵", "将", "王", "皇", "帝"}
        if doer.components.talker then
            if released > 0 then
                doer.components.talker:Say("释放了 1 只" .. rankNames[rank] .. "级蜜蜂")
            else
                doer.components.talker:Say("没有" .. rankNames[rank] .. "级蜜蜂可释放")
            end
        end
    end
end

---------------------------------------------------------------------------
-- 蜂巢袋丢失处理
---------------------------------------------------------------------------

local function OnDropped(inst)
    -- 蜂巢袋被丢弃时，释放所有蜜蜂
    local owner = inst.components.inventoryitem.owner
    if owner and owner.components.beetamer then
        owner.components.beetamer:ReleaseAllStoredBees()
    end
end

local function OnRemoved(inst)
    -- 蜂巢袋被销毁时，释放所有蜜蜂
    local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
    if owner and owner.components.beetamer then
        owner.components.beetamer:ReleaseAllStoredBees()
    end
end

---------------------------------------------------------------------------
-- Prefab 定义
---------------------------------------------------------------------------

local function fn()
    local inst = CreateEntity()

    -- 基础组件
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    -- 物理碰撞
    MakeInventoryPhysics(inst)

    -- 动画设置（复用背包）
    inst.AnimState:SetBank("backpack")
    inst.AnimState:SetBuild("backpack")
    inst.AnimState:PlayAnimation("idle")

    -- 网络同步
    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    -- 可检查
    inst:AddComponent("inspectable")

    -- 可放入背包
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/beehive_bag.xml"
    inst.components.inventoryitem.imagename = "beehive_bag"
    inst.components.inventoryitem:SetOnDroppedFn(OnDropped)

    -- 标签
    inst:AddTag("beehive_bag")

    -- 右键菜单功能
    inst.CollectAll = CollectAll
    inst.Release = Release
    inst.ReleaseByRank = ReleaseByRank
    inst.actions = ACTIONS

    -- 移除时的处理
    inst:ListenForEvent("onremove", OnRemoved)

    return inst
end

return Prefab("beehive_bag", fn, assets, prefabs)
