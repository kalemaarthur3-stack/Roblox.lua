-- 100 Nights: Rainforest Survival | KSJ
-- LocalScript: StarterPlayer/StarterPlayerScripts/GUI/ClassSelection.client.lua
-- Server must create ReplicatedStorage.Remotes.EquipClass (RemoteEvent).
-- The server validates ownership and prices; this client never handles currency.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local Config = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("GameConfig"))
local Remotes = ReplicatedStorage:WaitForChild("Remotes", 15)
local equipRemote = Remotes and Remotes:FindFirstChild("EquipClass")

local C = {
    bg = Color3.fromRGB(9, 29, 18),
    panel = Color3.fromRGB(17, 48, 29),
    panel2 = Color3.fromRGB(29, 70, 41),
    green = Color3.fromRGB(104, 183, 108),
    text = Color3.fromRGB(235, 244, 230),
    muted = Color3.fromRGB(171, 194, 171),
    gold = Color3.fromRGB(228, 193, 100),
}
local function make(className, props, parent)
    local o = Instance.new(className)
    for k,v in pairs(props or {}) do o[k] = v end
    o.Parent = parent
    return o
end

local gui = make("ScreenGui", {
    Name = "ClassSelectionGUI", ResetOnSpawn = false, Enabled = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, player:WaitForChild("PlayerGui"))

local shade = make("Frame", {
    Size = UDim2.fromScale(1,1), BackgroundColor3 = Color3.new(0,0,0),
    BackgroundTransparency = 0.35, BorderSizePixel = 0,
}, gui)
local panel = make("Frame", {
    AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.fromScale(0.5,0.5),
    Size = UDim2.new(0.86,0,0.78,0), BackgroundColor3 = C.bg, BorderSizePixel = 0,
}, shade)
make("UICorner", {CornerRadius = UDim.new(0,16)}, panel)
make("UIStroke", {Color = C.green, Thickness = 1.5}, panel)
make("TextLabel", {
    BackgroundTransparency = 1, Position = UDim2.new(0,16,0,8),
    Size = UDim2.new(1,-70,0,38), Font = Enum.Font.GothamBold,
    Text = "CHOOSE YOUR CLASS", TextColor3 = C.text, TextSize = 20,
    TextXAlignment = Enum.TextXAlignment.Left,
}, panel)
local close = make("TextButton", {
    Position = UDim2.new(1,-48,0,9), Size = UDim2.fromOffset(36,32),
    BackgroundColor3 = C.panel2, Text = "X", TextColor3 = C.text,
    Font = Enum.Font.GothamBold, TextSize = 16, BorderSizePixel = 0,
}, panel)
make("UICorner", {CornerRadius = UDim.new(0,8)}, close)
close.Activated:Connect(function() gui.Enabled = false end)

local info = make("TextLabel", {
    BackgroundTransparency = 1, Position = UDim2.new(0,16,0,47),
    Size = UDim2.new(1,-32,0,24), Font = Enum.Font.Gotham,
    Text = "Starter classes are free. Unlock other classes once, then switch freely.",
    TextColor3 = C.muted, TextSize = 11, TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left,
}, panel)

local scroll = make("ScrollingFrame", {
    Position = UDim2.new(0,14,0,78), Size = UDim2.new(1,-28,1,-126),
    BackgroundTransparency = 1, BorderSizePixel = 0,
    ScrollBarThickness = 5, CanvasSize = UDim2.new(),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, panel)
make("UIGridLayout", {
    CellSize = UDim2.new(0.48,-6,0,112),
    CellPadding = UDim2.fromOffset(8,8),
    SortOrder = Enum.SortOrder.LayoutOrder,
}, scroll)

local status = make("TextLabel", {
    Position = UDim2.new(0,16,1,-38), Size = UDim2.new(1,-32,0,26),
    BackgroundTransparency = 1, Font = Enum.Font.GothamSemibold,
    Text = "Select a class.", TextColor3 = C.gold, TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Left,
}, panel)

local buttons = {}
local function owned(className)
    local folder = player:FindFirstChild("UnlockedClasses")
    local flag = folder and folder:FindFirstChild(className)
    if flag and flag:IsA("BoolValue") then return flag.Value end
    return className == "Camper" or className == "Hunter" or className == "Medic"
end

local order = { "Camper", "Hunter", "Medic", "Alien", "Cyborg", "ShadowNinja", "BeastMaster" }
for index, className in ipairs(order) do
    local data = Config.Classes[className]
    local card = make("Frame", {
        BackgroundColor3 = C.panel, BorderSizePixel = 0, LayoutOrder = index,
    }, scroll)
    make("UICorner", {CornerRadius = UDim.new(0,10)}, card)
    make("UIStroke", {Color = C.green, Transparency = 0.55}, card)
    make("TextLabel", {
        BackgroundTransparency = 1, Position = UDim2.new(0,9,0,7),
        Size = UDim2.new(1,-18,0,23), Font = Enum.Font.GothamBold,
        Text = data.DisplayName or className, TextColor3 = C.text, TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, card)
    make("TextLabel", {
        BackgroundTransparency = 1, Position = UDim2.new(0,9,0,32),
        Size = UDim2.new(1,-18,0,34), Font = Enum.Font.Gotham,
        Text = "HP " .. data.MaxHealth .. "  •  Speed " .. data.WalkSpeed .. "\nItem: " .. data.StartingItem,
        TextColor3 = C.muted, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
    }, card)
    local button = make("TextButton", {
        Position = UDim2.new(0,8,1,-31), Size = UDim2.new(1,-16,0,24),
        BackgroundColor3 = C.panel2, BorderSizePixel = 0,
        Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = C.text,
        Text = owned(className) and "EQUIP" or ("UNLOCK • " .. data.Cost .. " Diamonds"),
    }, card)
    make("UICorner", {CornerRadius = UDim.new(0,7)}, button)
    buttons[className] = button
    button.Activated:Connect(function()
        if not equipRemote or not equipRemote:IsA("RemoteEvent") then
            status.Text = "Class remote is not connected yet."
            return
        end
        status.Text = "Requesting " .. data.DisplayName .. "..."
        equipRemote:FireServer(className)
    end)
end

local function refresh()
    for className, button in pairs(buttons) do
        button.Text = owned(className) and "EQUIP" or ("UNLOCK • " .. Config.Classes[className].Cost .. " Diamonds")
    end
end
local folder = player:FindFirstChild("UnlockedClasses")
if folder then folder.ChildAdded:Connect(refresh) end
player.ChildAdded:Connect(function(child)
    if child.Name == "UnlockedClasses" then
        child.ChildAdded:Connect(refresh)
        refresh()
    end
end)

-- Open this screen from a lobby class-selection prompt/button using this BindableEvent.
local openEvent = ReplicatedStorage:FindFirstChild("OpenClassSelection")
if not openEvent then
    openEvent = Instance.new("BindableEvent")
    openEvent.Name = "OpenClassSelection"
    openEvent.Parent = ReplicatedStorage
end
openEvent.Event:Connect(function() refresh(); gui.Enabled = true end)
