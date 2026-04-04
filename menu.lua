-- ══════════════════════════════════════════════════════
--           LULUCLC3 MENU v6.0 - HYBRID EDITION 👑
--                FLY OPTIMISÉ PC & MOBILE
-- ══════════════════════════════════════════════════════

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ── Chargement Rayfield ──
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
   Name = "Luluclc3 Hybrid 👑",
   LoadingTitle = "Optimisation Mobile/PC...",
   LoadingSubtitle = "Version 6.0 - Fly Pro",
   Theme = "Default",
   ConfigurationSaving = { Enabled = true, Folder = "Luluclc3_V6" }
})

-- ══════════════════════════════════════
-- VARIABLES ET ÉTATS
-- ══════════════════════════════════════
local flyActive = false
local flySpeed = 60
local AimbotEnabled = false
local HitboxSize = 2

local function getRoot() return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") end
local function getHum() return LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") end

-- ══════════════════════════════════════
-- ONGLET 1 : FLY OPTIMISÉ (PC & MOBILE)
-- ══════════════════════════════════════
local FlyTab = Window:CreateTab("✈️ Fly Pro", 4483362458)

FlyTab:CreateToggle({
   Name = "Activer le Vol (Fly)",
   CurrentValue = false,
   Callback = function(v)
       flyActive = v
       local root = getRoot()
       if not root then return end
       
       if v then
           -- Création des forces physiques
           local bg = Instance.new("BodyGyro", root)
           bg.Name = "FlyGyro"
           bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
           bg.p = 9e4
           
           local bv = Instance.new("BodyVelocity", root)
           bv.Name = "FlyVel"
           bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
           
           task.spawn(function()
               while flyActive and getRoot() do
                   RunService.RenderStepped:Wait()
                   local h = getHum()
                   if h then h.PlatformStand = true end
                   
                   -- Détection de direction intelligente
                   local moveDir = Vector3.new(0,0,0)
                   
                   -- Contrôles PC (Clavier)
                   if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
                   if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
                   if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end
                   if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end
                   if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
                   if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0,1,0) end
                   
                   -- Contrôles Mobile (Joystick)
                   if h and h.MoveDirection.Magnitude > 0 then
                       moveDir = moveDir + (h.MoveDirection * 1.5) -- Utilise le joystick
                   end
                   
                   bv.Velocity = moveDir * flySpeed
                   bg.CFrame = Camera.CFrame
               end
               -- Nettoyage
               if bg then bg:Destroy() end
               if bv then bv:Destroy() end
               if getHum() then getHum().PlatformStand = false end
           end)
       end
   end,
})

FlyTab:CreateSlider({
   Name = "Vitesse du Vol",
   Range = {10, 500}, Increment = 5, CurrentValue = 60,
   Callback = function(v) flySpeed = v end,
})

-- ══════════════════════════════════════
-- ONGLET 2 : COMBAT & AIMBOT
-- ══════════════════════════════════════
local CombatTab = Window:CreateTab("⚔️ Combat", 4483362458)

CombatTab:CreateToggle({
   Name = "Aimbot Auto-Lock",
   CurrentValue = false,
   Callback = function(v) AimbotEnabled = v end,
})

CombatTab:CreateSlider({
   Name = "Taille Hitbox Ennemis",
   Range = {2, 100}, Increment = 1, CurrentValue = 2,
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
-- ONGLET 3 : EMOTES (BRANLER & DANSES)
-- ══════════════════════════════════════
local EmoteTab = Window:CreateTab("🎭 Emotes Fun", 4483362458)

EmoteTab:CreateButton({
    Name = "Emote : Branler 💦",
    Callback = function()
        local h = getHum()
        if h then
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://3333499508"
            local t = h:LoadAnimation(anim)
            t:Play()
            t:AdjustSpeed(5) -- Très rapide pour l'effet
        end
    end
})

EmoteTab:CreateButton({
    Name = "Danse : Techno 🕺",
    Callback = function()
        local anim = Instance.new("Animation")
        anim.AnimationId = "rbxassetid://3338048109"
        getHum():LoadAnimation(anim):Play()
    end
})

-- ══════════════════════════════════════
-- BOUCLES DE MISE À JOUR
-- ══════════════════════════════════════
RunService.RenderStepped:Connect(function()
    -- Aimbot Logic
    if AimbotEnabled then
        local target = nil
        local dist = math.huge
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local pos, vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
                if vis then
                    local m = (Vector2.new(pos.X, pos.Y) - UIS:GetMouseLocation()).Magnitude
                    if m < dist then dist = m; target = p.Character.Head end
                end
            end
        end
        if target then Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position) end
    end
end)

Rayfield:LoadConfiguration()
Rayfield:Notify({Title = "Luluclc3 V6.0", Content = "Le Fly Hybrid est opérationnel !", Duration = 5})
