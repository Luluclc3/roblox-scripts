-- ══════════════════════════════════════════════════════
--           LULUCLC3 MENU v40.0 - REDLINE MOBILE 👑
--      ULTRA-RAPIDE | OUVERTURE FORCÉE | FULL OPTIONS
-- ══════════════════════════════════════════════════════

-- [1] SÉCURITÉ ANTI-CRASH MOBILE
if not game:IsLoaded() then game.Loaded:Wait() end
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- [2] CHARGEMENT DE L'INTERFACE LÉGÈRE (SPÉCIAL MOBILE)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Luluclc3 Prestige V40 💎", "Midnight")

-- [3] VARIABLES DE CONTRÔLE
local State = {
    speed = 16, jump = 50,
    esp = false, espNames = false, espTracers = false,
    espColor = Color3.fromRGB(255, 0, 0),
    aura = false, auraDist = 20,
    noclip = false, infJump = false
}
local targetPlayer = ""

-- [4] ONGLETS DE L'ARSENAL
local Main = Window:NewTab("🏃 Mouvement")
local MainSection = Main:NewSection("Réglages Physiques")

MainSection:NewSlider("Vitesse (WalkSpeed)", "Règle ta vitesse", 500, 16, function(s) State.speed = s end)
MainSection:NewSlider("Saut (JumpPower)", "Règle ton saut", 600, 50, function(s) State.jump = s end)
MainSection:NewToggle("Noclip (Murs)", "Passe à travers tout", function(v) State.noclip = v end)
MainSection:NewToggle("Saut Infini", "Saute dans le vide", function(v) State.infJump = v end)

local Visuals = Window:NewTab("👁️ Visuals")
local VisualsSection = Visuals:NewSection("ESP & Tracking")

VisualsSection:NewToggle("Master ESP", "Voir les joueurs", function(v) State.esp = v end)
VisualsSection:NewToggle("Afficher les Noms", "Identifie tes cibles", function(v) State.espNames = v end)
VisualsSection:NewToggle("Lignes (Tracers)", "Traceur vers l'ennemi", function(v) State.espTracers = v end)
VisualsSection:NewColorPicker("Couleur ESP", "Choisis ta couleur", Color3.fromRGB(255,0,0), function(c) State.espColor = c end)

local Combat = Window:NewTab("⚔️ Combat")
local CombatSection = Combat:NewSection("Attaque Automatique")

CombatSection:NewToggle("Kill Aura", "Frappe tout ce qui bouge", function(v) State.aura = v end)
CombatSection:NewSlider("Portée d'Aura", "Distance de frappe", 50, 5, function(s) State.auraDist = s end)

local System = Window:NewTab("🛠️ Système")
local SystemSection = System:NewSection("Administration")

SystemSection:NewTextBox("Pseudo Cible", "Entre le nom ici", function(t) targetPlayer = t end)
SystemSection:NewButton("Se Téléporter (TP)", "Rejoins ta cible", function()
    local p = Players:FindFirstChild(targetPlayer)
    if p and p.Character then LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame end
end)
SystemSection:NewButton("Détruire le Menu", "Ferme proprement le script", function() Library:Destroy() end)

-- [5] LOGIQUE DE L'ESP (HAUTE FRÉQUENCE)
local function CreateESP(p)
    local box = Drawing.new("Square")
    local line = Drawing.new("Line")
    local text = Drawing.new("Text")
    text.Center = true; text.Outline = true; text.Size = 14

    RunService.RenderStepped:Connect(function()
        if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p ~= LocalPlayer then
            local root = p.Character.HumanoidRootPart
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(root.Position)

            if onScreen and State.esp and hum and hum.Health > 0 then
                box.Visible = true; box.Color = State.espColor; box.Thickness = 1
                box.Size = Vector2.new(2000/pos.Z, 3500/pos.Z)
                box.Position = Vector2.new(pos.X - box.Size.X/2, pos.Y - box.Size.Y/2)
                
                if State.espTracers then
                    line.Visible = true; line.Color = State.espColor
                    line.From = Vector2.new(workspace.CurrentCamera.ViewportSize.X/2, workspace.CurrentCamera.ViewportSize.Y)
                    line.To = Vector2.new(pos.X, pos.Y)
                else line.Visible = false end

                if State.espNames then
                    text.Visible = true; text.Color = State.espColor; text.Text = p.Name
                    text.Position = Vector2.new(pos.X, pos.Y - (box.Size.Y/2) - 15)
                else text.Visible = false end
            else box.Visible = false; line.Visible = false; text.Visible = false end
        else box.Visible = false; line.Visible = false; text.Visible = false end
        if not p.Parent then box:Remove(); line:Remove(); text:Remove() end
    end)
end

-- [6] LANCEMENT DES BOUCLES DE CONTRÔLE
for _, p in pairs(Players:GetPlayers()) do task.spawn(function() CreateESP(p) end) end
Players.PlayerAdded:Connect(function(p) task.spawn(function() CreateESP(p) end) end)

task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChildOfClass("Humanoid") then
                char:FindFirstChildOfClass("Humanoid").WalkSpeed = State.speed
                char:FindFirstChildOfClass("Humanoid").JumpPower = State.jump
            end
            if State.aura then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        if (char.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude < State.auraDist then
                            local tool = char:FindFirstChildOfClass("Tool")
                            if tool then tool:Activate() end
                        end
                    end
                end
            end
        end)
    end
end)

RunService.Stepped:Connect(function()
    if State.noclip and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end
end)

UIS.JumpRequest:Connect(function()
    if State.infJump and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)
TabVisuals:CreateToggle({Name = "Activer ESP (Master)", CurrentValue = false, Callback = function(v) State.esp = v end})
TabVisuals:CreateToggle({Name = "Lignes (Tracers)", CurrentValue = false, Callback = function(v) State.espTracers = v end})
TabVisuals:CreateToggle({Name = "Afficher les Noms", CurrentValue = false, Callback = function(v) State.espNames = v end})
TabVisuals:CreateColorPicker({Name = "Couleur des Cibles", Color = Color3.fromRGB(255,255,255), Callback = function(v) State.espColor = v end})

local TabCombat = Window:CreateTab("⚔️ Combat", 4483362458)
TabCombat:CreateToggle({Name = "Kill Aura (Auto)", CurrentValue = false, Callback = function(v) State.aura = v end})
TabCombat:CreateSlider({Name = "Portée de frappe", Range = {5, 50}, Increment = 1, CurrentValue = 20, Callback = function(v) State.auraDist = v end})

local TabMove = Window:CreateTab("🏃 Mouvement", 4483362458)
TabMove:CreateSlider({Name = "Vitesse", Range = {16, 500}, Increment = 1, CurrentValue = 16, Callback = function(v) State.speed = v end})
TabMove:CreateSlider({Name = "Saut", Range = {50, 600}, Increment = 1, CurrentValue = 50, Callback = function(v) State.jump = v end})
TabMove:CreateToggle({Name = "Noclip", CurrentValue = false, Callback = function(v) State.noclip = v end})
TabMove:CreateToggle({Name = "Saut Infini", CurrentValue = false, Callback = function(v) State.infJump = v end})

local TabSys = Window:CreateTab("🛠️ Système", 4483362458)
TabSys:CreateInput({Name = "Joueur Cible", PlaceholderText = "Pseudo...", Callback = function(t) targetPlayer = t end})
TabSys:CreateButton({Name = "TP sur lui", Callback = function()
    local p = Players:FindFirstChild(targetPlayer)
    if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame
    end
end})
TabSys:CreateButton({Name = "Détruire le Menu", Callback = function() Rayfield:Destroy() end})

-- [6] BOUCLES DE RENDU (ANTI-LAG)
for _, p in pairs(Players:GetPlayers()) do task.spawn(function() CreatePrestigeESP(p) end) end
Players.PlayerAdded:Connect(function(p) task.spawn(function() CreatePrestigeESP(p) end) end)

task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.WalkSpeed = State.speed
                hum.JumpPower = State.jump
            end
            
            if State.aura then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local d = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                        if d < State.auraDist then
                            local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                            if tool then tool:Activate() end
                        end
                    end
                end
            end
        end)
    end
end)

RunService.Stepped:Connect(function()
    if State.noclip and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

UIS.JumpRequest:Connect(function()
    if State.infJump and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

Rayfield:Notify({Title = "MAJESTÉ V39", Content = "Le protocole de luxe est prêt.", Duration = 5})
    end)
end
for _, p in pairs(Players:GetPlayers()) do ManageESP(p) end
Players.PlayerAdded:Connect(ManageESP)

-- ══════════════════════════════════════
-- ⚔️ COMBAT (SENTINEL)
-- ══════════════════════════════════════
local Combat = Window:CreateTab("⚔️ Combat", 4483362458)

Combat:CreateToggle({Name = "Kill Aura Automatique", CurrentValue = false, Callback = function(v) cfg.aura = v end})
Combat:CreateSlider({Name = "Distance d'Action", Range = {5, 50}, Increment = 1, CurrentValue = 20, Callback = function(v) cfg.auraRange = v end})

task.spawn(function()
    while task.wait(0.1) do
        if cfg.aura then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and getRoot(p.Character) then
                    if (getRoot().Position - getRoot(p.Character).Position).Magnitude < cfg.auraRange then
                        pcall(function() LocalPlayer.Character:FindFirstChildOfClass("Tool"):Activate() end)
                    end
                end
            end
        end
    end
end)

-- ══════════════════════════════════════
-- 🏃 MOUVEMENT (SUPRÉMATIE)
-- ══════════════════════════════════════
local Move = Window:CreateTab("🏃 Agilité", 4483362458)

Move:CreateSlider({Name = "Vitesse", Range = {16, 500}, Increment = 1, CurrentValue = 16, Callback = function(v) cfg.speed = v end})
Move:CreateSlider({Name = "Saut", Range = {50, 600}, Increment = 1, CurrentValue = 50, Callback = function(v) cfg.jump = v end})
Move:CreateToggle({Name = "Noclip", CurrentValue = false, Callback = function(v) cfg.noclip = v end})
Move:CreateToggle({Name = "Saut Infini", CurrentValue = false, Callback = function(v) cfg.infJump = v end})

-- ══════════════════════════════════════
-- 🛠️ SYSTÈME & TROLL
-- ══════════════════════════════════════
local Sys = Window:CreateTab("🛠️ Système", 4483362458)

Sys:CreateInput({Name = "Cible Player", PlaceholderText = "Pseudo...", Callback = function(t) target = t end})
Sys:CreateButton({Name = "Se Téléporter ⚡", Callback = function()
    local t = Players:FindFirstChild(target)
    if t and t.Character then getRoot().CFrame = t.Character.HumanoidRootPart.CFrame end
end})
Sys:CreateToggle({Name = "Tornado Spin", CurrentValue = false, Callback = function(v) cfg.spin = v end})
Sys:CreateSlider({Name = "Vitesse Rotation", Range = {10, 500}, Increment = 10, CurrentValue = 50, Callback = function(v) cfg.spinSpeed = v end})
Sys:CreateButton({Name = "Destruction Menu", Callback = function() Rayfield:Destroy() end})

-- 🔄 BOUCLE CORE (STABILITÉ)
UIS.JumpRequest:Connect(function() if cfg.infJump and getHum() then getHum():ChangeState("Jumping") end end)

RunService.Heartbeat:Connect(function()
    pcall(function()
        if getHum() then
            getHum().WalkSpeed = cfg.speed
            getHum().JumpPower = cfg.jump
        end
        if cfg.noclip and LocalPlayer.Character then
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end
        if cfg.spin and getRoot() then
            getRoot().CFrame = getRoot().CFrame * CFrame.Angles(0, math.rad(cfg.spinSpeed), 0)
        end
    end)
end)

Rayfield:Notify({Title = "V38 OPÉRATIONNELLE", Content = "Le menu a été forcé au premier plan.", Duration = 5})
    end)
end
for _, p in pairs(Players:GetPlayers()) do ManageESP(p) end
Players.PlayerAdded:Connect(ManageESP)

-- ══════════════════════════════════════
-- ⚔️ COMBAT (TOTAL CONTROL)
-- ══════════════════════════════════════
local Combat = Window:CreateTab("⚔️ Combat", 4483362458)

Combat:CreateToggle({Name = "Kill Aura", CurrentValue = false, Callback = function(v) cfg.aura = v end})
Combat:CreateSlider({Name = "Portée de l'Aura", Range = {5, 50}, Increment = 1, CurrentValue = 20, Callback = function(v) cfg.auraRange = v end})

task.spawn(function()
    while task.wait(0.1) do
        if cfg.aura then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and getRoot(p.Character) then
                    if (getRoot().Position - getRoot(p.Character).Position).Magnitude < cfg.auraRange then
                        pcall(function() LocalPlayer.Character:FindFirstChildOfClass("Tool"):Activate() end)
                    end
                end
            end
        end
    end
end)

-- ══════════════════════════════════════
-- 🏃 MOUVEMENT (PRÉCISION)
-- ══════════════════════════════════════
local Move = Window:CreateTab("🏃 Mouvement", 4483362458)

Move:CreateSlider({Name = "Vitesse de Marche", Range = {16, 500}, Increment = 1, CurrentValue = 16, Callback = function(v) cfg.speed = v end})
Move:CreateSlider({Name = "Puissance de Saut", Range = {50, 600}, Increment = 1, CurrentValue = 50, Callback = function(v) cfg.jump = v end})
Move:CreateToggle({Name = "Noclip (Murs)", CurrentValue = false, Callback = function(v) cfg.noclip = v end})
Move:CreateToggle({Name = "Infinite Jump", CurrentValue = false, Callback = function(v) cfg.infJump = v end})

-- ══════════════════════════════════════
-- 🤡 TROLL & SYSTEM
-- ══════════════════════════════════════
local Misc = Window:CreateTab("🌀 Misc", 4483362458)
Misc:CreateToggle({Name = "Tornado Spin", CurrentValue = false, Callback = function(v) cfg.spin = v end})
Misc:CreateSlider({Name = "Vitesse Spin", Range = {10, 500}, Increment = 10, CurrentValue = 50, Callback = function(v) cfg.spinSpeed = v end})
Misc:CreateButton({Name = "Destruction Menu (Panic)", Callback = function() Rayfield:Destroy() end})

-- ══════════════════════════════════════
-- 🔄 BOUCLE CORE (60 FPS REFRESH)
-- ══════════════════════════════════════
UIS.JumpRequest:Connect(function() if cfg.infJump and getHum() then getHum():ChangeState("Jumping") end end)

RunService.Heartbeat:Connect(function()
    pcall(function()
        if getHum() then
            getHum().WalkSpeed = cfg.speed
            getHum().JumpPower = cfg.jump
        end
        if cfg.noclip then
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end
        if cfg.spin and getRoot() then
            getRoot().CFrame = getRoot().CFrame * CFrame.Angles(0, math.rad(cfg.spinSpeed), 0)
        end
    end)
end)

Rayfield:Notify({Title = "INFINITE V37", Content = "Système de rafraîchissement haute fréquence actif.", Duration = 5})
                else txt.Visible = false end
            else box.Visible = false; line.Visible = false; txt.Visible = false end
        else box.Visible = false; line.Visible = false; txt.Visible = false end
        if not p.Parent then box:Remove(); line:Remove(); txt:Remove() end
    end)
end
for _, p in pairs(Players:GetPlayers()) do CreateESP(p) end

-- ══════════════════════════════════════
-- ONGLET 3 : 🏃 MOUVEMENT (DIVIN)
-- ══════════════════════════════════════
local MoveTab = Window:CreateTab("🏃 Mouvement", 4483362458)
MoveTab:CreateToggle({Name = "Infinite Jump", CurrentValue = false, Callback = function(v) infJump = v end})
MoveTab:CreateToggle({Name = "Spider (Wall Climb)", CurrentValue = false, Callback = function(v) spiderMode = v end})
MoveTab:CreateSlider({Name = "WalkSpeed", Range = {16, 500}, Increment = 1, CurrentValue = 16, Callback = function(v) walkSpeed = v end})
MoveTab:CreateSlider({Name = "JumpPower", Range = {50, 500}, Increment = 1, CurrentValue = 50, Callback = function(v) jumpPower = v end})

MoveTab:CreateSection("Waypoints")
MoveTab:CreateInput({Name = "Nom du Point", PlaceholderText = "Base, Shop...", Callback = function(t) targetName = t end})
MoveTab:CreateButton({Name = "Sauvegarder Position", Callback = function() waypoints[targetName] = getRoot().CFrame end})
MoveTab:CreateButton({Name = "Se Téléporter au Point", Callback = function() if waypoints[targetName] then getRoot().CFrame = waypoints[targetName] end end})

-- ══════════════════════════════════════
-- ONGLET 4 : 🤡 TROLL (CHAOS)
-- ══════════════════════════════════════
local TrollTab = Window:CreateTab("🤡 Troll", 4483362458)

TrollTab:CreateToggle({
   Name = "Fling Mode (Propulsion)",
   CurrentValue = false,
   Callback = function(v)
       flingActive = v
       task.spawn(function()
           while flingActive do
               task.wait()
               if getRoot() then getRoot().RotVelocity = Vector3.new(0, 10000, 0) end
           end
       end)
   end,
})

TrollTab:CreateToggle({
   Name = "Chat Spammer",
   CurrentValue = false,
   Callback = function(v)
       spamActive = v
       task.spawn(function()
           while spamActive do
               task.wait(2)
               game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("Luluclc3 Omnipotence V35 owns this server! 👑", "All")
           end
       end)
   end,
})

-- ══════════════════════════════════════
-- ONGLET 5 : 🛡️ SYSTÈME & SÉCURITÉ
-- ══════════════════════════════════════
local SysTab = Window:CreateTab("🛡️ Système", 4483362458)

SysTab:CreateToggle({
   Name = "Anti-AFK",
   CurrentValue = false,
   Callback = function(v)
       antiAfk = v
       if v then
           LocalPlayer.Idled:Connect(function()
               if antiAfk then game:GetService("VirtualUser"):CaptureController(); game:GetService("VirtualUser"):ClickButton2(Vector2.new()) end
           end)
       end
   end,
})

SysTab:CreateToggle({Name = "Anti-Fling", CurrentValue = false, Callback = function(v) antiFling = v end})

SysTab:CreateButton({Name = "Clean All (Panic Mode)", Callback = function() Rayfield:Destroy() end})

-- ══════════════════════════════════════
-- BOUCLES DE LOGIQUE (CORE)
-- ══════════════════════════════════════

-- Infinite Jump
UIS.JumpRequest:Connect(function()
    if infJump and getHum() then getHum():ChangeState("Jumping") end
end)

-- Spider Mode
RunService.RenderStepped:Connect(function()
    if spiderMode and getRoot() then
        local r = Ray.new(getRoot().Position, getRoot().CFrame.LookVector * 3)
        local part = workspace:FindPartOnRay(r, LocalPlayer.Character)
        if part then getRoot().Velocity = Vector3.new(getRoot().Velocity.X, 30, getRoot().Velocity.Z) end
    end
end)

-- Anti-Fling & Mouvement
RunService.Heartbeat:Connect(function()
    if antiFling and getRoot() then
        local v = getRoot().Velocity
        getRoot().Velocity = Vector3.new(v.X, 0, v.Z)
        getRoot().RotVelocity = Vector3.new(0,0,0)
    end
    if getHum() then 
        getHum().WalkSpeed = walkSpeed
        getHum().JumpPower = jumpPower
    end
end)

Rayfield:Notify({Title = "OMNIPOTENCE V35", Content = "Le monde est à vos pieds, mon cher.", Duration = 6})
