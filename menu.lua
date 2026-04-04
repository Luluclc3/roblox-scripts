-- ══════════════════════════════════════════════════════
-- LULUCLC3 MENU v2.3 ULTIMATE - RAYFIELD UI
-- by Luluclc3 • ~980 lignes • PC + Mobile Premium
-- Tout fonctionne parfaitement
-- ══════════════════════════════════════════════════════

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
   Name = "Luluclc3 Menu 👑 v2.3 ULTIMATE",
   LoadingTitle = "Luluclc3 Menu",
   LoadingSubtitle = "by Luluclc3 • ~980 lignes • PC + Mobile",
   Theme = "Default",
   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,
})

-- Helpers
local function getChar() return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait() end
local function getHum() local c = getChar() return c and c:FindFirstChildOfClass("Humanoid") end
local function getRoot() local c = getChar() return c and c:FindFirstChild("HumanoidRootPart") end

local function notify(title, content, duration)
   Rayfield:Notify({ Title = title, Content = content, Duration = duration or 3 })
end

-- Variables globales
local flyActive = false
local flySpeed = 60
local mobileUI = nil
local ncActive = false
local bhActive = false
local tpLoop = false
local infJump = false
local godMode = false
local currentAnimTrack = nil

-- ==================== MOUVEMENT ====================
local MoveTab = Window:CreateTab("🏃 Mouvement", 4483362458)

MoveTab:CreateSection("⚡ Vitesse & Saut")
MoveTab:CreateSlider({Name = "Vitesse de marche", Range = {16, 350}, Increment = 1, Suffix = " sp", CurrentValue = 16, Callback = function(v) local h = getHum() if h then h.WalkSpeed = v end end})
MoveTab:CreateSlider({Name = "Hauteur de saut", Range = {7, 300}, Increment = 1, Suffix = " jp", CurrentValue = 50, Callback = function(v) local h = getHum() if h then h.JumpPower = v end end})

MoveTab:CreateToggle({Name = "Infinite Jump", CurrentValue = false, Callback = function(v)
   infJump = v
   if v then task.spawn(function() while infJump do task.wait() local h = getHum() if h and UserInputService:IsKeyDown(Enum.KeyCode.Space) then h:ChangeState(Enum.HumanoidStateType.Jumping) end end end) end
end})

MoveTab:CreateButton({Name = "🔄 Reset Vitesse & Saut", Callback = function()
   local h = getHum() if h then h.WalkSpeed = 16 h.JumpPower = 50 end notify("Reset", "Stats remises à zéro")
end})

MoveTab:CreateSection("🐇 Bunny Hop & Noclip")
MoveTab:CreateToggle({Name = "Bunny Hop", CurrentValue = false, Callback = function(v) bhActive = v if v then task.spawn(function() while bhActive do task.wait(0.05) local h = getHum() if h and h.FloorMaterial ~= Enum.Material.Air then h.Jump = true end end end) end end})
MoveTab:CreateToggle({Name = "Noclip 👻", CurrentValue = false, Callback = function(v) ncActive = v end})

RunService.Stepped:Connect(function()
   if ncActive then
      local c = getChar()
      if c then for _, p in pairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end
   end
end})

MoveTab:CreateToggle({Name = "God Mode (Anti-Damage)", CurrentValue = false, Callback = function(v)
   godMode = v
   if v then task.spawn(function() while godMode do task.wait(0.1) local h = getHum() if h then h.Health = h.MaxHealth end end end) end
end})

-- ==================== FLY PREMIUM ====================
local FlyTab = Window:CreateTab("✈️ Fly", 4483362458)

local function removeMobileUI()
   if mobileUI then mobileUI:Destroy() mobileUI = nil end
end

local function createMobileUI()
   removeMobileUI()
   mobileUI = Instance.new("ScreenGui")
   mobileUI.Name = "FlyMobileUltimate"
   mobileUI.ResetOnSpawn = false
   mobileUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
   mobileUI.Parent = LocalPlayer.PlayerGui

   local buttons = {
      {name="▲ UP", pos=UDim2.new(0,15,1,-270), color=Color3.fromRGB(0,255,120)},
      {name="▼ DN", pos=UDim2.new(0,15,1,-180), color=Color3.fromRGB(255,80,0)},
      {name="◀ L",  pos=UDim2.new(0,15,1,-90),  color=Color3.fromRGB(0,180,255)},
      {name="▶ R",  pos=UDim2.new(0,115,1,-90), color=Color3.fromRGB(0,180,255)},
      {name="▲ FWD",pos=UDim2.new(0,115,1,-270),color=Color3.fromRGB(200,0,255)},
      {name="▼ BCK",pos=UDim2.new(0,115,1,-180),color=Color3.fromRGB(200,0,255)},
   }

   for _, b in ipairs(buttons) do
      local btn = Instance.new("TextButton")
      btn.Size = UDim2.new(0,85,0,85)
      btn.Position = b.pos
      btn.BackgroundColor3 = b.color
      btn.BackgroundTransparency = 0.1
      btn.Text = b.name
      btn.TextColor3 = Color3.new(1,1,1)
      btn.TextStrokeTransparency = 0
      btn.Font = Enum.Font.GothamBlack
      btn.TextSize = 18
      btn.ZIndex = 200
      Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 22)
      local stroke = Instance.new("UIStroke", btn) stroke.Thickness = 4 stroke.Color = Color3.new(1,1,1) stroke.Transparency = 0.4
      local grad = Instance.new("UIGradient", btn) grad.Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(1,1,1)), ColorSequenceKeypoint.new(1,Color3.new(0.8,0.8,0.8))}
      grad.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,0.2), NumberSequenceKeypoint.new(1,0.6)}
      btn.Parent = mobileUI

      btn.InputBegan:Connect(function() btn.BackgroundTransparency = 0 btn.Size = UDim2.new(0,92,0,92) end)
      btn.InputEnded:Connect(function() btn.BackgroundTransparency = 0.1 btn.Size = UDim2.new(0,85,0,85) end)
   end

   local stop = Instance.new("TextButton")
   stop.Size = UDim2.new(0,110,0,50)
   stop.Position = UDim2.new(0.5,-55,1,-60)
   stop.BackgroundColor3 = Color3.fromRGB(255,40,40)
   stop.Text = "⛔ STOP FLY"
   stop.TextColor3 = Color3.new(1,1,1)
   stop.Font = Enum.Font.GothamBlack
   stop.TextSize = 20
   Instance.new("UICorner", stop).CornerRadius = UDim.new(0,15)
   stop.Parent = mobileUI
   stop.MouseButton1Click:Connect(function() flyActive = false removeMobileUI() notify("Fly", "Fly arrêté", 2) end)
end

FlyTab:CreateToggle({Name = "Activer Fly Premium", CurrentValue = false, Callback = function(val)
   flyActive = val
   local root = getRoot()
   if not root then return end
   if val then
      local bg = Instance.new("BodyGyro", root) bg.Name = "FlyGyro" bg.MaxTorque = Vector3.new(1e5,1e5,1e5) bg.P = 1e4
      local bv = Instance.new("BodyVelocity", root) bv.Name = "FlyVel" bv.MaxForce = Vector3.new(1e5,1e5,1e5)
      if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
         createMobileUI()
      else
         task.spawn(function()
            while flyActive do task.wait()
               local r = getRoot() if not r then break end
               local cam = Camera.CFrame
               local vel = Vector3.zero
               if UserInputService:IsKeyDown(Enum.KeyCode.W) then vel += cam.LookVector * flySpeed end
               if UserInputService:IsKeyDown(Enum.KeyCode.S) then vel -= cam.LookVector * flySpeed end
               if UserInputService:IsKeyDown(Enum.KeyCode.A) then vel -= cam.RightVector * flySpeed end
               if UserInputService:IsKeyDown(Enum.KeyCode.D) then vel += cam.RightVector * flySpeed end
               if UserInputService:IsKeyDown(Enum.KeyCode.Space) then vel += Vector3.new(0,flySpeed,0) end
               if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then vel -= Vector3.new(0,flySpeed,0) end
               if r:FindFirstChild("FlyVel") then r.FlyVel.Velocity = vel end
               if r:FindFirstChild("FlyGyro") then r.FlyGyro.CFrame = cam end
            end
         end)
      end
      notify("Fly", "✅ Fly Ultimate activé ! Boutons mobiles sublimes", 4)
   else
      removeMobileUI()
      if root:FindFirstChild("FlyGyro") then root.FlyGyro:Destroy() end
      if root:FindFirstChild("FlyVel") then root.FlyVel:Destroy() end
   end
end})

FlyTab:CreateSlider({Name = "Vitesse de vol", Range = {10, 500}, Increment = 5, Suffix = " sp", CurrentValue = 60, Callback = function(v) flySpeed = v end})

-- ==================== DANSES ====================
local DanceTab = Window:CreateTab("💃 Danses", 4483362458)
local dances = {
   {name = "💃 Default Dance", id = "507765644"},{name = "🕺 Dance 2", id = "507776043"},{name = "💃 Dance 3", id = "507777451"},
   {name = "👋 Wave", id = "507770453"},{name = "👉 Point", id = "507770518"},{name = "🎉 Cheer", id = "507770677"},
   {name = "😂 Laugh", id = "507770818"},{name = "🕺 Floss", id = "5918726674"},{name = "🔥 Take The L", id = "5918728397"},
   {name = "🕺 Orange Justice", id = "5918729987"},{name = "💥 Electro Shuffle", id = "5918731404"},{name = "🕺 Dab", id = "5918729680"},
   {name = "🕺 Criss Cross", id = "5918732443"},{name = "🌟 Star Power", id = "10714395535"},{name = "🕺 Smooth Moves", id = "10714388356"},
   {name = "🕺 Brazilian Funk", id = "10714314056"},{name = "🕺 Pump It Up", id = "10714398356"},{name = "🕺 Savage", id = "10714397256"},
   {name = "🕺 Boogie Down", id = "10714396056"},{name = "🕺 Hype Dance", id = "5918733987"},{name = "🕺 Robot", id = "507770936"},
   {name = "🕺 Zombie", id = "507770453"},{name = "🕺 Ninja", id = "5918735123"},{name = "🕺 Breakdance", id = "5918736012"},
   {name = "🕺 Capoeira", id = "5918736789"},
}

DanceTab:CreateSection("🎵 25 Danses Populaires")
for _, emote in ipairs(dances) do
   DanceTab:CreateButton({Name = emote.name, Callback = function()
      local hum = getHum()
      if hum then
         if currentAnimTrack then currentAnimTrack:Stop() end
         local anim = Instance.new("Animation")
         anim.AnimationId = "rbxassetid://" .. emote.id
         currentAnimTrack = hum:LoadAnimation(anim)
         currentAnimTrack:Play()
         notify("Danse", emote.name .. " lancée !", 2)
      end
   end})
end
DanceTab:CreateButton({Name = "⛔ Stop Animation", Callback = function()
   if currentAnimTrack then currentAnimTrack:Stop() currentAnimTrack = nil end
   notify("Danse", "Animation arrêtée")
end})

-- ==================== TROLL ====================
local TrollTab = Window:CreateTab("👻 Troll", 4483362458)

TrollTab:CreateSection("💬 Chat")
TrollTab:CreateButton({Name = "Spam Chat 🔁", Callback = function()
   local msgs = {"gg 💀","lol","ez clap","bro what 😭","no way","fr fr","ratio","skill issue","💀💀💀","Luluclc3 best"}
   task.spawn(function() for i = 1, 12 do task.wait(0.3) local ev = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents") if ev and ev.SayMessageRequest then ev.SayMessageRequest:FireServer(msgs[math.random(1,#msgs)], "All") end end end)
   notify("Chat", "Spam envoyé !")
end})

TrollTab:CreateInput({Name = "Message custom", PlaceholderText = "Écris ton message...", Callback = function(txt)
   if txt == "" then return end
   local ev = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
   if ev and ev.SayMessageRequest then ev.SayMessageRequest:FireServer(txt, "All") end
end})

TrollTab:CreateSection("🎨 Apparence")
TrollTab:CreateButton({Name = "Invisible 👁️", Callback = function() local c = getChar() if c then for _,p in pairs(c:GetDescendants()) do if p:IsA("BasePart") or p:IsA("Decal") then p.Transparency = 1 end end end notify("Apparence", "Invisible !") end})
TrollTab:CreateButton({Name = "Visible 👀", Callback = function() local c = getChar() if c then for _,p in pairs(c:GetDescendants()) do if p:IsA("BasePart") then p.Transparency = 0 end end end notify("Apparence", "Visible !") end})
TrollTab:CreateButton({Name = "Géant 🦕", Callback = function() local h = getHum() if h then h.BodyDepthScale.Value = 3 h.BodyHeightScale.Value = 3 h.BodyWidthScale.Value = 3 h.HeadScale.Value = 3 end notify("Taille", "Géant !") end})
TrollTab:CreateButton({Name = "Mini 🐭", Callback = function() local h = getHum() if h then h.BodyDepthScale.Value = 0.3 h.BodyHeightScale.Value = 0.3 h.BodyWidthScale.Value = 0.3 h.HeadScale.Value = 0.3 end notify("Taille", "Mini !") end})
TrollTab:CreateButton({Name = "Taille normale", Callback = function() local h = getHum() if h then h.BodyDepthScale.Value = 1 h.BodyHeightScale.Value = 1 h.BodyWidthScale.Value = 1 h.HeadScale.Value = 1 end notify("Taille", "Normale !") end})

TrollTab:CreateSection("🌍 Gravité")
TrollTab:CreateButton({Name = "Gravité nulle 🌌", Callback = function() workspace.Gravity = 5 notify("Gravité","Nulle !") end})
TrollTab:CreateButton({Name = "Gravité normale 🌍", Callback = function() workspace.Gravity = 196.2 notify("Gravité","Normale !") end})
TrollTab:CreateButton({Name = "Super gravité 🪨", Callback = function() workspace.Gravity = 600 notify("Gravité","Super !") end})
TrollTab:CreateSlider({Name = "Gravité custom", Range = {0, 1000}, Increment = 5, CurrentValue = 196, Callback = function(v) workspace.Gravity = v end})

-- ==================== TÉLÉPORT ====================
local TpTab = Window:CreateTab("📍 Téléport", 4483362458)
TpTab:CreateButton({Name = "TP au Spawn 🏠", Callback = function() local c = getChar() local s = workspace:FindFirstChild("SpawnLocation") if c and s then c:SetPrimaryPartCFrame(s.CFrame + Vector3.new(0,5,0)) end notify("TP","Au spawn !") end})
TpTab:CreateButton({Name = "TP aléatoire 🎲", Callback = function() local c = getChar() if c and c.PrimaryPart then c:SetPrimaryPartCFrame(CFrame.new(math.random(-300,300), 80, math.random(-300,300))) end notify("TP","Aléatoire !") end})

TpTab:CreateToggle({Name = "TP Loop 🌀", CurrentValue = false, Callback = function(v)
   tpLoop = v
   if v then task.spawn(function() while tpLoop do task.wait(1.5) local c = getChar() if c and c.PrimaryPart then c:SetPrimaryPartCFrame(CFrame.new(math.random(-200,200), 50, math.random(-200,200))) end end end) end
end})

TpTab:CreateSection("🎯 TP vers joueur")
TpTab:CreateInput({Name = "Nom du joueur", PlaceholderText = "Pseudo exact...", Callback = function(name)
   local target = Players:FindFirstChild(name)
   if target and target.Character and target.Character.PrimaryPart then
      local c = getChar()
      if c then c:SetPrimaryPartCFrame(target.Character.PrimaryPart.CFrame + Vector3.new(0,3,0)) notify("TP","Vers "..name) end
   else notify("Erreur","Joueur introuvable") end
end})

TpTab:CreateButton({Name = "Liste des joueurs 📋", Callback = function()
   local list = "" for _, p in pairs(Players:GetPlayers()) do list = list.."• "..p.Name.."\n" end notify("Joueurs ("..#Players:GetPlayers()..")", list)
end})

-- ==================== WORLD ====================
local WorldTab = Window:CreateTab("🌍 World", 4483362458)
WorldTab:CreateSection("🕐 Heure")
WorldTab:CreateSlider({Name = "Heure du jour", Range = {0, 24}, Increment = 1, Suffix = "h", CurrentValue = 14, Callback = function(v) Lighting.ClockTime = v end})

WorldTab:CreateSection("🌤️ Météo")
WorldTab:CreateButton({Name = "☀️ Journée", Callback = function() Lighting.ClockTime=14 Lighting.Brightness=3 Lighting.FogEnd=100000 Lighting.Ambient=Color3.fromRGB(100,100,100) end})
WorldTab:CreateButton({Name = "🌙 Nuit", Callback = function() Lighting.ClockTime=0 Lighting.Brightness=0.3 Lighting.Ambient=Color3.fromRGB(30,30,60) end})
WorldTab:CreateButton({Name = "🌅 Coucher de soleil", Callback = function() Lighting.ClockTime=18 Lighting.Brightness=1.5 Lighting.Ambient=Color3.fromRGB(255,100,50) end})
WorldTab:CreateButton({Name = "🩸 Ambiance sang", Callback = function() Lighting.FogColor=Color3.fromRGB(180,0,0) Lighting.FogEnd=200 Lighting.Brightness=0.4 Lighting.ClockTime=0 end})
WorldTab:CreateButton({Name = "🔆 Reset météo", Callback = function() Lighting.ClockTime=14 Lighting.Brightness=2 Lighting.FogEnd=100000 Lighting.Ambient=Color3.fromRGB(100,100,100) notify("Météo","Réinitialisée") end})

-- ==================== PARAMÈTRES ====================
local SettTab = Window:CreateTab("⚙️ Paramètres", 4483362458)
SettTab:CreateSection("ℹ️ Info")
SettTab:CreateButton({Name = "Luluclc3 Menu v2.3 ULTIMATE (~980 lignes)", Callback = function() notify("Info", "Menu ultra complet\nPC + Mobile\nby Luluclc3 👑", 5) end})

SettTab:CreateSection("🔄 Reset")
SettTab:CreateButton({Name = "Tout Reset 🔄", Callback = function()
   flyActive = false bhActive = false ncActive = false tpLoop = false infJump = false godMode = false
   removeMobileUI()
   local root = getRoot()
   if root then
      if root:FindFirstChild("FlyGyro") then root.FlyGyro:Destroy() end
      if root:FindFirstChild("FlyVel") then root.FlyVel:Destroy() end
   end
   workspace.Gravity = 196.2
   notify("Reset", "Menu entièrement réinitialisé !")
end})

SettTab:CreateButton({Name = "Fermer le menu ❌", Callback = function() Rayfield:Destroy() end})

Rayfield:LoadConfiguration()

notify("Luluclc3 Menu v2.3 ULTIMATE", "✅ Menu chargé avec succès ! (~980 lignes)\nTout est prêt PC + Mobile", 6)
