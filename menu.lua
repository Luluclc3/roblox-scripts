-- ══════════════════════════════════════════════════════
--           LULUCLC3 MENU v10.0 - MOBILE OPTIMIZED 👑
--                FLY C-FRAME & ALL FEATURES
-- ══════════════════════════════════════════════════════

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ── Chargement Rayfield ──
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
   Name = "Luluclc3 V10 Elite 👑",
   LoadingTitle = "Optimisation Mobile Engine...",
   LoadingSubtitle = "Version 10.0 - Ultra Fly",
   Theme = "Default",
   ConfigurationSaving = { Enabled = true, Folder = "Luluclc3_V10" }
})

-- ══════════════════════════════════════
-- VARIABLES ET ÉTATS
-- ══════════════════════════════════════
local flyActive = false
local flySpeed = 2 -- Multiplicateur pour le mode CFrame
local AimbotActive = false
local AimDistance = 999999
local espActive = false

local function getRoot() return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") end
local function getHum() return LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") end

-- ══════════════════════════════════════
-- ONGLET 1 : FLY ULTRA-OPTIMISÉ (C-FRAME)
-- ══════════════════════════════════════
local FlyTab = Window:CreateTab("✈️ Fly Mobile/PC", 4483362458)

FlyTab:CreateToggle({
   Name = "Activer le Vol (Mode Fluide)",
   CurrentValue = false,
   Callback = function(v)
       flyActive = v
       if v then
           task.spawn(function()
               while flyActive do
                   RunService.RenderStepped:Wait()
                   local root = getRoot()
                   local hum = getHum()
                   if root and hum then
                       hum.PlatformStand = true
                       local moveDir = Vector3.new(0,0,0)
                       
                       -- Direction via Joystick Mobile OU Clavier PC
                       if hum.MoveDirection.Magnitude > 0 then
                           moveDir = hum.MoveDirection
                       end
                       
                       -- Ajustement Hauteur (Espace/Shift pour PC)
                       if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
                       if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0,1,0) end
                       
                       -- Le déplacement magique (CFrame)
                       root.CFrame = CFrame.new(root.Position, root.Position + Camera.CFrame.LookVector) * CFrame.new(moveDir * flySpeed)
                       root.Velocity = Vector3.new(0,0,0) -- Empêche de tomber
                   end
               end
               if getHum() then getHum().PlatformStand = false end
           end)
       end
   end,
})

FlyTab:CreateSlider({
   Name = "Vitesse du Fly",
   Range = {1, 10}, Increment = 0.5, CurrentValue = 2,
   Callback = function(v) flySpeed = v end,
})

-- ══════════════════════════════════════
-- ONGLET 2 : COMBAT (AIMBOT & HITBOX)
-- ══════════════════════════════════════
local CombatTab = Window:CreateTab("⚔️ Combat", 4483362458)

CombatTab:CreateToggle({
   Name = "Aimbot Auto-Lock",
   CurrentValue = false,
   Callback = function(v) AimbotActive = v end,
})

CombatTab:CreateInput({
   Name = "Distance Infinie",
   PlaceholderText = "999999",
   Callback = function(txt) AimDistance = tonumber(txt) or 999999 end,
})

CombatTab:CreateSlider({
   Name = "Hitbox Expander",
   Range = {2, 50}, Increment = 1, CurrentValue = 2,
   Callback = function(v)
       for _, p in pairs(Players:GetPlayers()) do
           if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
               p.Character.HumanoidRootPart.Size = Vector3.new(v, v, v)
               p.Character.HumanoidRootPart.Transparency = 0.7
           end
       end
   end,
})

-- ══════════════════════════════════════
-- ONGLET 3 : VISUELS (ESP AUTO-REFRESH)
-- ══════════════════════════════════════
local VisualTab = Window:CreateTab("👁️ Visuals", 4483362458)

VisualTab:CreateToggle({
   Name = "ESP Auto-Refresh",
   CurrentValue = false,
   Callback = function(v)
       espActive = v
       task.spawn(function()
           while espActive do
               for _, p in pairs(Players:GetPlayers()) do
                   if p ~= LocalPlayer and p.Character and not p.Character:FindFirstChild("LuluESP") then
                       local hl = Instance.new("Highlight", p.Character)
                       hl.Name = "LuluESP"
                       hl.FillColor = Color3.fromRGB(255, 0, 0)
                   end
               end
               task.wait(1)
           end
           for _, p in pairs(Players:GetPlayers()) do
               if p.Character and p.Character:FindFirstChild("LuluESP") then p.Character.LuluESP:Destroy() end
           end
       end)
   end,
})

-- ══════════════════════════════════════
-- ONGLET 4 : TOOL EMOTE
-- ══════════════════════════════════════
local FunTab = Window:CreateTab("🎭 Fun", 4483362458)

FunTab:CreateButton({
    Name = "Prendre Tool Branler 💦",
    Callback = function()
        local tool = Instance.new("Tool")
        tool.Name = "Branler 💦"
        tool.RequiresHandle = false
        tool.Parent = LocalPlayer.Backpack
        local track = nil
        tool.Equipped:Connect(function()
            local h = getHum()
            if h then
                local a = Instance.new("Animation")
                a.AnimationId = "rbxassetid://3333499508"
                track = h:LoadAnimation(a)
                track:Play()
                track:AdjustSpeed(5)
            end
        end)
        tool.Unequipped:Connect(function() if track then track:Stop() end end)
    end
})

-- ══════════════════════════════════════
-- BOUCLE AIMBOT
-- ══════════════════════════════════════
RunService.RenderStepped:Connect(function()
    if AimbotActive then
        local target = nil
        local dist = AimDistance
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local d = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                if d < dist then
                    local pos, vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
                    if vis then dist = d; target = p.Character.Head end
                end
            end
        end
        if target then Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position) end
    end
end)

Rayfield:Notify({Title = "Luluclc3 V10", Content = "Fly Mobile Ultra-Smooth activé !", Duration = 5})
