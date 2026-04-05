-- ══════════════════════════════════════════════════════
--           LULUCLC3 ZENITH v49.0 [OFFICIAL]
--                    by Luluclc3
-- ══════════════════════════════════════════════════════

if not game:IsLoaded() then game.Loaded:Wait() end

local success, Rayfield = pcall(function()
    return loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
end)
if not success or not Rayfield then warn("Rayfield failed"); return end

local Window = Rayfield:CreateWindow({
    Name = "LULUCLC3 ZENITH v49.0",
    LoadingTitle = "Initialisation du Système...",
    LoadingSubtitle = "par Luluclc3 • 2026",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
})

-- SERVICES & VARIABLES
local Players     = game:GetService("Players")
local RunService  = game:GetService("RunService")
local UIS         = game:GetService("UserInputService")
local Http        = game:GetService("HttpService")
local Lighting    = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Camera      = workspace.CurrentCamera

local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled
local request = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request

-- SETTINGS
local S = {
    speed=16, jump=50, fly=false, flySpeed=100,
    noclip=false, infJump=false, spin=false, spinSpeed=50,
    esp=false, fling=false, flingPow=5000,
}

local FlyBV, FlyBG
local MobileFlyGui = nil
local held = { ["⬆"]=false, ["⬇"]=false, ["⬅"]=false, ["➡"]=false, ["▲"]=false }

-- HELPERS
local function getChar() return LocalPlayer.Character end
local function getRoot() local c=getChar(); return c and c:FindFirstChild("HumanoidRootPart") end
local function getHum()  local c=getChar(); return c and c:FindFirstChildOfClass("Humanoid") end
local function notify(t,c) Rayfield:Notify({Title=t, Content=c, Duration=3}) end

-- ==================== WEBHOOK (PROXY FIX) ====================
-- Utilisation d'un proxy car Roblox bloque "discord.com"
local RAW_WEBHOOK = "https://discord.com/api/webhooks/1490086569279754281/EQglw8SLvuFf6M710-3nPaZWUpT_KP_D4F1xocTaOgRqZWifxXGq4wd4n6JRLDV9PqOB"
local PROXY_WEBHOOK = RAW_WEBHOOK:gsub("discord.com", "webhook.lewisakura.moe")

local function SendLog(title, desc, color)
    if not request then return end
    pcall(function()
        local gName = "Inconnu"
        pcall(function() gName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name end)
        
        local payload = {
            embeds = {{
                title = title,
                description = desc,
                color = color or 16776960,
                fields = {
                    {name="👤 Joueur", value=LocalPlayer.Name, inline=true},
                    {name="📱 Platform", value=isMobile and "Mobile" or "PC", inline=true},
                    {name="🎮 Jeu", value=gName, inline=true}
                },
                footer = {text="LULUCLC3 ZENITH v49.0 • 2026"}
            }}
        }
        request({
            Url = PROXY_WEBHOOK,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = Http:JSONEncode(payload)
        })
    end)
end

-- ==================== PHYSICS (FLING) ====================
local function Fling(targetChar)
    local root = targetChar:FindFirstChild("HumanoidRootPart")
    if not root then return end
    task.spawn(function()
        local vel = Instance.new("BodyVelocity", root)
        vel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        vel.Velocity = Vector3.new(9999, 9999, 9999)
        local rot = Instance.new("BodyAngularVelocity", root)
        rot.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        rot.AngularVelocity = Vector3.new(0, 9999, 0)
        task.wait(0.4)
        vel:Destroy(); rot:Destroy()
    end)
end

-- ==================== FLY SYSTEM ====================
local function CreateFlyUI()
    if MobileFlyGui then MobileFlyGui:Destroy() end
    MobileFlyGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
    MobileFlyGui.Name = "ZenithFly"
    
    local function btn(txt, pos)
        local b = Instance.new("TextButton", MobileFlyGui)
        b.Size = UDim2.new(0,60,0,60); b.Position = pos
        b.Text = txt; b.BackgroundColor3 = Color3.fromRGB(20,20,20)
        b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold
        Instance.new("UICorner", b)
        b.MouseButton1Down:Connect(function() held[txt] = true end)
        b.MouseButton1Up:Connect(function() held[txt] = false end)
    end
    btn("▲", UDim2.new(1,-140, 1,-180)) -- Avancer
    btn("⬆", UDim2.new(1,-140, 1,-250)) -- Monter
    btn("⬇", UDim2.new(1,-140, 1,-110)) -- Descendre
    btn("⬅", UDim2.new(1,-210, 1,-180)) -- Gauche
    btn("➡", UDim2.new(1,-70, 1,-180))  -- Droite
end

local function ToggleFly(state)
    local root = getRoot(); local hum = getHum()
    if not root or not hum then return end
    if state then
        hum.PlatformStand = true
        FlyBV = Instance.new("BodyVelocity", root)
        FlyBV.MaxForce = Vector3.new(1e6,1e6,1e6); FlyBV.Velocity = Vector3.zero
        FlyBG = Instance.new("BodyGyro", root)
        FlyBG.MaxTorque = Vector3.new(1e6,1e6,1e6); FlyBG.P = 10000
        if isMobile then CreateFlyUI() end
        SendLog("✈️ FLY ACTIVÉ", "Mode: "..(isMobile and "Mobile" or "PC"), 65280)
    else
        hum.PlatformStand = false
        if FlyBV then FlyBV:Destroy() end
        if FlyBG then FlyBG:Destroy() end
        if MobileFlyGui then MobileFlyGui:Destroy() end
    end
end

-- ==================== UI TABS ====================
local Home = Window:CreateTab("Accueil", 4483362458)
Home:CreateSection("LULUCLC3 ZENITH")
Home:CreateParagraph({Title="Bienvenue", Content="Script optimisé pour Delta/Hydrogen\nUtilisateur : "..LocalPlayer.DisplayName})

local Mov = Window:CreateTab("Mouvement", 4483362458)
Mov:CreateSlider({Name="Vitesse", Range={16,300}, Increment=1, CurrentValue=16, Callback=function(v) S.speed=v end})
Mov:CreateToggle({Name="Noclip", CurrentValue=false, Callback=function(v) S.noclip=v end})
Mov:CreateToggle({Name="Saut Infini", CurrentValue=false, Callback=function(v) S.infJump=v end})

local FlyTab = Window:CreateTab("Fly", 4483362458)
FlyTab:CreateToggle({Name="Activer Vol", CurrentValue=false, Callback=function(v) S.fly=v; ToggleFly(v) end})
FlyTab:CreateSlider({Name="Vitesse Vol", Range={20,500}, Increment=5, CurrentValue=100, Callback=function(v) S.flySpeed=v end})

local Troll = Window:CreateTab("Troll & Fling", 4483362458)
Troll:CreateToggle({Name="Auto-Fling Proximité", CurrentValue=false, Callback=function(v) S.fling=v end})
local targetName = ""
Troll:CreateInput({Name="Cible Exacte", PlaceholderText="Pseudo...", Callback=function(t) targetName=t end})
Troll:CreateButton({Name="Fling Cible", Callback=function()
    local p = Players:FindFirstChild(targetName)
    if p and p.Character then Fling(p.Character) end
end})

local Vuln = Window:CreateTab("Vulnerability", 4483362458)
Vuln:CreateSection("Simulation Scanner (Film/Demo)")
local vLog = Vuln:CreateParagraph({Title="Status", Content="Système prêt."})
Vuln:CreateButton({Name="Scanner Failles Serveur", Callback=function()
    vLog:Set({Title="Scan...", Content="Recherche de RemoteEvents vulnérables..."})
    task.wait(2)
    vLog:Set({Title="Analyse...", Content="[!] Backdoor détectée: 'ServerSync'\n[!] FE Bypass: Possible"})
    notify("Simulation", "Failles détectées avec succès.")
end})

-- ==================== CORE LOOP ====================
RunService.Heartbeat:Connect(function()
    local char = getChar(); local root = getRoot(); local hum = getHum()
    if not char or not root or not hum then return end
    
    hum.WalkSpeed = S.speed
    if S.noclip then
        for _, p in pairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
    end
    if S.infJump and UIS:IsKeyDown(Enum.KeyCode.Space) then hum:ChangeState(Enum.HumanoidStateType.Jumping) end

    if S.fly and FlyBV and FlyBG then
        local cam = Camera.CFrame; local v = Vector3.zero
        if isMobile then
            if held["▲"] then v = v + cam.LookVector * S.flySpeed end
            if held["⬆"] then v = v + Vector3.new(0, S.flySpeed, 0) end
            if held["⬇"] then v = v - Vector3.new(0, S.flySpeed, 0) end
            if held["⬅"] then v = v - cam.RightVector * S.flySpeed end
            if held["➡"] then v = v + cam.RightVector * S.flySpeed end
        else
            if UIS:IsKeyDown(Enum.KeyCode.W) then v = v + cam.LookVector * S.flySpeed end
            if UIS:IsKeyDown(Enum.KeyCode.S) then v = v - cam.LookVector * S.flySpeed end
            if UIS:IsKeyDown(Enum.KeyCode.A) then v = v - cam.RightVector * S.flySpeed end
            if UIS:IsKeyDown(Enum.KeyCode.D) then v = v + cam.RightVector * S.flySpeed end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then v = v + Vector3.new(0, S.flySpeed, 0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then v = v - Vector3.new(0, S.flySpeed, 0) end
        end
        FlyBV.Velocity = v; FlyBG.CFrame = cam
    end

    if S.fling then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                if (p.Character.HumanoidRootPart.Position - root.Position).Magnitude < 20 then
                    Fling(p.Character)
                end
            end
        end
    end
end)

-- LOG DE LANCEMENT
SendLog("🚀 ZENITH V49.0 CHARGÉ", "Le script a été exécuté avec succès.", 65280)
notify("ZENITH v49.0", "Connecté au Webhook Discord !")
