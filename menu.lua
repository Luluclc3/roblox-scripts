-- ══════════════════════════════════════════════════════
--           LULUCLC3 PRESTIGE v46.0 - RAYFIELD EDITION 👑
--      STYLE PSYCHOLOGIQUE | FLUIDITÉ ABSOLUE | DELTA OK
-- ══════════════════════════════════════════════════════

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Luluclc3 Zenith 👑",
   LoadingTitle = "Initialisation de l'Élite...",
   LoadingSubtitle = "par Luluclc3",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "Luluclc3Config",
      FileName = "MainConfig"
   },
   KeySystem = false
})

-- [ ÉTAT DU SYSTÈME ]
local Settings = {
    speed = 16, jump = 50,
    aimbot = false, aimSmooth = 0.5,
    aura = false, auraRange = 20,
    esp = false, noclip = false,
    infJump = false, spin = false
}

-- ══════════════════════════════════════
-- ⚔️ ONGLET COMBAT (DISCRET & PUISSANT)
-- ══════════════════════════════════════
local Combat = Window:CreateTab("⚔️ Combat", 4483362458)

Combat:CreateToggle({
   Name = "Silent Aimbot (Psychologique)",
   CurrentValue = false,
   Callback = function(Value) Settings.aimbot = Value end,
})

Combat:CreateSlider({
   Name = "Fluidité de la Visée (Smooth)",
   Range = {0.1, 1},
   Increment = 0.1,
   Suffix = "Smooth",
   CurrentValue = 0.5,
   Callback = function(Value) Settings.aimSmooth = Value end,
})

Combat:CreateToggle({
   Name = "Kill Aura (Anti-Flag)",
   CurrentValue = false,
   Callback = function(Value) Settings.aura = Value end,
})

-- ══════════════════════════════════════
-- 🏃 ONGLET AGILITÉ
-- ══════════════════════════════════════
local Move = Window:CreateTab("🏃 Agilité", 4483362458)

Move:CreateSlider({
   Name = "Vitesse de Marche",
   Range = {16, 300},
   Increment = 5,
   Suffix = "Studs",
   CurrentValue = 16,
   Callback = function(Value) Settings.speed = Value end,
})

Move:CreateSlider({
   Name = "Puissance de Saut",
   Range = {50, 500},
   Increment = 10,
   Suffix = "Power",
   CurrentValue = 50,
   Callback = function(Value) Settings.jump = Value end,
})

Move:CreateToggle({
   Name = "Noclip (Fantôme)",
   CurrentValue = false,
   Callback = function(Value) Settings.noclip = Value end,
})

Move:CreateToggle({
   Name = "Saut Infini",
   CurrentValue = false,
   Callback = function(Value) Settings.infJump = Value end,
})

-- ══════════════════════════════════════
-- 👁️ ONGLET VISUELS
-- ══════════════════════════════════════
local Visuals = Window:CreateTab("👁️ Visuals", 4483362458)

Visuals:CreateToggle({
   Name = "ESP Highlight (Vision Divine)",
   CurrentValue = false,
   Callback = function(Value) Settings.esp = Value end,
})

-- ══════════════════════════════════════
-- 🌀 ONGLET TROLL & FUN
-- ══════════════════════════════════════
local Troll = Window:CreateTab("🌀 Troll", 4483362458)

Troll:CreateToggle({
   Name = "Tornado Spin",
   CurrentValue = false,
   Callback = function(Value) Settings.spin = Value end,
})

-- ══════════════════════════════════════
-- 🔄 LOGIQUES DE FOND (STABILITÉ DELTA)
-- ══════════════════════════════════════
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local function getClosest()
    local target, dist = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            local pos, vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
            if vis then
                local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                if mag < dist then target = p; dist = mag end
            end
        end
    end
    return target
end

RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("Humanoid") then return end

    -- Vitesse & Saut
    char.Humanoid.WalkSpeed = Settings.speed
    char.Humanoid.JumpPower = Settings.jump

    -- Aimbot Psychologique (Smooth)
    if Settings.aimbot then
        local t = getClosest()
        if t then
            local targetPos = CFrame.new(Camera.CFrame.Position, t.Character.Head.Position)
            Camera.CFrame = Camera.CFrame:Lerp(targetPos, Settings.aimSmooth)
        end
    end

    -- Noclip
    if Settings.noclip then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end

    -- Spin
    if Settings.spin and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(40), 0)
    end
end)

-- Kill Aura & ESP
task.spawn(function()
    while task.wait(0.1) do
        if Settings.aura then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    if (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude < Settings.auraRange then
                        local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                        if tool then tool:Activate() end
                    end
                end
            end
        end
    end
end)

local function ApplyESP(p)
    local h = Instance.new("Highlight")
    h.FillColor = Color3.fromRGB(255, 215, 0)
    h.OutlineColor = Color3.fromRGB(255, 255, 255)
    RunService.Heartbeat:Connect(function()
        h.Parent = (Settings.esp and p ~= LocalPlayer and p.Character) or nil
    end)
end
for _, p in pairs(Players:GetPlayers()) do ApplyESP(p) end
Players.PlayerAdded:Connect(ApplyESP)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if Settings.infJump and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState("Jumping")
    end
end)

Rayfield:Notify({Title = "BIENVENUE MON CHER", Content = "Menu Luluclc3 prêt pour la domination.", Duration = 5})
