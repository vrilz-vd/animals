-- ============================================================
-- VRILZHUB FEATURES — CLIMB FOR ANIMAL (AUTO CLIMB + STEAL)
-- RARITY ASLI DARI GAME
-- ============================================================

local Features = {}
local Shared = _G.VRILZ_Shared or {}
_G.VRILZ_Shared = Shared

if not Shared.StealAreaFilter then Shared.StealAreaFilter = { ["All"] = true } end
if not Shared.StealRarityFilter then Shared.StealRarityFilter = { ["All"] = true } end
if Shared.AutoReturn_Enabled == nil then Shared.AutoReturn_Enabled = false end

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- ═══════════════════════════════════════════════════════════
-- EGG RARITY — dari game asli (EggStats.Rarity TextLabel)
-- ═══════════════════════════════════════════════════════════
local EggRarity = {
    -- Common
    ["Frog"] = "Common", ["Coral Goby"] = "Common", ["Gold Fish"] = "Common",
    ["Goat"] = "Common", ["Lizard"] = "Common", ["Trumpet"] = "Common",
    ["Crab"] = "Common", ["Microraptor"] = "Common", ["Chicken"] = "Common",
    ["Hamster"] = "Common",
    -- Uncommon
    ["Surgeonfish"] = "Uncommon", ["Butter Fly Fish"] = "Uncommon",
    ["Angel Fish"] = "Uncommon", ["Triceratops"] = "Uncommon",
    ["Tuna"] = "Uncommon", ["Garuda"] = "Uncommon",
    ["Golden Retriver"] = "Uncommon", ["Bat"] = "Uncommon",
    -- Rare
    ["Turtle"] = "Rare", ["Box Fish"] = "Rare", ["Pony"] = "Rare",
    ["Kangaroo"] = "Rare", ["Simurgh"] = "Rare", ["Cat"] = "Rare",
    -- Epic
    ["Bear"] = "Epic",
    -- Legendary
    ["Capybara"] = "Legendary", ["T-Rex"] = "Legendary", ["Sphinx"] = "Legendary",
    -- Mythic
    ["Crocodile"] = "Mythic", ["Velicoraptor"] = "Mythic",
    -- Celestial
    ["Fire Phoenix"] = "Celestial",
    -- Astral
    ["Werewolf"] = "Astral", ["Lion Dragon"] = "Astral", ["Minotaur"] = "Astral",
    -- Radiant
    ["Giant Bat"] = "Radiant", ["Spider"] = "Radiant", ["Gargoyle Bat"] = "Radiant",
    -- Eternal
    ["Kitsune"] = "Eternal", ["Griffin"] = "Eternal", ["Red Dragon"] = "Eternal",
    ["Hydra"] = "Eternal", ["Pegasus"] = "Eternal",
}

-- Baca rarity dari TextLabel di egg (paling akurat)
local function getEggRarityFromModel(eggModel, eggName)
    -- Coba baca dari EggStats.Rarity TextLabel
    for _, desc in ipairs(eggModel:GetDescendants()) do
        if desc:IsA("TextLabel") and desc.Name == "Rarity" then
            local text = desc.Text
            if text and text ~= "" then
                return text
            end
        end
    end
    -- Fallback ke table
    return EggRarity[eggName] or "Common"
end

-- ═══════════════════════════════════════════════════════════
-- FILTER CHECK
-- ═══════════════════════════════════════════════════════════
local function isEggAllowed(biomeName, eggName, eggModel)
    local areaFilter = Shared.StealAreaFilter or {}
    local rarityFilter = Shared.StealRarityFilter or {}

    local biomeLower = string.lower(tostring(biomeName))
    local eggLower = string.lower(tostring(eggName))

    -- Area check
    local matchArea = areaFilter["All"] == true
    if not matchArea then
        for area, isSelected in pairs(areaFilter) do
            if isSelected then
                local areaLower = string.lower(tostring(area))
                if biomeLower == areaLower
                   or string.find(biomeLower, areaLower, 1, true)
                   or string.find(areaLower, biomeLower, 1, true) then
                    matchArea = true
                    break
                end
            end
        end
    end
    if not matchArea then return false, "area_mismatch" end

    -- Rarity check — baca dari game dulu, fallback ke table
    local rarity = eggModel and getEggRarityFromModel(eggModel, eggName) or (EggRarity[eggName] or "Common")
    local rarityLower = string.lower(tostring(rarity))
    local matchRarity = rarityFilter["All"] == true
    if not matchRarity then
        for r, isSelected in pairs(rarityFilter) do
            if isSelected then
                local rLower = string.lower(tostring(r))
                if rLower == rarityLower then
                    matchRarity = true
                    break
                end
            end
        end
    end
    if not matchRarity then return false, "rarity_mismatch" end

    return true, "match"
end

-- ═══════════════════════════════════════════════════════════
-- RETURN TO BASE
-- ═══════════════════════════════════════════════════════════
local function returnToBase()
    local char = LocalPlayer.Character
    local myRoot = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not myRoot or not hum then return false end

    local structures = Workspace:FindFirstChild("Structures")
    local bases = structures and structures:FindFirstChild("Bases")
    local targetPart
    if bases then
        for _, base in ipairs(bases:GetChildren()) do
            local spawn = base:FindFirstChildWhichIsA("BasePart", true)
            if spawn then targetPart = spawn; break end
        end
    end
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

    local target = targetPart.Position + Vector3.new(0, 5, 0)
    local start = myRoot.Position
    local dist = (target - start).Magnitude
    local steps = math.max(1, math.ceil(dist / 100))
    local dir = (target - start).Unit

    for i = 1, steps do
        local r = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not r then return false end
        r.CFrame = CFrame.new(start + dir * math.min(100 * i, dist))
        r.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        task.wait(0.05)
    end
    task.wait(0.3)
    return true
end

-- ═══════════════════════════════════════════════════════════
-- AUTO CLIMB
-- ═══════════════════════════════════════════════════════════
local cachedTrusses = {}
local lastTrussScan = 0

local function refreshTrussCache()
    cachedTrusses = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("TrussPart") then
            table.insert(cachedTrusses, obj)
        end
    end
    lastTrussScan = tick()
end

local function autoClimbTo(targetY)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return false end

    if tick() - lastTrussScan > 5 or #cachedTrusses == 0 then
        refreshTrussCache()
    end

    local closestTruss, closestDist = nil, math.huge
    for _, truss in ipairs(cachedTrusses) do
        if truss.Parent then
            local d = (truss.Position - hrp.Position).Magnitude
            if d < closestDist then
                closestDist = d
                closestTruss = truss
            end
        end
    end

    if not closestTruss then return false end

    local approachPos = closestTruss.Position + (closestTruss.CFrame.LookVector * -2)
    hrp.CFrame = CFrame.new(approachPos)
    task.wait(0.5)

    local targetPos = Vector3.new(closestTruss.Position.X, targetY, closestTruss.Position.Z)
    hum:MoveTo(targetPos)

    local startTime = tick()
    while tick() - startTime < 10 do
        if hrp.Position.Y >= targetY - 2 then break end
        task.wait(0.2)
    end
    return true
end

-- ═══════════════════════════════════════════════════════════
-- AUTO STEAL
-- ═══════════════════════════════════════════════════════════
local AutoStealState = { Enabled = false, Status = "Idle" }

function Features.setAutoSteal(v)
    v = v == true
    AutoStealState.Enabled = v
    AutoStealState.Status = v and "Active" or "Idle"
    print("[VRILZ] setAutoSteal:", v)
end

function Features.getAutoStealState()
    return AutoStealState
end

-- Force OFF di startup
AutoStealState.Enabled = false
AutoStealState.Status = "Idle"

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

        for _, biome in ipairs(spawned:GetChildren()) do
            for _, egg in ipairs(biome:GetChildren()) do
                if egg:IsA("Model") and egg.Name ~= "Nest" then
                    local allowed, reason = isEggAllowed(biome.Name, egg.Name, egg)
                    local part = egg:FindFirstChildWhichIsA("BasePart", true)
                    local prompt = egg:FindFirstChildWhichIsA("ProximityPrompt", true)

                    if allowed and part and prompt then
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

        if targetEgg and targetPart and targetPrompt then
            if targetPart.Position.Y > hrp.Position.Y + 20 then
                AutoStealState.Status = "🧗 Climbing ke " .. targetEgg.Name
                print("[VRILZ]", AutoStealState.Status)
                autoClimbTo(targetPart.Position.Y + 10)
                task.wait(0.3)
            end

            local r = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if r then
                r.CFrame = CFrame.new(targetPart.Position + Vector3.new(0, 1, 2))
                r.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                task.wait(0.3)
            end

            AutoStealState.Status = "🎯 Stealing: " .. targetEgg.Name
            print("[VRILZ]", AutoStealState.Status)
            targetPrompt.MaxActivationDistance = 50
            targetPrompt.HoldDuration = 0
            targetPrompt.RequiresLineOfSight = false

            for _ = 1, 10 do
                if fireproximityprompt then
                    pcall(fireproximityprompt, targetPrompt)
                end
                task.wait(0.15)
                if not targetEgg.Parent then break end
            end

            if not targetEgg.Parent then
                AutoStealState.Status = "✅ Stolen: " .. targetEgg.Name
                print("[VRILZ]", AutoStealState.Status)

                if Shared.AutoReturn_Enabled then
                    AutoStealState.Status = "🏠 Return ke Base..."
                    print("[VRILZ]", AutoStealState.Status)
                    returnToBase()
                end
            else
                AutoStealState.Status = "❌ Gagal Steal: " .. targetEgg.Name
                print("[VRILZ]", AutoStealState.Status)
            end

            task.wait(0.5)
        else
            AutoStealState.Status = "Mencari egg..."
        end
    end
end)

if _G.VRILZ_PendingAutoSteal ~= nil then
    Features.setAutoSteal(_G.VRILZ_PendingAutoSteal)
    _G.VRILZ_PendingAutoSteal = nil
end

_G.VRILZ_Features = Features
print("[VRILZHUB] Features loaded — AutoSteal OFF by default")
