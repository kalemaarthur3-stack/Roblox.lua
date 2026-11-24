-- 100 Nights: Rainforest Survival | KSJ
-- LocalScript: StarterPlayer/StarterPlayerScripts/GUI/LobbyStations.client.lua
-- UI panels for the physical Shop, Rewards, Trading, and Redeem Code stations.
-- Physical station prompts can fire the matching BindableEvents below.
-- Purchase/trade/reward remotes must be validated by the server before use.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

local C = {
    bg = Color3.fromRGB(8,27,17), panel = Color3.fromRGB(17,49,29),
    card = Color3.fromRGB(28,70,41), green = Color3.fromRGB(105,183,110),
    text = Color3.fromRGB(235,244,230), muted = Color3.fromRGB(173,195,173),
    gold = Color3.fromRGB(226,191,96),
}
local function make(className, props, parent)
    local o = Instance.new(className)
    for k,v in pairs(props or {}) do o[k] = v end
    o.Parent = parent
    return o
end

local gui = make("ScreenGui", {Name="LobbyStationsGUI", ResetOnSpawn=false}, playerGui)
local panel = make("Frame", {
    Name="StationPanel", AnchorPoint=Vector2.new(0.5,0.5),
    Position=UDim2.fromScale(0.5,0.5), Size=UDim2.new(0.84,0,0.66,0),
    BackgroundColor3=C.bg, BorderSizePixel=0, Visible=false,
}, gui)
make("UICorner", {CornerRadius=UDim.new(0,15)}, panel)
make("UIStroke", {Color=C.green, Thickness=1.5}, panel)
local title = make("TextLabel", {
    BackgroundTransparency=1, Position=UDim2.new(0,16,0,10),
    Size=UDim2.new(1,-68,0,34), Font=Enum.Font.GothamBold,
    Text="STATION", TextColor3=C.text, TextSize=19,
    TextXAlignment=Enum.TextXAlignment.Left,
}, panel)
local close = make("TextButton", {
    Position=UDim2.new(1,-48,0,10), Size=UDim2.fromOffset(34,30),
    BackgroundColor3=C.card, Text="X", TextColor3=C.text,
    Font=Enum.Font.GothamBold, TextSize=14, BorderSizePixel=0,
}, panel)
make("UICorner", {CornerRadius=UDim.new(0,8)}, close)
close.Activated:Connect(function() panel.Visible=false end)

local body = make("Frame", {
    BackgroundTransparency=1, Position=UDim2.new(0,16,0,52),
    Size=UDim2.new(1,-32,1,-68),
}, panel)
local function clearBody()
    for _, child in ipairs(body:GetChildren()) do child:Destroy() end
end
local function heading(text)
    make("TextLabel", {
        BackgroundTransparency=1, Size=UDim2.new(1,0,0,46),
        Font=Enum.Font.Gotham, Text=text, TextColor3=C.muted,
        TextSize=12, TextWrapped=true, TextYAlignment=Enum.TextYAlignment.Top,
    }, body)
end
local function show(name)
    panel.Visible=true
    title.Text=string.upper(name)
    clearBody()
    if name=="Shop" then
        heading("Welcome to the rainforest shop. Item listings and prices will appear here when the server shop catalog is connected.")
    elseif name=="Rewards" then
        heading("Your daily and milestone rewards will appear here. The server must verify and grant every reward.")
    elseif name=="Trading" then
        heading("Trading opens here. Player offers, confirmations, and item transfers must be handled securely by the server.")
    elseif name=="Redeem" then
        heading("Enter a promotional code. Each code should be checked and redeemed once by the server.")
        local input=make("TextBox", {
            Position=UDim2.new(0,0,0,55), Size=UDim2.new(1,0,0,42),
            BackgroundColor3=C.card, BorderSizePixel=0,
            PlaceholderText="Enter code", Text="", ClearTextOnFocus=false,
            Font=Enum.Font.Gotham, TextSize=14, TextColor3=C.text,
        }, body)
        make("UICorner", {CornerRadius=UDim.new(0,8)}, input)
        local submit=make("TextButton", {
            Position=UDim2.new(0,0,0,108), Size=UDim2.new(1,0,0,38),
            BackgroundColor3=C.green, BorderSizePixel=0,
            Text="REDEEM", TextColor3=C.bg, Font=Enum.Font.GothamBold, TextSize=13,
        }, body)
        make("UICorner", {CornerRadius=UDim.new(0,8)}, submit)
        local status=make("TextLabel", {
            Position=UDim2.new(0,0,0,152), Size=UDim2.new(1,0,0,36),
            BackgroundTransparency=1, Font=Enum.Font.Gotham,
            Text="Waiting for code.", TextColor3=C.gold, TextSize=11,
        }, body)
        submit.Activated:Connect(function()
            local remotes=ReplicatedStorage:FindFirstChild("Remotes")
            local remote=remotes and remotes:FindFirstChild("RedeemCode")
            if not remote or not remote:IsA("RemoteEvent") then
                status.Text="Code redemption is not connected yet."
                return
            end
            status.Text="Checking code..."
            remote:FireServer(input.Text)
        end)
    end
end

local eventNames = {
    Shop="OpenShopStation",
    Rewards="OpenRewardsStation",
    Trading="OpenTradingStation",
    Redeem="OpenRedeemStation",
}
for station, eventName in pairs(eventNames) do
    local event=ReplicatedStorage:FindFirstChild(eventName)
    if not event then
        event=Instance.new("BindableEvent")
        event.Name=eventName
        event.Parent=ReplicatedStorage
    end
    event.Event:Connect(function() show(station) end)
end
