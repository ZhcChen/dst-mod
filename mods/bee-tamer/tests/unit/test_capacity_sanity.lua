-- 单元测试：容量和精神恢复计算
-- 运行: cd mods/bee-tamer && busted tests/unit/ --pattern="test"

require("tests.unit.test_helper")
local BeetamerLogic = require("beetamer_logic")

describe("容量检查", function()

    describe("CanStore", function()

        it("无效输入返回 false", function()
            assert.is_false(BeetamerLogic.CanStore(nil, 1000))
            assert.is_false(BeetamerLogic.CanStore(100, nil))
            assert.is_false(BeetamerLogic.CanStore(nil, nil))
        end)

        it("未满时可存储", function()
            assert.is_true(BeetamerLogic.CanStore(0, 1000))
            assert.is_true(BeetamerLogic.CanStore(500, 1000))
            assert.is_true(BeetamerLogic.CanStore(999, 1000))
        end)

        it("已满时不可存储", function()
            assert.is_false(BeetamerLogic.CanStore(1000, 1000))
            assert.is_false(BeetamerLogic.CanStore(1001, 1000))
        end)

    end)

    describe("GetAvailableSpace", function()

        it("无效输入返回 0", function()
            assert.equals(0, BeetamerLogic.GetAvailableSpace(nil, 1000))
            assert.equals(0, BeetamerLogic.GetAvailableSpace(100, nil))
        end)

        it("返回正确的可用空间", function()
            assert.equals(1000, BeetamerLogic.GetAvailableSpace(0, 1000))
            assert.equals(500, BeetamerLogic.GetAvailableSpace(500, 1000))
            assert.equals(1, BeetamerLogic.GetAvailableSpace(999, 1000))
            assert.equals(0, BeetamerLogic.GetAvailableSpace(1000, 1000))
        end)

        it("超出容量返回 0", function()
            assert.equals(0, BeetamerLogic.GetAvailableSpace(1500, 1000))
        end)

    end)

end)

describe("精神恢复计算", function()

    describe("CalculateSanityGain", function()

        it("无效输入返回 0", function()
            assert.equals(0, BeetamerLogic.CalculateSanityGain(nil, 1))
            assert.equals(0, BeetamerLogic.CalculateSanityGain(100, nil))
            assert.equals(0, BeetamerLogic.CalculateSanityGain(0, 1))
            assert.equals(0, BeetamerLogic.CalculateSanityGain(100, 0))
            assert.equals(0, BeetamerLogic.CalculateSanityGain(-10, 1))
            assert.equals(0, BeetamerLogic.CalculateSanityGain(100, -5))
        end)

        it("正确计算精神恢复 (0.01 * 蜜蜂数 * 分钟)", function()
            -- 1只蜜蜂, 1分钟 = 0.01
            assert.equals(0.01, BeetamerLogic.CalculateSanityGain(1, 1))

            -- 100只蜜蜂, 1分钟 = 1.0
            assert.equals(1.0, BeetamerLogic.CalculateSanityGain(100, 1))

            -- 100只蜜蜂, 10分钟 = 10.0
            assert.equals(10.0, BeetamerLogic.CalculateSanityGain(100, 10))

            -- 1000只蜜蜂, 60分钟 = 600
            assert.equals(600, BeetamerLogic.CalculateSanityGain(1000, 60))
        end)

    end)

end)

describe("群体伤害计算", function()

    describe("CalculateSwarmDamage", function()

        it("空列表返回 0", function()
            assert.equals(0, BeetamerLogic.CalculateSwarmDamage(nil))
            assert.equals(0, BeetamerLogic.CalculateSwarmDamage({}))
        end)

        it("单只蜜蜂伤害", function()
            assert.equals(5, BeetamerLogic.CalculateSwarmDamage({{rank = 0}}))
            assert.equals(10, BeetamerLogic.CalculateSwarmDamage({{rank = 1}}))
            assert.equals(80, BeetamerLogic.CalculateSwarmDamage({{rank = 5}}))
        end)

        it("多只蜜蜂伤害累加", function()
            -- 3只普通 = 15
            assert.equals(15, BeetamerLogic.CalculateSwarmDamage({
                {rank = 0}, {rank = 0}, {rank = 0}
            }))

            -- 混合品阶: 普通(5) + 兵(10) + 将(20) = 35
            assert.equals(35, BeetamerLogic.CalculateSwarmDamage({
                {rank = 0}, {rank = 1}, {rank = 2}
            }))

            -- 帝级军团: 5只帝级 = 400
            assert.equals(400, BeetamerLogic.CalculateSwarmDamage({
                {rank = 5}, {rank = 5}, {rank = 5}, {rank = 5}, {rank = 5}
            }))
        end)

        it("无品阶信息默认为 0 级", function()
            assert.equals(5, BeetamerLogic.CalculateSwarmDamage({{}}))
            assert.equals(10, BeetamerLogic.CalculateSwarmDamage({{}, {}}))
        end)

    end)

end)
