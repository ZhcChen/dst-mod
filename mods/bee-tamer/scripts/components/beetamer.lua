-- beetamer 组件
-- 蜂群管理器，挂载在玩家身上，管理所有宠物蜜蜂

local Beetamer = Class(function(self, inst)
    self.inst = inst

    -- 收纳袋中的蜜蜂（按品阶分类存储）
    -- 每个蜜蜂存储为 {exp = number, rank = number}
    self.stored_bees = {
        [0] = {},  -- 普通
        [1] = {},  -- 兵级
        [2] = {},  -- 将级
        [3] = {},  -- 王级
        [4] = {},  -- 皇级
        [5] = {},  -- 帝级
    }

    -- 已释放的蜜蜂（Entity 引用列表）
    self.released_bees = {}

    -- 战斗模式：auto（自主攻击）或 command（指挥攻击）
    self.combat_mode = "auto"

    -- 当前攻击目标
    self.attack_target = nil

    -- 配置
    self.capacity = 1000
end)

---------------------------------------------------------------------------
-- 配置
---------------------------------------------------------------------------

function Beetamer:SetCapacity(capacity)
    self.capacity = capacity or 1000
end

function Beetamer:GetCapacity()
    return self.capacity
end

---------------------------------------------------------------------------
-- 统计
---------------------------------------------------------------------------

-- 获取收纳袋中的蜜蜂总数
function Beetamer:GetStoredBeeCount()
    local count = 0
    for rank = 0, 5 do
        count = count + #self.stored_bees[rank]
    end
    return count
end

-- 获取已释放的蜜蜂数量
function Beetamer:GetReleasedBeeCount()
    -- 清理无效的引用
    local valid = {}
    for _, bee in ipairs(self.released_bees) do
        if bee:IsValid() and bee.components.health and not bee.components.health:IsDead() then
            table.insert(valid, bee)
        end
    end
    self.released_bees = valid
    return #self.released_bees
end

-- 获取存活蜜蜂总数（收纳 + 释放）
function Beetamer:GetTotalBeeCount()
    return self:GetStoredBeeCount() + self:GetReleasedBeeCount()
end

-- 获取各品阶的蜜蜂数量
function Beetamer:GetRankCounts()
    local counts = {}
    for rank = 0, 5 do
        counts[rank] = #self.stored_bees[rank]
    end

    -- 统计已释放的蜜蜂
    for _, bee in ipairs(self.released_bees) do
        if bee:IsValid() then
            local rank = bee.rank or 0
            counts[rank] = (counts[rank] or 0) + 1
        end
    end

    return counts
end

---------------------------------------------------------------------------
-- 驯化
---------------------------------------------------------------------------

-- 驯化一只蜜蜂
function Beetamer:TameBee(bee)
    if not bee or not bee:IsValid() then
        return false
    end

    -- 获取原蜜蜂的位置
    local x, y, z = bee.Transform:GetWorldPosition()

    -- 移除原蜜蜂
    bee:Remove()

    -- 创建宠物蜜蜂
    local petBee = SpawnPrefab("pet_bee")
    if not petBee then
        return false
    end

    -- 设置位置
    petBee.Transform:SetPosition(x, y, z)

    -- 设置主人
    petBee.owner = self.inst

    -- 播放驯化特效
    local fx = SpawnPrefab("hearts")
    if fx then
        fx.Transform:SetPosition(x, y, z)
    end

    -- 检查是否有空间收纳
    if self:GetStoredBeeCount() < self.capacity then
        -- 有空间，存入收纳袋
        self:StoreBee(petBee)
    else
        -- 没空间，作为跟随者存在
        table.insert(self.released_bees, petBee)
    end

    return true
end

---------------------------------------------------------------------------
-- 收纳
---------------------------------------------------------------------------

-- 将蜜蜂存入收纳袋
function Beetamer:StoreBee(bee)
    if not bee or not bee:IsValid() then
        return false
    end

    local rank = bee.rank or 0
    local exp = bee.exp or 0

    -- 存储数据
    table.insert(self.stored_bees[rank], {exp = exp, rank = rank})

    -- 播放收回特效
    local fx = SpawnPrefab("puff")
    if fx then
        fx.Transform:SetPosition(bee.Transform:GetWorldPosition())
    end

    -- 移除实体
    bee:Remove()

    return true
end

-- 收取所有已释放的蜜蜂
function Beetamer:CollectAllBees()
    local count = 0
    local bees = {}

    -- 复制列表以避免修改时出错
    for _, bee in ipairs(self.released_bees) do
        table.insert(bees, bee)
    end

    for _, bee in ipairs(bees) do
        if bee:IsValid() and self:GetStoredBeeCount() < self.capacity then
            if self:StoreBee(bee) then
                count = count + 1
            end
        end
    end

    -- 清理已释放列表
    self.released_bees = {}
    for _, bee in ipairs(bees) do
        if bee:IsValid() then
            table.insert(self.released_bees, bee)
        end
    end

    return count
end

---------------------------------------------------------------------------
-- 释放
---------------------------------------------------------------------------

-- 从收纳袋中释放蜜蜂（低品阶优先）
function Beetamer:ReleaseBees(count)
    count = count or 1
    local released = 0

    for rank = 0, 5 do
        while #self.stored_bees[rank] > 0 and released < count do
            local beeData = table.remove(self.stored_bees[rank], 1)
            if self:SpawnBee(beeData) then
                released = released + 1
            end
        end
        if released >= count then
            break
        end
    end

    return released
end

-- 释放指定品阶的蜜蜂
function Beetamer:ReleaseBeesByRank(rank, count)
    rank = rank or 0
    count = count or 1
    local released = 0

    while #self.stored_bees[rank] > 0 and released < count do
        local beeData = table.remove(self.stored_bees[rank], 1)
        if self:SpawnBee(beeData) then
            released = released + 1
        end
    end

    return released
end

-- 释放所有收纳的蜜蜂（蜂巢袋丢失时调用）
function Beetamer:ReleaseAllStoredBees()
    for rank = 0, 5 do
        while #self.stored_bees[rank] > 0 do
            local beeData = table.remove(self.stored_bees[rank], 1)
            self:SpawnBee(beeData)
        end
    end
end

-- 生成一只蜜蜂实体
function Beetamer:SpawnBee(beeData)
    if not beeData then
        return false
    end

    -- 获取玩家位置（稍微偏移）
    local x, y, z = self.inst.Transform:GetWorldPosition()
    local offset = math.random() * 2
    local angle = math.random() * 2 * math.pi
    x = x + math.cos(angle) * offset
    z = z + math.sin(angle) * offset

    -- 创建蜜蜂
    local bee = SpawnPrefab("pet_bee")
    if not bee then
        return false
    end

    -- 设置位置
    bee.Transform:SetPosition(x, y, z)

    -- 恢复数据
    bee.exp = beeData.exp or 0
    bee.rank = beeData.rank or 0
    bee.owner = self.inst

    -- 应用品阶属性
    bee:CheckRankUp()

    -- 播放释放特效
    local fx = SpawnPrefab("puff_spawning")
    if fx then
        fx.Transform:SetPosition(x, y, z)
    end

    -- 加入已释放列表
    table.insert(self.released_bees, bee)

    return true
end

---------------------------------------------------------------------------
-- 战斗
---------------------------------------------------------------------------

-- 获取战斗模式
function Beetamer:GetCombatMode()
    return self.combat_mode
end

-- 切换战斗模式
function Beetamer:ToggleCombatMode()
    if self.combat_mode == "auto" then
        self.combat_mode = "command"
    else
        self.combat_mode = "auto"
    end
    return self.combat_mode
end

-- 设置攻击目标
function Beetamer:SetAttackTarget(target)
    self.attack_target = target

    -- 命令所有已释放的蜜蜂攻击目标
    for _, bee in ipairs(self.released_bees) do
        if bee:IsValid() and bee.components.combat then
            bee.components.combat:SetTarget(target)
        end
    end
end

-- 蜜蜂被击杀时的回调
function Beetamer:OnBeeKilled(bee)
    -- 从已释放列表中移除
    for i, b in ipairs(self.released_bees) do
        if b == bee then
            table.remove(self.released_bees, i)
            break
        end
    end
end

---------------------------------------------------------------------------
-- 场景处理
---------------------------------------------------------------------------

-- 玩家死亡时收回所有蜜蜂
function Beetamer:OnPlayerDeath()
    self:CollectAllBees()
end

-- 进入洞穴时收回所有蜜蜂
function Beetamer:OnPlayerMigrate()
    self:CollectAllBees()
end

---------------------------------------------------------------------------
-- 数据持久化
---------------------------------------------------------------------------

function Beetamer:OnSave()
    local data = {
        stored_bees = self.stored_bees,
        combat_mode = self.combat_mode,
    }
    return data
end

function Beetamer:OnLoad(data)
    if data then
        if data.stored_bees then
            self.stored_bees = data.stored_bees
        end
        if data.combat_mode then
            self.combat_mode = data.combat_mode
        end
    end
end

return Beetamer
