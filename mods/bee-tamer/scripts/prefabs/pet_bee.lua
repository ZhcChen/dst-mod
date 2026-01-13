-- 宠物蜜蜂 (Pet Bee)
-- 驯化后的蜜蜂，可升级、可战斗

local assets = {
    -- 不需要声明游戏内置动画资源，直接使用即可
}

local prefabs = {
    "electrichitsparks",  -- 升级特效
    "honey",              -- 蜂蜜掉落
}

---------------------------------------------------------------------------
-- 品阶配置
---------------------------------------------------------------------------

local RANKS = {
    [0] = {name = "普通", exp = 0,     scale = 1.0, color = {1, 1, 1},       damage = 5,  health = 25},
    [1] = {name = "兵",   exp = 10,    scale = 1.1, color = {1, 1, 0},       damage = 10, health = 50},
    [2] = {name = "将",   exp = 100,   scale = 1.2, color = {1, 0.5, 0},     damage = 20, health = 100},
    [3] = {name = "王",   exp = 500,   scale = 1.3, color = {1, 0, 0},       damage = 35, health = 180},
    [4] = {name = "皇",   exp = 2000,  scale = 1.4, color = {0.5, 0, 0.5},   damage = 55, health = 300},
    [5] = {name = "帝",   exp = 10000, scale = 1.5, color = {1, 0.84, 0},    damage = 80, health = 500},
}

---------------------------------------------------------------------------
-- 经验和升级
---------------------------------------------------------------------------

-- 检查并执行升级
local function CheckRankUp(inst)
    local currentRank = inst.rank or 0
    local currentExp = inst.exp or 0

    -- 检查是否可以升级
    for rank = currentRank + 1, 5 do
        if currentExp >= RANKS[rank].exp then
            -- 升级！
            inst.rank = rank
            local rankData = RANKS[rank]

            -- 更新属性
            inst.Transform:SetScale(rankData.scale, rankData.scale, rankData.scale)
            inst.AnimState:SetMultColour(rankData.color[1], rankData.color[2], rankData.color[3], 1)

            -- 更新战斗属性
            if inst.components.combat then
                inst.components.combat:SetDefaultDamage(rankData.damage)
            end
            if inst.components.health then
                inst.components.health:SetMaxHealth(rankData.health)
                inst.components.health:SetPercent(1) -- 升级时回满血
            end

            -- 播放升级特效
            local fx = SpawnPrefab("electrichitsparks")
            if fx then
                fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
            end

            print("[宠物蜜蜂] 升级到 " .. rankData.name .. " 级！")
        else
            break
        end
    end
end

-- 添加经验值
local function AddExp(inst, exp)
    inst.exp = (inst.exp or 0) + exp
    CheckRankUp(inst)
end

-- 计算击杀获得的经验
local function CalculateKillExp(victim)
    if victim and victim.components.health then
        local maxHealth = victim.components.health:GetMaxHealth()
        if maxHealth < 100 then
            return 1
        else
            return 5 + math.floor(maxHealth * 0.01)
        end
    end
    return 1
end

---------------------------------------------------------------------------
-- 战斗回调
---------------------------------------------------------------------------

local function OnKill(inst, data)
    if data and data.victim then
        local exp = CalculateKillExp(data.victim)
        AddExp(inst, exp)
    end
end

local function OnAttacked(inst, data)
    -- 被攻击时的反应
    if data and data.attacker and inst.components.combat then
        inst.components.combat:SetTarget(data.attacker)
    end
end

local function OnDeath(inst)
    -- 死亡时通知主人
    local owner = inst.owner
    if owner and owner.components.beetamer then
        owner.components.beetamer:OnBeeKilled(inst)
    end

    -- 有小概率掉落蜂蜜
    if math.random() < 0.3 then
        local honey = SpawnPrefab("honey")
        if honey then
            honey.Transform:SetPosition(inst.Transform:GetWorldPosition())
        end
    end
end

---------------------------------------------------------------------------
-- 跟随主人
---------------------------------------------------------------------------

local function FollowOwner(inst)
    if inst.owner and inst.owner:IsValid() then
        local owner = inst.owner

        -- 如果距离太远，传送到主人身边
        local myPos = inst:GetPosition()
        local ownerPos = owner:GetPosition()
        local dist = myPos:Dist(ownerPos)

        if dist > 30 then
            -- 太远了，传送过去
            inst.Transform:SetPosition(ownerPos:Get())
        elseif dist > 5 then
            -- 跟随主人
            if inst.components.locomotor then
                inst.components.locomotor:GoToPoint(ownerPos)
            end
        end
    end
end

---------------------------------------------------------------------------
-- 数据保存/加载
---------------------------------------------------------------------------

local function OnSave(inst, data)
    data.exp = inst.exp
    data.rank = inst.rank
    data.owner_userid = inst.owner and inst.owner.userid or nil
end

local function OnLoad(inst, data)
    if data then
        inst.exp = data.exp or 0
        inst.rank = data.rank or 0

        -- 应用品阶属性
        local rankData = RANKS[inst.rank]
        if rankData then
            inst.Transform:SetScale(rankData.scale, rankData.scale, rankData.scale)
            inst.AnimState:SetMultColour(rankData.color[1], rankData.color[2], rankData.color[3], 1)
            if inst.components.combat then
                inst.components.combat:SetDefaultDamage(rankData.damage)
            end
            if inst.components.health then
                inst.components.health:SetMaxHealth(rankData.health)
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
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    -- 物理
    MakeCharacterPhysics(inst, 1, 0.5)
    inst.DynamicShadow:SetSize(1, 0.75)

    -- 可飞行
    inst.Transform:SetFourFaced()

    -- 动画设置
    inst.AnimState:SetBank("bee")
    inst.AnimState:SetBuild("bee_build")
    inst.AnimState:PlayAnimation("idle", true)

    -- 标签
    inst:AddTag("pet_bee")
    inst:AddTag("flying")
    inst:AddTag("smallcreature")
    inst:AddTag("animal")

    -- 网络同步
    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    -- 可检查
    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = function(inst)
        local rankData = RANKS[inst.rank or 0]
        return rankData.name .. "级蜜蜂 (经验: " .. (inst.exp or 0) .. ")"
    end

    -- 血量
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(RANKS[0].health)

    -- 战斗
    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(RANKS[0].damage)
    inst.components.combat:SetAttackPeriod(2)
    inst.components.combat:SetRange(2)

    -- 移动
    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = 6
    inst.components.locomotor.runspeed = 8
    inst.components.locomotor:EnableGroundSpeedMultiplier(false)
    inst.components.locomotor:SetTriggersCreep(false)

    -- 初始属性
    inst.exp = 0
    inst.rank = 0
    inst.owner = nil

    -- 方法
    inst.AddExp = AddExp
    inst.CheckRankUp = CheckRankUp

    -- 事件监听
    inst:ListenForEvent("killed", OnKill)
    inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("death", OnDeath)

    -- 跟随任务
    inst:DoPeriodicTask(1, FollowOwner)

    -- 保存/加载
    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end

return Prefab("pet_bee", fn, assets, prefabs)
