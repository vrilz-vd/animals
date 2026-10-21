-- ============================================================
-- VRILZHUB FEATURES — CLIMB FOR ANIMAL (AUTO STEAL + RETURN)
-- ============================================================

local Features = {}
local Shared = _G.VRILZ_Shared or {}

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- ⭐ Helper Remote Knit
local function getKnitRemote(serviceName, remoteName)
    local src = ReplicatedStorage:FindFirstChild("src")
    local packages = src and src:FindFirstChild("Packages")
    local index = packages and packages:FindFirstChild("_Index")
    if not index then return nil end
    local knitFolder
    for _, folder in ipairs(index:GetChildren()) do
        if folder.Name:find("sleitnick_knit", 1, true) then knitFolder = folder; break end
    end
    if not knitFolder then return nil end
    local services = knitFolder:FindFirstChild("knit")
    services = services and services:FindFirstChild("Services")
    if not services then return nil end
    local service = services:FindFirstChild(serviceName)
    if not service then return nil end
    return service:FindFirstChild("RF_" .. remoteName) or service:FindFirstChild("RE_" .. remoteName)
end

-- ⭐ HELPER: Cari Base / Plot Player
local function getMyBase()
    local structures = Workspace:FindFirstChild("Structures")
    local bases = structures and structures:FindFirstChild("Bases")
    if not bases then return nil end
    
    for _, base in ipairs(bases:GetChildren()) do
        local owner = base:GetAttribute("OwnerUserId") or base:GetAttribute("Owner")
        if owner == LocalPlayer.UserId or owner == LocalPlayer.Name then
            return base
        end
    end
    return bases:FindFirstChild("Base") -- Fallback
end

-- ⭐ HELPER: Return ke Base (TP Step biar aman)
local function returnToBase()
    local base = getMyBase()
    if not base then return false end
    
    local spawn = base:FindFirstChild("Spawn", true) 
        or base:FindFirstChildWhichIsA("SpawnLocation", true)
        or base:FindFirstChildWhichIsA("BasePart", true)
        
    if not spawn then return false end
    
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    
    -- TP Step (per 100 studs)
    local target = spawn.Position + Vector3.new(0, 5, 0)
    local start = hrp.Position
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
-- AUTO STEAL (FILTER AREA + RARITY + AUTO RETURN)
-- ============================================================
local AutoStealState = { 
    Enabled = false, 
    FilterArea = "All",
    FilterRarity = "All",
    Status = "Idle",
    Stolen = 0
}

function Features.setAutoSteal(v)
    AutoStealState.Enabled = v
    AutoStealState.Status = v and "Active" or "Idle"
end

function Features.setAutoStealFilters(area, rarity)
    AutoStealState.FilterArea = area or "All"
    AutoStealState.FilterRarity = rarity or "All"
end

function Features.getAutoStealState() return AutoStealState end

-- Daftar Rarity berdasarkan nama egg di game lu
local EggRarity = {
    ["Gold Fish"] = "Common", ["Chicken"] = "Common", ["Hamster"] = "Common",
    ["Frog"] = "Rare", ["Cat"] = "Rare", ["Pigeon"] = "Rare", ["Ostrich"] = "Rare",
    ["Crocodile"] = "Epic", ["Bear"] = "Epic", ["Crab"] = "Epic", ["Koala"] = "Epic",
    ["T-Rex"] = "Legendary", ["Dragon"] = "Legendary", ["Pegasus"] = "Legendary", ["Unicorn"] = "Legendary",
    ["Hydra"] = "Mythic", ["Griffin"] = "Mythic", ["Kraken"] = "Mythic",
    ["Simurgh"] = "Divine", ["YI QI"] = "Divine"
}

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
        
        -- Cari Egg sesuai Filter
        for _, biome in ipairs(spawned:GetChildren()) do
            -- Cek Filter Area
            if AutoStealState.FilterArea ~= "All" and biome.Name ~= AutoStealState.FilterArea then
                continue
            end
            
            for _, egg in ipairs(biome:GetChildren()) do
                if egg:IsA("Model") and egg.Name ~= "Nest" then
                    
                    -- Cek Filter Rarity
                    local rarity = EggRarity[egg.Name] or "Common"
                    if AutoStealState.FilterRarity ~= "All" and rarity ~= AutoStealState.FilterRarity then
                        continue
                    end
                    
                    local part = egg:FindFirstChildWhichIsA("BasePart", true)
                    local prompt = egg:FindFirstChild("StealPrompt", true)
                    
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
        
        -- Eksekusi Steal
        if targetEgg and targetPart and targetPrompt then
            AutoStealState.Status = "Stealing: " .. targetEgg.Name
            hrp.CFrame = CFrame.new(targetPart.Position + Vector3.new(0, 3, 0))
            task.wait(0.1)
            
            targetPrompt.HoldDuration = 0
            targetPrompt.MaxActivationDistance = math.huge
            
            for _ = 1, 5 do
                if fireproximityprompt then pcall(fireproximityprompt, targetPrompt) end
                task.wait(0.1)
                if not targetEgg.Parent then break end
            end
            
            AutoStealState.Stolen = AutoStealState.Stolen + 1
            AutoStealState.Status = "✅ Stolen: " .. targetEgg.Name
            
            -- AUTO RETURN KE BASE
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

-- ============================================================
-- SPEED & OTHER (TETEP SAMA)
-- ============================================================
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
            if hum and hum.WalkSpeed ~= SpeedState.Value then
                hum.WalkSpeed = SpeedState.Value
            end
        end
    end
end)

_G.VRILZ_Features = Features
_G.VRILZ_Shared = Shared
print("[VRILZHUB] Features Loaded (Filter + Return)")
