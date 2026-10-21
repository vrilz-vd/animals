local url_features = "https://raw.githubusercontent.com/vrilz-vd/animals/main/features.lua"
local url_ui       = "https://raw.githubusercontent.com/vrilz-vd/animals/main/ui.lua"

-- Load features dulu
local okF, resF = pcall(game:HttpGet, url_features)
if not okF then warn("[VRILZ] Gagal download features:", resF); return end

local f, errF = loadstring(resF)
if not f then warn("[VRILZ] Features syntax error:", errF); return end

local okRun, errRun = pcall(f)
if not okRun then warn("[VRILZ] Features runtime error:", errRun); return end

print("[VRILZ] ✅ Features loaded")

task.wait(1)

-- Load UI
local okU, resU = pcall(game:HttpGet, url_ui)
if not okU then warn("[VRILZ] Gagal download UI:", resU); return end

local u, errU = loadstring(resU)
if not u then warn("[VRILZ] UI syntax error:", errU); return end

local okRun2, errRun2 = pcall(u)
if not okRun2 then warn("[VRILZ] UI runtime error:", errRun2); return end

print("[VRILZ] ✅ UI loaded")
