-- ============================================================
-- VRILZHUB FEATURES — CLIMB FOR ANIMAL (FIXED MULTI FILTER)
-- ============================================================

local Features = {}
local Shared = _G.VRILZ_Shared or {}

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- ⭐ HELPER: Cek apakah egg ini diizinkan (Multi Filter)
local function isEggAllowed(biomeName, eggName)
    local areaFilter = Shared.StealAreaFilter or {}
    local rarityFilter = Shared.StealRarityFilter or {}
    
    -- Cek Area (Kalau kosong atau ada "All", berarti semua area)
    local matchArea = false
    if next(areaFilter) == nil or areaFilter["All"] then
        matchArea = true
    else
        if areaFilter[biomeName] then matchArea = true end
    end
    if not matchArea then return false end
    
    -- Cek Rarity (Kalau kosong atau ada "All", berarti semua rarity)
    local EggRarity = {
        ["Gold Fish"] = "Common", ["Chicken"] = "Common", ["Hamster"] = "Common",
        ["Frog"] = "Rare", ["Cat"] = "Rare", ["Pigeon"] = "Rare", ["Ostrich"] = "Rare",
        ["Crocodile"] = "Epic", ["Bear"] = "Epic", ["Crab"] = "Epic", ["Koala"] = "Epic",
        ["T-Rex"] = "Legendary", ["Dragon"] = "Legendary", ["Pegasus"] = "Legendary", ["Unicorn"] = "Legendary",
        ["Hydra"] = "Mythic", ["Griffin"] = "Mythic", ["Kraken"] = "Mythic",
        ["Simurgh"] = "Divine", ["YI QI"] = "Divine"
    }
    local rarity = EggRarity[eggName] or "Common"
    
    local matchRarity = false
    if next(rarityFilter) == nil or rarityFilter["All"] then
        matchRarity = true
    else
        if rarityFilter[rarity] then matchRarity = true end
    end
    
    return matchRarity
end

-- ⭐ HELPER: Balik ke Base (Ambil dari SpawnEggs di Island)
local function returnToBase()
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return false end
    
    -- Karena Base gak ketemu di recon, kita balik ke SpawnEggs area pertama
    local islands = Workspace:FindFirstChild("Structures") and Workspace.Structures:FindFirstChild("Islands")
    local targetPart
    if islands then
        for _, island in ipairs(islands:GetChildren()) do
            local spawn = island:FindFirstChild("SpawnEggs")
            if spawn and spawn:IsA("BasePart") then
                targetPart = spawn
                break
            end
        end
    end
    
    if not targetPart then return false end
    
    -- TP step by step (aman)
    local target = targetPart.Position + Vector3.new(0, 5, 0)
    local start = myRoot.Position
    local dist = (target - start).Magnitude
    local steps = math.ceil(dist / 100)
    local dir = (target - start).Unit
    
    for i = 1, steps do
        local r = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not r then return false end
        r.CFrame = CFrame.new(start + dir * math.min(100 * i, dist))
        task.wait(0.05)
    end
    task.wait(0.3)
    return true
end

-- ============================================================
-- AUTO STEAL (FIXED TP + MULTI FILTER)
-- ============================================================
local AutoStealState = { Enabled = false, Status = "Idle" }

function Features.setAutoSteal(v)
    AutoStealState.Enabled = v
    AutoStealState.Status = v and "Active" or "Idle"
end
function Features.getAutoStealState() return AutoStealState end

task.spawn(function()
    while task.wait(0.5) do
        if not AutoStealState.Enabled then continue end
        
        local spawned = Workspace:FindFirstChild("SpawnedEggs")
        if not spawned then continue end
        
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end
        
        local targetEgg, targetPart, targetPrompt
        local closestDist = math.huge
        
        -- Cari egg yang paling deket & sesuai filter
        for _, biome in ipairs(spawned:GetChildren()) do
            for _, egg in ipairs(biome:GetChildren()) do
                if egg:IsA("Model") and egg.Name ~= "Nest" then
                    
                    -- ⭐ Cek Multi-Filter
                    if isEggAllowed(biome.Name, egg.Name) then
                        local part = egg:FindFirstChildWhichIsA("BasePart", true)
                        local prompt = egg:FindFirstChildWhichIsA("ProximityPrompt", true) -- Ambil prompt apapun
                        
                        if part and prompt then
                            local d = (part.Position - hrp.Position).Magnitude
                            if d < closestDist then
                                closestDist = d
                                targetEgg = egg
                                targetPart = part
                                targetPrompt = prompt
                            end
                        end
                    end
                end
            end
        end
        
        if targetEgg and targetPart and targetPrompt then
            AutoStealState.Status = "TP ke: " .. targetEgg.Name
            
            -- ⭐ FIX TP: Langsung ke posisi egg
            hrp.CFrame = CFrame.new(targetPart.Position + Vector3.new(0, 3, 0))
            hrp.Velocity = Vector3.zero
            task.wait(0.15)
            
            targetPrompt.HoldDuration = 0
            targetPrompt.MaxActivationDistance = math.huge
            targetPrompt.RequiresLineOfSight = false
            
            for _ = 1, 8 do
                if fireproximityprompt then pcall(fireproximityprompt, targetPrompt) end
                task.wait(0.15)
                if not targetEgg.Parent then break end
            end
            
            AutoStealState.Status = "✅ Stolen: " .. targetEgg.Name
            
            -- ⭐ AUTO RETURN
            if Shared.AutoReturn_Enabled then
                AutoStealState.Status = "🏠 Returning to Base..."
                returnToBase()
            end
            task.wait(0.5)
        else
            AutoStealState.Status = "Menunggu egg spawn..."
        end
    end
end)

-- (FITUR LAIN SEPERTI SPEED & HATCH TETAP SAMA)
local SpeedState = { Enabled = false, Value = 100 }
function Features.setSpeed(v) SpeedState.Enabled = v end
function Features.setSpeedValue(v)
    SpeedState.Value = v
    if SpeedState.Enabled then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = v end
    end
end
function Features.getSpeedState() return SpeedState end

task.spawn(function()
    while task.wait(0.3) do
        if SpeedState.Enabled then
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum and hum.WalkSpeed ~= SpeedState.Value then hum.WalkSpeed = SpeedState.Value end
        end
    end
end)

_G.VRILZ_Features = Features
_G.VRILZ_Shared = Shared
print("[VRILZHUB] Features Loaded (Fixed)")
