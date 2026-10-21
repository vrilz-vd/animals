-- ============================================================
-- VRILZHUB FEATURES — CLIMB FOR ANIMAL (AUTO CLIMB + STEAL)
-- ============================================================

local Features = {}
local Shared = _G.VRILZ_Shared or {}

if not Shared.StealAreaFilter then Shared.StealAreaFilter = { ["All"] = true } end
if not Shared.StealRarityFilter then Shared.StealRarityFilter = { ["All"] = true } end

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- ═══════════════════════════════════════════════════════════
-- 1. HELPER FILTER (MULTI)
-- ═══════════════════════════════════════════════════════════
local EggRarity = {
    ["Gold Fish"] = "Common", ["Chicken"] = "Common", ["Hamster"] = "Common",
    ["Frog"] = "Rare", ["Cat"] = "Rare", ["Pigeon"] = "Rare", ["Ostrich"] = "Rare",
    ["Crocodile"] = "Epic", ["Bear"] = "Epic", ["Crab"] = "Epic", ["Koala"] = "Epic",
    ["T-Rex"] = "Legendary", ["Dragon"] = "Legendary", ["Pegasus"] = "Legendary", ["Unicorn"] = "Legendary",
    ["Hydra"] = "Mythic", ["Griffin"] = "Mythic", ["Kraken"] = "Mythic",
    ["Simurgh"] = "Divine", ["YI QI"] = "Divine"
}

local function isEggAllowed(biomeName, eggName)
    local areaFilter = Shared.StealAreaFilter or {}
    local rarityFilter = Shared.StealRarityFilter or {}
    
    local matchArea = areaFilter["All"]
    if not matchArea then
        for area, isSelected in pairs(areaFilter) do
            if isSelected and area == biomeName then matchArea = true break end
        end
    end
    if not matchArea then return false end
    
    local rarity = EggRarity[eggName] or "Common"
    local matchRarity = rarityFilter["All"]
    if not matchRarity then
        for r, isSelected in pairs(rarityFilter) do
            if isSelected and r == rarity then matchRarity = true break end
        end
    end
    return matchRarity
end

-- ═══════════════════════════════════════════════════════════
-- 2. HELPER RETURN TO BASE
-- ═══════════════════════════════════════════════════════════
local function returnToBase()
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not myRoot or not hum then return false end
    
    -- Cari Base di Structures.Bases
    local structures = Workspace:FindFirstChild("Structures")
    local bases = structures and structures:FindFirstChild("Bases")
    local targetPart
    if bases then
        for _, base in ipairs(bases:GetChildren()) do
            local spawn = base:FindFirstChildWhichIsA("BasePart", true)
            if spawn then targetPart = spawn; break end
        end
    end
    
    -- Fallback: Islands
    if not targetPart then
        local islands = structures and structures:FindFirstChild("Islands")
        if islands then
            for _, island in ipairs(islands:GetChildren()) do
                local spawn = island:FindFirstChild("SpawnEggs")
                if spawn and spawn:IsA("BasePart") then targetPart = spawn; break end
            end
        end
    end
    
    if not targetPart then return false end
    
    -- TP Glide 100 studs
    local target = targetPart.Position + Vector3.new(0, 5, 0)
    local start = myRoot.Position
    local dist = (target - start).Magnitude
    local steps = math.ceil(dist / 100)
    local dir = (target - start).Unit
    
    for i = 1, steps do
        local r = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not r then return false end
        r.CFrame = CFrame.new(start + dir * math.min(100 * i, dist))
        r.Velocity = Vector3.zero
        task.wait(0.05)
    end
    task.wait(0.3)
    return true
end

-- ═══════════════════════════════════════════════════════════
-- 3. FUNGSI AUTO CLIMB (MOVE TO TANGGA)
-- ═══════════════════════════════════════════════════════════
local function autoClimbTo(targetY)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return false end
    
    -- Cari TrussPart (Tangga) terdekat
    local closestTruss
    local closestDist = math.huge
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("TrussPart") then
            local d = (obj.Position - hrp.Position).Magnitude
            if d < closestDist then
                closestDist = d
                closestTruss = obj
            end
        end
    end
    
    if not closestTruss then return false end
    
    -- Posisi di depan tangga (offset 2 studs dari hitbox)
    local approachPos = closestTruss.Position + (closestTruss.CFrame.LookVector * -2)
    hrp.CFrame = CFrame.new(approachPos)
    task.wait(0.5)
    
    -- Pake MoveTo biar server nganggep lu beneran manjat
    local targetPos = Vector3.new(closestTruss.Position.X, targetY, closestTruss.Position.Z)
    hum:MoveTo(targetPos)
    
    -- Tunggu sampe nyampe atas (max 10 detik)
    local startTime = tick()
    while tick() - startTime < 10 do
        if hrp.Position.Y >= targetY - 2 then break end
        task.wait(0.2)
    end
    
    return true
end

-- ═══════════════════════════════════════════════════════════
-- 4. LOGIC AUTO STEAL (CLIMB + MINGGIR + STEAL)
-- ═══════════════════════════════════════════════════════════
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
        
        -- Cari Egg sesuai filter (Prioritas Egg di Y paling tinggi)
        for _, biome in ipairs(spawned:GetChildren()) do
            for _, egg in ipairs(biome:GetChildren()) do
                if egg:IsA("Model") and egg.Name ~= "Nest" then
                    if isEggAllowed(biome.Name, egg.Name) then
                        local part = egg:FindFirstChildWhichIsA("BasePart", true)
                        local prompt = egg:FindFirstChildWhichIsA("ProximityPrompt", true)
                        if part and prompt then
                            local d = (part.Position - hrp.Position).Magnitude
                            -- Prioritaskan Y tertinggi (Area atas)
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
            -- ⭐ CEK KALO EGG DI ATAS, NAIK TANGGA DULU
            if targetPart.Position.Y > hrp.Position.Y + 20 then
                AutoStealState.Status = "🧗 Climbing ke " .. targetEgg.Name
                autoClimbTo(targetPart.Position.Y + 10)
                task.wait(0.3)
            end
            
            -- ⭐ MINGGIR 2 STUDS DARI TANGGA (BIAR NEMPEL TANAH)
            local r = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if r then
                r.CFrame = CFrame.new(targetPart.Position + Vector3.new(0, 1, 2)) -- Offset Z = 2
                r.Velocity = Vector3.zero
                task.wait(0.3)
            end
            
            -- ⭐ NEMBAK PROMPT STEAL
            AutoStealState.Status = "🎯 Stealing: " .. targetEgg.Name
            targetPrompt.HoldDuration = 0
            targetPrompt.MaxActivationDistance = math.huge
            targetPrompt.RequiresLineOfSight = false
            
            for _ = 1, 10 do
                if fireproximityprompt then pcall(fireproximityprompt, targetPrompt) end
                task.wait(0.15)
                if not targetEgg.Parent then break end
            end
            
            -- ⭐ CEK HASIL
            if not targetEgg.Parent then
                AutoStealState.Status = "✅ Stolen: " .. targetEgg.Name
                
                if Shared.AutoReturn_Enabled then
                    AutoStealState.Status = "🏠 Return ke Base..."
                    returnToBase()
                end
            else
                AutoStealState.Status = "❌ Gagal Steal: " .. targetEgg.Name
            end
            
            task.wait(0.5)
        else
            AutoStealState.Status = "Mencari egg..."
        end
    end
end)

_G.VRILZ_Features = Features
_G.VRILZ_Shared = Shared
print("[VRILZHUB] Features Fixed & Ready")
