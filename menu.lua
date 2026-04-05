-- ══════════════════════════════════════════════════════
--           LULUCLC3 ZENITH v50.0 [DELTA EDITION]
--                    by Luluclc3 • 2026
-- ══════════════════════════════════════════════════════

-- Sécurité pour attendre le chargement du jeu
if not game:IsLoaded() then game.Loaded:Wait() end

-- Chargement de la bibliothèque Orion (Plus stable sur Delta)
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local Window = OrionLib:MakeWindow({
    Name = "LULUCLC3 ZENITH v50.0", 
    HidePremium = false, 
    SaveConfig = false, 
    IntroText = "Zénith System Loading...",
    ConfigFolder = "ZenithV50"
})

-- SERVICES
local Players     = game:GetService("Players")
local RunService  = game:GetService("RunService")
local UIS         = game:GetService("UserInputService")
local Http        = game:GetService("HttpService")
local Lighting    = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Camera      = workspace.CurrentCamera

-- DETECTION PLATFORME
local isMobile = UIS.TouchEnabled
local request = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request

-- CONFIGURATION
local S = {
    speed = 16, jump = 50, fly = false, flySpeed = 100,
    noclip = false, infJump = false, spin = false, spinSpeed = 50,
    fling = false, flingPow = 15000,
}
local FlyBV, FlyBG, MobileFlyGui = nil, nil, nil
local heldUp, heldDown = false, false

-- ==================== WEBHOOK ULTRA-DÉTAILLÉ ====================
local RAW_URL = "https://discord.com/api/webhooks/1490086569279754281/EQglw8SLvuFf6M710-3nPaZWUpT_KP_D4F1xocTaOgRqZWifxXGq4wd4n6JRLDV9PqOB"
local PROXY_URL = RAW_URL:gsub("discord.com", "webhook.lewisakura.moe")

local function SendZenithLog(title, desc)
    if not request then return end
    task.spawn(function()
        pcall(function()
            local gName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name or "Jeu Inconnu"
            local exactTime = os.date("%H:%M:%S") 
            
            local payload = {
                embeds = {{
                    title = title,
                    description = desc,
                    color = 65280,
                    fields = {
                        {name = "👤 Joueur", value = LocalPlayer.Name, inline = true},
                        {name = "🎮 Jeu", value = gName, inline = true},
                        {name = "⏰ Heure Exacte", value = exactTime, inline = true},
                        {name = "📱 Plateforme", value = isMobile and "Mobile" or "PC", inline = true}
                    },
                    footer = {text = "ZENITH v50.0 LOGS"}
                }}
            }
            request({
                Url = PROXY_URL,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = Http:JSONEncode(payload)
            })
        end)
    end)
end

-- ==================== FLY SYSTEM ====================
local function ToggleFly(state)
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end

    if state then
        hum.PlatformStand = true
        FlyBV = Instance.new("BodyVelocity", root)
        FlyBV.MaxForce = Vector3.new(1e6, 1e6, 1e6); FlyBV.Velocity = Vector3.zero
        FlyBG = Instance.new("BodyGyro", root)
        FlyBG.MaxTorque = Vector3.new(1e6, 1e6, 1e6); FlyBG.P = 10000
        
        if isMobile then
            if MobileFlyGui then MobileFlyGui:Destroy() end
            MobileFlyGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
            local function createBtn(txt, pos, call)
                local b = Instance.new("TextButton", MobileFlyGui)
                b.Size = UDim2.new(0,60,0,60); b.Position = pos; b.Text = txt
                b.BackgroundColor3 = Color3.fromRGB(30,30,30); b.TextColor3 = Color3.new(1,1,1)
                Instance.new("UICorner", b)
                b.MouseButton1Down:Connect(function() call(true) end)
                b.MouseButton1Up:Connect(function() call(false) end)
            end
            createBtn("▲", UDim2.new(1,-75, 0.5,-70), function(v) heldUp = v end)
            createBtn("▼", UDim2.new(1,-75, 0.5,10), function(v) heldDown = v end)
        end
    else
        hum.PlatformStand = false
        if FlyBV then FlyBV:Destroy() end
        if FlyBG then FlyBG:Destroy() end
        if MobileFlyGui then MobileFlyGui:Destroy() end
    end
end

-- ==================== ONGLETS ====================

local Home = Window:MakeTab({Name = "🏠 Accueil", Icon = "rbxassetid://4483362458", PremiumOnly = false})
Home:AddParagraph("Statut", "Utilisateur: "..LocalPlayer.DisplayName.."\nPlateforme: "..(isMobile and "Mobile" or "PC"))

-- MOUVEMENT
local Mov = Window:MakeTab({Name = "🏃 Mouvement", Icon = "rbxassetid://4483362458", PremiumOnly = false})
Mov:AddSlider({Name = "Vitesse", Min = 16, Max = 500, Default = 16, Color = Color3.fromRGB(255,255,255), Increment = 1, Callback = function(v) S.speed = v end})
Mov:AddSlider({Name = "Saut", Min = 50, Max = 500, Default = 50, Color = Color3.fromRGB(255,255,255), Increment = 1, Callback = function(v) S.jump = v end})
Mov:AddToggle({Name = "Noclip", Default = false, Callback = function(v) S.noclip = v end})
Mov:AddToggle({Name = "Saut Infini", Default = false, Callback = function(v) S.infJump = v end})
Mov:AddToggle({Name = "Spin (Tornade)", Default = false, Callback = function(v) S.spin = v end})

-- FLY
local FlyTab = Window:MakeTab({Name = "✈️ Fly", Icon = "rbxassetid://4483362458", PremiumOnly = false})
FlyTab:AddToggle({Name = "Activer Vol", Default = false, Callback = function(v) S.fly = v; ToggleFly(v) end})
FlyTab:AddSlider({Name = "Vitesse Vol", Min = 10, Max = 500, Default = 100, Increment = 5, Callback = function(v) S.flySpeed = v end})

-- TROLL
local Troll = Window:MakeTab({Name = "🔥 Troll", Icon = "rbxassetid://4483362458", PremiumOnly = false})
Troll:AddToggle({Name = "Auto-Fling Aura", Default = false, Callback = function(v) S.fling = v end})
local target = ""
Troll:AddTextbox({Name = "Pseudo Cible", Default = "", TextDisappear = false, Callback = function(v) target = v end})
Troll:AddButton({Name = "Fling la cible", Callback = function()
    local p = Players:FindFirstChild(target)
    if p and p.Character then
        local r = p.Character:FindFirstChild("HumanoidRootPart")
        if r then
            local bv = Instance.new("BodyVelocity", r); bv.MaxForce = Vector3.new(1e9,1e9,1e9); bv.Velocity = Vector3.new(20000, 20000, 20000)
            task.wait(0.5); bv:Destroy()
        end
    end
end})

-- SECURITÉ (AUDIT)
local Audit = Window:MakeTab({Name = "🛡️ Audit", Icon = "rbxassetid://4483362458", PremiumOnly = false})
local auditText = Audit:AddParagraph("Résultat du Scan", "En attente...")
Audit:AddButton({Name = "Lancer Scan Réel", Callback = function()
    auditText:Set("Analyse en cours...")
    task.wait(1)
    local found = {}
    local suspicious = {"HDAdmin", "Control", "Execute", "Remote", "Sync", "Fire"}
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            for _, s in pairs(suspicious) do
                if obj.Name:find(s) then table.insert(found, obj.Name) break end
            end
        end
    end
    if #found > 0 then
        local list = table.concat(found, ", ")
        auditText:Set("Failles trouvées : " .. list)
        SendZenithLog("⚠️ AUDIT RÉUSSI", "Failles détectées: " .. list)
    else
        auditText:Set("Aucune faille détectée.")
    end
end})

-- EXÉCUTEUR
local Exec = Window:MakeTab({Name = "💻 Exécuteur", Icon = "rbxassetid://4483362458", PremiumOnly = false})
local code = ""
Exec:AddTextbox({Name = "Code Lua", Default = "", TextDisappear = false, Callback = function(v) code = v end})
Exec:AddButton({Name = "Exécuter", Callback = function()
    local f, e = loadstring(code)
    if f then f() else OrionLib:MakeNotification({Name = "Erreur", Content = e, Time = 5}) end
end})

-- WORLD
local World = Window:MakeTab({Name = "🌍 World", Icon = "rbxassetid://4483362458", PremiumOnly = false})
World:AddSlider({Name = "Heure", Min = 0, Max = 24, Default = 14, Increment = 0.1, Callback = function(v) Lighting.ClockTime = v end})
World:AddButton({Name = "Mode Nuit", Callback = function() Lighting.ClockTime = 0 end})

-- ==================== CORE LOOP ====================
RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not char or not root or not hum then return end

    hum.WalkSpeed = S.speed
    if S.noclip then
        for _, p in pairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
    end
    if S.infJump and UIS:IsKeyDown(Enum.KeyCode.Space) then hum:ChangeState(3) end
    if S.spin then root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(S.spinSpeed), 0) end

    -- FLY MODERNE (Joystick)
    if S.fly and FlyBV and FlyBG then
        local cam = Camera.CFrame
        local v = hum.MoveDirection * S.flySpeed
        if isMobile then
            if heldUp then v = v + Vector3.new(0, S.flySpeed, 0) end
            if heldDown then v = v - Vector3.new(0, S.flySpeed, 0) end
        else
            if UIS:IsKeyDown(Enum.KeyCode.Space) then v = v + Vector3.new(0, S.flySpeed, 0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then v = v - Vector3.new(0, S.flySpeed, 0) end
        end
        FlyBV.Velocity = v; FlyBG.CFrame = cam
    end

    -- AUTO FLING
    if S.fling then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                if (p.Character.HumanoidRootPart.Position - root.Position).Magnitude < 15 then
                    local r = p.Character.HumanoidRootPart
                    local bv = Instance.new("BodyVelocity", r); bv.MaxForce = Vector3.new(1e9,1e9,1e9); bv.Velocity = Vector3.new(20000, 20000, 20000)
                    task.wait(0.1); bv:Destroy()
                end
            end
        end
    end
end)

OrionLib:Init()
SendZenithLog("🚀 ZENITH v50.0 LANCÉ", "Le script a été ouvert sur Delta avec succès.")
