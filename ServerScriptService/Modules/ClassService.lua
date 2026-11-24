-- 100 Nights: Rainforest Survival | KSJ
-- ModuleScript: ServerScriptService/Modules/ClassService
-- RemoteEvent code should call Equip(player, requestedClassName).

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("GameConfig"))
local Data = require(script.Parent:WaitForChild("PlayerDataService"))

local ClassService = {}

local function apply(player, className)
    local info = Config.Classes[className]
    local character = player.Character
    if not info or not character then return false, "Character is not ready." end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false, "Humanoid not found." end

    humanoid.MaxHealth = info.MaxHealth
    humanoid.Health = info.MaxHealth
    humanoid.WalkSpeed = info.WalkSpeed
    player:SetAttribute("SelectedClass", className)
    return true, "Equipped."
end

function ClassService.Equip(player, className)
    if type(className) ~= "string" then return false, "Invalid class." end
    local info = Config.Classes[className]
    if not info then return false, "Unknown class." end
    if not Data.Get(player) then return false, "Player data is not loaded." end

    if not Data.IsClassUnlocked(player, className) then
        local ok, message = Data.UnlockClass(player, className, info.Cost)
        if not ok then return false, message end
    end

    if not Data.SetSelectedClass(player, className) then
        return false, "Could not select class."
    end
    return apply(player, className)
end

function ClassService.ApplySavedClass(player)
    local profile = Data.Get(player)
    if not profile then return false, "Player data is not loaded." end
    local selected = profile.SelectedClass
    if not Config.Classes[selected] then selected = "Camper" end
    return apply(player, selected)
end

return ClassService
