-- ============================================================
-- VRILZHUB LOADER — CLIMB FOR ANIMAL
-- ============================================================

-- Load Fitur
local featUrl = "https://raw.githubusercontent.com/vrilz-vd/animals/main/features.lua"
local ok1, featRes = pcall(game:HttpGet, featUrl)
if ok1 then
    local func1, err1 = loadstring(featRes)
    if func1 then pcall(func1) else warn("[VH] Syntax Error Features: " .. tostring(err1)) end
else
    warn("[VH] Gagal download features.lua")
end

task.wait(2) -- Tunggu fitur load

-- Load UI
local uiUrl = "https://raw.githubusercontent.com/vrilz-vd/animals/main/ui.lua"
local ok2, uiRes = pcall(game:HttpGet, uiUrl)
if ok2 then
    local func2, err2 = loadstring(uiRes)
    if func2 then pcall(func2) else warn("[VH] Syntax Error UI: " .. tostring(err2)) end
else
    warn("[VH] Gagal download ui.lua")
end
