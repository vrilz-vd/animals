-- ============================================================
-- VRILZHUB LOADER — CLIMB FOR ANIMAL
-- ============================================================

local BASE_URL = "https://raw.githubusercontent.com/vrilz-vd/animals/main/"

-- ⚙️ KONFIGURASI
-- true  = Cuma load UI (Fiturs di-mock/dummy, aman buat ngetes visual)
-- false = Load Fiturs asli + UI (Buat main game)
local TEST_MODE = true 

-- ============================================================
-- LOADER FUNCTION
-- ============================================================
local function loadFile(filename)
    local url = BASE_URL .. filename
    print("[VH-LOADER] Fetching: " .. url)
    
    local success, response = pcall(game:HttpGet, url)
    if not success then
        warn("[VH-LOADER] ❌ Gagal download " .. filename)
        return nil
    end
    
    local func, err = loadstring(response)
    if not func then
        warn("[VH-LOADER] ❌ Syntax error di " .. filename .. ": " .. tostring(err))
        return nil
    end
    
    return func
end

-- ============================================================
-- MOCK FEATURES (Buat Test UI)
-- ============================================================
local function createMockFeatures()
    print("[VH-LOADER] ⚠️ TEST MODE ACTIVE — Load Dummy Features")
    
    local mockShared = {}
    local mockFeatures = {}
    
    -- Mock function dasar biar UI gak error
    local function dummyFunc(name)
        return function(...)
            print("[VH-MOCK] Called: " .. name, ...)
            -- Kirim notif ke UI kalo tombol ditekan
            if mockShared.Notify then
                mockShared.Notify("Test: " .. name, "info")
            end
        end
    end

    -- Setup function bohongan
    mockFeatures.setAutoSteal = dummyFunc("setAutoSteal")
    mockFeatures.setAutoStealFilter = dummyFunc("setAutoStealFilter")
    mockFeatures.setAutoHatch = dummyFunc("setAutoHatch")
    mockFeatures.setAutoRebirth = dummyFunc("setAutoRebirth")
    mockFeatures.setAutoUpgrade = dummyFunc("setAutoUpgrade")
    mockFeatures.claimOfflineCash = dummyFunc("claimOfflineCash")
    mockFeatures.setSpeed = dummyFunc("setSpeed")
    mockFeatures.setSpeedValue = dummyFunc("setSpeedValue")
    mockFeatures.setFlyEnabled = dummyFunc("setFlyEnabled")
    mockFeatures.setFlyHeight = dummyFunc("setFlyHeight")
    mockFeatures.setFlySpeed = dummyFunc("setFlySpeed")
    mockFeatures.setInfiniteJumpEnabled = dummyFunc("setInfiniteJump")
    mockFeatures.setAntiJail = dummyFunc("setAntiJail")
    
    -- Mock getter status
    mockFeatures.getAutoStealState = function() 
        return { Status = "Test Mode Running", Stolen = 0 } 
    end

    -- Expose ke global
    _G.VRILZ_Features = mockFeatures
    _G.VRILZ_Shared = mockShared
    _G.VRILZ_UI_Shared = mockShared
end

-- ============================================================
-- EXECUTION FLOW
-- ============================================================
task.spawn(function()
    -- 1. Load Fiturs (atau Mock)
    if TEST_MODE then
        createMockFeatures()
    else
        local featuresFunc = loadFile("features.lua")
        if featuresFunc then
            local success, err = pcall(featuresFunc)
            if not success then warn("[VH-LOADER] ❌ Features Error: " .. tostring(err)) end
        end
    end

    -- Kasih jeda bentar biar _G ke-set
    task.wait(1.5)

    -- 2. Load UI
    local uiFunc = loadFile("ui.lua")
    if uiFunc then
        local success, err = pcall(uiFunc)
        if not success then 
            warn("[VH-LOADER] ❌ UI Error: " .. tostring(err)) 
        else
            print("[VH-LOADER] ✅ UI Loaded Successfully!")
        end
    end
end)
