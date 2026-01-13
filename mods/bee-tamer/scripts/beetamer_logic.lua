-- 可测试的纯逻辑函数模块
-- 这些函数不依赖游戏环境，可以用 busted 进行单元测试

local BeetamerLogic = {}

---------------------------------------------------------------------------
-- 品阶配置
---------------------------------------------------------------------------

BeetamerLogic.RANKS = {
    [0] = {name = "普通", exp = 0,     scale = 1.0, color = {1, 1, 1},       damage = 5,  health = 25},
    [1] = {name = "兵",   exp = 10,    scale = 1.1, color = {1, 1, 0},       damage = 10, health = 50},
    [2] = {name = "将",   exp = 100,   scale = 1.2, color = {1, 0.5, 0},     damage = 20, health = 100},
    [3] = {name = "王",   exp = 500,   scale = 1.3, color = {1, 0, 0},       damage = 35, health = 180},
    [4] = {name = "皇",   exp = 2000,  scale = 1.4, color = {0.5, 0, 0.5},   damage = 55, health = 300},
    [5] = {name = "帝",   exp = 10000, scale = 1.5, color = {1, 0.84, 0},    damage = 80, health = 500},
}

---------------------------------------------------------------------------
-- 经验计算
---------------------------------------------------------------------------

--- 计算击杀目标获得的经验值
--- @param maxHealth number 目标最大血量
--- @return number 经验值
function BeetamerLogic.CalculateKillExp(maxHealth)
    if maxHealth == nil or maxHealth <= 0 then
        return 0
    end
    if maxHealth < 100 then
        return 1
    else
        return 5 + math.floor(maxHealth * 0.01)
    end
end

---------------------------------------------------------------------------
-- 品阶计算
---------------------------------------------------------------------------

--- 根据经验值计算品阶
--- @param exp number 当前经验值
--- @return number 品阶 (0-5)
function BeetamerLogic.CalculateRank(exp)
    if exp == nil or exp < 0 then
        return 0
    end
    for rank = 5, 1, -1 do
        if exp >= BeetamerLogic.RANKS[rank].exp then
            return rank
        end
    end
    return 0
end

--- 获取品阶属性
--- @param rank number 品阶
--- @return table 品阶属性
function BeetamerLogic.GetRankData(rank)
    rank = rank or 0
    if rank < 0 then rank = 0 end
    if rank > 5 then rank = 5 end
    return BeetamerLogic.RANKS[rank]
end

--- 计算升级所需经验
--- @param currentRank number 当前品阶
--- @return number|nil 升级所需经验，已满级返回 nil
function BeetamerLogic.GetExpToNextRank(currentRank)
    if currentRank >= 5 then
        return nil
    end
    return BeetamerLogic.RANKS[currentRank + 1].exp
end

---------------------------------------------------------------------------
-- 精神恢复计算
---------------------------------------------------------------------------

--- 计算精神恢复量
--- @param beeCount number 蜜蜂数量
--- @param minutesPassed number 经过的分钟数
--- @return number 精神恢复量
function BeetamerLogic.CalculateSanityGain(beeCount, minutesPassed)
    if beeCount == nil or beeCount <= 0 then
        return 0
    end
    if minutesPassed == nil or minutesPassed <= 0 then
        return 0
    end
    local ratePerMinute = 0.01 * beeCount
    return ratePerMinute * minutesPassed
end

---------------------------------------------------------------------------
-- 容量检查
---------------------------------------------------------------------------

--- 检查是否可以存储更多蜜蜂
--- @param currentCount number 当前数量
--- @param capacity number 容量上限
--- @return boolean 是否可存储
function BeetamerLogic.CanStore(currentCount, capacity)
    if currentCount == nil or capacity == nil then
        return false
    end
    return currentCount < capacity
end

--- 计算可存储的蜜蜂数量
--- @param currentCount number 当前数量
--- @param capacity number 容量上限
--- @return number 可存储数量
function BeetamerLogic.GetAvailableSpace(currentCount, capacity)
    if currentCount == nil or capacity == nil then
        return 0
    end
    local space = capacity - currentCount
    return space > 0 and space or 0
end

---------------------------------------------------------------------------
-- 伤害计算
---------------------------------------------------------------------------

--- 计算蜜蜂群体伤害
--- @param bees table 蜜蜂列表 {{rank = 1}, {rank = 2}, ...}
--- @return number 总伤害
function BeetamerLogic.CalculateSwarmDamage(bees)
    if bees == nil or #bees == 0 then
        return 0
    end
    local totalDamage = 0
    for _, bee in ipairs(bees) do
        local rank = bee.rank or 0
        local rankData = BeetamerLogic.RANKS[rank]
        if rankData then
            totalDamage = totalDamage + rankData.damage
        end
    end
    return totalDamage
end

return BeetamerLogic
