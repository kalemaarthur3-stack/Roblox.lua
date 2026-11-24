-- 100 Nights: Rainforest Survival | KSJ
-- LocalScript: StarterPlayer/StarterPlayerScripts/GUI/SurvivalHUD.client.lua
-- Builds the compact rainforest survival HUD. Server systems should update
-- Player Attributes and leaderstats; this script only displays their values.

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local COLORS = {
    panel = Color3.fromRGB(12, 35, 22),
    panel2 = Color3.fromRGB(21, 57, 34),
    green = Color3.fromRGB(94, 176, 105),
    pale = Color3.fromRGB(225, 239, 220),
    muted = Color3.fromRGB(160, 188, 160),
    red = Color3.fromRGB(190, 75, 65),
    gold = Color3.fromRGB(222, 190, 93),
}

local function make(className, props, parent)
    local obj = Instance.new(className)
    for k, v in pairs(props or {}) do obj[k] = v end
    obj.Parent = parent
    return obj
end

local gui = make("ScreenGui", {
    Name = "RainforestSurvivalHUD",
    ResetOnSpawn = false,
    IgnoreGuiInset = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, playerGui)

local top = make("Frame", {
    Name = "TopBar",
    AnchorPoint = Vector2.new(0.5, 0),
    Position = UDim2.new(0.5, 0, 0, 8),
    Size = UDim2.new(0.72, 0, 0, 48),
    BackgroundColor3 = COLORS.panel,
    BackgroundTransparency = 0.08,
    BorderSizePixel = 0,
}, gui)
make("UICorner", { CornerRadius = UDim.new(0, 12) }, top)
make("UIStroke", { Color = COLORS.green, Transparency = 0.35, Thickness = 1 }, top)
make("UITextSizeConstraint", { MaxTextSize = 18 }, make("TextLabel", {
    Name = "GameTitle",
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 10, 0, 0),
    Size = UDim2.new(0.42, 0, 1, 0),
    Font = Enum.Font.GothamBold,
    Text = "🌿 100 NIGHTS",
    TextColor3 = COLORS.pale,
    TextSize = 16,
    TextXAlignment = Enum.TextXAlignment.Left,
}, top))

local nightLabel = make("TextLabel", {
    Name = "Night",
    BackgroundTransparency = 1,
    Position = UDim2.new(0.48, 0, 0, 0),
    Size = UDim2.new(0.24, 0, 1, 0),
    Font = Enum.Font.GothamBold,
    Text = "NIGHT 1",
    TextColor3 = COLORS.gold,
    TextSize = 14,
}, top)
local biomeLabel = make("TextLabel", {
    Name = "Biome",
    BackgroundTransparency = 1,
    Position = UDim2.new(0.72, 0, 0, 0),
    Size = UDim2.new(0.26, -8, 1, 0),
    Font = Enum.Font.Gotham,
    Text = "Rainforest",
    TextColor3 = COLORS.pale,
    TextSize = 12,
    TextTruncate = Enum.TextTruncate.AtEnd,
    TextXAlignment = Enum.TextXAlignment.Right,
}, top)

local stats = make("Frame", {
    Name = "SurvivalStats",
    Position = UDim2.new(0, 10, 0.5, -76),
    Size = UDim2.new(0, 178, 0, 152),
    BackgroundColor3 = COLORS.panel,
    BackgroundTransparency = 0.1,
    BorderSizePixel = 0,
}, gui)
make("UICorner", { CornerRadius = UDim.new(0, 10) }, stats)
make("UIStroke", { Color = COLORS.green, Transparency = 0.55 }, stats)
make("UIPadding", {
    PaddingTop = UDim.new(0, 8),
    PaddingBottom = UDim.new(0, 8),
    PaddingLeft = UDim.new(0, 9),
    PaddingRight = UDim.new(0, 9),
}, stats)
make("UIListLayout", { Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder }, stats)

local bars = {}
local function addBar(key, title, color)
    local wrap = make("Frame", {
        Name = key,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 28),
        LayoutOrder = #bars + 1,
    }, stats)
    make("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(0.55, 0, 0, 12),
        Font = Enum.Font.GothamSemibold,
        Text = title,
        TextColor3 = COLORS.pale,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, wrap)
    local value = make("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0.55, 0, 0, 0),
        Size = UDim2.new(0.45, 0, 0, 12),
        Font = Enum.Font.Gotham,
        Text = "100 / 100",
        TextColor3 = COLORS.muted,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Right,
    }, wrap)
    local track = make("Frame", {
        Position = UDim2.new(0, 0, 0, 16),
        Size = UDim2.new(1, 0, 0, 8),
        BackgroundColor3 = Color3.fromRGB(39, 54, 43),
        BorderSizePixel = 0,
    }, wrap)
    make("UICorner", { CornerRadius = UDim.new(1, 0) }, track)
    local fill = make("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = color,
        BorderSizePixel = 0,
    }, track)
    make("UICorner", { CornerRadius = UDim.new(1, 0) }, fill)
    bars[key] = { value = value, fill = fill }
end

addBar("Health", "❤ HEALTH", COLORS.red)
addBar("Hunger", "🍖 HUNGER", Color3.fromRGB(203, 151, 70))
addBar("Thirst", "💧 THIRST", Color3.fromRGB(75, 151, 205))
addBar("Stamina", "⚡ STAMINA", Color3.fromRGB(116, 190, 105))

local resources = make("Frame", {
    Name = "ResourceStrip",
    AnchorPoint = Vector2.new(0.5, 1),
    Position = UDim2.new(0.5, 0, 1, -12),
    Size = UDim2.new(0.82, 0, 0, 34),
    BackgroundColor3 = COLORS.panel,
    BackgroundTransparency = 0.08,
    BorderSizePixel = 0,
}, gui)
make("UICorner", { CornerRadius = UDim.new(0, 9) }, resources)
make("UIStroke", { Color = COLORS.green, Transparency = 0.5 }, resources)
local resourceLayout = make("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    Padding = UDim.new(0, 10),
}, resources)
local resourceLabels = {}
for _, name in ipairs({ "Diamonds", "Coins", "Wood", "Scrap", "Metal", "ForestGems" }) do
    resourceLabels[name] = make("TextLabel", {
        Name = name,
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.new(0, 0, 1, 0),
        Font = Enum.Font.GothamSemibold,
        Text = name .. ": 0",
        TextColor3 = COLORS.pale,
        TextSize = 11,
    }, resources)
end

local function getNumber(source, key, fallback)
    local value = source:GetAttribute(key)
    if type(value) == "number" then return value end
    return fallback
end

local function updateBar(key, current, maximum)
    local item = bars[key]
    if not item then return end
    maximum = math.max(1, maximum or 100)
    current = math.clamp(current or maximum, 0, maximum)
    item.value.Text = tostring(math.floor(current)) .. " / " .. tostring(math.floor(maximum))
    item.fill.Size = UDim2.new(current / maximum, 0, 1, 0)
end

local function update()
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        updateBar("Health", humanoid.Health, humanoid.MaxHealth)
    end
    for _, key in ipairs({ "Hunger", "Thirst", "Stamina" }) do
        local maximum = getNumber(player, key .. "Max", 100)
        updateBar(key, getNumber(player, key, maximum), maximum)
    end

    nightLabel.Text = "NIGHT " .. tostring(getNumber(player, "CurrentNight", 1))
    biomeLabel.Text = tostring(player:GetAttribute("CurrentBiome") or "Rainforest")

    local leaderstats = player:FindFirstChild("leaderstats")
    for name, label in pairs(resourceLabels) do
        local value = leaderstats and leaderstats:FindFirstChild(name)
        local amount = value and value.Value or getNumber(player, name, 0)
        label.Text = name .. ": " .. tostring(amount)
    end
end

player:GetAttributeChangedSignal("CurrentNight"):Connect(update)
player:GetAttributeChangedSignal("CurrentBiome"):Connect(update)
for _, key in ipairs({ "Hunger", "Thirst", "Stamina", "HungerMax", "ThirstMax", "StaminaMax" }) do
    player:GetAttributeChangedSignal(key):Connect(update)
end

local function bindCharacter(character)
    local humanoid = character:WaitForChild("Humanoid", 10)
    if humanoid then
        humanoid.HealthChanged:Connect(update)
        humanoid:GetPropertyChangedSignal("MaxHealth"):Connect(update)
    end
    update()
end
player.CharacterAdded:Connect(bindCharacter)
if player.Character then task.spawn(bindCharacter, player.Character) end

local leaderstats = player:WaitForChild("leaderstats", 20)
if leaderstats then
    for _, value in ipairs(leaderstats:GetChildren()) do
        if value:IsA("ValueBase") then value.Changed:Connect(update) end
    end
    leaderstats.ChildAdded:Connect(function(value)
        if value:IsA("ValueBase") then value.Changed:Connect(update) end
        update()
    end)
end

task.spawn(function()
    while gui.Parent do
        update()
        task.wait(1)
    end
end)
