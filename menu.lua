-- ══════════════════════════════════════════════════════
--           LULUCLC3 MENU v7.0 - REFRESH EDITION 👑
--                ESP AUTO-LOAD & FULL SYNC
-- ══════════════════════════════════════════════════════

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ── Chargement Rayfield ──
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
   Name = "Luluclc3 V7 Elite 👑",
   LoadingTitle = "Actualisation des Joueurs...",
   LoadingSubtitle = "Version 7.0 - ESP Refresh",
   Theme = "Default",
   ConfigurationSaving = { Enabled = true, Folder = "Luluclc3_V7" }
})

-- ══════════════════════════════════════
-- VARIABLES ET ÉTATS
-- ══════════════════════════════════════
local espActive = false
local flyActive = false
local flySpeed = 70
local AimbotEnabled = false

local function getRoot() return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") end
local function getHum() return LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") end

-- ══════════════════════════════════════
-- ONGLET ESP (RAFRAÎCHISSEMENT CONTINU)
-- ══════════════════════════════════════
local VisualTab = Window:CreateTab("👁️ Visuals", 4483362458)

VisualTab:CreateToggle({
   Name = "ESP Auto-Refresh (Tout le monde)",
   CurrentValue = false,
   Callback = function(v)
       espActive = v
       if v then
           task.spawn(function()
               while espActive do
                   for _, p in pairs(Players:GetPlayers()) do
                       if p ~= LocalPlayer and p.Character then
                           -- Si le joueur n'a pas de contour, on lui en met un
                           if not p.Character:FindFirstChild("LuluESP") then
                               local highlight = Instance.new("Highlight")
                               highlight.Name = "LuluESP"
                               highlight.Parent = p.Character
                               highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Rouge
                               highlight.OutlineColor = Color3.new(1, 1, 1) -- Blanc
                               highlight.FillTransparency = 0.5
                           end
                       end
                   end
                   task.wait(1) -- Rafraîchit toutes les secondes
               end
               -- Nettoyage quand on éteint
               for _, p in pairs(Players:GetPlayers()) do
                   if p.Character and p.Character:FindFirstChild("LuluESP") then
                       p.Character.LuluESP:Destroy()
                   end
               end
           end)
       end
   end,
})

-- ══════════════════════════════════════
-- ONGLET FLY (HYBRIDE PC/MOBILE)
-- ══════════════════════════════════════
local FlyTab = Window:CreateTab("✈️ Fly Hybrid", 4483362458)

FlyTab:CreateToggle({
   Name = "Activer le Vol",
   CurrentValue = false,
   Callback = function(v)
       flyActive = v
       local root = getRoot()
       if v and root then
           local bv = Instance.new("BodyVelocity", root)
           bv.Name = "LuluFlyVel"
           bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
           local bg = Instance.new("BodyGyro", root)
           bg.Name = "LuluFlyGyro"
           bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
           
           task.spawn(function()
               while flyActive and getRoot() do
                   RunService.RenderStepped:Wait()
                   local h = getHum()
                   if h then h.PlatformStand = true end
                   
                   local moveDir = Vector3.zero
                   -- Clavier PC
                   if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir += Camera.CFrame.LookVector end
                   if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir -= Camera.CFrame.LookVector end
                   if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir -= Camera.CFrame.RightVector end
                   if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir += Camera.CFrame.RightVector end
                   if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.new(0,1,0) end
                   if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir -= Vector3.new(0,1,0) end
                   -- Joystick Mobile
                   if h and h.MoveDirection.Magnitude > 0 then moveDir += h.MoveDirection end
                   
                   bv.Velocity = moveDir * flySpeed
                   bg.CFrame = Camera.CFrame
               end
               if bv then bv:Destroy() end
               if bg then bg:Destroy() end
               if getHum() then getHum().PlatformStand = false end
           end)
       end
   end,
})

FlyTab:CreateSlider({
   Name = "Vitesse du Fly",
   Range = {10, 500}, Increment = 5, CurrentValue = 70,
   Callback = function(v) flySpeed = v end,
})

-- ══════════════════════════════════════
-- ONGLET COMBAT & EMOTES
-- ══════════════════════════════════════
local CombatTab = Window:CreateTab("⚔️ Combat & Fun", 4483362458)

CombatTab:CreateToggle({
   Name = "Aimbot (Auto-Lock)",
   CurrentValue = false,
   Callback = function(v) AimbotEnabled = v end,
})

CombatTab:CreateButton({
    Name = "Emote : Branler 💦",
    Callback = function()
        local h = getHum()
        if h then
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://3333499508"
            local t = h:LoadAnimation(anim)
            t:Play()
            t:AdjustSpeed(5)
        end
    end
})

-- ══════════════════════════════════════
-- LOGIQUE AIMBOT
-- ══════════════════════════════════════
RunService.RenderStepped:Connect(function()
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
Rayfield:Notify({Title = "Luluclc3 V7 Loaded", Content = "ESP et Fly synchronisés, mon cher !", Duration = 5})
