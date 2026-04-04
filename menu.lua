-- ══════════════════════════════════════════════════════
--           LULUCLC3 MENU v13.0 - MASTER SUPREME 👑
--                L'ÉDITION ULTIME & COMPLÈTE
-- ══════════════════════════════════════════════════════

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ── Chargement de l'Interface Rayfield ──
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
   Name = "Luluclc3 Master V13 👑",
   LoadingTitle = "Chargement de l'Arsenal Suprême...",
   LoadingSubtitle = "by Luluclc3 - Version Finale",
   Theme = "DarkBlue",
   ConfigurationSaving = { Enabled = true, Folder = "Luluclc3_V13" }
})

-- ══════════════════════════════════════
-- VARIABLES ET ÉTATS (CORE)
-- ══════════════════════════════════════
local flyActive = false
local flySpeed = 2
local AimbotActive = false
local AimDistance = 999999
local espActive = false
local hitboxSize = 2
local spinning = false
local spinSpeed = 50

local function getRoot() return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") end
local function getHum() return LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") end

-- ══════════════════════════════════════
-- ONGLET 1 : COMBAT (AIMBOT & HITBOX)
-- ══════════════════════════════════════
local CombatTab = Window:CreateTab("⚔️ Combat Elite", 4483362458)

CombatTab:CreateSection("🎯 Aimbot de Précision")
CombatTab:CreateToggle({
   Name = "Activer l'Aimbot",
   CurrentValue = false,
   Callback = function(v) AimbotActive = v end,
})

CombatTab:CreateInput({
   Name = "Distance de Verrouillage (Nombre)",
   PlaceholderText = "Ex: 999999",
   Callback = function(txt) AimDistance = tonumber(txt) or 999999 end,
})

CombatTab:CreateSection("🛡️ Hitbox Expander")
CombatTab:CreateSlider({
   Name = "Taille Hitbox (Cibles)",
   Range = {2, 100}, Increment = 1, Suffix = " studs", CurrentValue = 2,
   Callback = function(v)
       hitboxSize = v
       task.spawn(function()
           while hitboxSize > 2 do
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

CombatTab:CreateButton({
   Name = "Réinitialiser Hitbox 🔄",
   Callback = function()
       hitboxSize = 2
       for _, p in pairs(Players:GetPlayers()) do
           if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
               p.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
               p.Character.HumanoidRootPart.Transparency = 0
               p.Character.HumanoidRootPart.CanCollide = true
           end
       end
       Rayfield:Notify({Title = "Système", Content = "Hitboxes réinitialisées avec succès.", Duration = 3})
   end,
})

-- ══════════════════════════════════════
-- ONGLET 2 : MOUVEMENT (FLY C-FRAME PRO)
-- ══════════════════════════════════════
local MoveTab = Window:CreateTab("✈️ Fly & Mouvement", 4483362458)

MoveTab:CreateSection("🚀 Vol Mobile & PC")
MoveTab:CreateToggle({
   Name = "Activer le Fly (Optimisé)",
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
                       local moveDir = Vector3.zero
                       
                       -- Support Joystick Mobile & Clavier PC
                       if hum.MoveDirection.Magnitude > 0 then
                           moveDir = hum.MoveDirection
                       end
                       
                       -- Contrôles de Hauteur
                       if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.new(0,1,0) end
                       if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir -= Vector3.new(0,1,0) end
                       
                       -- Mouvement CFrame Fluide
                       root.CFrame = CFrame.new(root.Position, root.Position + Camera.CFrame.LookVector) * CFrame.new(moveDir * flySpeed)
                       root.Velocity = Vector3.zero
                   end
               end
               if getHum() then getHum().PlatformStand = false end
           end)
       end
   end,
})

MoveTab:CreateSlider({
   Name = "Vitesse du Vol",
   Range = {1, 15}, Increment = 0.5, CurrentValue = 2,
   Callback = function(v) flySpeed = v end,
})

-- ══════════════════════════════════════
-- ONGLET 3 : VISUELS (ESP AUTO-REFRESH)
-- ══════════════════════════════════════
local VisualTab = Window:CreateTab("👁️ Visuals ESP", 4483362458)

VisualTab:CreateToggle({
   Name = "ESP Auto-Refresh (Highlights)",
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
-- ONGLET 4 : FUN & TOOL GENERATOR
-- ══════════════════════════════════════
local FunTab = Window:CreateTab("🎭 Fun & Tools", 4483362458)

FunTab:CreateSection("🎁 Objets Spéciaux")
FunTab:CreateButton({
    Name = "Obtenir Tool : Branler 💦",
    Callback = function()
        local tool = Instance.new("Tool")
        tool.Name = "Branler 💦"
        tool.RequiresHandle = false
        tool.Parent = LocalPlayer.Backpack
        
        local animTrack = nil
        tool.Equipped:Connect(function()
            local h = getHum()
            if h then
                local a = Instance.new("Animation")
                a.AnimationId = "rbxassetid://3333499508"
                animTrack = h:LoadAnimation(a)
                animTrack:Play()
                animTrack:AdjustSpeed(5)
            end
        end)
        tool.Unequipped:Connect(function() if animTrack then animTrack:Stop() end end)
        Rayfield:Notify({Title = "Inventaire", Content = "Tool ajouté !", Duration = 2})
    end
})

FunTab:CreateSection("🌪️ Troll")
FunTab:CreateToggle({
   Name = "Activer le Spin-Bot",
   CurrentValue = false,
   Callback = function(v) spinning = v end,
})

FunTab:CreateSlider({
   Name = "Vitesse du Spin",
   Range = {10, 500}, Increment = 10, CurrentValue = 50,
   Callback = function(v) spinSpeed = v end,
})

-- ══════════════════════════════════════
-- LOGIQUE GLOBALE (RUNSERVICE)
-- ══════════════════════════════════════
RunService.RenderStepped:Connect(function()
    -- Aimbot
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
    
    -- Spin
    if spinning and getRoot() then
        getRoot().CFrame = getRoot().CFrame * CFrame.Angles(0, math.rad(spinSpeed), 0)
    end
end)

-- ══════════════════════════════════════
-- PARAMÈTRES
-- ══════════════════════════════════════
local SettingsTab = Window:CreateTab("⚙️ Paramètres", 4483362458)
SettingsTab:CreateButton({Name = "Détruire le Menu", Callback = function() Rayfield:Destroy() end})

Rayfield:LoadConfiguration()
Rayfield:Notify({Title = "Luluclc3 Master V13", Content = "Système opérationnel, mon cher !", Duration = 5})
