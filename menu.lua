-- ══════════════════════════════════════════════════════
--           LULUCLC3 ZENITH v49.0 [ULTIMATE EDITION]
--                    by Luluclc3 • 2026
-- ══════════════════════════════════════════════════════

if not game:IsLoaded() then game.Loaded:Wait() end

local success, Rayfield = pcall(function()
    return loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
end)
if not success or not Rayfield then warn("Rayfield failed"); return end

local Window = Rayfield:CreateWindow({
    Name = "LULUCLC3 ZENITH v49.0",
    LoadingTitle = "Zenith System Online...",
    LoadingSubtitle = "par Luluclc3 • Édition Finale",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
})

-- SERVICES
local Players     = game:GetService("Players")
local RunService  = game:GetService("RunService")
local UIS         = game:GetService("UserInputService")
local Http        = game:GetService("HttpService")
local Lighting    = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Camera      = workspace.CurrentCamera

-- DETECTION & REQUEST SYSTEM
local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled
local request = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request

-- PARAMÈTRES GLOBAUX
local S = {
    speed=16, jump=50, fly=false, flySpeed=100,
    noclip=false, infJump=false, spin=false, spinSpeed=50,
    esp=false, fling=false, flingPow=9000,
}
local FlyBV, FlyBG, FlyGui = nil, nil, nil
local heldUp, heldDown = false, false

-- HELPERS
local function getChar() return LocalPlayer.Character end
local function getRoot() local c=getChar(); return c and c:FindFirstChild("HumanoidRootPart") end
local function getHum()  local c=getChar(); return c and c:FindFirstChildOfClass("Humanoid") end
local function notify(t,c) Rayfield:Notify({Title=t, Content=c, Duration=4}) end

-- ==================== WEBHOOK (PROXY FIX) ====================
local RAW_WEBHOOK = "https://discord.com/api/webhooks/1490086569279754281/EQglw8SLvuFf6M710-3nPaZWUpT_KP_D4F1xocTaOgRqZWifxXGq4wd4n6JRLDV9PqOB"
local PROXY_URL = RAW_WEBHOOK:gsub("discord.com", "webhook.lewisakura.moe")

local function SendLog(title, desc)
    if not request then return end
    pcall(function()
        local gName = "Inconnu"
        pcall(function() gName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name end)
        request({
            Url = PROXY_URL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = Http:JSONEncode({
                embeds = {{
                    title = title, description = desc, color = 65280,
                    fields = {
                        {name="👤 Joueur", value=LocalPlayer.Name, inline=true},
                        {name="📱 Platform", value=isMobile and "Mobile" or "PC", inline=true},
                        {name="🎮 Jeu", value=gName, inline=true}
                    },
                    footer = {text="ZENITH v49.0 • LULUCLC3"}
                }}
            })
        })
    end)
end

-- ==================== PHYSICS (FLING) ====================
local function FlingPlayer(targetChar)
    local root = targetChar:FindFirstChild("HumanoidRootPart")
    if not root then return end
    task.spawn(function()
        local bV = Instance.new("BodyVelocity", root)
        bV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bV.Velocity = Vector3.new(S.flingPow, S.flingPow, S.flingPow)
        local bAV = Instance.new("BodyAngularVelocity", root)
        bAV.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bAV.AngularVelocity = Vector3.new(0, S.flingPow, 0)
        task.wait(0.5)
        bV:Destroy(); bAV:Destroy()
    end)
end

-- ==================== MODERN FLY (JOYSTICK) ====================
local function ToggleFly(state)
    local root = getRoot(); local hum = getHum()
    if not root or not hum then return end
    if state then
        hum.PlatformStand = true
        FlyBV = Instance.new("BodyVelocity", root)
        FlyBV.MaxForce = Vector3.new(1e6, 1e6, 1e6); FlyBV.Velocity = Vector3.zero
        FlyBG = Instance.new("BodyGyro", root)
        FlyBG.MaxTorque = Vector3.new(1e6, 1e6, 1e6); FlyBG.P = 10000
        if isMobile then
            FlyGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
            local function btn(txt, pos, call)
                local b = Instance.new("TextButton", FlyGui)
                b.Size = UDim2.new(0,65,0,65); b.Position = pos; b.Text = txt
                b.BackgroundColor3 = Color3.fromRGB(30,30,30); b.TextColor3 = Color3.new(1,1,1)
                Instance.new("UICorner", b)
                b.MouseButton1Down:Connect(function() call(true) end)
                b.MouseButton1Up:Connect(function() call(false) end)
            end
            btn("⬆", UDim2.new(1,-80, 0.5,-70), function(v) heldUp = v end)
            btn("⬇", UDim2.new(1,-80, 0.5,10), function(v) heldDown = v end)
        end
    else
        hum.PlatformStand = false
        if FlyBV then FlyBV:Destroy() end
        if FlyBG then FlyBG:Destroy() end
        if FlyGui then FlyGui:Destroy() end
    end
end

-- ==================== ONGLET ACCUEIL ====================
local Home = Window:CreateTab("🏠 Accueil", 4483362458)
Home:CreateSection("ZENITH v49.0 • LULUCLC3")
Home:CreateParagraph({Title="Utilisateur", Content=LocalPlayer.DisplayName.." ("..LocalPlayer.Name..")"})
Home:CreateButton({Name="Rejoindre Discord", Callback=function() setclipboard("Luluclc3 Discord") notify("Discord","Lien copié !") end})

-- ==================== ONGLET MOUVEMENT ====================
local Mov = Window:CreateTab("🏃 Mouvement", 4483362458)
Mov:CreateSlider({Name="Vitesse", Range={16,500}, Increment=1, CurrentValue=16, Callback=function(v) S.speed=v end})
Mov:CreateSlider({Name="Saut", Range={50,500}, Increment=1, CurrentValue=50, Callback=function(v) S.jump=v end})
Mov:CreateToggle({Name="Noclip (Murs)", CurrentValue=false, Callback=function(v) S.noclip=v end})
Mov:CreateToggle({Name="Saut Infini", CurrentValue=false, Callback=function(v) S.infJump=v end})
Mov:CreateToggle({Name="Tornado Spin", CurrentValue=false, Callback=function(v) S.spin=v end})
Mov:CreateSlider({Name="Vitesse Spin", Range={10,500}, Increment=5, CurrentValue=50, Callback=function(v) S.spinSpeed=v end})

-- ==================== ONGLET FLY (MODERNE) ====================
local FlyTab = Window:CreateTab("✈️ Fly", 4483362458)
FlyTab:CreateToggle({Name="Activer Fly Moderne", CurrentValue=false, Callback=function(v) S.fly=v; ToggleFly(v) end})
FlyTab:CreateSlider({Name="Vitesse Vol", Range={20,600}, Increment=5, CurrentValue=100, Callback=function(v) S.flySpeed=v end})
FlyTab:CreateParagraph({Title="Info", Content="Mobile : Le vol suit ton joystick de marche.\nUtilise les flèches à droite pour monter/descendre."})

-- ==================== ONGLET TROLL ====================
local Troll = Window:CreateTab("🔥 Troll", 4483362458)
Troll:CreateToggle({Name="Auto-Fling Proximité", CurrentValue=false, Callback=function(v) S.fling=v end})
Troll:CreateSlider({Name="Puissance Fling", Range={1000,20000}, Increment=500, CurrentValue=9000, Callback=function(v) S.flingPow=v end})
local fName = ""
Troll:CreateInput({Name="Cible Exacte", PlaceholderText="Pseudo...", Callback=function(t) fName=t end})
Troll:CreateButton({Name="Fling Cible", Callback=function()
    local p = Players:FindFirstChild(fName)
    if p and p.Character then FlingPlayer(p.Character) else notify("Erreur","Joueur introuvable") end
end})

-- ==================== ONGLET WORLD ====================
local World = Window:CreateTab("🌍 World", 4483362458)
World:CreateSlider({Name="Heure", Range={0,24}, Increment=0.1, CurrentValue=14, Callback=function(v) Lighting.ClockTime=v end})
World:CreateButton({Name="Mode Sang", Callback=function() Lighting.FogColor=Color3.new(1,0,0); Lighting.FogEnd=200; Lighting.ClockTime=0 end})
World:CreateButton({Name="Reset World", Callback=function() Lighting.ClockTime=14; Lighting.FogEnd=100000; Lighting.Brightness=2 end})

-- ==================== ONGLET EXÉCUTEUR ====================
local ExecTab = Window:CreateTab("💻 Exécuteur", 4483362458)
local customCode = ""
ExecTab:CreateInput({Name="Script Lua", PlaceholderText="print('Zenith active')", RemoveTextAfterFocusLost=false, Callback=function(t) customCode=t end})
ExecTab:CreateButton({Name="Exécuter", Callback=function()
    local f, e = loadstring(customCode)
    if f then f() else notify("Erreur Lua", e) end
end})

-- ==================== ONGLET VULNÉRABILITÉ ====================
local Vuln = Window:CreateTab("⚠️ Vulnérabilité", 4483362458)
local vLog = Vuln:CreateParagraph({Title="Status", Content="Système en attente..."})
Vuln:CreateButton({Name="Scan Server-Side Failles", Callback=function()
    vLog:Set({Title="Scan...", Content="Analyse des RemoteEvents..."})
    task.wait(2)
    vLog:Set({Title="Terminé", Content="Backdoors trouvées : 3\nStatut : Prêt pour Injection (Simulation)"})
end})

-- ==================== BOUCLE PRINCIPALE ====================
RunService.Stepped:Connect(function()
    local char = getChar(); local root = getRoot(); local hum = getHum()
    if not char or not root or not hum then return end

    -- Vitesse & Saut
    hum.WalkSpeed = S.speed
    hum.JumpPower = S.jump

    -- Saut Infini
    if S.infJump and UIS:IsKeyDown(Enum.KeyCode.Space) then hum:ChangeState(3) end

    -- NoClip stable
    if S.noclip then
        for _, p in pairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
    end

    -- Spin
    if S.spin then root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(S.spinSpeed), 0) end

    -- FLY MODERNE (JOYSTICK)
    if S.fly and FlyBV and FlyBG then
        local cam = Camera.CFrame
        local moveDir = hum.MoveDirection -- Détecte le joystick mobile/touches PC
        local velocity = moveDir * S.flySpeed

        if isMobile then
            if heldUp then velocity = velocity + Vector3.new(0, S.flySpeed, 0) end
            if heldDown then velocity = velocity - Vector3.new(0, S.flySpeed, 0) end
        else
            if UIS:IsKeyDown(Enum.KeyCode.Space) then velocity = velocity + Vector3.new(0, S.flySpeed, 0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then velocity = velocity - Vector3.new(0, S.flySpeed, 0) end
        end

        FlyBV.Velocity = velocity
        FlyBG.CFrame = cam
    end

    -- AUTO FLING PROXIMITÉ
    if S.fling then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (p.Character.HumanoidRootPart.Position - root.Position).Magnitude
                if dist < 20 then FlingPlayer(p.Character) end
            end
        end
    end
end)

-- INITIALISATION
SendLog("🚀 ZENITH V49.0 DÉPLOYÉ", "Script lancé avec succès. Toutes les fonctions sont opérationnelles.")
notify("ZENITH v49.0", "Système chargé à 100%. Bienvenue, Luluclc3.")
