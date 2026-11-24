-- 100 Nights: Rainforest Survival | KSJ
-- LocalScript: StarterPlayer/StarterPlayerScripts/GUI/CampfireHealth.client.lua
-- Looks for a BasePart named Campfire (or a Model named Campfire with a
-- PrimaryPart) and displays its CampfireHP attribute above the world object.
-- Server should set CampfireHP and CampfireMaxHP attributes on that instance.

local Workspace = game:GetService("Workspace")

local function findCampfirePart()
    local campfire = Workspace:FindFirstChild("Campfire")
    if not campfire then return nil end
    if campfire:IsA("BasePart") then return campfire end
    if campfire:IsA("Model") then
        return campfire.PrimaryPart or campfire:FindFirstChildWhichIsA("BasePart", true)
    end
    return nil
end

local function attach(part)
    local old = part:FindFirstChild("CampfireHealthBillboard")
    if old then old:Destroy() end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "CampfireHealthBillboard"
    billboard.Adornee = part
    billboard.Size = UDim2.fromOffset(170, 38)
    billboard.StudsOffset = Vector3.new(0, 4, 0)
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = 120
    billboard.Parent = part

    local background = Instance.new("Frame")
    background.Size = UDim2.fromScale(1,1)
    background.BackgroundColor3 = Color3.fromRGB(10,32,19)
    background.BackgroundTransparency = 0.12
    background.BorderSizePixel = 0
    background.Parent = billboard
    Instance.new("UICorner", background).CornerRadius = UDim.new(0,8)

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1,0,0.55,0)
    label.Font = Enum.Font.GothamBold
    label.TextColor3 = Color3.fromRGB(239,244,224)
    label.TextSize = 12
    label.Parent = background

    local track = Instance.new("Frame")
    track.Position = UDim2.new(0.08,0,0.68,0)
    track.Size = UDim2.new(0.84,0,0,6)
    track.BackgroundColor3 = Color3.fromRGB(52,60,47)
    track.BorderSizePixel = 0
    track.Parent = background
    Instance.new("UICorner", track).CornerRadius = UDim.new(1,0)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.fromScale(1,1)
    fill.BackgroundColor3 = Color3.fromRGB(104,183,108)
    fill.BorderSizePixel = 0
    fill.Parent = track
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1,0)

    local function update()
        local hp = tonumber(part:GetAttribute("CampfireHP")) or 0
        local maxHp = math.max(1, tonumber(part:GetAttribute("CampfireMaxHP")) or 100)
        local ratio = math.clamp(hp/maxHp,0,1)
        label.Text = "CAMPFIRE  " .. math.floor(hp) .. " / " .. math.floor(maxHp)
        fill.Size = UDim2.new(ratio,0,1,0)
    end
    part:GetAttributeChangedSignal("CampfireHP"):Connect(update)
    part:GetAttributeChangedSignal("CampfireMaxHP"):Connect(update)
    update()
end

local function tryAttach()
    local part=findCampfirePart()
    if part then attach(part) end
end

Workspace.ChildAdded:Connect(function(child)
    if child.Name=="Campfire" then
        task.wait(0.2)
        tryAttach()
    end
end)
tryAttach()
