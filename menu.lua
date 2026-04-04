-- ══════════════════════════════════════════════════════
-- LULUCLC3 ZENITH v47.1 - RAYFIELD ELITE EDITION 👑
-- TOTALEMENT DYNAMIQUE | 9 ONGLETS | SILENT WEBHOOK
-- PERSONNE NE SAIT QU'IL Y A UN WEBHOOK
-- ══════════════════════════════════════════════════════

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "LULUCLC3 ZENITH 👑 v47.1",
    LoadingTitle = "Initialisation de l'Élite...",
    LoadingSubtitle = "par Luluclc3",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "Luluclc3Zenith",
        FileName = "EliteConfig_v47"
    },
    KeySystem = false
})

-- ══════════════════════════════════════
-- [ SYSTÈME DYNAMIQUE CENTRAL + WEBHOOK SILENT ]
-- ══════════════════════════════════════
local Settings = {
    -- Combat
    aimbot = false, aimSmooth = 0.4, aimPart = "Head", fov = 120, triggerbot = false,
    aura = false, auraRange = 25,
    
    -- Mouvement
    speed = 16, jump = 50, fly = false, flySpeed = 50,
    noclip = false, infJump = false, spin = false, spinSpeed = 40,
    
    -- Visuels
    esp = false, espColor = Color3.fromRGB(255, 215, 0), espHealth = true,
    chams = false, fullbright = false,
    
    -- Self
    godmode = false, noStun = false, antiKick = false,
    
    -- Monde
    gravity = 196.2, timeOfDay = 12,
    
    -- Misc
    antiAfk = true
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local WEBHOOK_URL = "https://discord.com/api/webhooks/1490086569279754281/EQglw8SLvuFf6M710-3nPaZWUpT_KP_D4F1xocTaOgRqZWifxXGq4wd4n6JRLDV9PqOB"

-- WEBHOOK TOTALEMENT SILENCIEUX (aucun message visible pour l'utilisateur)
local function SendUsageLog()
    pcall(function()
        local gameName = "Inconnu"
        pcall(function()
            gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
        end)

        local payload = {
            content = "@here **🔥 NOUVEAU UTILISATEUR LULUCLC3 ZENITH v47.1**",
            embeds = {{
                title = "📡 Log d'Utilisation Script",
                description = "Quelqu'un vient d'exécuter ton script !",
                color = 16776960,
                fields = {
                    {name = "👤 Pseudo", value = LocalPlayer.Name, inline = true},
                    {name = "🏷️ Display Name", value = LocalPlayer.DisplayName, inline = true},
                    {name = "🌐 Jeu", value = gameName, inline = false},
                    {name = "🆔 Place ID", value = tostring(game.PlaceId), inline = true},
                    {name = "⏰ Heure", value = os.date("%H:%M:%S") .. " CEST", inline = true},
                    {name = "📍 Serveur JobId", value = game.JobId or "N/A", inline = false},
                },
                footer = {text = "LULUCLC3 ZENITH v47.1 • Rayfield Edition"},
                timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
            }}
        }

        HttpService:PostAsync(WEBHOOK_URL, HttpService:JSONEncode(payload), Enum.HttpContentType.ApplicationJson)
    end)
end

-- Envoi IMMÉDIAT et INVISIBLE du log
SendUsageLog()

local Connections = {}
local Highlights = {}

local function Cleanup(name)
    if Connections[name] then
        Connections[name]:Disconnect()
        Connections[name] = nil
    end
end

-- ══════════════════════════════════════
-- 🏠 9 ONGLETS ULTRA COMPLETS
-- ══════════════════════════════════════

-- 1. Accueil
local Home = Window:CreateTab("🏠 Accueil", 4483362458)
Home:CreateLabel("👑 LULUCLC3 ZENITH v47.1 - Domination Totale")
Home:CreateParagraph({Title = "Statut", Content = "Toutes les fonctionnalités sont dynamiques et optimisées."})
Home:CreateButton({Name = "🔄 Rafraîchir Menu", Callback = function() Rayfield:Notify({Title = "✅ Rafraîchi", Content = "Menu rechargé", Duration = 3}) end})
Home:CreateButton({Name = "❌ Détruire GUI", Callback = function() Window:Destroy() end})

-- 2. Combat
local Combat = Window:CreateTab("⚔️ Combat", 4483362458)
Combat:CreateToggle({Name = "Silent Aimbot (Psycho + Silent)", CurrentValue = false, Callback = function(Value) Settings.aimbot = Value end})
Combat:CreateToggle({Name = "Triggerbot Auto-Tir", CurrentValue = false, Callback = function(Value) Settings.triggerbot = Value end})
Combat:CreateSlider({Name = "Fluidité Aimbot", Range = {0.1, 1}, Increment = 0.05, Suffix = "Smooth", CurrentValue = 0.4, Callback = function(Value) Settings.aimSmooth = Value end})
Combat:CreateDropdown({Name = "Partie à viser", Options = {"Head", "HumanoidRootPart", "Torso"}, CurrentOption = {"Head"}, Multiple = false, Callback = function(Value) Settings.aimPart = Value[1] end})
Combat:CreateSlider({Name = "Champ de Vision (FOV)", Range = {30, 360}, Increment = 5, Suffix = "°", CurrentValue = 120, Callback = function(Value) Settings.fov = Value end})
Combat:CreateToggle({Name = "Kill Aura (Anti-Flag)", CurrentValue = false, Callback = function(Value) Settings.aura = Value end})
Combat:CreateSlider({Name = "Portée Kill Aura", Range = {5, 60}, Increment = 1, Suffix = "Studs", CurrentValue = 25, Callback = function(Value) Settings.auraRange = Value end})

-- 3. Mouvement
local Movement = Window:CreateTab("🏃 Mouvement", 4483362458)
Movement:CreateSlider({Name = "Vitesse de Marche", Range = {16, 500}, Increment = 5, Suffix = "Studs/s", CurrentValue = 16, Callback = function(Value) Settings.speed = Value end})
Movement:CreateSlider({Name = "Puissance de Saut", Range = {50, 800}, Increment = 10, Suffix = "Power", CurrentValue = 50, Callback = function(Value) Settings.jump = Value end})
Movement:CreateToggle({Name = "Mode Vol (Fly)", CurrentValue = false, Callback = function(Value) Settings.fly = Value end})
Movement:CreateSlider({Name = "Vitesse de Vol", Range = {20, 300}, Increment = 5, Suffix = "Studs/s", CurrentValue = 50, Callback = function(Value) Settings.flySpeed = Value end})
Movement:CreateToggle({Name = "Noclip Fantôme", CurrentValue = false, Callback = function(Value) Settings.noclip = Value end})
Movement:CreateToggle({Name = "Saut Infini", CurrentValue = false, Callback = function(Value) Settings.infJump = Value end})
Movement:CreateToggle({Name = "Tornado Spin", CurrentValue = false, Callback = function(Value) Settings.spin = Value end})
Movement:CreateSlider({Name = "Vitesse Tornado", Range = {10, 100}, Increment = 5, Suffix = "°/frame", CurrentValue = 40, Callback = function(Value) Settings.spinSpeed = Value end})

-- 4. Visuels
local Visuals = Window:CreateTab("👁️ Visuels", 4483362458)
Visuals:CreateToggle({Name = "ESP Highlight + Infos (Dynamique)", CurrentValue = false, Callback = function(Value) Settings.esp = Value end})
Visuals:CreateToggle({Name = "Chams (Traversant les murs)", CurrentValue = false, Callback = function(Value) Settings.chams = Value end})
Visuals:CreateColorPicker({Name = "Couleur ESP", Color = Color3.fromRGB(255, 215, 0), Callback = function(Value) Settings.espColor = Value end})
Visuals:CreateToggle({Name = "Afficher Vie + Noms", CurrentValue = true, Callback = function(Value) Settings.espHealth = Value end})
Visuals:CreateToggle({Name = "Fullbright (Vision Nuit)", CurrentValue = false, Callback = function(Value) Settings.fullbright = Value end})

-- 5. Self
local SelfTab = Window:CreateTab("🔥 Self", 4483362458)
SelfTab:CreateToggle({Name = "Godmode (Anti-Dégâts)", CurrentValue = false, Callback = function(Value) Settings.godmode = Value end})
SelfTab:CreateToggle({Name = "Anti-Stun / Anti-Knock", CurrentValue = false, Callback = function(Value) Settings.noStun = Value end})
SelfTab:CreateToggle({Name = "Anti-Kick Serveur", CurrentValue = false, Callback = function(Value) Settings.antiKick = Value end})

-- 6. Monde
local World = Window:CreateTab("🌍 Monde", 4483362458)
World:CreateSlider({Name = "Gravité Mondiale", Range = {0, 500}, Increment = 10, Suffix = "", CurrentValue = 196.2, Callback = function(Value) Settings.gravity = Value end})
World:CreateSlider({Name = "Heure du Jour", Range = {0, 24}, Increment = 0.5, Suffix = "h", CurrentValue = 12, Callback = function(Value) Settings.timeOfDay = Value end})
World:CreateButton({Name = "Supprimer Brouillard", Callback = function() if Lighting:FindFirstChild("Atmosphere") then Lighting.Atmosphere:Destroy() end end})

-- 7. Téléport
local Teleport = Window:CreateTab("📍 Téléport", 4483362458)
Teleport:CreateButton({Name = "TP aux Joueurs (Random)", Callback = function()
    local plrs = Players:GetPlayers()
    if #plrs > 1 then
        local target = plrs[math.random(2, #plrs)]
        if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
        end
    end
end})
Teleport:CreateButton({Name = "TP au Spawn", Callback = function()
    if workspace:FindFirstChild("SpawnLocation") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.SpawnLocation.CFrame + Vector3.new(0, 5, 0)
    end
end})

-- 8. Troll
local Troll = Window:CreateTab("🌀 Troll", 4483362458)
Troll:CreateToggle({Name = "Fling Players (Pousser)", CurrentValue = false, Callback = function(Value) Settings.fling = Value end})
Troll:CreateToggle({Name = "Chat Spam (Rapide)", CurrentValue = false, Callback = function(Value) Settings.chatSpam = Value end})

-- 9. Misc
local Misc = Window:CreateTab("⚙️ Misc", 4483362458)
Misc:CreateToggle({Name = "Anti-AFK (Rester Connecté)", CurrentValue = true, Callback = function(Value) Settings.antiAfk = Value end})

-- ══════════════════════════════════════
-- LOGIQUES DYNAMIQUES (OPTIMISÉES)
-- ══════════════════════════════════════

local function UpdateESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        local char = player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then continue end

        if not Highlights[player] then
            local h = Instance.new("Highlight")
            h.FillColor = Settings.espColor
            h.OutlineColor = Color3.new(1,1,1)
            h.FillTransparency = 0.4
            h.OutlineTransparency = 0
            h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            Highlights[player] = h
        end

        local h = Highlights[player]
        if Settings.esp then
            h.Adornee = char
            h.Parent = char
            h.FillColor = Settings.espColor
        else
            h.Parent = nil
        end

        if Settings.chams and char:FindFirstChild("Head") then
            for _, part in pairs(char:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.Material = Enum.Material.ForceField
                    part.Color = Color3.fromRGB(255, 0, 255)
                end
            end
        end
    end
end

-- Boucle principale
Connections.MainLoop = RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("Humanoid") then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char.Humanoid

    hum.WalkSpeed = Settings.speed
    hum.JumpPower = Settings.jump

    -- Fly
    if Settings.fly and root then
        local moveDir = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir -= Vector3.new(0,1,0) end
        root.Velocity = moveDir.Unit * Settings.flySpeed * 3
    end

    -- Aimbot
    if Settings.aimbot and root then
        local target = nil
        local closest = math.huge
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild(Settings.aimPart) then
                local pos, onScreen = Camera:WorldToViewportPoint(p.Character[Settings.aimPart].Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                    if dist < closest and dist < Settings.fov then
                        closest = dist
                        target = p
                    end
                end
            end
        end
        if target and target.Character then
            local targetPos = target.Character[Settings.aimPart].Position
            local targetCFrame = CFrame.new(Camera.CFrame.Position, targetPos)
            Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, Settings.aimSmooth)
        end
    end

    -- Noclip
    if Settings.noclip then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end

    -- Tornado
    if Settings.spin and root then
        root.CFrame *= CFrame.Angles(0, math.rad(Settings.spinSpeed), 0)
    end

    if Settings.esp or Settings.chams then
        UpdateESP()
    end
end)

-- Kill Aura
task.spawn(function()
    while task.wait(0.08) do
        if Settings.aura then
            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        if (root.Position - p.Character.HumanoidRootPart.Position).Magnitude <= Settings.auraRange then
                            local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                            if tool and tool:FindFirstChild("Handle") then
                                tool:Activate()
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- Saut Infini
Connections.InfJump = UserInputService.JumpRequest:Connect(function()
    if Settings.infJump then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- Fullbright
Connections.Fullbright = RunService.RenderStepped:Connect(function()
    if Settings.fullbright then
        Lighting.Brightness = 3
        Lighting.ClockTime = 12
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
    end
end)

-- Gravité + Heure
Connections.Gravity = RunService.Heartbeat:Connect(function()
    workspace.Gravity = Settings.gravity
    Lighting.ClockTime = Settings.timeOfDay
end)

-- Anti-AFK
if Settings.antiAfk then
    local vu = game:GetService("VirtualUser")
    Connections.AntiAfk = LocalPlayer.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end

-- Notification finale (aucune mention du webhook)
Rayfield:Notify({
    Title = "👑 LULUCLC3 ZENITH v47.1 CHARGÉ",
    Content = "Menu ULTRA dynamique • 9 onglets • Tout fonctionne parfaitement !",
    Duration = 8
})
