-- 驯蜂笛 (Bee Taming Flute)
-- 使用后驯化 10 格范围内的普通蜜蜂

local assets = {
    -- 不需要声明游戏内置动画资源，直接使用即可
}

local prefabs = {
    "musicnotes",    -- 音符特效
    "pet_bee",       -- 宠物蜜蜂
}

---------------------------------------------------------------------------
-- 常量定义
---------------------------------------------------------------------------

local TAMING_RANGE = 10      -- 驯化范围
local MAX_USES = 20          -- 最大使用次数

---------------------------------------------------------------------------
-- 驯化逻辑
---------------------------------------------------------------------------

-- 搜索范围内的普通蜜蜂
local function FindNearbyBees(inst, doer)
    local x, y, z = doer.Transform:GetWorldPosition()
    local bees = TheSim:FindEntities(x, y, z, TAMING_RANGE, {"bee"}, {"pet_bee", "INLIMBO"})

    local tamedCount = 0
    for _, bee in ipairs(bees) do
        -- 只驯化普通蜜蜂（不是杀人蜂）
        if bee.prefab == "bee" and bee:IsValid() then
            -- 获取玩家的 beetamer 组件
            local beetamer = doer.components.beetamer
            if beetamer then
                -- 驯化蜜蜂
                local success = beetamer:TameBee(bee)
                if success then
                    tamedCount = tamedCount + 1
                end
            end
        end
    end

    return tamedCount
end

-- 使用驯蜂笛
local function OnPlay(inst, doer)
    if doer == nil or doer.components.beetamer == nil then
        return false
    end

    -- 播放音效
    inst.SoundEmitter:PlaySound("dontstarve/wilson/flute_LP", "flute")

    -- 播放音符特效
    local fx = SpawnPrefab("musicnotes")
    if fx then
        fx.Transform:SetPosition(doer.Transform:GetWorldPosition())
    end

    -- 驯化蜜蜂
    local tamedCount = FindNearbyBees(inst, doer)

    -- 停止音效
    inst:DoTaskInTime(1.5, function()
        inst.SoundEmitter:KillSound("flute")
    end)

    -- 消耗耐久
    if inst.components.finiteuses then
        inst.components.finiteuses:Use()
    end

    -- 显示驯化结果
    if tamedCount > 0 then
        if doer.components.talker then
            doer.components.talker:Say("驯化了 " .. tamedCount .. " 只蜜蜂！")
        end
    else
        if doer.components.talker then
            doer.components.talker:Say("附近没有可驯化的蜜蜂...")
        end
    end

    return true
end

---------------------------------------------------------------------------
-- Prefab 定义
---------------------------------------------------------------------------

local function fn()
    local inst = CreateEntity()

    -- 基础组件
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    -- 物理碰撞
    MakeInventoryPhysics(inst)

    -- 动画设置（复用排箫）
    inst.AnimState:SetBank("panflute")
    inst.AnimState:SetBuild("panflute")
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
    inst.components.inventoryitem.atlasname = "images/inventoryimages/bee_taming_flute.xml"
    inst.components.inventoryitem.imagename = "bee_taming_flute"

    -- 有限使用次数
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(MAX_USES)
    inst.components.finiteuses:SetUses(MAX_USES)
    inst.components.finiteuses:SetOnFinished(inst.Remove)

    -- 使用功能（通过 spellcaster 组件）
    inst:AddComponent("spellcaster")
    inst.components.spellcaster:SetSpellFn(OnPlay)
    inst.components.spellcaster.canuseonpoint = true
    inst.components.spellcaster.canuseonpoint_water = false

    -- 标签
    inst:AddTag("bee_taming_flute")

    return inst
end

return Prefab("bee_taming_flute", fn, assets, prefabs)
