-- ══════════════════════════════════════════════════════
--           LULUCLC3 ZENITH v49.0
--                    by Luluclc3
-- ══════════════════════════════════════════════════════

if not game:IsLoaded() then game.Loaded:Wait() end

local success, Rayfield = pcall(function()
    return loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
end)
if not success or not Rayfield then warn("Rayfield failed"); return end

local Window = Rayfield:CreateWindow({
    Name = "LULUCLC3 ZENITH v49.0",
    LoadingTitle = "Chargement...",
    LoadingSubtitle = "par Luluclc3 • 2026",
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

-- DETECTION AUTOMATIQUE PC / MOBILE
local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled
print(isMobile and "📱 Mode Mobile détecté" or "💻 Mode PC détecté")

-- HELPERS
local function getChar() return LocalPlayer.Character end
local function getRoot() local c=getChar(); return c and c:FindFirstChild("HumanoidRootPart") end
local function getHum()  local c=getChar(); return c and c:FindFirstChildOfClass("Humanoid") end
local function notify(t,c) Rayfield:Notify({Title=t,Content=c,Duration=3}) end

-- SETTINGS
local S = {
    speed=16, jump=50, fly=false, flySpeed=100,
    noclip=false, infJump=false, spin=false, spinSpeed=50,
    esp=false, fling=false, flingPow=200,
}

-- ==================== WEBHOOK ====================
local WEBHOOK = "https://discord.com/api/webhooks/1490086569279754281/EQglw8SLvuFf6M710-3nPaZWUpT_KP_D4F1xocTaOgRqZWifxXGq4wd4n6JRLDV9PqOB"

local function SendWebhook(title, description, color)
    pcall(function()
        local gameName = "Inconnu"
        pcall(function()
            gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
        end)
        local payload = {
            embeds = {{
                title = title,
                description = description,
                color = color or 16776960,
                fields = {
                    {name="👤 Joueur",   value=LocalPlayer.Name,                          inline=true},
                    {name="📱 Platform", value=isMobile and "Mobile" or "PC",             inline=true},
                    {name="🎮 Jeu",      value=gameName,                                  inline=true},
                    {name="🆔 PlaceID",  value=tostring(game.PlaceId),                    inline=true},
                    {name="⏰ Heure",    value=os.date("%H:%M:%S"),                       inline=true},
                },
                footer = {text="LULUCLC3 ZENITH v49.0"}
            }}
        }
        Http:PostAsync(WEBHOOK, Http:JSONEncode(payload), Enum.HttpContentType.ApplicationJson)
    end)
end

-- Log au lancement
SendWebhook("🚀 SCRIPT LANCÉ", "Zenith v49.0 chargé avec succès !", 65280)

-- ==================== FLY ====================
local FlyBV, FlyBG
local MobileFlyGui = nil

local function RemoveFlyMobileUI()
    if MobileFlyGui then MobileFlyGui:Destroy(); MobileFlyGui = nil end
end

local function CreateFlyMobileUI()
    RemoveFlyMobileUI()
    MobileFlyGui = Instance.new("ScreenGui")
    MobileFlyGui.Name = "FlyMobile"
    MobileFlyGui.ResetOnSpawn = false
    MobileFlyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    MobileFlyGui.Parent = LocalPlayer.PlayerGui

    local held = {}

    local function makeBtn(label, pos, color)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 75, 0, 75)
        b.Position = pos
        b.BackgroundColor3 = color or Color3.fromRGB(30,30,30)
        b.BackgroundTransparency = 0.15
        b.TextColor3 = Color3.new(1,1,1)
        b.Text = label
        b.Font = Enum.Font.GothamBold
        b.TextSize = 14
        b.ZIndex = 20
        local corner = Instance.new("UICorner", b)
        corner.CornerRadius = UDim.new(0, 14)
        local stroke = Instance.new("UIStroke", b)
        stroke.Color = Color3.fromRGB(255,255,255)
        stroke.Thickness = 1
        stroke.Transparency = 0.7
        b.Parent = MobileFlyGui
        held[label] = false
        b.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.Touch then held[label] = true end
        end)
        b.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.Touch then held[label] = false end
        end)
        return b
    end

    -- Boutons positionnés côté droit de l'écran
    makeBtn("⬆",  UDim2.new(1,-170,1,-260), Color3.fromRGB(0,120,255))   -- Monter
    makeBtn("⬇",  UDim2.new(1,-170,1,-175), Color3.fromRGB(0,80,200))    -- Descendre
    makeBtn("⬅",  UDim2.new(1,-260,1,-175), Color3.fromRGB(80,80,80))    -- Gauche
    makeBtn("➡",  UDim2.new(1,-80,1,-175),  Color3.fromRGB(80,80,80))    -- Droite
    makeBtn("▲",  UDim2.new(1,-170,1,-175), Color3.fromRGB(0,180,0))     -- Avancer (centre)
    -- Label info
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0,200,0,30)
    lbl.Position = UDim2.new(1,-210,1,-300)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.new(1,1,1)
    lbl.Text = "FLY MOBILE ACTIF"
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 13
    lbl.ZIndex = 20
    lbl.Parent = MobileFlyGui

    -- Boucle fly mobile (utilise joystick Roblox + boutons haut/bas)
    task.spawn(function()
        while S.fly and MobileFlyGui do
            task.wait()
            local r = getRoot()
            local h = getHum()
            if not r or not FlyBV then break end
            local cam = Camera.CFrame
            local vel = Vector3.zero

            -- Direction du joystick Roblox (move direction)
            if h and h.MoveDirection.Magnitude > 0 then
                vel = vel + h.MoveDirection.Unit * S.flySpeed
            end

            -- Boutons haut/bas
            if held["⬆"] then vel = vel + Vector3.new(0, S.flySpeed, 0) end
            if held["⬇"] then vel = vel - Vector3.new(0, S.flySpeed, 0) end

            FlyBV.Velocity = vel
            FlyBG.CFrame = cam
        end
    end)

    return held
end

local function ToggleFly(state)
    local char = getChar()
    local root = getRoot()
    local hum  = getHum()
    if not char or not root or not hum then return end

    if state then
        hum.PlatformStand = true

        FlyBV = Instance.new("BodyVelocity")
        FlyBV.MaxForce = Vector3.new(1e6,1e6,1e6)
        FlyBV.Velocity = Vector3.zero
        FlyBV.Parent = root

        FlyBG = Instance.new("BodyGyro")
        FlyBG.MaxTorque = Vector3.new(1e6,1e6,1e6)
        FlyBG.P = 3000
        FlyBG.Parent = root

        if isMobile then
            CreateFlyMobileUI()
            notify("Fly Mobile ✈️", "Joystick = direction\n⬆⬇ = monter/descendre")
        else
            notify("Fly PC ✈️", "WASD = direction\nSpace = monter | Shift = descendre")
        end

        SendWebhook("✈️ FLY ACTIVÉ", "Fly activé sur "..(isMobile and "Mobile" or "PC"), 255)

    else
        hum.PlatformStand = false
        if FlyBV then FlyBV:Destroy(); FlyBV = nil end
        if FlyBG then FlyBG:Destroy(); FlyBG = nil end
        RemoveFlyMobileUI()
        notify("Fly", "Désactivé.")
    end
end

-- ==================== FLING ====================
local function FlingPlayer(targetChar)
    if not targetChar then return end
    local root   = targetChar:FindFirstChild("HumanoidRootPart")
    local lpRoot = getRoot()
    if not root or not lpRoot then return end
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
    bv.Velocity = (root.Position-lpRoot.Position).Unit * S.flingPow * 1.8 + Vector3.new(0,140,0)
    bv.Parent = root
    local ba = Instance.new("BodyAngularVelocity")
    ba.MaxTorque = Vector3.new(math.huge,math.huge,math.huge)
    ba.AngularVelocity = Vector3.new(0,300,0)
    ba.Parent = root
    game:GetService("Debris"):AddItem(bv, 0.8)
    game:GetService("Debris"):AddItem(ba, 0.8)
end

-- ==================== ESP ====================
local NameTags = {}
local function CreateTag(player)
    if NameTags[player] then return end
    local char = player.Character
    if not char or not char:FindFirstChild("Head") then return end
    local bb = Instance.new("BillboardGui")
    bb.Adornee = char.Head; bb.AlwaysOnTop = true
    bb.Size = UDim2.new(5,0,3,0); bb.StudsOffset = Vector3.new(0,4,0)
    bb.Parent = char.Head
    local frame = Instance.new("Frame", bb)
    frame.Size = UDim2.new(1,0,1,0)
    frame.BackgroundTransparency = 0.7
    frame.BackgroundColor3 = Color3.new(0,0,0)
    local nameL = Instance.new("TextLabel", frame)
    nameL.Size = UDim2.new(1,0,0.4,0)
    nameL.BackgroundTransparency = 1
    nameL.TextColor3 = Color3.new(1,1,1)
    nameL.TextStrokeTransparency = 0
    nameL.Font = Enum.Font.GothamBold
    nameL.TextSize = 22
    local hpBg = Instance.new("Frame", frame)
    hpBg.Size = UDim2.new(1,0,0.15,0)
    hpBg.Position = UDim2.new(0,0,0.45,0)
    hpBg.BackgroundColor3 = Color3.new(0,0,0)
    local hp = Instance.new("Frame", hpBg)
    hp.Size = UDim2.new(1,0,1,0)
    hp.BackgroundColor3 = Color3.fromRGB(0,255,0)
    local distL = Instance.new("TextLabel", frame)
    distL.Size = UDim2.new(1,0,0.35,0)
    distL.Position = UDim2.new(0,0,0.65,0)
    distL.BackgroundTransparency = 1
    distL.TextColor3 = Color3.new(1,1,1)
    distL.TextSize = 16
    NameTags[player] = {bb=bb, name=nameL, hp=hp, dist=distL}
end
local function UpdateESP()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        local char = plr.Character
        if not char then continue end
        local head = char:FindFirstChild("Head")
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum  = char:FindFirstChildOfClass("Humanoid")
        if not head or not root or not hum then continue end
        if not NameTags[plr] then CreateTag(plr) end
        local tag = NameTags[plr]
        if not tag then continue end
        tag.bb.Enabled = S.esp
        if not S.esp then continue end
        tag.name.Text = plr.DisplayName
        local ratio = math.clamp(hum.Health/hum.MaxHealth, 0, 1)
        tag.hp.Size = UDim2.new(ratio,0,1,0)
        tag.hp.BackgroundColor3 = Color3.fromRGB(255*(1-ratio), 255*ratio, 0)
        local lpRoot = getRoot()
        if lpRoot then
            tag.dist.Text = string.format("%.0f studs", (root.Position-lpRoot.Position).Magnitude)
        end
    end
end

-- ==================== ONGLETS ====================

-- ACCUEIL
local Home = Window:CreateTab("Accueil", 4483362458)
Home:CreateSection("LULUCLC3 ZENITH v49.0")
Home:CreateParagraph({Title="Bienvenue", Content="PC & Mobile auto-detecte\nby Luluclc3 | "..(isMobile and "📱 Mobile" or "💻 PC")})
Home:CreateButton({Name="Liste joueurs", Callback=function()
    local list=""
    for _,p in pairs(Players:GetPlayers()) do list=list.."- "..p.Name.."\n" end
    notify("Joueurs ("..#Players:GetPlayers()..")", list)
end})

-- MOUVEMENT
local Mov = Window:CreateTab("Mouvement", 4483362458)
Mov:CreateSection("Stats")
Mov:CreateSlider({Name="Vitesse", Range={16,600}, Increment=5, CurrentValue=16, Flag="Speed", Callback=function(v) S.speed=v end})
Mov:CreateSlider({Name="Puissance Saut", Range={50,1000}, Increment=10, CurrentValue=50, Flag="Jump", Callback=function(v) S.jump=v end})
Mov:CreateButton({Name="Reset Stats", Callback=function() S.speed=16;S.jump=50;notify("Reset","OK !") end})
Mov:CreateSection("Options")
Mov:CreateToggle({Name="Noclip", CurrentValue=false, Flag="NC", Callback=function(v) S.noclip=v end})
Mov:CreateToggle({Name="Saut Infini", CurrentValue=false, Flag="IJ", Callback=function(v) S.infJump=v end})
Mov:CreateToggle({Name="Tornado Spin", CurrentValue=false, Flag="Spin", Callback=function(v) S.spin=v end})
Mov:CreateSlider({Name="Vitesse Spin", Range={10,200}, Increment=5, CurrentValue=50, Flag="SpinSpd", Callback=function(v) S.spinSpeed=v end})
Mov:CreateSection("Gravite")
Mov:CreateSlider({Name="Gravite", Range={0,1000}, Increment=5, CurrentValue=196, Flag="Grav", Callback=function(v) workspace.Gravity=v end})
Mov:CreateButton({Name="Nulle",   Callback=function() workspace.Gravity=5     end})
Mov:CreateButton({Name="Normale", Callback=function() workspace.Gravity=196.2 end})
Mov:CreateButton({Name="x3",      Callback=function() workspace.Gravity=600   end})

-- FLY
local FlyTab = Window:CreateTab("Fly", 4483362458)
FlyTab:CreateSection("Vol - Auto detecte")
FlyTab:CreateParagraph({
    Title = isMobile and "📱 Mode Mobile" or "💻 Mode PC",
    Content = isMobile
        and "Joystick Roblox = avancer\nBoutons ⬆⬇ = monter/descendre"
        or  "W/A/S/D = direction\nSpace = monter | Shift = descendre"
})
FlyTab:CreateToggle({Name="Activer Fly", CurrentValue=false, Flag="Fly", Callback=function(v) S.fly=v; ToggleFly(v) end})
FlyTab:CreateSlider({Name="Vitesse vol", Range={30,400}, Increment=10, CurrentValue=100, Flag="FlySpd", Callback=function(v) S.flySpeed=v end})

-- TROLL
local Troll = Window:CreateTab("Troll", 4483362458)
Troll:CreateSection("Chat")
Troll:CreateButton({Name="Spam Chat", Callback=function()
    local msgs={"gg","lol","ez clap","bro what","no way","fr fr","ratio","skill issue"}
    task.spawn(function()
        for i=1,8 do
            task.wait(0.35)
            local ev=game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
            if ev and ev:FindFirstChild("SayMessageRequest") then
                ev.SayMessageRequest:FireServer(msgs[math.random(1,#msgs)],"All")
            end
        end
    end)
    notify("Chat","Spam envoye !")
end})
local customMsg=""
Troll:CreateInput({Name="Message Custom", PlaceholderText="Ton message...", RemoveTextAfterFocusLost=false, Flag="CMsg", Callback=function(t) customMsg=t end})
Troll:CreateButton({Name="Envoyer", Callback=function()
    if customMsg=="" then return end
    local ev=game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
    if ev and ev:FindFirstChild("SayMessageRequest") then ev.SayMessageRequest:FireServer(customMsg,"All") end
    notify("Chat","Envoye !")
end})
Troll:CreateSection("Apparence")
Troll:CreateButton({Name="Invisible", Callback=function()
    local c=getChar();if not c then return end
    for _,p in pairs(c:GetDescendants()) do if p:IsA("BasePart") or p:IsA("Decal") then p.Transparency=1 end end
    notify("Invisible","OK !")
end})
Troll:CreateButton({Name="Visible", Callback=function()
    local c=getChar();if not c then return end
    for _,p in pairs(c:GetDescendants()) do if p:IsA("BasePart") then p.Transparency=0 end end
    notify("Visible","OK !")
end})
Troll:CreateButton({Name="Geant", Callback=function()
    local h=getHum();if not h then return end
    for _,s in pairs({"BodyDepthScale","BodyHeightScale","BodyWidthScale","HeadScale"}) do if h:FindFirstChild(s) then h[s].Value=3 end end
end})
Troll:CreateButton({Name="Mini", Callback=function()
    local h=getHum();if not h then return end
    for _,s in pairs({"BodyDepthScale","BodyHeightScale","BodyWidthScale","HeadScale"}) do if h:FindFirstChild(s) then h[s].Value=0.3 end end
end})
Troll:CreateButton({Name="Normal", Callback=function()
    local h=getHum();if not h then return end
    for _,s in pairs({"BodyDepthScale","BodyHeightScale","BodyWidthScale","HeadScale"}) do if h:FindFirstChild(s) then h[s].Value=1 end end
end})

-- FLING
local FlingTab = Window:CreateTab("Fling", 4483362458)
FlingTab:CreateSection("Fling Auto")
FlingTab:CreateToggle({Name="Fling Auto proches", CurrentValue=false, Flag="FlingAuto", Callback=function(v)
    S.fling=v
    SendWebhook("🔥 FLING AUTO", v and "Activé" or "Désactivé", v and 65280 or 16711680)
end})
FlingTab:CreateSlider({Name="Puissance", Range={50,500}, Increment=10, CurrentValue=200, Flag="FlingPow", Callback=function(v) S.flingPow=v end})
FlingTab:CreateSection("Fling Cible")
local flingTarget=""
FlingTab:CreateInput({Name="Nom joueur", PlaceholderText="Pseudo exact...", RemoveTextAfterFocusLost=false, Flag="FlingName", Callback=function(t) flingTarget=t end})
FlingTab:CreateButton({Name="Fling ce joueur", Callback=function()
    local plr=Players:FindFirstChild(flingTarget)
    if plr and plr.Character then
        FlingPlayer(plr.Character)
        SendWebhook("🔥 FLING CIBLE", "Cible : "..flingTarget, 16711680)
        notify("Fling","Fling sur "..flingTarget.." !")
    else
        notify("Erreur","Joueur introuvable.")
    end
end})

-- ESP
local EspTab = Window:CreateTab("ESP", 4483362458)
EspTab:CreateSection("ESP Visuel")
EspTab:CreateToggle({Name="ESP", CurrentValue=false, Flag="ESP", Callback=function(v)
    S.esp=v
    SendWebhook("👁️ ESP", v and "Activé" or "Désactivé", v and 65280 or 16711680)
end})
EspTab:CreateParagraph({Title="Infos", Content="Nom + HP + Distance\nVisible que pour toi"})

-- JOUEURS
local PlrTab = Window:CreateTab("Joueurs", 4483362458)
local function RefreshPlayers()
    for _,plr in pairs(Players:GetPlayers()) do
        if plr==LocalPlayer then continue end
        PlrTab:CreateSection(plr.DisplayName)
        PlrTab:CreateButton({Name="TP vers "..plr.DisplayName, Callback=function()
            local lpRoot=getRoot()
            local tRoot=plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
            if lpRoot and tRoot then
                lpRoot.CFrame=tRoot.CFrame+Vector3.new(0,5,0)
                notify("TP","Teleporte vers "..plr.DisplayName.." !")
            end
        end})
        PlrTab:CreateButton({Name="Fling "..plr.DisplayName, Callback=function()
            if plr.Character then FlingPlayer(plr.Character);notify("Fling","OK !") end
        end})
    end
end
PlrTab:CreateButton({Name="Rafraichir", Callback=RefreshPlayers})
RefreshPlayers()

-- WORLD
local World = Window:CreateTab("World", 4483362458)
World:CreateSection("Heure")
World:CreateSlider({Name="Heure", Range={0,24}, Increment=1, Suffix="h", CurrentValue=14, Flag="Time", Callback=function(v) Lighting.ClockTime=v end})
World:CreateSection("Meteo")
World:CreateButton({Name="Journee",          Callback=function() Lighting.ClockTime=14;Lighting.Brightness=3;Lighting.FogEnd=100000 end})
World:CreateButton({Name="Nuit",             Callback=function() Lighting.ClockTime=0;Lighting.Brightness=0.3 end})
World:CreateButton({Name="Coucher soleil",   Callback=function() Lighting.ClockTime=18;Lighting.Brightness=1.5;Lighting.Ambient=Color3.fromRGB(255,100,50) end})
World:CreateButton({Name="Ambiance sang",    Callback=function() Lighting.FogColor=Color3.fromRGB(180,0,0);Lighting.FogEnd=200;Lighting.Brightness=0.4;Lighting.ClockTime=0 end})
World:CreateButton({Name="Brouillard",       Callback=function() Lighting.FogEnd=50 end})
World:CreateButton({Name="Reset meteo",      Callback=function() Lighting.ClockTime=14;Lighting.Brightness=2;Lighting.FogEnd=100000;Lighting.Ambient=Color3.fromRGB(100,100,100) end})

-- PARAMETRES
local Sett = Window:CreateTab("Parametres", 4483362458)
Sett:CreateSection("Info")
Sett:CreateParagraph({Title="LULUCLC3 ZENITH v49.0", Content="by Luluclc3\n"..(isMobile and "📱 Mobile" or "💻 PC").." | Delta compatible"})
Sett:CreateSection("Reset")
Sett:CreateButton({Name="Tout reset", Callback=function()
    S.speed=16;S.jump=50;S.fly=false;S.noclip=false
    S.infJump=false;S.spin=false;S.esp=false;S.fling=false
    workspace.Gravity=196.2
    ToggleFly(false)
    local h=getHum()
    if h then h.WalkSpeed=16;h.JumpPower=50 end
    notify("Reset","Tout reinitialise !")
end})
Sett:CreateButton({Name="Fermer", Callback=function() Rayfield:Destroy() end})

-- ==================== BOUCLE PRINCIPALE ====================
RunService.RenderStepped:Connect(function()
    local char=getChar();if not char then return end
    local hum=getHum();local root=getRoot()
    if hum then hum.WalkSpeed=S.speed;hum.JumpPower=S.jump end

    -- FLY PC uniquement
    if S.fly and FlyBV and FlyBG and root and not isMobile then
        local cam=Camera.CFrame;local vel=Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W)         then vel=vel+cam.LookVector*S.flySpeed end
        if UIS:IsKeyDown(Enum.KeyCode.S)         then vel=vel-cam.LookVector*S.flySpeed end
        if UIS:IsKeyDown(Enum.KeyCode.A)         then vel=vel-cam.RightVector*S.flySpeed end
        if UIS:IsKeyDown(Enum.KeyCode.D)         then vel=vel+cam.RightVector*S.flySpeed end
        if UIS:IsKeyDown(Enum.KeyCode.Space)     then vel=vel+Vector3.new(0,S.flySpeed,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then vel=vel-Vector3.new(0,S.flySpeed,0) end
        FlyBV.Velocity=vel;FlyBG.CFrame=cam
    end

    if S.noclip then
        for _,p in pairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end
    end
    if S.spin and root then root.CFrame=root.CFrame*CFrame.Angles(0,math.rad(S.spinSpeed),0) end
    if S.infJump and hum then hum.Jump=true end
    if S.esp then UpdateESP() end
end)

-- FLING AUTO
task.spawn(function()
    while task.wait(0.1) do
        if S.fling then
            local lpRoot=getRoot();if not lpRoot then continue end
            for _,p in pairs(Players:GetPlayers()) do
                if p==LocalPlayer then continue end
                local c=p.Character
                if c and c:FindFirstChild("HumanoidRootPart") then
                    if (c.HumanoidRootPart.Position-lpRoot.Position).Magnitude<35 then FlingPlayer(c) end
                end
            end
        end
    end
end)

Rayfield:Notify({Title="LULUCLC3 ZENITH v49.0", Content="Chargé ! by Luluclc3\n"..(isMobile and "📱 Mobile" or "💻 PC"), Duration=6})
print("=== ZENITH v49.0 CHARGÉ ===")
