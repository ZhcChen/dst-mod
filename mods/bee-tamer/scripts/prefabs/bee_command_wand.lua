-- 指挥棒 (Bee Command Wand)
-- 用于指挥蜜蜂战斗，装备后恢复精神值

local assets = {
    -- 不需要声明游戏内置动画资源，直接使用即可
}

local prefabs = {}

---------------------------------------------------------------------------
-- 常量定义
---------------------------------------------------------------------------

local DAMAGE = 34                -- 攻击力（与长矛相当）
local MAX_USES = 100             -- 最大使用次数
local SANITY_RATE = 0.01         -- 每分钟精神回复 = 0.01 * 蜜蜂数量

---------------------------------------------------------------------------
-- 精神回复
---------------------------------------------------------------------------

local function StartSanityAura(inst, owner)
    if inst.sanitytask then
        inst.sanitytask:Cancel()
    end

    -- 每 60 秒恢复一次精神
    inst.sanitytask = inst:DoPeriodicTask(60, function()
        if owner and owner.components.beetamer and owner.components.sanity then
            local beeCount = owner.components.beetamer:GetTotalBeeCount()
            local sanityGain = SANITY_RATE * beeCount
            if sanityGain > 0 then
                owner.components.sanity:DoDelta(sanityGain)
            end
        end
    end)
end

local function StopSanityAura(inst)
    if inst.sanitytask then
        inst.sanitytask:Cancel()
        inst.sanitytask = nil
    end
end

---------------------------------------------------------------------------
-- 装备回调
---------------------------------------------------------------------------

local function OnEquip(inst, owner)
    -- 显示手持动画
    owner.AnimState:OverrideSymbol("swap_object", "spear", "swap_spear")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

    -- 开始精神回复
    StartSanityAura(inst, owner)

    -- 记录拥有者
    inst.owner = owner
end

local function OnUnequip(inst, owner)
    -- 恢复动画
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")

    -- 停止精神回复
    StopSanityAura(inst)

    inst.owner = nil
end

---------------------------------------------------------------------------
-- 战斗模式切换
---------------------------------------------------------------------------

local function ToggleCombatMode(inst, doer)
    local beetamer = doer.components.beetamer
    if beetamer then
        local newMode = beetamer:ToggleCombatMode()
        local modeNames = {
            auto = "自主攻击",
            command = "指挥攻击"
        }
        if doer.components.talker then
            doer.components.talker:Say("战斗模式：" .. modeNames[newMode])
        end
    end
end

---------------------------------------------------------------------------
-- 攻击目标指定
---------------------------------------------------------------------------

local function OnAttack(inst, attacker, target)
    -- 指挥模式下，点击敌人设置为攻击目标
    if attacker and attacker.components.beetamer then
        local mode = attacker.components.beetamer:GetCombatMode()
        if mode == "command" and target then
            attacker.components.beetamer:SetAttackTarget(target)
            if attacker.components.talker then
                attacker.components.talker:Say("进攻目标！")
            end
        end
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

    -- 动画设置（复用长矛）
    inst.AnimState:SetBank("spear")
    inst.AnimState:SetBuild("spear")
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
    inst.components.inventoryitem.atlasname = "images/inventoryimages/bee_command_wand.xml"
    inst.components.inventoryitem.imagename = "bee_command_wand"

    -- 武器组件
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(DAMAGE)
    inst.components.weapon:SetOnAttack(OnAttack)

    -- 有限使用次数
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(MAX_USES)
    inst.components.finiteuses:SetUses(MAX_USES)
    inst.components.finiteuses:SetOnFinished(inst.Remove)

    -- 可装备（武器槽）
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)

    -- 标签
    inst:AddTag("bee_command_wand")

    -- 右键菜单功能
    inst.ToggleCombatMode = ToggleCombatMode
    inst.actions = {
        {name = "切换模式", fn = "ToggleCombatMode"},
    }

    return inst
end

return Prefab("bee_command_wand", fn, assets, prefabs)
