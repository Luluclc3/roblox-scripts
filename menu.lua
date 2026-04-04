-- ══════════════════════════════════════════════════════
--           LULUCLC3 MENU v9.0 - TOOL EDITION 👑
--                ALL-IN-ONE + EMOTE ITEM
-- ══════════════════════════════════════════════════════

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ── Chargement Rayfield ──
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
   Name = "Luluclc3 Ultimate V9 👑",
   LoadingTitle = "Génération des Objets...",
   LoadingSubtitle = "Version 9.0 - Master Tool",
   Theme = "Default",
   ConfigurationSaving = { Enabled = true, Folder = "Luluclc3_V9" }
})

-- ══════════════════════════════════════
-- VARIABLES ET ÉTATS
-- ══════════════════════════════════════
local AimbotActive = false
local AimDistance = 999999
local flyActive = false
local flySpeed = 70
local espActive = false
local hitboxSize = 2
local spinning = false
local spinSpeed = 50

local function getRoot() return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") end
local function getHum() return LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") end

-- ══════════════════════════════════════
-- FONCTION : CRÉATION DU TOOL EMOTE
-- ══════════════════════════════════════
local function GiveEmoteTool()
    local tool = Instance.new("Tool")
    tool.Name = "Branler 💦"
    tool.RequiresHandle = false
    tool.Parent = LocalPlayer.Backpack
    
    local animTrack = nil
    
    tool.Equipped:Connect(function()
        local h = getHum()
        if h then
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://3333499508"
            animTrack = h:LoadAnimation(anim)
            animTrack:Play()
            animTrack:AdjustSpeed(5)
            Rayfield:Notify({Title = "Emote", Content = "Activation de l'emote !", Duration = 2})
        end
    end)
    
    tool.Unequipped:Connect(function()
        if animTrack then
            animTrack:Stop()
            animTrack:Destroy()
        end
    end)
end

-- ══════════════════════════════════════
-- ONGLET 1 : COMBAT (AIMBOT & HITBOX)
-- ══════════════════════════════════════
local CombatTab = Window:CreateTab("⚔️ Combat Elite", 4483362458)

CombatTab:CreateToggle({
   Name = "Aimbot (Auto-Lock)",
   CurrentValue = false,
   Callback = function(v) AimbotActive = v end,
})

CombatTab:CreateInput({
   Name = "Distance Aimbot (Nombre)",
   PlaceholderText = "Ex: 999999",
   Callback = function(txt) AimDistance = tonumber(txt) or 999999 end,
})

CombatTab:CreateSlider({
   Name = "Taille Hitbox Ennemis",
   Range = {2, 100}, Increment = 1, Suffix = " studs", CurrentValue = 2,
   Callback = function(v)
       hitboxSize = v
       task.spawn(function()
           while true do
               task.wait(2)
               for _, p in pairs(Players:GetPlayers()) do
                   if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                       p.Character.HumanoidRootPart.Size = Vector3.new(v, v, v)
                       p.Character.HumanoidRootPart.Transparency = 0.7
                       p.Character.HumanoidRootPart.CanCollide = false
                   end
               end
           end
       end)
   end,
})

-- ══════════════════════════════════════
-- ONGLET 2 : FLY & MOUVEMENT
-- ══════════════════════════════════════
local MoveTab = Window:CreateTab("✈️ Fly Pro", 4483362458)

MoveTab:CreateToggle({
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
                   if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir += Camera.CFrame.LookVector end
                   if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir -= Camera.CFrame.LookVector end
                   if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir -= Camera.CFrame.RightVector end
                   if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir += Camera.CFrame.RightVector end
                   if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.new(0,1,0) end
                   if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir -= Vector3.new(0,1,0) end
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

MoveTab:CreateSlider({
   Name = "Vitesse Fly",
   Range = {10, 500}, Increment = 5, CurrentValue = 70,
   Callback = function(v) flySpeed = v end,
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
       if v then
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
       end
   end,
})

-- ══════════════════════════════════════
-- ONGLET 4 : FUN & TOOL GENERATOR
-- ══════════════════════════════════════
local FunTab = Window:CreateTab("🎭 Fun & Tools", 4483362458)

FunTab:CreateButton({
    Name = "Obtenir le Tool : Branler 💦",
    Callback = function()
        GiveEmoteTool()
        Rayfield:Notify({Title = "Inventaire", Content = "Tool ajouté à ton sac !", Duration = 3})
    end
})

FunTab:CreateToggle({
   Name = "Activer Spin-Bot",
   CurrentValue = false,
   Callback = function(v) spinning = v end,
})

-- ══════════════════════════════════════
-- BOUCLES DE MISE À JOUR
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
    
    if spinning and getRoot() then
        getRoot().CFrame = getRoot().CFrame * CFrame.Angles(0, math.rad(spinSpeed), 0)
    end
end)

Rayfield:LoadConfiguration()
Rayfield:Notify({Title = "Luluclc3 Master V9", Content = "Prêt pour l'action !", Duration = 5})
