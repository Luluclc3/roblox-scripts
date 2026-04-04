-- ══════════════════════════════════════════════════════
--           LULUCLC3 MENU v45.0 - OMNI-ZENITH 👑
--      FULL CONTROL | DOUBLE ADJUST | MOBILE READY
-- ══════════════════════════════════════════════════════

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [1] ÉCRAN DE CHARGEMENT PRÉCIEUX (0% - 100%)
local LoaderGui = Instance.new("ScreenGui")
LoaderGui.Parent = game:GetService("CoreGui")
local LoadFrame = Instance.new("Frame")
LoadFrame.Size = UDim2.new(0, 280, 0, 40)
LoadFrame.Position = UDim2.new(0.5, -140, 0.8, 0)
LoadFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
LoadFrame.Parent = LoaderGui
Instance.new("UICorner", LoadFrame)

local Bar = Instance.new("Frame")
Bar.Size = UDim2.new(0, 0, 1, 0)
Bar.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
Bar.Parent = LoadFrame
Instance.new("UICorner", Bar)

local LoadText = Instance.new("TextLabel")
LoadText.Size = UDim2.new(1, 0, 1, 0)
LoadText.BackgroundTransparency = 1
LoadText.TextColor3 = Color3.fromRGB(255, 255, 255)
LoadText.Font = Enum.Font.GothamBold
LoadText.Parent = LoadFrame

for i = 0, 100, 20 do
    Bar.Size = UDim2.new(i/100, 0, 1, 0)
    LoadText.Text = "Chargement Luluclc3 : " .. i .. "%"
    task.wait(0.1)
end
LoaderGui:Destroy()

-- [2] INTERFACE PRINCIPALE
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Luluclc3_Omni"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 450, 0, 320)
Main.Position = UDim2.new(0.5, -225, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Visible = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

-- CROIX DE FERMETURE
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Main
Instance.new("UICorner", CloseBtn)
CloseBtn.MouseButton1Click:Connect(function() Main.Visible = false end)

-- BOUTON D'OUVERTURE (MOBILE/PC)
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 10, 0.5, -25)
OpenBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
OpenBtn.Text = "L"
OpenBtn.TextColor3 = Color3.fromRGB(255, 215, 0)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.Parent = ScreenGui
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
OpenBtn.MouseButton1Click:Connect(function() Main.Visible = true end)

-- SIGNATURE
local Credit = Instance.new("TextLabel")
Credit.Size = UDim2.new(1, 0, 0, 20)
Credit.Position = UDim2.new(0, 0, 1, -25)
Credit.BackgroundTransparency = 1
Credit.Text = "Créé par Luluclc3"
Credit.TextColor3 = Color3.fromRGB(255, 215, 0)
Credit.Font = Enum.Font.GothamBold
Credit.Parent = Main

-- SYSTEME D'ONGLETS
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 100, 1, -60)
Sidebar.Position = UDim2.new(0, 10, 0, 10)
Sidebar.BackgroundTransparency = 1
Sidebar.Parent = Main
local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Parent = Sidebar; SidebarLayout.Padding = UDim.new(0, 5)

local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -130, 1, -70)
Container.Position = UDim2.new(0, 120, 0, 10)
Container.BackgroundTransparency = 1
Container.Parent = Main

local Settings = {
    speed = 16, jump = 50, esp = false, aura = false, auraRange = 20,
    aimbot = false, noclip = false, infJump = false, spin = false, spinSpeed = 50, antiFlag = true
}

local function CreateTab(name)
    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.CanvasSize = UDim2.new(0, 0, 2, 0)
    Page.ScrollBarThickness = 0
    Page.Parent = Container
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8)

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 30)
    Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    Btn.Text = name; Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    Btn.Font = Enum.Font.GothamBold; Btn.Parent = Sidebar
    Instance.new("UICorner", Btn)
    Btn.MouseButton1Click:Connect(function()
        for _, v in pairs(Container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
        Page.Visible = true
    end)
    return Page
end

-- [3] COMPOSANTS AVEC DOUBLE RÉGLAGE (+ / -)
local function AddToggle(parent, text, key)
    local B = Instance.new("TextButton")
    B.Size = UDim2.new(1, 0, 0, 30)
    B.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    B.Text = text .. " : OFF"; B.TextColor3 = Color3.fromRGB(255, 255, 255)
    B.Parent = parent; Instance.new("UICorner", B)
    B.MouseButton1Click:Connect(function()
        Settings[key] = not Settings[key]
        B.Text = text .. " : " .. (Settings[key] and "ON" or "OFF")
        B.BackgroundColor3 = Settings[key] and Color3.fromRGB(50, 100, 50) or Color3.fromRGB(40, 40, 45)
    end)
end

local function AddDoubleAdjust(parent, text, key, inc)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 50)
    Frame.BackgroundTransparency = 1; Frame.Parent = parent
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.Text = text .. " : " .. Settings[key]
    Label.TextColor3 = Color3.fromRGB(255, 215, 0); Label.BackgroundTransparency = 1; Label.Parent = Frame
    
    local Minus = Instance.new("TextButton")
    Minus.Size = UDim2.new(0.45, 0, 0, 25); Minus.Position = UDim2.new(0, 0, 0, 20)
    Minus.Text = "- " .. inc; Minus.BackgroundColor3 = Color3.fromRGB(60, 30, 30); Minus.Parent = Frame; Instance.new("UICorner", Minus)
    
    local Plus = Instance.new("TextButton")
    Plus.Size = UDim2.new(0.45, 0, 0, 25); Plus.Position = UDim2.new(0.55, 0, 0, 20)
    Plus.Text = "+ " .. inc; Plus.BackgroundColor3 = Color3.fromRGB(30, 60, 30); Plus.Parent = Frame; Instance.new("UICorner", Plus)
    
    Minus.MouseButton1Click:Connect(function() Settings[key] = math.max(0, Settings[key] - inc); Label.Text = text .. " : " .. Settings[key] end)
    Plus.MouseButton1Click:Connect(function() Settings[key] = Settings[key] + inc; Label.Text = text .. " : " .. Settings[key] end)
end

-- ONGLETS
local T1 = CreateTab("COMBAT"); T1.Visible = true
local T2 = CreateTab("AGILITÉ")
local T3 = CreateTab("VISUELS")
local T4 = CreateTab("TROLL")

AddToggle(T1, "Aimbot Head", "aimbot")
AddToggle(T1, "Kill Aura", "aura")
AddDoubleAdjust(T1, "Portée Aura", "auraRange", 5)
AddToggle(T1, "Anti-Flag", "antiFlag")

AddDoubleAdjust(T2, "Vitesse", "speed", 10)
AddDoubleAdjust(T2, "Saut", "jump", 10)
AddToggle(T2, "Noclip", "noclip")
AddToggle(T2, "Infinite Jump", "infJump")

AddToggle(T3, "ESP Master", "esp")

AddToggle(T4, "Spin Tornado", "spin")
AddDoubleAdjust(T4, "Vitesse Spin", "spinSpeed", 20)

-- [4] LOGIQUES DE FOND
RunService.RenderStepped:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        if Settings.aimbot then
            local target = nil; local dist = math.huge
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                    local d = (char.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                    if d < dist then target = p; dist = d end
                end
            end
            if target then Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position) end
        end
        char.Humanoid.WalkSpeed = Settings.speed
        char.Humanoid.JumpPower = Settings.jump
        if Settings.noclip then for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
        if Settings.spin then char.HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(Settings.spinSpeed), 0) end
    end)
end)

task.spawn(function()
    while task.wait(0.1) do
        if Settings.aura then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude < Settings.auraRange then
                    if Settings.antiFlag then task.wait(math.random(1,3)/100) end
                    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if tool then tool:Activate() end
                end
            end
        end
    end
end)

local function ApplyESP(p)
    local h = Instance.new("Highlight")
    h.FillColor = Color3.fromRGB(255, 215, 0)
    RunService.Heartbeat:Connect(function() h.Parent = (Settings.esp and p ~= LocalPlayer and p.Character) or nil end)
end
for _, p in pairs(Players:GetPlayers()) do ApplyESP(p) end
Players.PlayerAdded:Connect(ApplyESP)

UIS.JumpRequest:Connect(function() if Settings.infJump then LocalPlayer.Character.Humanoid:ChangeState("Jumping") end end)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.CanvasSize = UDim2.new(0, 0, 2, 0)
    Page.ScrollBarThickness = 0
    Page.Parent = Container
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 10)

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 35)
    Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    Btn.Text = name
    Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    Btn.Font = Enum.Font.GothamBold
    Btn.Parent = Sidebar
    Instance.new("UICorner", Btn)

    Btn.MouseButton1Click:Connect(function()
        for _, v in pairs(Container:GetChildren()) do v.Visible = false end
        Page.Visible = true
    end)
    return Page
end

-- [3] COMPOSANTS (DESCENDRE LES VALEURS)
local function AddToggle(parent, text, key)
    local B = Instance.new("TextButton")
    B.Size = UDim2.new(1, 0, 0, 30)
    B.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    B.Text = text .. " : OFF"
    B.TextColor3 = Color3.fromRGB(255, 255, 255)
    B.Parent = parent
    Instance.new("UICorner", B)
    B.MouseButton1Click:Connect(function()
        Settings[key] = not Settings[key]
        B.Text = text .. " : " .. (Settings[key] and "ON" or "OFF")
        B.BackgroundColor3 = Settings[key] and Color3.fromRGB(50, 100, 50) or Color3.fromRGB(40, 40, 45)
    end)
end

local function AddSliderDescend(parent, text, min, max, key)
    local L = Instance.new("TextLabel")
    L.Size = UDim2.new(1, 0, 0, 20)
    L.BackgroundTransparency = 1
    L.Text = text .. " : " .. Settings[key]
    L.TextColor3 = Color3.fromRGB(255, 215, 0)
    L.Parent = parent
    
    local B = Instance.new("TextButton")
    B.Size = UDim2.new(1, 0, 0, 30)
    B.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    B.Text = "[ CLIQUER POUR DESCENDRE ]"
    B.TextColor3 = Color3.fromRGB(255, 255, 255)
    B.Parent = parent
    Instance.new("UICorner", B)
    
    B.MouseButton1Click:Connect(function()
        Settings[key] = Settings[key] - 10
        if Settings[key] < min then Settings[key] = max end
        L.Text = text .. " : " .. Settings[key]
    end)
end

-- ONGLETS
local T1 = CreateTab("COMBAT"); T1.Visible = true
local T2 = CreateTab("AGILITÉ")
local T3 = CreateTab("VISUELS")
local T4 = CreateTab("TROLL")

AddToggle(T1, "Aimbot Head", "aimbot")
AddToggle(T1, "Kill Aura", "aura")
AddSliderDescend(T1, "Portée Aura", 10, 100, "auraRange")

AddSliderDescend(T2, "Vitesse", 16, 500, "speed")
AddSliderDescend(T2, "Saut", 50, 600, "jump")
AddToggle(T2, "Noclip", "noclip")
AddToggle(T2, "Infinite Jump", "infJump")

AddToggle(T3, "ESP Master", "esp")

AddToggle(T4, "Spin Tornado", "spin")
AddSliderDescend(T4, "Vitesse Spin", 10, 500, "spinSpeed")

-- [4] LOGIQUES DE FONCTIONNEMENT
RunService.RenderStepped:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        if Settings.aimbot then
            local target = nil; local dist = math.huge
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                    local d = (char.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                    if d < dist then target = p; dist = d end
                end
            end
            if target then Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position) end
        end
        char.Humanoid.WalkSpeed = Settings.speed
        char.Humanoid.JumpPower = Settings.jump
        if Settings.noclip then for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
        if Settings.spin then char.HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(Settings.spinSpeed), 0) end
    end)
end)

task.spawn(function()
    while task.wait(0.1) do
        if Settings.aura then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude < Settings.auraRange then
                    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if tool then tool:Activate() end
                end
            end
        end
    end
end)

local function ApplyESP(p)
    local h = Instance.new("Highlight")
    h.FillColor = Color3.fromRGB(255, 215, 0)
    RunService.Heartbeat:Connect(function() h.Parent = (Settings.esp and p ~= LocalPlayer and p.Character) or nil end)
end
for _, p in pairs(Players:GetPlayers()) do ApplyESP(p) end
Players.PlayerAdded:Connect(ApplyESP)

UIS.JumpRequest:Connect(function() if Settings.infJump then LocalPlayer.Character.Humanoid:ChangeState("Jumping") end end)

print("Luluclc3 Zenith V44 - Chargée.")
