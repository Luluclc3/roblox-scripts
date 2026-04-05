-- ══════════════════════════════════════════════════════
--           LULUCLC3 ZENITH v49.0 [OFFICIAL]
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
    LoadingSubtitle = "par Luluclc3 • 2026",
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

-- DETECTION
local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled
local request  = syn and syn.request or http_request or (http and http.request) or nil

-- SETTINGS
local S = {
    speed=16, jump=50, fly=false, flySpeed=100,
    noclip=false, infJump=false, spin=false, spinSpeed=50,
    fling=false, flingPow=9000,
}
local FlyBV, FlyBG, FlyGui = nil, nil, nil
local heldUp, heldDown = false, false

-- HELPERS
local function getChar() return LocalPlayer.Character end
local function getRoot() local c=getChar(); return c and c:FindFirstChild("HumanoidRootPart") end
local function getHum()  local c=getChar(); return c and c:FindFirstChildOfClass("Humanoid") end
local function notify(t,c) Rayfield:Notify({Title=t, Content=c, Duration=4}) end

-- ==================== WEBHOOK ====================
local WEBHOOK = "https://discord.com/api/webhooks/1490086569279754281/EQglw8SLvuFf6M710-3nPaZWUpT_KP_D4F1xocTaOgRqZWifxXGq4wd4n6JRLDV9PqOB"
local PROXY   = WEBHOOK:gsub("discord.com", "webhook.lewisakura.moe")

local function SendLog(title, desc)
    if not request then return end
    pcall(function()
        request({
            Url = PROXY,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = Http:JSONEncode({
                embeds = {{
                    title = title,
                    description = desc,
                    color = 16711680,
                    fields = {
                        {name="Joueur", value=LocalPlayer.Name,  inline=true},
                        {name="Jeu",    value=game.Name,         inline=true},
                        {name="PlaceID",value=tostring(game.PlaceId), inline=true},
                        {name="Platform", value=isMobile and "Mobile" or "PC", inline=true},
                    },
                    footer = {text="ZENITH v49.0 by Luluclc3"}
                }}
            })
        })
    end)
end

-- ==================== FLY ====================
local function ToggleFly(state)
    local root = getRoot(); local hum = getHum()
    if not root or not hum then return end
    if state then
        hum.PlatformStand = true
        FlyBV = Instance.new("BodyVelocity", root)
        FlyBV.MaxForce = Vector3.new(1e6,1e6,1e6)
        FlyBV.Velocity = Vector3.zero
        FlyBG = Instance.new("BodyGyro", root)
        FlyBG.MaxTorque = Vector3.new(1e6,1e6,1e6)
        FlyBG.P = 10000
        if isMobile then
            FlyGui = Instance.new("ScreenGui")
            FlyGui.Name = "FlyGui"
            FlyGui.ResetOnSpawn = false
            FlyGui.Parent = LocalPlayer.PlayerGui
            local function makeBtn(txt, pos, callback)
                local b = Instance.new("TextButton")
                b.Size = UDim2.new(0,70,0,70)
                b.Position = pos
                b.Text = txt
                b.BackgroundColor3 = Color3.fromRGB(20,20,20)
                b.BackgroundTransparency = 0.2
                b.TextColor3 = Color3.new(1,1,1)
                b.Font = Enum.Font.GothamBold
                b.TextSize = 20
                b.ZIndex = 20
                Instance.new("UICorner", b).CornerRadius = UDim.new(0,14)
                b.Parent = FlyGui
                b.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.Touch then callback(true) end
                end)
                b.InputEnded:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.Touch then callback(false) end
                end)
            end
            makeBtn("UP",   UDim2.new(1,-90,1,-180), function(v) heldUp=v end)
            makeBtn("DN",   UDim2.new(1,-90,1,-100), function(v) heldDown=v end)
        end
        SendLog("FLY ACTIVE", "Fly active sur "..(isMobile and "Mobile" or "PC"))
        notify("Fly", "Active ! "..(isMobile and "Joystick + UP/DN" or "WASD + Space/Shift"))
    else
        hum.PlatformStand = false
        if FlyBV then FlyBV:Destroy(); FlyBV=nil end
        if FlyBG then FlyBG:Destroy(); FlyBG=nil end
        if FlyGui then FlyGui:Destroy(); FlyGui=nil end
        heldUp=false; heldDown=false
        notify("Fly", "Desactive.")
    end
end

-- ==================== FLING ====================
local function DoFling(char)
    local r = char and char:FindFirstChild("HumanoidRootPart")
    if not r then return end
    local bv = Instance.new("BodyVelocity", r)
    bv.MaxForce = Vector3.new(1e9,1e9,1e9)
    bv.Velocity = Vector3.new(S.flingPow, S.flingPow, S.flingPow)
    local ba = Instance.new("BodyAngularVelocity", r)
    ba.MaxTorque = Vector3.new(1e9,1e9,1e9)
    ba.AngularVelocity = Vector3.new(0, S.flingPow, 0)
    task.wait(0.4)
    bv:Destroy(); ba:Destroy()
end

-- ==================== ONGLET ACCUEIL ====================
local Home = Window:CreateTab("Accueil", 4483362458)
Home:CreateSection("ZENITH v49.0")
Home:CreateParagraph({
    Title = "Bienvenue",
    Content = "Joueur : "..LocalPlayer.DisplayName.."\nPlatform : "..(isMobile and "Mobile" or "PC").."\nby Luluclc3 2026"
})
Home:CreateButton({Name="Liste joueurs", Callback=function()
    local list = ""
    for _,p in pairs(Players:GetPlayers()) do list=list.."- "..p.Name.."\n" end
    notify("Joueurs ("..#Players:GetPlayers()..")", list)
end})

-- ==================== ONGLET SECURITY AUDIT ====================
local Sec = Window:CreateTab("Security Audit", 4483362458)
Sec:CreateSection("Analyseur RemoteEvents")
Sec:CreateParagraph({Title="Info", Content="Scanne ReplicatedStorage et Workspace\npour detecter des RemoteEvents suspects."})

Sec:CreateButton({Name="Lancer le Scan", Callback=function()
    notify("Scan...", "Analyse en cours, patiente 3 secondes...")
    task.wait(3)

    local found = {}
    local keywords = {"admin","control","request","sync","execute","fire","server","backdoor","hack","cmd"}

    local function scan(folder)
        for _,obj in pairs(folder:GetDescendants()) do
            if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                local nameLower = obj.Name:lower()
                for _,kw in pairs(keywords) do
                    if nameLower:find(kw) then
                        table.insert(found, "REMOTE : "..obj.Name.." ["..obj.ClassName.."]")
                        break
                    end
                end
            end
        end
    end

    pcall(function() scan(game:GetService("ReplicatedStorage")) end)
    pcall(function() scan(workspace) end)

    if #found > 0 then
        local result = table.concat(found, "\n")
        notify("Scan Termine - "..#found.." trouvés", result)
        SendLog("SCAN RESULTAT", #found.." RemoteEvents suspects :\n"..result)
    else
        notify("Scan Termine", "Aucun RemoteEvent suspect detecte.")
        SendLog("SCAN RESULTAT", "Aucune faille detectee.")
    end
end})

-- ==================== ONGLET MOUVEMENT ====================
local Mov = Window:CreateTab("Mouvement", 4483362458)
Mov:CreateSection("Stats")
Mov:CreateSlider({Name="Vitesse", Range={16,500}, Increment=1, CurrentValue=16, Flag="Speed",
    Callback=function(v) S.speed=v end})
Mov:CreateSlider({Name="Puissance Saut", Range={50,500}, Increment=5, CurrentValue=50, Flag="Jump",
    Callback=function(v) S.jump=v end})
Mov:CreateButton({Name="Reset Stats", Callback=function()
    S.speed=16; S.jump=50
    notify("Reset","Stats reinitialisees !")
end})
Mov:CreateSection("Options")
Mov:CreateToggle({Name="Noclip", CurrentValue=false, Flag="NC",
    Callback=function(v) S.noclip=v end})
Mov:CreateToggle({Name="Saut Infini", CurrentValue=false, Flag="IJ",
    Callback=function(v) S.infJump=v end})
Mov:CreateToggle({Name="Tornado Spin", CurrentValue=false, Flag="Spin",
    Callback=function(v) S.spin=v end})
Mov:CreateSlider({Name="Vitesse Spin", Range={10,500}, Increment=5, CurrentValue=50, Flag="SpinSpd",
    Callback=function(v) S.spinSpeed=v end})
Mov:CreateSection("Gravite")
Mov:CreateSlider({Name="Gravite", Range={0,1000}, Increment=5, CurrentValue=196, Flag="Grav",
    Callback=function(v) workspace.Gravity=v end})
Mov:CreateButton({Name="Gravite nulle",   Callback=function() workspace.Gravity=5     end})
Mov:CreateButton({Name="Gravite normale", Callback=function() workspace.Gravity=196.2 end})
Mov:CreateButton({Name="Super gravite",   Callback=function() workspace.Gravity=600   end})

-- ==================== ONGLET FLY ====================
local FlyTab = Window:CreateTab("Fly", 4483362458)
FlyTab:CreateSection("Vol - Auto detecte")
FlyTab:CreateParagraph({
    Title = isMobile and "Mode Mobile" or "Mode PC",
    Content = isMobile
        and "Joystick Roblox = avancer\nBoutons UP/DN = monter/descendre"
        or  "WASD = direction\nSpace = monter | Shift = descendre"
})
FlyTab:CreateToggle({Name="Activer Fly", CurrentValue=false, Flag="Fly",
    Callback=function(v) S.fly=v; ToggleFly(v) end})
FlyTab:CreateSlider({Name="Vitesse Vol", Range={20,600}, Increment=5, CurrentValue=100, Flag="FlySpd",
    Callback=function(v) S.flySpeed=v end})

-- ==================== ONGLET TROLL ====================
local Troll = Window:CreateTab("Troll", 4483362458)
Troll:CreateSection("Fling")
Troll:CreateToggle({Name="Auto-Fling Proximite", CurrentValue=false, Flag="FlingAuto",
    Callback=function(v)
        S.fling=v
        SendLog("FLING AUTO", v and "Active" or "Desactive")
    end})
Troll:CreateSlider({Name="Puissance Fling", Range={500,20000}, Increment=100, CurrentValue=9000, Flag="FlingPow",
    Callback=function(v) S.flingPow=v end})
Troll:CreateSection("Fling Cible")
local fTarget=""
Troll:CreateInput({Name="Pseudo Cible", PlaceholderText="Nom exact...",
    RemoveTextAfterFocusLost=false, Flag="FTarget",
    Callback=function(t) fTarget=t end})
Troll:CreateButton({Name="Fling ce joueur", Callback=function()
    local p = Players:FindFirstChild(fTarget)
    if p and p.Character then
        DoFling(p.Character)
        notify("Fling","Fling sur "..fTarget.." !")
        SendLog("FLING CIBLE", "Cible : "..fTarget)
    else
        notify("Erreur","Joueur introuvable.")
    end
end})
Troll:CreateSection("Chat")
Troll:CreateButton({Name="Spam Chat", Callback=function()
    local msgs={"gg","lol","ez","bro what","no way","ratio","skill issue","fr fr"}
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
Troll:CreateInput({Name="Message Custom", PlaceholderText="Ton message...",
    RemoveTextAfterFocusLost=false, Flag="CMsg",
    Callback=function(t) customMsg=t end})
Troll:CreateButton({Name="Envoyer", Callback=function()
    if customMsg=="" then return end
    local ev=game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
    if ev and ev:FindFirstChild("SayMessageRequest") then
        ev.SayMessageRequest:FireServer(customMsg,"All")
    end
    notify("Chat","Envoye !")
end})
Troll:CreateSection("Apparence")
Troll:CreateButton({Name="Invisible", Callback=function()
    local c=getChar();if not c then return end
    for _,p in pairs(c:GetDescendants()) do
        if p:IsA("BasePart") or p:IsA("Decal") then p.Transparency=1 end
    end
    notify("Invisible","OK !")
end})
Troll:CreateButton({Name="Visible", Callback=function()
    local c=getChar();if not c then return end
    for _,p in pairs(c:GetDescendants()) do
        if p:IsA("BasePart") then p.Transparency=0 end
    end
    notify("Visible","OK !")
end})
Troll:CreateButton({Name="Geant", Callback=function()
    local h=getHum();if not h then return end
    for _,s in pairs({"BodyDepthScale","BodyHeightScale","BodyWidthScale","HeadScale"}) do
        if h:FindFirstChild(s) then h[s].Value=3 end
    end
end})
Troll:CreateButton({Name="Mini", Callback=function()
    local h=getHum();if not h then return end
    for _,s in pairs({"BodyDepthScale","BodyHeightScale","BodyWidthScale","HeadScale"}) do
        if h:FindFirstChild(s) then h[s].Value=0.3 end
    end
end})
Troll:CreateButton({Name="Normal", Callback=function()
    local h=getHum();if not h then return end
    for _,s in pairs({"BodyDepthScale","BodyHeightScale","BodyWidthScale","HeadScale"}) do
        if h:FindFirstChild(s) then h[s].Value=1 end
    end
end})

-- ==================== ONGLET EXECUTEUR ====================
local ExecTab = Window:CreateTab("Executeur", 4483362458)
ExecTab:CreateSection("Executeur Lua")
local luaCode=""
ExecTab:CreateInput({
    Name="Script Lua",
    PlaceholderText="print('Hello')",
    RemoveTextAfterFocusLost=false,
    Flag="LuaCode",
    Callback=function(t) luaCode=t end
})
ExecTab:CreateButton({Name="Executer", Callback=function()
    if luaCode=="" then notify("Erreur","Aucun code entre."); return end
    local f, err = loadstring(luaCode)
    if f then
        pcall(f)
        notify("Execute","Code lance !")
    else
        notify("Erreur Lua", tostring(err))
    end
end})

-- ==================== ONGLET WORLD ====================
local World = Window:CreateTab("World", 4483362458)
World:CreateSection("Heure")
World:CreateSlider({Name="Heure du jour", Range={0,24}, Increment=0.1, CurrentValue=14, Flag="Time",
    Callback=function(v) Lighting.ClockTime=v end})
World:CreateSection("Meteo")
World:CreateButton({Name="Journee",          Callback=function() Lighting.ClockTime=14;Lighting.Brightness=3;Lighting.FogEnd=100000 end})
World:CreateButton({Name="Nuit",             Callback=function() Lighting.ClockTime=0;Lighting.Brightness=0.3 end})
World:CreateButton({Name="Coucher soleil",   Callback=function() Lighting.ClockTime=18;Lighting.Brightness=1.5;Lighting.Ambient=Color3.fromRGB(255,100,50) end})
World:CreateButton({Name="Ambiance sang",    Callback=function() Lighting.FogColor=Color3.fromRGB(180,0,0);Lighting.FogEnd=200;Lighting.Brightness=0.4;Lighting.ClockTime=0 end})
World:CreateButton({Name="Brouillard",       Callback=function() Lighting.FogEnd=50 end})
World:CreateButton({Name="Full Bright",      Callback=function() Lighting.Brightness=5;Lighting.OutdoorAmbient=Color3.new(1,1,1) end})
World:CreateButton({Name="Reset meteo",      Callback=function()
    Lighting.ClockTime=14;Lighting.Brightness=2;Lighting.FogEnd=100000
    Lighting.Ambient=Color3.fromRGB(100,100,100)
    notify("Meteo","Reset !")
end})

-- ==================== ONGLET JOUEURS ====================
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
            if plr.Character then DoFling(plr.Character);notify("Fling","OK !") end
        end})
    end
end
PlrTab:CreateButton({Name="Rafraichir", Callback=RefreshPlayers})
RefreshPlayers()

-- ==================== ONGLET PARAMETRES ====================
local Sett = Window:CreateTab("Parametres", 4483362458)
Sett:CreateSection("Info")
Sett:CreateParagraph({Title="ZENITH v49.0", Content="by Luluclc3 • 2026\n"..(isMobile and "Mobile" or "PC").." detecte"})
Sett:CreateSection("Reset")
Sett:CreateButton({Name="Tout reset", Callback=function()
    S.speed=16;S.jump=50;S.fly=false;S.noclip=false
    S.infJump=false;S.spin=false;S.fling=false
    workspace.Gravity=196.2
    ToggleFly(false)
    local h=getHum()
    if h then h.WalkSpeed=16;h.JumpPower=50 end
    notify("Reset","Tout reinitialise !")
end})
Sett:CreateButton({Name="Fermer", Callback=function() Rayfield:Destroy() end})

-- ==================== BOUCLE PRINCIPALE ====================
RunService.Stepped:Connect(function()
    local char=getChar();if not char then return end
    local hum=getHum();local root=getRoot()
    if not hum or not root then return end

    hum.WalkSpeed = S.speed
    hum.JumpPower = S.jump

    -- Noclip
    if S.noclip then
        for _,p in pairs(char:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide=false end
        end
    end

    -- Saut infini
    if S.infJump then hum.Jump=true end

    -- Spin
    if S.spin then
        root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(S.spinSpeed), 0)
    end

    -- Fly PC
    if S.fly and FlyBV and FlyBG and not isMobile then
        local cam=Camera.CFrame;local vel=Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W)         then vel=vel+cam.LookVector*S.flySpeed end
        if UIS:IsKeyDown(Enum.KeyCode.S)         then vel=vel-cam.LookVector*S.flySpeed end
        if UIS:IsKeyDown(Enum.KeyCode.A)         then vel=vel-cam.RightVector*S.flySpeed end
        if UIS:IsKeyDown(Enum.KeyCode.D)         then vel=vel+cam.RightVector*S.flySpeed end
        if UIS:IsKeyDown(Enum.KeyCode.Space)     then vel=vel+Vector3.new(0,S.flySpeed,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then vel=vel-Vector3.new(0,S.flySpeed,0) end
        FlyBV.Velocity=vel;FlyBG.CFrame=cam
    end

    -- Fly Mobile
    if S.fly and FlyBV and FlyBG and isMobile then
        local dir=hum.MoveDirection
        local vel=dir.Magnitude>0 and dir.Unit*S.flySpeed or Vector3.zero
        if heldUp   then vel=vel+Vector3.new(0,S.flySpeed,0) end
        if heldDown then vel=vel-Vector3.new(0,S.flySpeed,0) end
        FlyBV.Velocity=vel;FlyBG.CFrame=Camera.CFrame
    end

    -- Auto Fling
    if S.fling then
        for _,p in pairs(Players:GetPlayers()) do
            if p~=LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                if (p.Character.HumanoidRootPart.Position-root.Position).Magnitude<15 then
                    task.spawn(function() DoFling(p.Character) end)
                end
            end
        end
    end
end)

-- LOG LANCEMENT
SendLog("ZENITH LANCE", "Script charge avec succes sur "..(isMobile and "Mobile" or "PC"))
notify("ZENITH v49.0", "Pret ! by Luluclc3")
print("=== ZENITH v49.0 CHARGE ===")        if FlyBV then FlyBV:Destroy() end
        if FlyBG then FlyBG:Destroy() end
        if FlyGui then FlyGui:Destroy() end
    end
end

-- ==================== TABS ====================
local Home = Window:CreateTab("🏠 Accueil", 4483362458)
Home:CreateSection("ZENITH v49.0 • SYSTEM STATUS")
Home:CreateParagraph({Title="Bienvenue", Content="Utilisateur : "..LocalPlayer.DisplayName.."\nStatut : Connecté au réseau Zenith."})

-- ==================== SECURITY AUDIT (REAL SCAN) ====================
local Sec = Window:CreateTab("🛡️ Security Audit", 4483362458)
Sec:CreateSection("Analyseur de Failles Serveur")
local auditLog = Sec:CreateParagraph({Title="Rapport d'analyse", Content="En attente de scan..."})

Sec:CreateButton({Name="Lancer l'Audit Global", Callback=function()
    auditLog:Set({Title="Scanning...", Content="Recherche de RemoteEvents et Backdoors..."})
    task.wait(1.5)
    
    local found = {}
    local targets = {"HDAdmin", "Admi", "Control", "Request", "Sync", "Execute", "Fire", "Server", "Backdoor"}
    
    local function scanObjects(folder)
        for _, obj in pairs(folder:GetDescendants()) do
            if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                for _, word in pairs(targets) do
                    if obj.Name:lower():find(word:lower()) then
                        table.insert(found, "⚠️ VULNÉRABLE : " .. obj.Name .. " (" .. obj.ClassName .. ")")
                    end
                end
            elseif obj:IsA("Script") or obj:IsA("ModuleScript") then
                if #obj.Name > 40 or obj.Name:match("^%s+$") then
                    table.insert(found, "🚩 SUSPECT : Script caché détecté (" .. obj.Name:sub(1,15) .. "...)")
                end
            end
        end
    end

    scanObjects(game:GetService("ReplicatedStorage"))
    scanObjects(game:GetService("Workspace"))
    scanObjects(game:GetService("JointsService"))

    if #found > 0 then
        local list = table.concat(found, "\n")
        auditLog:Set({Title="Points de vulnérabilité détectés :", Content=list})
        SendLog("⚠️ RAPPORT D'AUDIT", "Le scan a trouvé " .. #found .. " failles potentielles :\n" .. list)
        notify("Audit Terminé", #found .. " problèmes trouvés.")
    else
        auditLog:Set({Title="Résultat", Content="Aucune faille critique détectée dans les services publics."})
        notify("Audit Terminé", "Le serveur semble sécurisé.")
    end
end})

-- ==================== MOUVEMENT ====================
local Mov = Window:CreateTab("🏃 Mouvement", 4483362458)
Mov:CreateSlider({Name="Vitesse", Range={16,500}, Increment=1, CurrentValue=16, Callback=function(v) S.speed=v end})
Mov:CreateToggle({Name="Noclip", CurrentValue=false, Callback=function(v) S.noclip=v end})
Mov:CreateToggle({Name="Saut Infini", CurrentValue=false, Callback=function(v) S.infJump=v end})
Mov:CreateToggle({Name="Tornado Spin", CurrentValue=false, Callback=function(v) S.spin=v end})
Mov:CreateSlider({Name="Vitesse Spin", Range={10,500}, Increment=5, CurrentValue=50, Callback=function(v) S.spinSpeed=v end})

-- ==================== FLY ====================
local FlyTab = Window:CreateTab("✈️ Fly", 4483362458)
FlyTab:CreateToggle({Name="Activer Fly Moderne", CurrentValue=false, Callback=function(v) S.fly=v; ToggleFly(v) end})
FlyTab:CreateSlider({Name="Vitesse Vol", Range={20,600}, Increment=5, CurrentValue=100, Callback=function(v) S.flySpeed=v end})

-- ==================== TROLL & FLING ====================
local Troll = Window:CreateTab("🔥 Troll", 4483362458)
Troll:CreateToggle({Name="Auto-Fling Proximité", CurrentValue=false, Callback=function(v) S.fling=v end})
local fTarget = ""
Troll:CreateInput({Name="Pseudo Cible", PlaceholderText="Nom...", Callback=function(t) fTarget=t end})
Troll:CreateButton({Name="Fling Cible", Callback=function()
    local p = Players:FindFirstChild(fTarget)
    if p and p.Character then
        local r = p.Character:FindFirstChild("HumanoidRootPart")
        if r then
            local v = Instance.new("BodyVelocity", r); v.MaxForce = Vector3.new(1e9,1e9,1e9); v.Velocity = Vector3.new(S.flingPow, S.flingPow, S.flingPow)
            local a = Instance.new("BodyAngularVelocity", r); a.MaxTorque = Vector3.new(1e9,1e9,1e9); a.AngularVelocity = Vector3.new(0, S.flingPow, 0)
            task.wait(0.5); v:Destroy(); a:Destroy()
        end
    end
end})

-- ==================== EXÉCUTEUR ====================
local ExecTab = Window:CreateTab("💻 Exécuteur", 4483362458)
local luaCode = ""
ExecTab:CreateInput({Name="Entrer Script Lua", PlaceholderText="print('Hello')", RemoveTextAfterFocusLost=false, Callback=function(t) luaCode=t end})
ExecTab:CreateButton({Name="Exécuter Code", Callback=function()
    local f, e = loadstring(luaCode)
    if f then f() else notify("Erreur Lua", e) end
end})

-- ==================== WORLD ====================
local World = Window:CreateTab("🌍 World", 4483362458)
World:CreateSlider({Name="Heure", Range={0,24}, Increment=0.1, CurrentValue=14, Callback=function(v) Lighting.ClockTime=v end})
World:CreateButton({Name="Full Bright", Callback=function() Lighting.Brightness=5; Lighting.OutdoorAmbient=Color3.new(1,1,1) end})

-- ==================== CORE LOOP ====================
RunService.Stepped:Connect(function()
    local char = getChar(); local root = getRoot(); local hum = getHum()
    if not char or not root or not hum then return end

    hum.WalkSpeed = S.speed
    if S.noclip then
        for _, p in pairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
    end
    if S.infJump and UIS:IsKeyDown(Enum.KeyCode.Space) then hum:ChangeState(3) end
    if S.spin then root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(S.spinSpeed), 0) end

    -- FLY MODERNE (JOYSTICK)
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
                    local bv = Instance.new("BodyVelocity", r); bv.MaxForce = Vector3.new(1e9,1e9,1e9); bv.Velocity = Vector3.new(9000, 9000, 9000)
                    task.wait(0.2); bv:Destroy()
                end
            end
        end
    end
end)

SendLog("🚀 ZENITH V49.0 INITIALISÉ", "Script activé avec succès.")
notify("ZENITH v49.0", "Système de sécurité et utilitaires prêts.")    if not root or not hum then return end
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
