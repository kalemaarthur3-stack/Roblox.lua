-- 100 Nights: Rainforest Survival | KSJ
-- LocalScript: StarterPlayer/StarterPlayerScripts/GUI/LobbyMenu.client.lua
-- Mode selection client. Server must validate capacity and create/assign teams.
-- Optional RemoteEvent: ReplicatedStorage/Remotes.SelectMode

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local C = {
    bg = Color3.fromRGB(8,27,17), panel = Color3.fromRGB(17,49,29),
    card = Color3.fromRGB(27,69,40), green = Color3.fromRGB(105,183,110),
    text = Color3.fromRGB(235,244,230), muted = Color3.fromRGB(173,195,173),
    gold = Color3.fromRGB(226,191,96),
}
local function make(className, props, parent)
    local o = Instance.new(className)
    for k,v in pairs(props or {}) do o[k] = v end
    o.Parent = parent
    return o
end

local gui = make("ScreenGui", {
    Name = "LobbyMenuGUI", ResetOnSpawn = false, Enabled = false,
}, playerGui)
local shade = make("Frame", {
    Size = UDim2.fromScale(1,1), BackgroundColor3 = Color3.new(0,0,0),
    BackgroundTransparency = 0.35, BorderSizePixel = 0,
}, gui)
local panel = make("Frame", {
    AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.fromScale(0.5,0.5),
    Size = UDim2.new(0.86,0,0.64,0), BackgroundColor3 = C.bg, BorderSizePixel = 0,
}, shade)
make("UICorner", {CornerRadius = UDim.new(0,16)}, panel)
make("UIStroke", {Color = C.green, Thickness = 1.5}, panel)
make("TextLabel", {
    BackgroundTransparency = 1, Position = UDim2.new(0,16,0,12),
    Size = UDim2.new(1,-32,0,34), Font = Enum.Font.GothamBold,
    Text = "🌿 RAINFOREST LOBBY", TextColor3 = C.text, TextSize = 19,
}, panel)
make("TextLabel", {
    BackgroundTransparency = 1, Position = UDim2.new(0,18,0,48),
    Size = UDim2.new(1,-36,0,28), Font = Enum.Font.Gotham,
    Text = "Choose how you want to survive.", TextColor3 = C.muted, TextSize = 12,
}, panel)

local close = make("TextButton", {
    Position = UDim2.new(1,-46,0,10), Size = UDim2.fromOffset(32,30),
    BackgroundColor3 = C.card, Text = "X", TextColor3 = C.text,
    Font = Enum.Font.GothamBold, TextSize = 14, BorderSizePixel = 0,
}, panel)
make("UICorner", {CornerRadius = UDim.new(0,8)}, close)
close.Activated:Connect(function() gui.Enabled = false end)

local list = make("Frame", {
    BackgroundTransparency = 1, Position = UDim2.new(0,16,0,88),
    Size = UDim2.new(1,-32,1,-142),
}, panel)
make("UIListLayout", {Padding = UDim.new(0,9), SortOrder = Enum.SortOrder.LayoutOrder}, list)

local feedback = make("TextLabel", {
    BackgroundTransparency = 1, Position = UDim2.new(0,16,1,-43),
    Size = UDim2.new(1,-32,0,28), Font = Enum.Font.GothamSemibold,
    Text = "Choose a mode to continue.", TextColor3 = C.gold, TextSize = 12,
}, panel)

local modes = {
    { key = "Normal", title = "NORMAL SURVIVAL", desc = "Everyone works together to survive 100 nights." },
    { key = "PvP", title = "PLAYER VS PLAYER", desc = "Compete against other survivors." },
    { key = "TeamVsTeam", title = "TEAM VS TEAM", desc = "Red vs Blue • Minimum 10 players per team • 30-second countdown." },
}
local remotes = ReplicatedStorage:FindFirstChild("Remotes")
local selectRemote = remotes and remotes:FindFirstChild("SelectMode")
for index, mode in ipairs(modes) do
    local button = make("TextButton", {
        Size = UDim2.new(1,0,0,72), BackgroundColor3 = C.panel,
        BorderSizePixel = 0, Text = "", LayoutOrder = index,
    }, list)
    make("UICorner", {CornerRadius = UDim.new(0,11)}, button)
    make("UIStroke", {Color = C.green, Transparency = 0.55}, button)
    make("TextLabel", {
        BackgroundTransparency = 1, Position = UDim2.new(0,12,0,8),
        Size = UDim2.new(1,-24,0,23), Font = Enum.Font.GothamBold,
        Text = mode.title, TextColor3 = C.text, TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, button)
    make("TextLabel", {
        BackgroundTransparency = 1, Position = UDim2.new(0,12,0,32),
        Size = UDim2.new(1,-24,0,32), Font = Enum.Font.Gotham,
        Text = mode.desc, TextColor3 = C.muted, TextSize = 10,
        TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left,
    }, button)
    button.Activated:Connect(function()
        if not selectRemote or not selectRemote:IsA("RemoteEvent") then
            feedback.Text = "Mode matchmaking is not connected yet."
            return
        end
        feedback.Text = "Sending " .. mode.key .. " request..."
        selectRemote:FireServer(mode.key)
    end)
end

-- Lobby trigger can fire this event; no HUD shortcut is created.
local openEvent = ReplicatedStorage:FindFirstChild("OpenLobbyMenu")
if not openEvent then
    openEvent = Instance.new("BindableEvent")
    openEvent.Name = "OpenLobbyMenu"
    openEvent.Parent = ReplicatedStorage
end
openEvent.Event:Connect(function() gui.Enabled = true end)
