-- ============================================================
-- VRILZHUB FEATURES — CLIMB FOR ANIMAL (FIXED)
-- ============================================================

local Features = {}
local Shared = _G.VRILZ_Shared or {}

-- Set Default biar gak error pas UI load
if not Shared.StealAreaFilter then Shared.StealAreaFilter = { ["All"] = true } end
if not Shared.StealRarityFilter then Shared.StealRarityFilter = { ["All"] = true } end

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Cek Filter (Multi)
local function isEggAllowed(biomeName, eggName)
    local areaFilter = Shared.StealAreaFilter or {}
    local rarityFilter = Shared.StealRarityFilter or {}
    
    -- Cek Area
    local matchArea = false
    if areaFilter["All"] then
        matchArea = true
    else
        for area, isSelected in pairs(areaFilter) do
            if isSelected and area == biomeName then matchArea = true break end
        end
    end
    if not matchArea then return false end
    
    -- Cek Rarity
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
    if rarityFilter["All"] then
        matchRarity = true
    else
        for r, isSelected in pairs(rarityFilter) do
            if isSelected and r == rarity then matchRarity = true break end
        end
    end
    
    return matchRarity
end

-- Return ke Base (Pake SpawnEggs pertama di Islands)
local function returnToBase()
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return false end
    
    local islands = Workspace:FindFirstChild("Structures") and Workspace.Structures:FindFirstChild("Islands")
    local targetPart
    if islands then
        for _, island in ipairs(islands:GetChildren()) do
            local spawn = island:FindFirstChild("SpawnEggs")
            if spawn and spawn:IsA("BasePart") then targetPart = spawn; break end
        end
    end
    
    if not targetPart then return false end
    
    myRoot.CFrame = CFrame.new(targetPart.Position + Vector3.new(0, 5, 0))
    myRoot.Velocity = Vector3.zero
    task.wait(0.5)
    return true
end

-- ============================================================
-- AUTO STEAL
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
        
        for _, biome in ipairs(spawned:GetChildren()) do
            for _, egg in ipairs(biome:GetChildren()) do
                if egg:IsA("Model") and egg.Name ~= "Nest" then
                    if isEggAllowed(biome.Name, egg.Name) then
                        local part = egg:FindFirstChildWhichIsA("BasePart", true)
                        local prompt = egg:FindFirstChildWhichIsA("ProximityPrompt", true)
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
            AutoStealState.Status = "TP: " .. targetEgg.Name
            hrp.CFrame = CFrame.new(targetPart.Position + Vector3.new(0, 3, 0))
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
            
            if Shared.AutoReturn_Enabled then
                AutoStealState.Status = "🏠 Return ke Base..."
                returnToBase()
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
