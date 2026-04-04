-- ══════════════════════════════════════════════════════
--           LULUCLC3 MENU v17.0 - INFINITY EDITION 👑
--                FLY+NOCLIP & JERK EMOTE FIX
-- ══════════════════════════════════════════════════════

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ── Chargement Rayfield ──
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
   Name = "Luluclc3 Master V17 👑",
   LoadingTitle = "Protocole Excellence en cours...",
   LoadingSubtitle = "Version 17.0 - Infinite Style",
   Theme = "DarkBlue",
   ConfigurationSaving = { Enabled = true, Folder = "Luluclc3_V17" }
})

-- ══════════════════════════════════════
-- VARIABLES ET ÉTATS
-- ══════════════════════════════════════
local flyActive = false
local noclipActive = false
local flySpeed = 2
local AimbotActive = false
local TargetPlayer = "Tous"
local AimDistance = 999999
local espActive = false
local hitboxSize = 2

local function getRoot() return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") end
local function getHum() return LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") end

-- ══════════════════════════════════════
-- ONGLET 1 : COMBAT (AIM SÉLECTIF)
-- ══════════════════════════════════════
local CombatTab = Window:CreateTab("⚔️ Combat Elite", 4483362458)

CombatTab:CreateSection("🎯 Aimbot Custom")
CombatTab:CreateToggle({
   Name = "Activer l'Aimbot",
   CurrentValue = false,
   Callback = function(v) AimbotActive = v end,
})

local PlayerList = {"Tous"}
for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then table.insert(PlayerList, p.Name) end end

local TargetDropdown = CombatTab:CreateDropdown({
   Name = "Cible Spécifique",
   Options = PlayerList,
   CurrentOption = {"Tous"},
   Callback = function(v) TargetPlayer = v[1] end,
})

CombatTab:CreateButton({
   Name = "Actualiser la Liste 🔄",
   Callback = function()
       local NewList = {"Tous"}
       for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then table.insert(NewList, p.Name) end end
       TargetDropdown:Set(NewList)
   end,
})

CombatTab:CreateSection("🛡️ Hitbox Modifier")
CombatTab:CreateSlider({
   Name = "Taille Hitbox",
   Range = {2, 100}, Increment = 1, CurrentValue = 2,
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

CombatTab:CreateButton({Name = "Réinitialiser Hitbox 🔄", Callback = function()
    hitboxSize = 2
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            p.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
            p.Character.HumanoidRootPart.Transparency = 0
            p.Character.HumanoidRootPart.CanCollide = true
        end
    end
end})

-- ══════════════════════════════════════
-- ONGLET 2 : MOUVEMENT (BEST FLY & NOCLIP)
-- ══════════════════════════════════════
local MoveTab = Window:CreateTab("✈️ Fly & Noclip", 4483362458)

MoveTab:CreateSection("🚀 Vol Directionnel (Optimisé Mobile)")
MoveTab:CreateToggle({
   Name = "Activer Fly + Noclip",
   CurrentValue = false,
   Callback = function(v)
       flyActive = v
       noclipActive = v
       if v then
           task.spawn(function()
               while flyActive do
                   RunService.RenderStepped:Wait()
                   local root = getRoot()
                   local hum = getHum()
                   if root and hum then
                       hum.PlatformStand = true
                       local moveDir = hum.MoveDirection
                       
                       -- DIRECTION PARFAITE : On se déplace vers là où on regarde
                       if moveDir.Magnitude > 0 then
                            root.CFrame = root.CFrame:Lerp(CFrame.new(root.Position, root.Position + Camera.CFrame.LookVector) * CFrame.new(0, 0, -flySpeed), 0.5)
                       else
                            root.Velocity = Vector3.new(0,0,0)
                       end
                       
                       -- Contrôles PC additionnels
                       if UIS:IsKeyDown(Enum.KeyCode.Space) then root.CFrame = root.CFrame * CFrame.new(0, flySpeed, 0) end
                       if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then root.CFrame = root.CFrame * CFrame.new(0, -flySpeed, 0) end
                   end
               end
               if getHum() then getHum().PlatformStand = false end
           end)
       end
   end,
})

MoveTab:CreateToggle({
    Name = "Noclip Manuel",
    CurrentValue = false,
    Callback = function(v) noclipActive = v end,
})

MoveTab:CreateSlider({
   Name = "Vitesse du Vol",
   Range = {1, 15}, Increment = 0.5, CurrentValue = 2,
   Callback = function(v) flySpeed = v end,
})

-- ══════════════════════════════════════
-- ONGLET 3 : VISUELS (ESP)
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
-- ONGLET 4 : EMOTE JERK (IY STYLE)
-- ══════════════════════════════════════
local FunTab = Window:CreateTab("🎭 Fun & Emotes", 4483362458)

FunTab:CreateButton({
    Name = "Prendre le Tool : Jerk 💦",
    Callback = function()
        local tool = Instance.new("Tool")
        tool.Name = "Jerk 💦"
        tool.RequiresHandle = false
        tool.Parent = LocalPlayer.Backpack
        local track = nil
        
        tool.Equipped:Connect(function()
            local h = getHum()
            if h then
                local a = Instance.new("Animation")
                -- ID Universel pour l'emote Jerk
                a.AnimationId = "rbxassetid://35154961" 
                track = h:LoadAnimation(a)
                track:Play()
                track:AdjustSpeed(5)
                track.Looped = true
            end
        end)
        
        tool.Unequipped:Connect(function() 
            if track then 
                track:Stop()
                track:Destroy() 
            end 
        end)
        Rayfield:Notify({Title = "Inventaire", Content = "Équipez l'objet pour commencer l'animation !", Duration = 3})
    end
})

-- ══════════════════════════════════════
-- LOGIQUE NOCLIP & AIMBOT (BOUCLES)
-- ══════════════════════════════════════
RunService.Stepped:Connect(function()
    if noclipActive and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if AimbotActive then
        local targetHead = nil
        local dist = AimDistance
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                if TargetPlayer == "Tous" or TargetPlayer == p.Name then
                    local d = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                    if d < dist then
                        local pos, vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
                        if vis then dist = d; targetHead = p.Character.Head end
                    end
                end
            end
        end
        if targetHead then Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetHead.Position) end
    end
end)

Rayfield:Notify({Title = "Luluclc3 Master V17", Content = "Le script ultime est chargé !", Duration = 5})
