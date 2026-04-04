-- ══════════════════════════════════════════════════════
-- LULUCLC3 MENU v2.1 - RAYFIELD UI (PC + MOBILE)
-- by Luluclc3 • Amélioré & Nettoyé
-- ══════════════════════════════════════════════════════

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Charger Rayfield
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
   Name = "Luluclc3 Menu 👑 v2.1",
   LoadingTitle = "Luluclc3 Menu",
   LoadingSubtitle = "by Luluclc3 • Optimisé PC & Mobile",
   Theme = "Default",
   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,
})

-- Helpers
local function getChar() return LocalPlayer.Character end
local function getHum() local c = getChar() return c and c:FindFirstChildOfClass("Humanoid") end
local function getRoot() local c = getChar() return c and c:FindFirstChild("HumanoidRootPart") end

local function notify(title, content)
   Rayfield:Notify({ Title = title, Content = content, Duration = 3 })
end

-- ==================== ONGLET 1 : MOUVEMENT ====================
local MoveTab = Window:CreateTab("🏃 Mouvement", 4483362458)

MoveTab:CreateSection("⚡ Vitesse & Saut")
MoveTab:CreateSlider({ Name = "Vitesse de marche", Range = {16, 250}, Increment = 1, Suffix = " sp", CurrentValue = 16, Flag = "WalkSpeed",
   Callback = function(v) local h = getHum() if h then h.WalkSpeed = v end end })

MoveTab:CreateSlider({ Name = "Hauteur de saut", Range = {7, 200}, Increment = 1, Suffix = " jp", CurrentValue = 50, Flag = "JumpPower",
   Callback = function(v) local h = getHum() if h then h.JumpPower = v end end })

MoveTab:CreateButton({ Name = "🔄 Reset stats", Callback = function()
   local h = getHum()
   if h then h.WalkSpeed = 16; h.JumpPower = 50 end
   notify("Reset", "Vitesse et saut réinitialisés !")
end})

MoveTab:CreateSection("🐇 Bunny Hop")
local bhActive = false
MoveTab:CreateToggle({ Name = "Bunny Hop", CurrentValue = false, Flag = "BH",
   Callback = function(v)
      bhActive = v
      if v then
         task.spawn(function()
            while bhActive do
               task.wait(0.05)
               local h = getHum()
               if h and h.FloorMaterial ~= Enum.Material.Air then
                  h.Jump = true
               end
            end
         end)
      end
   end})

MoveTab:CreateSection("👻 Noclip")
local ncActive = false
MoveTab:CreateToggle({ Name = "Noclip", CurrentValue = false, Flag = "NC",
   Callback = function(v) ncActive = v end})

RunService.Stepped:Connect(function()
   if ncActive then
      local c = getChar()
      if c then
         for _, p in pairs(c:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
         end
      end
   end
end)

-- ==================== ONGLET 2 : FLY (PC + MOBILE) ====================
local FlyTab = Window:CreateTab("✈️ Fly", 4483362458)

local flyActive = false
local flySpeed = 60
local mobileUI = nil

local function removeMobileUI()
   if mobileUI then mobileUI:Destroy() mobileUI = nil end
end

local function createMobileUI()
   removeMobileUI()
   mobileUI = Instance.new("ScreenGui")
   mobileUI.Name = "FlyMobileUI"
   mobileUI.ResetOnSpawn = false
   mobileUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
   mobileUI.Parent = LocalPlayer:WaitForChild("PlayerGui")

   local buttons = {
      {name="▲ UP",  pos=UDim2.new(0,10,1,-240)},
      {name="▼ DN",  pos=UDim2.new(0,10,1,-160)},
      {name="◀ L",   pos=UDim2.new(0,10,1,-90)},
      {name="▶ R",   pos=UDim2.new(0,90,1,-90)},
      {name="▲ FWD", pos=UDim2.new(0,90,1,-240)},
      {name="▼ BCK", pos=UDim2.new(0,90,1,-160)},
   }

   local held = {}
   for _, b in ipairs(buttons) do
      local btn = Instance.new("TextButton")
      btn.Size = UDim2.new(0,70,0,70)
      btn.Position = b.pos
      btn.BackgroundColor3 = Color3.fromRGB(20,20,20)
      btn.BackgroundTransparency = 0.2
      btn.Text = b.name
      btn.TextColor3 = Color3.new(1,1,1)
      btn.Font = Enum.Font.GothamBold
      btn.TextSize = 12
      btn.ZIndex = 10
      Instance.new("UICorner", btn).CornerRadius = UDim.new(0,12)
      btn.Parent = mobileUI

      held[b.name] = false
      btn.InputBegan:Connect(function() held[b.name] = true end)
      btn.InputEnded:Connect(function() held[b.name] = false end)
   end

   task.spawn(function()
      while flyActive and mobileUI do
         task.wait()
         local root = getRoot()
         if root then
            local vel = Vector3.zero
            local cam = Camera.CFrame
            if held["▲ FWD"] then vel += cam.LookVector * flySpeed end
            if held["▼ BCK"] then vel -= cam.LookVector * flySpeed end
            if held["◀ L"]  then vel -= cam.RightVector * flySpeed end
            if held["▶ R"]  then vel += cam.RightVector * flySpeed end
            if held["▲ UP"] then vel += Vector3.new(0, flySpeed, 0) end
            if held["▼ DN"] then vel -= Vector3.new(0, flySpeed, 0) end

            local bv = root:FindFirstChild("FlyVel")
            if bv then bv.Velocity = vel end
         end
      end
   end)
end

FlyTab:CreateToggle({ Name = "Activer le Fly", CurrentValue = false, Flag = "FlyToggle",
   Callback = function(val)
      flyActive = val
      local root = getRoot()
      if not root then return end

      if val then
         -- BodyGyro + BodyVelocity
         local bg = Instance.new("BodyGyro", root)
         bg.Name = "FlyGyro"
         bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
         bg.P = 1e4

         local bv = Instance.new("BodyVelocity", root)
         bv.Name = "FlyVel"
         bv.MaxForce = Vector3.new(1e5,1e5,1e5)

         -- Mobile ou PC ?
         if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
            createMobileUI()
         else
            -- PC controls
            task.spawn(function()
               while flyActive do
                  task.wait()
                  local r = getRoot()
                  if not r then break end
                  local cam = Camera.CFrame
                  local vel = Vector3.zero

                  if UserInputService:IsKeyDown(Enum.KeyCode.W) then vel += cam.LookVector * flySpeed end
                  if UserInputService:IsKeyDown(Enum.KeyCode.S) then vel -= cam.LookVector * flySpeed end
                  if UserInputService:IsKeyDown(Enum.KeyCode.A) then vel -= cam.RightVector * flySpeed end
                  if UserInputService:IsKeyDown(Enum.KeyCode.D) then vel += cam.RightVector * flySpeed end
                  if UserInputService:IsKeyDown(Enum.KeyCode.Space) then vel += Vector3.new(0,flySpeed,0) end
                  if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then vel -= Vector3.new(0,flySpeed,0) end

                  local bv2 = r:FindFirstChild("FlyVel")
                  local bg2 = r:FindFirstChild("FlyGyro")
                  if bv2 then bv2.Velocity = vel end
                  if bg2 then bg2.CFrame = cam end
               end
            end)
         end
         notify("Fly", "✅ Fly activé !\nPC → WASD + Space/Shift\nMobile → boutons à l'écran")
      else
         removeMobileUI()
         if root:FindFirstChild("FlyGyro") then root.FlyGyro:Destroy() end
         if root:FindFirstChild("FlyVel") then root.FlyVel:Destroy() end
         notify("Fly", "Fly désactivé.")
      end
   end})

FlyTab:CreateSlider({ Name = "Vitesse de vol", Range = {10, 300}, Increment = 5, Suffix = " sp", CurrentValue = 60, Flag = "FlySpeed",
   Callback = function(v) flySpeed = v end })

-- ==================== ONGLET 3 : TROLL ====================
local TrollTab = Window:CreateTab("👻 Troll", 4483362458)

TrollTab:CreateSection("💬 Chat")
TrollTab:CreateButton({ Name = "Spam Chat 🔁", Callback = function()
   local msgs = {"gg 💀","lol","ez clap","bro what 😭","no way","fr fr","ratio","skill issue","💀💀💀"}
   task.spawn(function()
      for i = 1, 8 do
         task.wait(0.35)
         local ev = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
         if ev and ev:FindFirstChild("SayMessageRequest") then
            ev.SayMessageRequest:FireServer(msgs[math.random(1,#msgs)], "All")
         end
      end
   end)
   notify("Chat", "Spam envoyé !")
end})

TrollTab:CreateInput({ Name = "Message custom 📝", PlaceholderText = "Ton message...", RemoveTextAfterFocusLost = false, Callback = function(txt)
   if txt == "" then return end
   local ev = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
   if ev and ev:FindFirstChild("SayMessageRequest") then
      ev.SayMessageRequest:FireServer(txt, "All")
   end
end})

TrollTab:CreateSection("🎨 Apparence")
TrollTab:CreateButton({ Name = "Invisible 👁️", Callback = function()
   local c = getChar() if c then for _,p in pairs(c:GetDescendants()) do if p:IsA("BasePart") or p:IsA("Decal") then p.Transparency = 1 end end end
   notify("Apparence", "Tu es invisible !")
end})
TrollTab:CreateButton({ Name = "Visible 👀", Callback = function()
   local c = getChar() if c then for _,p in pairs(c:GetDescendants()) do if p:IsA("BasePart") then p.Transparency = 0 end end end
   notify("Apparence", "Tu es visible !")
end})

TrollTab:CreateButton({ Name = "Géant 🦕", Callback = function()
   local h = getHum() if h then
      h.BodyDepthScale.Value = 3; h.BodyHeightScale.Value = 3; h.BodyWidthScale.Value = 3; h.HeadScale.Value = 3
   end notify("Taille", "Tu es géant !") end})
TrollTab:CreateButton({ Name = "Mini 🐭", Callback = function()
   local h = getHum() if h then
      h.BodyDepthScale.Value = 0.3; h.BodyHeightScale.Value = 0.3; h.BodyWidthScale.Value = 0.3; h.HeadScale.Value = 0.3
   end notify("Taille", "Tu es tout petit !") end})
TrollTab:CreateButton({ Name = "Taille normale 📏", Callback = function()
   local h = getHum() if h then
      h.BodyDepthScale.Value = 1; h.BodyHeightScale.Value = 1; h.BodyWidthScale.Value = 1; h.HeadScale.Value = 1
   end notify("Taille", "Taille normale !") end})

TrollTab:CreateSection("🌍 Gravité")
TrollTab:CreateButton({ Name = "Gravité nulle 🌌", Callback = function() workspace.Gravity = 5 notify("Gravité","Gravité nulle !") end })
TrollTab:CreateButton({ Name = "Gravité normale 🌍", Callback = function() workspace.Gravity = 196.2 notify("Gravité","Normale !") end })
TrollTab:CreateButton({ Name = "Super gravité 🪨", Callback = function() workspace.Gravity = 600 notify("Gravité","Super gravité !") end })
TrollTab:CreateSlider({ Name = "Gravité custom", Range = {0, 1000}, Increment = 5, CurrentValue = 196, Callback = function(v) workspace.Gravity = v end })

-- ==================== ONGLET 4 : TÉLÉPORT ====================
local TpTab = Window:CreateTab("📍 Téléport", 4483362458)

TpTab:CreateButton({ Name = "TP au Spawn 🏠", Callback = function()
   local c = getChar() local s = workspace:FindFirstChild("SpawnLocation")
   if c and s then c:SetPrimaryPartCFrame(s.CFrame + Vector3.new(0,5,0)) end
   notify("TP","Téléporté au spawn !")
end})

TpTab:CreateButton({ Name = "TP aléatoire 🎲", Callback = function()
   local c = getChar()
   if c and c.PrimaryPart then
      c:SetPrimaryPartCFrame(CFrame.new(math.random(-300,300), 80, math.random(-300,300)))
   end
   notify("TP","TP aléatoire !")
end})

local tpLoop = false
TpTab:CreateToggle({ Name = "TP loop 🌀", CurrentValue = false, Callback = function(v)
   tpLoop = v
   if v then task.spawn(function()
      while tpLoop do
         task.wait(1.5)
         local c = getChar()
         if c and c.PrimaryPart then
            c:SetPrimaryPartCFrame(CFrame.new(math.random(-200,200), 50, math.random(-200,200)))
         end
      end
   end) end
end})

TpTab:CreateSection("🎯 TP vers joueur")
TpTab:CreateInput({ Name = "Nom du joueur", PlaceholderText = "Pseudo exact...", Callback = function(name)
   local target = Players:FindFirstChild(name)
   if target and target.Character and target.Character.PrimaryPart then
      local c = getChar()
      if c then c:SetPrimaryPartCFrame(target.Character.PrimaryPart.CFrame + Vector3.new(0,3,0)) end
      notify("TP","Téléporté vers "..name.." !")
   else
      notify("Erreur","Joueur introuvable.")
   end
end})

TpTab:CreateButton({ Name = "Liste des joueurs 📋", Callback = function()
   local list = ""
   for _, p in pairs(Players:GetPlayers()) do list = list.."• "..p.Name.."\n" end
   notify("Joueurs ("..#Players:GetPlayers()..")", list)
end})

-- ==================== ONGLET 5 : WORLD ====================
local WorldTab = Window:CreateTab("🌍 World", 4483362458)

WorldTab:CreateSection("🕐 Heure")
WorldTab:CreateSlider({ Name = "Heure du jour", Range = {0, 24}, Increment = 1, Suffix = "h", CurrentValue = 14,
   Callback = function(v) game:GetService("Lighting").ClockTime = v end })

WorldTab:CreateSection("🌤️ Météo rapide")
WorldTab:CreateButton({ Name = "☀️ Journée", Callback = function()
   local L = game:GetService("Lighting")
   L.ClockTime=14; L.Brightness=3; L.FogEnd=100000; L.Ambient=Color3.fromRGB(100,100,100)
end})
WorldTab:CreateButton({ Name = "🌙 Nuit", Callback = function()
   local L = game:GetService("Lighting")
   L.ClockTime=0; L.Brightness=0.3; L.Ambient=Color3.fromRGB(30,30,60)
end})
WorldTab:CreateButton({ Name = "🌅 Coucher de soleil", Callback = function()
   local L = game:GetService("Lighting")
   L.ClockTime=18; L.Brightness=1.5; L.Ambient=Color3.fromRGB(255,100,50)
end})
WorldTab:CreateButton({ Name = "🩸 Ambiance sang", Callback = function()
   local L = game:GetService("Lighting")
   L.FogColor=Color3.fromRGB(180,0,0); L.FogEnd=200; L.Brightness=0.4; L.ClockTime=0
end})
WorldTab:CreateButton({ Name = "🔆 Reset météo", Callback = function()
   local L = game:GetService("Lighting")
   L.ClockTime=14; L.Brightness=2; L.FogEnd=100000; L.Ambient=Color3.fromRGB(100,100,100)
   notify("Météo","Météo réinitialisée !")
end})

-- ==================== ONGLET 6 : PARAMÈTRES ====================
local SettTab = Window:CreateTab("⚙️ Paramètres", 4483362458)

SettTab:CreateSection("ℹ️ Info")
SettTab:CreateButton({ Name = "Luluclc3 Menu v2.1 👑", Callback = function()
   notify("Luluclc3 Menu", "Version 2.1\nOptimisé PC & Mobile\nby Luluclc3")
end})

SettTab:CreateSection("🔄 Reset global")
SettTab:CreateButton({ Name = "Tout reset 🔄", Callback = function()
   local h = getHum() if h then h.WalkSpeed=16; h.JumpPower=50 end
   workspace.Gravity = 196.2
   flyActive = false; bhActive = false; ncActive = false; tpLoop = false
   removeMobileUI()
   local root = getRoot()
   if root then
      if root:FindFirstChild("FlyGyro") then root.FlyGyro:Destroy() end
      if root:FindFirstChild("FlyVel") then root.FlyVel:Destroy() end
   end
   notify("Reset","Tout réinitialisé !")
end})

SettTab:CreateButton({ Name = "Fermer le menu ❌", Callback = function() Rayfield:Destroy() end })

-- Chargement de la config
Rayfield:LoadConfiguration()
