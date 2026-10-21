local url_features = "https://raw.githubusercontent.com/vrilz-vd/animals/main/features.lua"
local url_ui = "https://raw.githubusercontent.com/vrilz-vd/animals/main/ui.lua"

local ok, res = pcall(game:HttpGet, url_features)
if ok then local f = loadstring(res); if f then pcall(f) end end
task.wait(1)
local ok2, res2 = pcall(game:HttpGet, url_ui)
if ok2 then local f2 = loadstring(res2); if f2 then pcall(f2) end end
