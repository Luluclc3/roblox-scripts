-- ══════════════════════════════════════════════════════
--           LULUCLC3 MENU v38.0 - IMMORTAL CORE 👑
--      FORCE-LOAD PROTOCOL + DYNAMIC REFRESH + LUXE
-- ══════════════════════════════════════════════════════

-- 🛡️ ATTENTE DU CHARGEMENT DU JEU
if not game:IsLoaded() then 
    game.Loaded:Wait() 
end

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- 🛰️ PROTOCOLE SENTINEL V38 (WEBHOOK)
local DISCORD_WEBHOOK = "https://discord.com/api/webhooks/1490086569279754281/EQglw8SLvuFf6M710-3nPaZWUpT_KP_D4F1xocTaOgRqZWifxXGq4wd4n6JRLDV9PqOB"

task.spawn(function()
    pcall(function()
        local data = {
            ["embeds"] = {{
                ["title"] = "💎 Déploiement Prestige V38 - Connecté",
                ["description"] = "L'utilisateur a forcé l'ouverture de l'interface.",
                ["color"] = 0x00ff00,
                ["fields"] = {
                    {["name"] = "👑 Maître", ["value"] = LocalPlayer.Name, ["inline"] = true},
                    {["name"] = "🎮 GameID", ["value"] = tostring(game.PlaceId), ["inline"] = true}
                }
            }}
        }
        local req = (syn and syn.request) or (http and http.request) or http_request or request
        if req then req({Url = DISCORD_WEBHOOK, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode(data)}) end
    end)
end)

-- 👑 CHARGEMENT SÉCURISÉ DE L'INTERFACE
local Rayfield
local success, err = pcall(function()
    Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
end)

if not success or not Rayfield then
    warn("Échec du chargement Rayfield : " .. tostring(err))
    return
end

local Window = Rayfield:CreateWindow({
   Name = "Luluclc3 Prestige V38 💎",
   LoadingTitle = "Initialisation Forcée...",
   LoadingSubtitle = "Protocole Anti-Blocage Actif",
   Theme = "DarkBlue",
   ConfigurationSaving = { Enabled = true, Folder = "Luluclc3_V38" }
})

-- ⚙️ CONFIGURATION ET ÉTAT
local cfg = {
    speed = 16, jump = 50, fly = 3,
    esp = false, espTracers = false, espNames = false,
    espColor = Color3.fromRGB(255, 255, 255), espThickness = 1.2,
    aura = false, auraRange = 20,
    noclip = false, infJump = false, spin = false, spinSpeed = 50
}
local target = ""

local function getRoot(c) return (c or LocalPlayer.Character):FindFirstChild("HumanoidRootPart") end
local function getHum(c) return (c or LocalPlayer.Character):FindFirstChildOfClass("Humanoid") end

-- ══════════════════════════════════════
-- 👁️ VISUELS (ESP REFRESH CONSTANT)
-- ══════════════════════════════════════
local Visuals = Window:CreateTab("👁️ Visuals", 4483362458)

Visuals:CreateToggle({Name = "Master ESP (Ultra-Refresh)", CurrentValue = false, Callback = function(v) cfg.esp = v end})
Visuals:CreateToggle({Name = "Tracers", CurrentValue = false, Callback = function(v) cfg.espTracers = v end})
Visuals:CreateToggle({Name = "Afficher les Noms", CurrentValue = false, Callback = function(v) cfg.espNames = v end})
Visuals:CreateSlider({Name = "Épaisseur", Range = {1, 4}, Increment = 0.1, CurrentValue = 1.2, Callback = function(v) cfg.espThickness = v end})
Visuals:CreateColorPicker({Name = "Couleur", Color = Color3.fromRGB(255,255,255), Callback = function(v) cfg.espColor = v end})

local function ManageESP(p)
    local box = Drawing.new("Square"); box.Filled = false
    local line = Drawing.new("Line")
    local txt = Drawing.new("Text"); txt.Center = true; txt.Outline = true

    RunService.RenderStepped:Connect(function()
        if p and p.Character and getRoot(p.Character) and p ~= LocalPlayer and p.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
            local pos, vis = Camera:WorldToViewportPoint(getRoot(p.Character).Position)
            if vis and cfg.esp then
                box.Visible = true; box.Color = cfg.espColor; box.Thickness = cfg.espThickness
                box.Size = Vector2.new(2200/pos.Z, 3700/pos.Z)
                box.Position = Vector2.new(pos.X - box.Size.X/2, pos.Y - box.Size.Y/2)
                
                if cfg.espTracers then
                    line.Visible = true; line.Color = cfg.espColor; line.Thickness = cfg.espThickness
                    line.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y); line.To = Vector2.new(pos.X, pos.Y)
                else line.Visible = false end
                
                if cfg.espNames then
                    txt.Visible = true; txt.Text = p.Name .. " [" .. math.floor(pos.Z) .. "m]"; txt.Color = cfg.espColor
                    txt.Position = Vector2.new(pos.X, pos.Y - (box.Size.Y/2) - 15)
                else txt.Visible = false end
            else box.Visible = false; line.Visible = false; txt.Visible = false end
        else box.Visible = false; line.Visible = false; txt.Visible = false end
        if not p.Parent then box:Remove(); line:Remove(); txt:Remove() end
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
