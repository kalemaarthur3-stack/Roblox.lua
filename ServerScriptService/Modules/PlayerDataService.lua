-- 100 Nights: Rainforest Survival | KSJ
-- ModuleScript: ServerScriptService/Modules/PlayerDataService
-- Prepared source; integrate with the master script before live use.

local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local Store = DataStoreService:GetDataStore("RainforestSaveData")

local Service = {}
local Profiles, Saving = {}, {}
local AUTOSAVE_SECONDS, MAX_RETRIES = 60, 3
local shuttingDown = false

local DEFAULTS = {
    Version = 2,
    Diamonds = 0,
    Coins = 0,
    UnlockedClasses = { Camper = true, Hunter = true, Medic = true },
    SelectedClass = "Camper",
    RedeemedCodes = {},
}

local function clone(value)
    local out = {}
    for k, v in pairs(value) do
        out[k] = type(v) == "table" and clone(v) or v
    end
    return out
end

local function normalize(data)
    local p = clone(DEFAULTS)
    if type(data) == "number" then
        p.Diamonds = math.max(0, math.floor(data))
    elseif type(data) == "table" then
        for _, currency in ipairs({ "Diamonds", "Coins" }) do
            if type(data[currency]) == "number" then
                p[currency] = math.max(0, math.floor(data[currency]))
            end
        end
        if type(data.UnlockedClasses) == "table" then
            for name, owned in pairs(data.UnlockedClasses) do
                if type(name) == "string" and owned == true then
                    p.UnlockedClasses[name] = true
                end
            end
        end
        if type(data.SelectedClass) == "string" then
            p.SelectedClass = data.SelectedClass
        end
        if type(data.RedeemedCodes) == "table" then
            for code, redeemed in pairs(data.RedeemedCodes) do
                if type(code) == "string" and redeemed == true then
                    p.RedeemedCodes[code] = true
                end
            end
        end
    end
    p.UnlockedClasses.Camper = true
    p.UnlockedClasses.Hunter = true
    p.UnlockedClasses.Medic = true
    if not p.UnlockedClasses[p.SelectedClass] then
        p.SelectedClass = "Camper"
    end
    p.Version = 2
    return p
end

local function read(key)
    local lastError
    for attempt = 1, MAX_RETRIES do
        local ok, result = pcall(function() return Store:GetAsync(key) end)
        if ok then return true, result end
        lastError = result
        warn("[PlayerDataService] Load attempt " .. attempt .. ": " .. tostring(result))
        task.wait(attempt * 2)
    end
    return false, lastError
end

function Service.Load(player)
    if Profiles[player] then return true, Profiles[player] end
    local key = "Player_" .. tostring(player.UserId)
    local ok, data = read(key)
    if not ok then return false, "Data load failed. Please rejoin." end

    if data == nil then
        -- Legacy master script used the numeric UserId as the DataStore key.
        local legacyOk, legacy = read(player.UserId)
        if not legacyOk then return false, "Could not check your old save." end
        if legacy ~= nil then
            data = normalize(legacy)
            local migrated, err = pcall(function() Store:SetAsync(key, data) end)
            if not migrated then
                warn("[PlayerDataService] Legacy migration failed: " .. tostring(err))
                return false, "Your old save could not be migrated safely."
            end
        end
    end

    Profiles[player] = normalize(data)
    return true, Profiles[player]
end

function Service.Get(player)
    return Profiles[player]
end

function Service.GetSnapshot(player)
    local p = Profiles[player]
    return p and clone(p) or nil
end

function Service.AddCurrency(player, currency, amount)
    local p = Profiles[player]
    if not p or (currency ~= "Diamonds" and currency ~= "Coins")
        or type(amount) ~= "number" or amount <= 0 then
        return false
    end
    p[currency] += math.floor(amount)
    return true, p[currency]
end

function Service.SpendCurrency(player, currency, amount)
    local p = Profiles[player]
    if not p or (currency ~= "Diamonds" and currency ~= "Coins")
        or type(amount) ~= "number" or amount <= 0 then
        return false
    end
    amount = math.floor(amount)
    if p[currency] < amount then return false end
    p[currency] -= amount
    return true, p[currency]
end

function Service.IsClassUnlocked(player, className)
    local p = Profiles[player]
    return p ~= nil and p.UnlockedClasses[className] == true
end

function Service.UnlockClass(player, className, cost)
    local p = Profiles[player]
    if not p or type(className) ~= "string" or type(cost) ~= "number" or cost < 0 then
        return false, "Invalid purchase."
    end
    if p.UnlockedClasses[className] then return true, "Already owned." end
    cost = math.floor(cost)
    if p.Diamonds < cost then return false, "Not enough Diamonds." end
    p.Diamonds -= cost
    p.UnlockedClasses[className] = true
    return true, "Unlocked."
end

function Service.SetSelectedClass(player, className)
    local p = Profiles[player]
    if not p or type(className) ~= "string" or not p.UnlockedClasses[className] then
        return false
    end
    p.SelectedClass = className
    return true
end

function Service.RedeemCode(player, code, rewards)
    local p = Profiles[player]
    if not p or type(code) ~= "string" or type(rewards) ~= "table" then
        return false, "Invalid code."
    end
    code = string.upper((string.gsub(code, "%s+", "")))
    if code == "" or p.RedeemedCodes[code] then
        return false, "Code already used or invalid."
    end
    local diamonds = tonumber(rewards.Diamonds) or 0
    local coins = tonumber(rewards.Coins) or 0
    if diamonds < 0 or coins < 0 then return false, "Invalid reward." end
    p.RedeemedCodes[code] = true
    p.Diamonds += math.floor(diamonds)
    p.Coins += math.floor(coins)
    return true, "Code redeemed."
end

function Service.Save(player)
    local p = Profiles[player]
    if not p then return false, "No loaded profile." end
    if Saving[player] then return false, "Save already running." end
    Saving[player] = true
    local snapshot = clone(p)
    local key = "Player_" .. tostring(player.UserId)
    local lastError

    for attempt = 1, MAX_RETRIES do
        local ok, err = pcall(function()
            Store:UpdateAsync(key, function()
                return snapshot
            end)
        end)
        if ok then
            Saving[player] = nil
            return true
        end
        lastError = err
        warn("[PlayerDataService] Save attempt " .. attempt .. ": " .. tostring(err))
        task.wait(attempt * 2)
    end

    Saving[player] = nil
    return false, lastError
end

function Service.Release(player)
    local ok, err = Service.Save(player)
    if not ok then
        warn("[PlayerDataService] Keeping profile in memory after failed final save: " .. tostring(err))
        return false, err
    end
    Profiles[player] = nil
    Saving[player] = nil
    return true
end

function Service.StartAutosave()
    task.spawn(function()
        while not shuttingDown do
            task.wait(AUTOSAVE_SECONDS)
            if not shuttingDown then
                for player in pairs(Profiles) do
                    if player.Parent == Players and not Saving[player] then
                        task.spawn(Service.Save, player)
                    end
                end
            end
        end
    end)
end

function Service.Shutdown()
    shuttingDown = true
    local pending = 0
    for player in pairs(Profiles) do
        pending += 1
        task.spawn(function()
            Service.Release(player)
            pending -= 1
        end)
    end
    local deadline = os.clock() + 25
    while pending > 0 and os.clock() < deadline do task.wait(0.1) end
end

return Service
