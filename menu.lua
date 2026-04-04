-- ══════════════════════════════════════════════════════
--           LULUCLC3 MENU v15.0 - EXCELLENCE 👑
--                SELECTIVE AIM & PERFECT FLY
-- ══════════════════════════════════════════════════════

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ── Chargement Rayfield ──
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
   Name = "Luluclc3 Master V15 👑",
   LoadingTitle = "Optimisation du Moteur...",
   LoadingSubtitle = "by Luluclc3 - L'Excellence",
   Theme = "DarkBlue",
   ConfigurationSaving = { Enabled = true, Folder = "Luluclc3_V15" }
})

-- ══════════════════════════════════════
-- VARIABLES GLOBALES
-- ══════════════════════════════════════
local AimbotActive = false
local AimDistance = 999999
local TargetPlayer = "Tous"
local flyActive = false
local flySpeed = 2
local espActive = false
local hitboxSize = 2
local spinning = false
local spinSpeed = 50

local function getRoot() return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") end
local function getHum() return LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") end

-- ══════════════════════════════════════
-- ONGLET 1 : COMBAT (AIMBOT SÉLECTIF)
-- ══════════════════════════════════════
local CombatTab = Window:CreateTab("⚔️ Combat Elite", 4483362458)

CombatTab:CreateSection("🎯 Aimbot Avancé")
CombatTab:CreateToggle({
   Name = "Activer l'Aimbot",
   CurrentValue = false,
   Callback = function(v) AimbotActive = v end,
})

local PlayerList = {"Tous"}
for _, p in pairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then table.insert(PlayerList, p.Name) end
end

local TargetDropdown = CombatTab:CreateDropdown({
   Name = "Choisir la Cible",
   Options = PlayerList,
   CurrentOption = {"Tous"},
   MultipleOptions = false,
   Callback = function(v) TargetPlayer = v[1] end,
})

CombatTab:CreateButton({
   Name = "Rafraîchir Liste Joueurs 🔄",
   Callback = function()
       local NewList = {"Tous"}
       for _, p in pairs(Players:GetPlayers()) do
           if p ~= LocalPlayer then table.insert(NewList, p.Name) end
       end
       TargetDropdown:Set(NewList)
   end,
})

CombatTab:CreateInput({
   Name = "Distance Max (Infinie)",
   PlaceholderText = "999999",
   Callback = function(txt) AimDistance = tonumber(txt) or 999999 end,
})

CombatTab:CreateSection("🛡️ Hitbox Expander")
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
           end
       end
   end,
})

-- ══════════════════════════════════════
-- ONGLET 2 : FLY (LE MEILLEUR POSSIBLE)
-- ══════════════════════════════════════
local MoveTab = Window:CreateTab("✈️ Fly Parfait", 4483362458)

MoveTab:CreateSection("🚀 Vol Directionnel (Mobile & PC)")
MoveTab:CreateToggle({
   Name = "Activer le Fly Pro",
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
                       
                       -- Logique Mobile/PC Unifiée
                       if hum.MoveDirection.Magnitude > 0 then
                           -- Utilise la direction du joystick relative à la vue caméra
                           moveDir = hum.MoveDirection
                       end
                       
                       -- Hauteur manuelle (PC)
                       if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.new(0, 1, 0) end
                       if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir -= Vector3.new(0, 1, 0) end
                       
                       -- Déplacement par CFrame (Zéro friction, zéro inversion)
                       root.CFrame = CFrame.new(root.Position + (moveDir * flySpeed)) * CFrame.Angles(math.rad(Camera.CFrame.LookVector.Y * 90), 0, 0)
                       -- On maintient l'angle de vue pour plus de style
                       root.CFrame = CFrame.new(root.Position, root.Position + Camera.CFrame.LookVector)
                       
                       root.Velocity = Vector3.zero
                   end
               end
               if getHum() then getHum().PlatformStand = false end
           end)
       end
   end,
})

MoveTab:CreateSlider({
   Name = "Vitesse de Croisière",
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
-- ONGLET 4 : FUN (TOOL EMOTE)
-- ══════════════════════════════════════
local FunTab = Window:CreateTab("🎭 Fun & Tools", 4483362458)

FunTab:CreateButton({
    Name = "Obtenir Tool : Branler 💦",
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
        Rayfield:Notify({Title = "Inventaire", Content = "L'objet est prêt, mon cher !"})
    end
})

FunTab:CreateToggle({
   Name = "Spin-Bot",
   CurrentValue = false,
   Callback = function(v) spinning = v end,
})

-- ══════════════════════════════════════
-- LOGIQUE FINALE (RUNSERVICE)
-- ══════════════════════════════════════
RunService.RenderStepped:Connect(function()
    if AimbotActive then
        local targetHead = nil
        local dist = AimDistance
        
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                -- Filtre par joueur sélectionné
                if TargetPlayer == "Tous" or TargetPlayer == p.Name then
                    local d = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                    if d < dist then
                        local pos, vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
                        if vis then
                            dist = d
                            targetHead = p.Character.Head
                        end
                    end
                end
            end
        end
        if targetHead then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetHead.Position)
        end
    end
    
    if spinning and getRoot() then
        getRoot().CFrame = getRoot().CFrame * CFrame.Angles(0, math.rad(spinSpeed), 0)
    end
end)

Rayfield:Notify({Title = "Luluclc3 Master V15", Content = "Système d'Excellence activé !", Duration = 5})
