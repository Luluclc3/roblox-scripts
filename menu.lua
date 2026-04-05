-- ══════════════════════════════════════════════════════
--           LULUCLC3 ZENITH v49.0 - FIXED EDITION 👑
--                    by Luluclc3
-- ══════════════════════════════════════════════════════

print("=== LULUCLC3 ZENITH v49.0 - CHARGEMENT... ===")

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local success, Rayfield = pcall(function()
    return loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
end)

if not success or not Rayfield then
    warn("❌ Rayfield n'a pas chargé !")
    return
end

local Window = Rayfield:CreateWindow({
    Name = "LULUCLC3 ZENITH v49.0",
    LoadingTitle = "Chargement...",
    LoadingSubtitle = "par Luluclc3 • 2026",
    KeySystem = false
})

local Players     = game:GetService("Players")
local RunService  = game:GetService("RunService")
local UIS         = game:GetService("UserInputService")
local Lighting    = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Camera      = workspace.CurrentCamera
local isMobile    = UIS.TouchEnabled and not UIS.KeyboardEnabled

local function getChar() return LocalPlayer.Character end
local function getRoot() local c=getChar(); return c and c:FindFirstChild("HumanoidRootPart") end
local function getHum()  local c=getChar(); return c and c:FindFirstChildOfClass("Humanoid") end
local function notify(t,c) Rayfield:Notify({Title=t,Content=c,Duration=3}) end

local S = {
    speed=16, jump=50, fly=false, flySpeed=100,
    noclip=false, infJump=false, spin=false, spinSpeed=50,
    esp=false, fling=false, flingPow=200,
}

-- ==================== FLY ====================
local FlyBV, FlyBG

local function ToggleFly(state)
    local char=getChar(); local root=getRoot(); local hum=getHum()
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
            local gui = Instance.new("ScreenGui")
            gui.Name = "FlyMobile"
            gui.ResetOnSpawn = false
            gui.Parent = LocalPlayer.PlayerGui
            local held = {}
            local function makeBtn(label, pos)
                local b = Instance.new("TextButton")
                b.Size = UDim2.new(0,70,0,70)
                b.Position = pos
                b.BackgroundColor3 = Color3.fromRGB(20,20,20)
                b.BackgroundTransparency = 0.2
                b.TextColor3 = Color3.new(1,1,1)
                b.Text = label
                b.Font = Enum.Font.GothamBold
                b.TextSize = 13
                b.ZIndex = 10
                Instance.new("UICorner",b).CornerRadius = UDim.new(0,12)
                b.Parent = gui
                held[label] = false
                b.InputBegan:Connect(function() held[label]=true end)
                b.InputEnded:Connect(function() held[label]=false end)
            end
            makeBtn("UP",  UDim2.new(0,10,1,-240))
            makeBtn("DN",  UDim2.new(0,10,1,-160))
            makeBtn("L",   UDim2.new(0,10,1,-90))
            makeBtn("R",   UDim2.new(0,90,1,-90))
            makeBtn("FWD", UDim2.new(0,90,1,-240))
            makeBtn("BCK", UDim2.new(0,90,1,-160))
            task.spawn(function()
                while S.fly do
                    task.wait()
                    local r=getRoot()
                    if not r or not FlyBV then break end
                    local cam=Camera.CFrame
                    local vel=Vector3.zero
                    if held["FWD"] then vel=vel+cam.LookVector*S.flySpeed end
                    if held["BCK"] then vel=vel-cam.LookVector*S.flySpeed end
                    if held["L"]   then vel=vel-cam.RightVector*S.flySpeed end
                    if held["R"]   then vel=vel+cam.RightVector*S.flySpeed end
                    if held["UP"]  then vel=vel+Vector3.new(0,S.flySpeed,0) end
                    if held["DN"]  then vel=vel-Vector3.new(0,S.flySpeed,0) end
                    FlyBV.Velocity=vel
                    FlyBG.CFrame=cam
                end
                gui:Destroy()
            end)
        end
        notify("Fly","Active ! "..(isMobile and "Boutons a l'ecran" or "WASD+Space/Shift"))
    else
        hum.PlatformStand=false
        if FlyBV then FlyBV:Destroy(); FlyBV=nil end
        if FlyBG then FlyBG:Destroy(); FlyBG=nil end
        local g=LocalPlayer.PlayerGui:FindFirstChild("FlyMobile")
        if g then g:Destroy() end
        notify("Fly","Desactive.")
    end
end

-- ==================== FLING ====================
local function FlingPlayer(targetChar)
    if not targetChar then return end
    local root=targetChar:FindFirstChild("HumanoidRootPart")
    local lpRoot=getRoot()
    if not root or not lpRoot then return end
    local bv=Instance.new("BodyVelocity")
    bv.MaxForce=Vector3.new(math.huge,math.huge,math.huge)
    bv.Velocity=(root.Position-lpRoot.Position).Unit*S.flingPow*1.8+Vector3.new(0,140,0)
    bv.Parent=root
    local ba=Instance.new("BodyAngularVelocity")
    ba.MaxTorque=Vector3.new(math.huge,math.huge,math.huge)
    ba.AngularVelocity=Vector3.new(0,300,0)
    ba.Parent=root
    game:GetService("Debris"):AddItem(bv,0.8)
    game:GetService("Debris"):AddItem(ba,0.8)
end

-- ==================== ESP ====================
local NameTags = {}
local function CreateTag(player)
    if NameTags[player] then return end
    local char=player.Character
    if not char or not char:FindFirstChild("Head") then return end
    local bb=Instance.new("BillboardGui")
    bb.Adornee=char.Head; bb.AlwaysOnTop=true
    bb.Size=UDim2.new(5,0,3,0); bb.StudsOffset=Vector3.new(0,4,0)
    bb.Parent=char.Head
    local frame=Instance.new("Frame",bb)
    frame.Size=UDim2.new(1,0,1,0)
    frame.BackgroundTransparency=0.7
    frame.BackgroundColor3=Color3.new(0,0,0)
    local nameL=Instance.new("TextLabel",frame)
    nameL.Size=UDim2.new(1,0,0.4,0)
    nameL.BackgroundTransparency=1
    nameL.TextColor3=Color3.new(1,1,1)
    nameL.TextStrokeTransparency=0
    nameL.Font=Enum.Font.GothamBold
    nameL.TextSize=22
    local hpBg=Instance.new("Frame",frame)
    hpBg.Size=UDim2.new(1,0,0.15,0)
    hpBg.Position=UDim2.new(0,0,0.45,0)
    hpBg.BackgroundColor3=Color3.new(0,0,0)
    local hp=Instance.new("Frame",hpBg)
    hp.Size=UDim2.new(1,0,1,0)
    hp.BackgroundColor3=Color3.fromRGB(0,255,0)
    local distL=Instance.new("TextLabel",frame)
    distL.Size=UDim2.new(1,0,0.35,0)
    distL.Position=UDim2.new(0,0,0.65,0)
    distL.BackgroundTransparency=1
    distL.TextColor3=Color3.new(1,1,1)
    distL.TextSize=16
    NameTags[player]={bb=bb,name=nameL,hp=hp,dist=distL}
end
local function UpdateESP()
    for _,plr in pairs(Players:GetPlayers()) do
        if plr==LocalPlayer then continue end
        local char=plr.Character
        if not char then continue end
        local head=char:FindFirstChild("Head")
        local root=char:FindFirstChild("HumanoidRootPart")
        local hum=char:FindFirstChildOfClass("Humanoid")
        if not head or not root or not hum then continue end
        if not NameTags[plr] then CreateTag(plr) end
        local tag=NameTags[plr]
        if not tag then continue end
        tag.bb.Enabled=S.esp
        if not S.esp then continue end
        tag.name.Text=plr.DisplayName
        local ratio=math.clamp(hum.Health/hum.MaxHealth,0,1)
        tag.hp.Size=UDim2.new(ratio,0,1,0)
        tag.hp.BackgroundColor3=Color3.fromRGB(255*(1-ratio),255*ratio,0)
        local lpRoot=getRoot()
        if lpRoot then tag.dist.Text=string.format("%.0f studs",(root.Position-lpRoot.Position).Magnitude) end
    end
end

-- ==================== ONGLET ACCUEIL ====================
local Home = Window:CreateTab("Accueil", 4483362458)
Home:CreateSection("LULUCLC3 ZENITH v49.0")
Home:CreateParagraph({Title="Bienvenue",Content="PC & Mobile optimise\nFly+Fling+ESP+Troll\nby Luluclc3"})
Home:CreateButton({Name="Liste des joueurs",Callback=function()
    local list=""
    for _,p in pairs(Players:GetPlayers()) do list=list.."- "..p.Name.."\n" end
    notify("Joueurs ("..#Players:GetPlayers()..")",list)
end})

-- ==================== ONGLET MOUVEMENT ====================
local Mov = Window:CreateTab("Mouvement", 4483362458)
Mov:CreateSection("Stats")
Mov:CreateSlider({Name="Vitesse",Range={16,600},Increment=5,CurrentValue=16,Flag="Speed",Callback=function(v) S.speed=v end})
Mov:CreateSlider({Name="Puissance Saut",Range={50,1000},Increment=10,CurrentValue=50,Flag="Jump",Callback=function(v) S.jump=v end})
Mov:CreateButton({Name="Reset Stats",Callback=function() S.speed=16;S.jump=50;notify("Reset","Stats reinitialisees !") end})
Mov:CreateSection("Options")
Mov:CreateToggle({Name="Noclip",CurrentValue=false,Flag="NC",Callback=function(v) S.noclip=v end})
Mov:CreateToggle({Name="Saut Infini",CurrentValue=false,Flag="IJ",Callback=function(v) S.infJump=v end})
Mov:CreateToggle({Name="Tornado Spin",CurrentValue=false,Flag="Spin",Callback=function(v) S.spin=v end})
Mov:CreateSlider({Name="Vitesse Spin",Range={10,200},Increment=5,CurrentValue=50,Flag="SpinSpd",Callback=function(v) S.spinSpeed=v end})
Mov:CreateSection("Gravite")
Mov:CreateSlider({Name="Gravite",Range={0,1000},Increment=5,CurrentValue=196,Flag="Grav",Callback=function(v) workspace.Gravity=v end})
Mov:CreateButton({Name="Gravite nulle",  Callback=function() workspace.Gravity=5;     notify("Gravite","Nulle !") end})
Mov:CreateButton({Name="Gravite normale",Callback=function() workspace.Gravity=196.2; notify("Gravite","Normale !") end})
Mov:CreateButton({Name="Super gravite",  Callback=function() workspace.Gravity=600;   notify("Gravite","x3 !") end})

-- ==================== ONGLET FLY ====================
local FlyTab = Window:CreateTab("Fly", 4483362458)
FlyTab:CreateSection("Vol")
FlyTab:CreateParagraph({Title=isMobile and "Mode Mobile" or "Mode PC",Content=isMobile and "Boutons tactiles a l'ecran" or "WASD+Space/Shift"})
FlyTab:CreateToggle({Name="Activer le Fly",CurrentValue=false,Flag="Fly",Callback=function(v) S.fly=v;ToggleFly(v) end})
FlyTab:CreateSlider({Name="Vitesse de vol",Range={30,400},Increment=10,CurrentValue=100,Flag="FlySpd",Callback=function(v) S.flySpeed=v end})

-- ==================== ONGLET TROLL ====================
local Troll = Window:CreateTab("Troll", 4483362458)
Troll:CreateSection("Chat")
Troll:CreateButton({Name="Spam Chat",Callback=function()
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
Troll:CreateInput({Name="Message Custom",PlaceholderText="Ton message...",RemoveTextAfterFocusLost=false,Flag="CMsg",Callback=function(t) customMsg=t end})
Troll:CreateButton({Name="Envoyer message",Callback=function()
    if customMsg=="" then return end
    local ev=game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
    if ev and ev:FindFirstChild("SayMessageRequest") then ev.SayMessageRequest:FireServer(customMsg,"All") end
    notify("Chat","Envoye !")
end})
Troll:CreateSection("Apparence")
Troll:CreateButton({Name="Invisible",Callback=function()
    local c=getChar();if not c then return end
    for _,p in pairs(c:GetDescendants()) do if p:IsA("BasePart") or p:IsA("Decal") then p.Transparency=1 end end
    notify("Apparence","Invisible !")
end})
Troll:CreateButton({Name="Visible",Callback=function()
    local c=getChar();if not c then return end
    for _,p in pairs(c:GetDescendants()) do if p:IsA("BasePart") then p.Transparency=0 end end
    notify("Apparence","Visible !")
end})
Troll:CreateButton({Name="Geant",Callback=function()
    local h=getHum();if not h then return end
    for _,s in pairs({"BodyDepthScale","BodyHeightScale","BodyWidthScale","HeadScale"}) do if h:FindFirstChild(s) then h[s].Value=3 end end
    notify("Taille","Geant !")
end})
Troll:CreateButton({Name="Mini",Callback=function()
    local h=getHum();if not h then return end
    for _,s in pairs({"BodyDepthScale","BodyHeightScale","BodyWidthScale","HeadScale"}) do if h:FindFirstChild(s) then h[s].Value=0.3 end end
    notify("Taille","Mini !")
end})
Troll:CreateButton({Name="Taille normale",Callback=function()
    local h=getHum();if not h then return end
    for _,s in pairs({"BodyDepthScale","BodyHeightScale","BodyWidthScale","HeadScale"}) do if h:FindFirstChild(s) then h[s].Value=1 end end
    notify("Taille","Normal !")
end})

-- ==================== ONGLET FLING ====================
local FlingTab = Window:CreateTab("Fling", 4483362458)
FlingTab:CreateSection("Fling Auto")
FlingTab:CreateToggle({Name="Fling Auto (proches)",CurrentValue=false,Flag="FlingAuto",Callback=function(v) S.fling=v end})
FlingTab:CreateSlider({Name="Puissance Fling",Range={50,500},Increment=10,CurrentValue=200,Flag="FlingPow",Callback=function(v) S.flingPow=v end})
FlingTab:CreateSection("Fling Cible")
local flingTarget=""
FlingTab:CreateInput({Name="Nom du joueur",PlaceholderText="Pseudo exact...",RemoveTextAfterFocusLost=false,Flag="FlingName",Callback=function(t) flingTarget=t end})
FlingTab:CreateButton({Name="Fling ce joueur",Callback=function()
    local plr=Players:FindFirstChild(flingTarget)
    if plr and plr.Character then FlingPlayer(plr.Character);notify("Fling","Fling sur "..flingTarget.." !")
    else notify("Erreur","Joueur introuvable.") end
end})

-- ==================== ONGLET ESP ====================
local EspTab = Window:CreateTab("ESP", 4483362458)
EspTab:CreateSection("ESP Visuel")
EspTab:CreateToggle({Name="ESP Activer",CurrentValue=false,Flag="ESP",Callback=function(v) S.esp=v end})
EspTab:CreateParagraph({Title="Infos",Content="Nom + HP + Distance\nVisible uniquement pour toi"})

-- ==================== ONGLET JOUEURS ====================
local PlrTab = Window:CreateTab("Joueurs", 4483362458)
local function RefreshPlayers()
    for _,plr in pairs(Players:GetPlayers()) do
        if plr==LocalPlayer then continue end
        PlrTab:CreateSection(plr.DisplayName)
        PlrTab:CreateButton({Name="TP vers "..plr.DisplayName,Callback=function()
            local lpRoot=getRoot()
            local tRoot=plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
            if lpRoot and tRoot then lpRoot.CFrame=tRoot.CFrame+Vector3.new(0,5,0);notify("TP","Teleporte vers "..plr.DisplayName.." !")
            else notify("Erreur","Joueur introuvable.") end
        end})
        PlrTab:CreateButton({Name="Fling "..plr.DisplayName,Callback=function()
            if plr.Character then FlingPlayer(plr.Character);notify("Fling","Fling sur "..plr.DisplayName.." !") end
        end})
    end
end
PlrTab:CreateButton({Name="Rafraichir liste",Callback=RefreshPlayers})
RefreshPlayers()

-- ==================== ONGLET WORLD ====================
local World = Window:CreateTab("World", 4483362458)
World:CreateSection("Heure")
World:CreateSlider({Name="Heure du jour",Range={0,24},Increment=1,Suffix="h",CurrentValue=14,Flag="Time",Callback=function(v) Lighting.ClockTime=v end})
World:CreateSection("Meteo")
World:CreateButton({Name="Journee",          Callback=function() Lighting.ClockTime=14;Lighting.Brightness=3;Lighting.FogEnd=100000 end})
World:CreateButton({Name="Nuit",             Callback=function() Lighting.ClockTime=0;Lighting.Brightness=0.3 end})
World:CreateButton({Name="Coucher de soleil",Callback=function() Lighting.ClockTime=18;Lighting.Brightness=1.5;Lighting.Ambient=Color3.fromRGB(255,100,50) end})
World:CreateButton({Name="Ambiance sang",    Callback=function() Lighting.FogColor=Color3.fromRGB(180,0,0);Lighting.FogEnd=200;Lighting.Brightness=0.4;Lighting.ClockTime=0 end})
World:CreateButton({Name="Brouillard epais", Callback=function() Lighting.FogEnd=50 end})
World:CreateButton({Name="Reset meteo",      Callback=function() Lighting.ClockTime=14;Lighting.Brightness=2;Lighting.FogEnd=100000;Lighting.Ambient=Color3.fromRGB(100,100,100);notify("Meteo","Reset !") end})

-- ==================== ONGLET PARAMETRES ====================
local Sett = Window:CreateTab("Parametres", 4483362458)
Sett:CreateSection("Info")
Sett:CreateParagraph({Title="LULUCLC3 ZENITH v49.0",Content="by Luluclc3\nPC & Mobile | Delta compatible"})
Sett:CreateSection("Reset")
Sett:CreateButton({Name="Tout reset",Callback=function()
    S.speed=16;S.jump=50;S.fly=false;S.noclip=false
    S.infJump=false;S.spin=false;S.esp=false;S.fling=false
    workspace.Gravity=196.2
    ToggleFly(false)
    local h=getHum()
    if h then h.WalkSpeed=16;h.JumpPower=50 end
    notify("Reset","Tout reinitialise !")
end})
Sett:CreateButton({Name="Fermer le menu",Callback=function() Rayfield:Destroy() end})

-- ==================== BOUCLE PRINCIPALE ====================
RunService.RenderStepped:Connect(function()
    local char=getChar();if not char then return end
    local hum=getHum();local root=getRoot()
    if hum then hum.WalkSpeed=S.speed;hum.JumpPower=S.jump end
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
    if S.fly and FlyBV and FlyBG and root and isMobile then
        if hum then
            local dir=hum.MoveDirection
            FlyBV.Velocity=dir.Magnitude>0 and dir.Unit*S.flySpeed or Vector3.zero
        end
        FlyBG.CFrame=Camera.CFrame
    end
    if S.noclip then
        for _,p in pairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end
    end
    if S.spin and root then root.CFrame=root.CFrame*CFrame.Angles(0,math.rad(S.spinSpeed),0) end
    if S.infJump and hum then hum.Jump=true end
    if S.esp then UpdateESP() end
end)

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

Rayfield:Notify({Title="LULUCLC3 ZENITH v49.0",Content="Charge ! by Luluclc3",Duration=6})
print("=== ZENITH v49.0 CHARGE ===")
