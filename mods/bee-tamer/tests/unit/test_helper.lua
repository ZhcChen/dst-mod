-- 测试环境配置
-- 设置正确的 package.path 以便加载模块

local function get_script_dir()
    local info = debug.getinfo(1, "S")
    local path = info.source:match("@(.*/)")
    return path or "./"
end

local script_dir = get_script_dir()
local mod_root = script_dir .. "../../"
local scripts_dir = mod_root .. "scripts/"

-- 添加 scripts 目录到 package.path
package.path = package.path .. ";" .. scripts_dir .. "?.lua"
package.path = package.path .. ";" .. scripts_dir .. "?/init.lua"

return {
    mod_root = mod_root,
    scripts_dir = scripts_dir,
}
