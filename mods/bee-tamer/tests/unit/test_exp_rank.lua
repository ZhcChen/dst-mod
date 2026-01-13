-- 单元测试：经验和品阶计算
-- 运行: cd mods/bee-tamer && busted tests/unit/ --pattern="test"

require("tests.unit.test_helper")
local BeetamerLogic = require("beetamer_logic")

describe("经验计算", function()

    describe("CalculateKillExp", function()

        it("无效输入返回 0", function()
            assert.equals(0, BeetamerLogic.CalculateKillExp(nil))
            assert.equals(0, BeetamerLogic.CalculateKillExp(0))
            assert.equals(0, BeetamerLogic.CalculateKillExp(-10))
        end)

        it("血量 < 100 返回 1 经验", function()
            assert.equals(1, BeetamerLogic.CalculateKillExp(1))
            assert.equals(1, BeetamerLogic.CalculateKillExp(25))   -- 兔子
            assert.equals(1, BeetamerLogic.CalculateKillExp(50))   -- 鸟
            assert.equals(1, BeetamerLogic.CalculateKillExp(99))
        end)

        it("血量 >= 100 返回 5 + HP*0.01", function()
            assert.equals(6, BeetamerLogic.CalculateKillExp(100))   -- 5 + 1
            assert.equals(6, BeetamerLogic.CalculateKillExp(150))   -- 5 + floor(1.5) = 6
            assert.equals(7, BeetamerLogic.CalculateKillExp(200))   -- 5 + 2
            assert.equals(10, BeetamerLogic.CalculateKillExp(500))  -- 5 + 5
            assert.equals(15, BeetamerLogic.CalculateKillExp(1000)) -- 5 + 10 巨鹿
            assert.equals(55, BeetamerLogic.CalculateKillExp(5000)) -- 5 + 50 远古守护者
        end)

    end)

end)

describe("品阶计算", function()

    describe("CalculateRank", function()

        it("无效输入返回 0", function()
            assert.equals(0, BeetamerLogic.CalculateRank(nil))
            assert.equals(0, BeetamerLogic.CalculateRank(-10))
        end)

        it("经验 0-9 为普通级 (0)", function()
            assert.equals(0, BeetamerLogic.CalculateRank(0))
            assert.equals(0, BeetamerLogic.CalculateRank(5))
            assert.equals(0, BeetamerLogic.CalculateRank(9))
        end)

        it("经验 10-99 为兵级 (1)", function()
            assert.equals(1, BeetamerLogic.CalculateRank(10))
            assert.equals(1, BeetamerLogic.CalculateRank(50))
            assert.equals(1, BeetamerLogic.CalculateRank(99))
        end)

        it("经验 100-499 为将级 (2)", function()
            assert.equals(2, BeetamerLogic.CalculateRank(100))
            assert.equals(2, BeetamerLogic.CalculateRank(250))
            assert.equals(2, BeetamerLogic.CalculateRank(499))
        end)

        it("经验 500-1999 为王级 (3)", function()
            assert.equals(3, BeetamerLogic.CalculateRank(500))
            assert.equals(3, BeetamerLogic.CalculateRank(1000))
            assert.equals(3, BeetamerLogic.CalculateRank(1999))
        end)

        it("经验 2000-9999 为皇级 (4)", function()
            assert.equals(4, BeetamerLogic.CalculateRank(2000))
            assert.equals(4, BeetamerLogic.CalculateRank(5000))
            assert.equals(4, BeetamerLogic.CalculateRank(9999))
        end)

        it("经验 >= 10000 为帝级 (5)", function()
            assert.equals(5, BeetamerLogic.CalculateRank(10000))
            assert.equals(5, BeetamerLogic.CalculateRank(50000))
            assert.equals(5, BeetamerLogic.CalculateRank(100000))
        end)

    end)

    describe("GetRankData", function()

        it("返回正确的品阶属性", function()
            local rank0 = BeetamerLogic.GetRankData(0)
            assert.equals("普通", rank0.name)
            assert.equals(5, rank0.damage)
            assert.equals(25, rank0.health)

            local rank5 = BeetamerLogic.GetRankData(5)
            assert.equals("帝", rank5.name)
            assert.equals(80, rank5.damage)
            assert.equals(500, rank5.health)
        end)

        it("边界处理", function()
            local rankNeg = BeetamerLogic.GetRankData(-1)
            assert.equals("普通", rankNeg.name)

            local rankOver = BeetamerLogic.GetRankData(10)
            assert.equals("帝", rankOver.name)
        end)

    end)

    describe("GetExpToNextRank", function()

        it("返回升级所需经验", function()
            assert.equals(10, BeetamerLogic.GetExpToNextRank(0))
            assert.equals(100, BeetamerLogic.GetExpToNextRank(1))
            assert.equals(500, BeetamerLogic.GetExpToNextRank(2))
            assert.equals(2000, BeetamerLogic.GetExpToNextRank(3))
            assert.equals(10000, BeetamerLogic.GetExpToNextRank(4))
        end)

        it("满级返回 nil", function()
            assert.is_nil(BeetamerLogic.GetExpToNextRank(5))
        end)

    end)

end)
