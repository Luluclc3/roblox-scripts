-- ══════════════════════════════════════════════════════
--           LULUCLC3 MENU v2.0 - RAYFIELD UI
--                    by Luluclc3
-- ══════════════════════════════════════════════════════

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ── Charger Rayfield ──
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
   Name = "Luluclc3 Menu 👑",
   LoadingTitle = "Luluclc3 Menu",
   LoadingSubtitle = "by Luluclc3 • v2.0",
   Theme = "Default",
   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,
})

-- ══════════════════════════════════════
-- HELPERS
-- ══════════════════════════════════════
local function getChar()
   return LocalPlayer.Character
end
local function getHum()
   local c = getChar()
   return c and c:FindFirstChildOfClass("Humanoid")
end
local function getRoot()
   local c = getChar()
   return c and c:FindFirstChild("HumanoidRootPart")
end
local function notify(title, content)
   Rayfield:Notify({ Title = title, Content = content, Duration = 3 })
end

-- ══════════════════════════════════════
-- ONGLET 1 — MOUVEMENT 🏃
-- ══════════════════════════════════════
local MoveTab = Window:CreateTab("🏃 Mouvement", 4483362458)

-- Speed
MoveTab:CreateSection("⚡ Vitesse & Saut")
MoveTab:CreateSlider({
   Name = "Vitesse de marche",
   Range = {16, 250}, Increment = 1,
   Suffix = " sp", CurrentValue = 16,
   Flag = "WalkSpeed",
   Callback = function(v)
      local h = getHum()
      if h then h.WalkSpeed = v end
   end,
})
MoveTab:CreateSlider({
   Name = "Hauteur de saut",
   Range = {7, 200}, Increment = 1,
   Suffix = " jp", CurrentValue = 50,
   Flag = "JumpPower",
   Callback = function(v)
      local h = getHum()
      if h then h.JumpPower = v end
   end,
})
MoveTab:CreateButton({
   Name = "🔄 Reset stats",
   Callback = function()
      local h = getHum()
      if h then h.WalkSpeed = 16; h.JumpPower = 50 end
      notify("Reset", "Vitesse et saut réinitialisés !")
   end,
})

-- Bunny Hop
MoveTab:CreateSection("🐇 Bunny Hop")
local bhActive = false
MoveTab:CreateToggle({
   Name = "Bunny Hop",
   CurrentValue = false, Flag = "BH",
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
   end,
})

-- Noclip
MoveTab:CreateSection("👻 Noclip")
local ncActive = false
MoveTab:CreateToggle({
   Name = "Noclip",
   CurrentValue = false, Flag = "NC",
   Callback = function(v) ncActive = v end,
})
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

-- ══════════════════════════════════════
-- ONGLET 2 — FLY ✈️
-- ══════════════════════════════════════
local FlyTab = Window:CreateTab("✈️ Fly", 4483362458)

FlyTab:CreateSection("✈️ Voler")

local flyActive = false
local flySpeed = 60

-- Boutons mobiles
local flyButtons = {}
local function createMobileButton(name, pos)
   local btn = Instance.new("TextButton")
   btn.Size = UDim2.new(0, 70, 0, 70)
   btn.Position = pos
   btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
   btn.BackgroundTransparency = 0.3
   btn.TextColor3 = Color3.new(1,1,1)
   btn.Text = name
   btn.Font = Enum.Font.GothamBold
   btn.TextSize = 14
   btn.ZIndex = 10
   local corner = Instance.new("UICorner", btn)
   corner.CornerRadius = UDim.new(0, 10)
   btn.Parent = LocalPlayer.PlayerGui:FindFirstChild("ScreenGui") or Instance.new("ScreenGui", LocalPlayer.PlayerGui)
   return btn
end

local mobileUI
local function removeMobileUI()
   if mobileUI then mobileUI:Destroy(); mobileUI = nil end
end
local function createMobileUI()
   removeMobileUI()
   mobileUI = Instance.new("ScreenGui")
   mobileUI.Name = "FlyMobileUI"
   mobileUI.ResetOnSpawn = false
   mobileUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
   mobileUI.Parent = LocalPlayer.PlayerGui

   local btns = {
      {name="▲ UP",   pos=UDim2.new(0, 10, 1, -240)},
      {name="▼ DN",   pos=UDim2.new(0, 10, 1, -160)},
      {name="◀ L",    pos=UDim2.new(0, 10, 1, -90)},
      {name="▶ R",    pos=UDim2.new(0, 90, 1, -90)},
      {name="▲ FWD",  pos=UDim2.new(0, 90, 1, -240)},
      {name="▼ BCK",  pos=UDim2.new(0, 90, 1, -160)},
   }

   local held = {}
   for _, b in pairs(btns) do
      local btn = Instance.new("TextButton")
      btn.Size = UDim2.new(0, 70, 0, 70)
      btn.Position = b.pos
      btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
      btn.BackgroundTransparency = 0.2
      btn.TextColor3 = Color3.new(1,1,1)
      btn.Text = b.name
      btn.Font = Enum.Font.GothamBold
      btn.TextSize = 12
      btn.ZIndex = 10
      Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
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
            if held["▲ FWD"] then vel = vel + cam.LookVector * flySpeed end
            if held["▼ BCK"] then vel = vel - cam.LookVector * flySpeed end
            if held["◀ L"]   then vel = vel - cam.RightVector * flySpeed end
            if held["▶ R"]   then vel = vel + cam.RightVector * flySpeed end
            if held["▲ UP"]  then vel = vel + Vector3.new(0, flySpeed, 0) end
            if held["▼ DN"]  then vel = vel - Vector3.new(0, flySpeed, 0) end
            local bv = root:FindFirstChild("FlyVel")
            if bv then bv.Velocity = vel end
         end
      end
   end)
end

FlyTab:CreateToggle({
   Name = "Activer le Fly",
   CurrentValue = false, Flag = "FlyToggle",
   Callback = function(val)
      flyActive = val
      local root = getRoot()
      if not root then return end

      if val then
         -- PC
         local bg = Instance.new("BodyGyro", root)
         bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
         bg.P = 1e4; bg.Name = "FlyGyro"
         local bv = Instance.new("BodyVelocity", root)
         bv.Velocity = Vector3.zero
         bv.MaxForce = Vector3.new(1e5,1e5,1e5)
         bv.Name = "FlyVel"

         -- Détection mobile
         if UIS.TouchEnabled and not UIS.KeyboardEnabled then
            createMobileUI()
         else
            task.spawn(function()
               while flyActive do
                  task.wait()
                  local r = getRoot()
                  if not r then break end
                  local cam = Camera.CFrame
                  local vel = Vector3.zero
                  if UIS:IsKeyDown(Enum.KeyCode.W) then vel += cam.LookVector * flySpeed end
                  if UIS:IsKeyDown(Enum.KeyCode.S) then vel -= cam.LookVector * flySpeed end
                  if UIS:IsKeyDown(Enum.KeyCode.A) then vel -= cam.RightVector * flySpeed end
                  if UIS:IsKeyDown(Enum.KeyCode.D) then vel += cam.RightVector * flySpeed end
                  if UIS:IsKeyDown(Enum.KeyCode.Space) then vel += Vector3.new(0, flySpeed, 0) end
                  if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then vel -= Vector3.new(0, flySpeed, 0) end
                  local bv2 = r:FindFirstChild("FlyVel")
                  if bv2 then bv2.Velocity = vel end
                  local bg2 = r:FindFirstChild("FlyGyro")
                  if bg2 then bg2.CFrame = cam end
               end
            end)
         end
         notify("Fly", "Fly activé !\nPC: WASD + Space/Shift\nMobile: boutons à l'écran")
      else
         removeMobileUI()
         if root:FindFirstChild("FlyGyro") then root.FlyGyro:Destroy() end
         if root:FindFirstChild("FlyVel") then root.FlyVel:Destroy() end
         notify("Fly", "Fly désactivé.")
      end
   end,
})

FlyTab:CreateSlider({
   Name = "Vitesse de vol",
   Range = {10, 300}, Increment = 5,
   Suffix = " sp", CurrentValue = 60,
   Flag = "FlySpeed",
   Callback = function(v) flySpeed = v end,
})

-- ══════════════════════════════════════
-- ONGLET 3 — TROLL 👻
-- ══════════════════════════════════════
local TrollTab = Window:CreateTab("👻 Troll", 4483362458)

-- Chat
TrollTab:CreateSection("💬 Chat")
TrollTab:CreateButton({
   Name = "Spam Chat 🔁",
   Callback = function()
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
   end,
})
TrollTab:CreateInput({
   Name = "Message custom 📝",
   PlaceholderText = "Ton message...",
   RemoveTextAfterFocusLost = false,
   Flag = "CustomMsg",
   Callback = function(txt)
      if txt == "" then return end
      local ev = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
      if ev and ev:FindFirstChild("SayMessageRequest") then
         ev.SayMessageRequest:FireServer(txt, "All")
      end
   end,
})

-- Apparence
TrollTab:CreateSection("🎨 Apparence")
TrollTab:CreateButton({
   Name = "Invisible 👁️",
   Callback = function()
      local c = getChar()
      if c then
         for _, p in pairs(c:GetDescendants()) do
            if p:IsA("BasePart") or p:IsA("Decal") then p.Transparency = 1 end
         end
      end
      notify("Apparence", "Tu es invisible !")
   end,
})
TrollTab:CreateButton({
   Name = "Visible 👀",
   Callback = function()
      local c = getChar()
      if c then
         for _, p in pairs(c:GetDescendants()) do
            if p:IsA("BasePart") then p.Transparency = 0 end
         end
      end
      notify("Apparence", "Tu es visible !")
   end,
})
TrollTab:CreateButton({
   Name = "Géant 🦕",
   Callback = function()
      local h = getHum()
      if h then h.BodyDepthScale.Value = 3; h.BodyHeightScale.Value = 3; h.BodyWidthScale.Value = 3; h.HeadScale.Value = 3 end
      notify("Taille", "Tu es géant !")
   end,
})
TrollTab:CreateButton({
   Name = "Mini 🐭",
   Callback = function()
      local h = getHum()
      if h then h.BodyDepthScale.Value = 0.3; h.BodyHeightScale.Value = 0.3; h.BodyWidthScale.Value = 0.3; h.HeadScale.Value = 0.3 end
      notify("Taille", "Tu es tout petit !")
   end,
})
TrollTab:CreateButton({
   Name = "Taille normale 📏",
   Callback = function()
      local h = getHum()
      if h then h.BodyDepthScale.Value = 1; h.BodyHeightScale.Value = 1; h.BodyWidthScale.Value = 1; h.HeadScale.Value = 1 end
      notify("Taille", "Taille normale !")
   end,
})

-- Gravité
TrollTab:CreateSection("🌍 Gravité")
TrollTab:CreateButton({ Name = "Gravité nulle 🌌", Callback = function() workspace.Gravity = 5; notify("Gravité","Gravité nulle !") end })
TrollTab:CreateButton({ Name = "Gravité normale 🌍", Callback = function() workspace.Gravity = 196.2; notify("Gravité","Normale !") end })
TrollTab:CreateButton({ Name = "Super gravité 🪨", Callback = function() workspace.Gravity = 600; notify("Gravité","Super gravité !") end })
TrollTab:CreateSlider({
   Name = "Gravité custom",
   Range = {0, 1000}, Increment = 5,
   Suffix = "", CurrentValue = 196,
   Flag = "GravSlider",
   Callback = function(v) workspace.Gravity = v end,
})

-- ══════════════════════════════════════
-- ONGLET 4 — TP 📍
-- ══════════════════════════════════════
local TpTab = Window:CreateTab("📍 Téléport", 4483362458)

TpTab:CreateSection("📍 Téléportation")
TpTab:CreateButton({
   Name = "TP au Spawn 🏠",
   Callback = function()
      local c = getChar()
      local s = workspace:FindFirstChild("SpawnLocation")
      if c and s then c:SetPrimaryPartCFrame(s.CFrame + Vector3.new(0,5,0)) end
      notify("TP","Téléporté au spawn !")
   end,
})
TpTab:CreateButton({
   Name = "TP aléatoire 🎲",
   Callback = function()
      local c = getChar()
      if c and c.PrimaryPart then
         c:SetPrimaryPartCFrame(CFrame.new(math.random(-300,300), 80, math.random(-300,300)))
      end
      notify("TP","TP aléatoire !")
   end,
})

local tpLoop = false
TpTab:CreateToggle({
   Name = "TP loop 🌀",
   CurrentValue = false, Flag = "TpLoop",
   Callback = function(v)
      tpLoop = v
      if v then
         task.spawn(function()
            while tpLoop do
               task.wait(1.5)
               local c = getChar()
               if c and c.PrimaryPart then
                  c:SetPrimaryPartCFrame(CFrame.new(math.random(-200,200), 50, math.random(-200,200)))
               end
            end
         end)
      end
   end,
})

TpTab:CreateSection("🎯 TP vers joueur")
TpTab:CreateInput({
   Name = "Nom du joueur",
   PlaceholderText = "Pseudo exact...",
   RemoveTextAfterFocusLost = false,
   Flag = "TpPlayer",
   Callback = function(name)
      local target = Players:FindFirstChild(name)
      if target and target.Character and target.Character.PrimaryPart then
         local c = getChar()
         if c then
            c:SetPrimaryPartCFrame(target.Character.PrimaryPart.CFrame + Vector3.new(0,3,0))
            notify("TP","Téléporté vers "..name.." !")
         end
      else
         notify("Erreur","Joueur introuvable.")
      end
   end,
})
TpTab:CreateButton({
   Name = "Liste des joueurs 📋",
   Callback = function()
      local list = ""
      for _, p in pairs(Players:GetPlayers()) do
         list = list.."• "..p.Name.."\n"
      end
      notify("Joueurs ("..#Players:GetPlayers()..")", list)
   end,
})

-- ══════════════════════════════════════
-- ONGLET 5 — WORLD 🌍
-- ══════════════════════════════════════
local WorldTab = Window:CreateTab("🌍 World", 4483362458)

WorldTab:CreateSection("🕐 Heure")
WorldTab:CreateSlider({
   Name = "Heure du jour",
   Range = {0, 24}, Increment = 1,
   Suffix = "h", CurrentValue = 14,
   Flag = "TimeSlider",
   Callback = function(v) game:GetService("Lighting").ClockTime = v end,
})

WorldTab:CreateSection("🌤️ Météo rapide")
WorldTab:CreateButton({ Name = "☀️ Journée", Callback = function()
   local L = game:GetService("Lighting")
   L.ClockTime=14; L.Brightness=3; L.FogEnd=100000; L.Ambient=Color3.fromRGB(100,100,100)
end })
WorldTab:CreateButton({ Name = "🌙 Nuit", Callback = function()
   local L = game:GetService("Lighting")
   L.ClockTime=0; L.Brightness=0.3; L.Ambient=Color3.fromRGB(30,30,60)
end })
WorldTab:CreateButton({ Name = "🌅 Coucher de soleil", Callback = function()
   local L = game:GetService("Lighting")
   L.ClockTime=18; L.Brightness=1.5; L.Ambient=Color3.fromRGB(255,100,50)
end })
WorldTab:CreateButton({ Name = "🩸 Ambiance sang", Callback = function()
   local L = game:GetService("Lighting")
   L.FogColor=Color3.fromRGB(180,0,0); L.FogEnd=200; L.Brightness=0.4; L.ClockTime=0
end })
WorldTab:CreateButton({ Name = "🌫️ Brouillard", Callback = function()
   local L = game:GetService("Lighting")
   L.FogEnd=50; L.FogColor=Color3.fromRGB(200,200,200)
end })
WorldTab:CreateButton({ Name = "🔆 Reset météo", Callback = function()
   local L = game:GetService("Lighting")
   L.ClockTime=14; L.Brightness=2; L.FogEnd=100000; L.Ambient=Color3.fromRGB(100,100,100)
   notify("Météo","Météo réinitialisée !")
end })

-- ══════════════════════════════════════
-- ONGLET 6 — PARAMÈTRES ⚙️
-- ══════════════════════════════════════
local SettTab = Window:CreateTab("⚙️ Paramètres", 4483362458)

SettTab:CreateSection("ℹ️ Info")
SettTab:CreateButton({
   Name = "Luluclc3 Menu v2.0 👑",
   Callback = function()
      notify("Luluclc3 Menu", "Version 2.0\nDéveloppé par Luluclc3 👑\nOptimisé PC & Mobile")
   end,
})

SettTab:CreateSection("🔄 Reset global")
SettTab:CreateButton({
   Name = "Tout reset 🔄",
   Callback = function()
      local h = getHum()
      if h then h.WalkSpeed=16; h.JumpPower=50 end
      workspace.Gravity = 196.2
      flyActive = false; bhActive = false; ncActive = false; tpLoop = false
      removeMobileUI()
      local root = getRoot()
      if root then
         if root:FindFirstChild("FlyGyro") then root.FlyGyro:Destroy() end
         if root:FindFirstChild("FlyVel") then root.FlyVel:Destroy() end
      end
      notify("Reset","Tout a été réinitialisé !")
   end,
})
SettTab:CreateButton({
   Name = "Fermer le menu ❌",
   Callback = function() Rayfield:Destroy() end,
})

Rayfield:LoadConfiguration()   Callback = function(val)
      jumpLoop = val
      if val then
         task.spawn(function()
            while jumpLoop do
               task.wait(0.05)
               local char = LocalPlayer.Character
               if char then
                  local hum = char:FindFirstChildOfClass("Humanoid")
                  if hum and hum.FloorMaterial ~= Enum.Material.Air then
                     hum.Jump = true
                  end
               end
            end
         end)
      end
   end,
})

TrollTab:CreateSlider({
   Name = "Vitesse 🏃",
   Range = {16, 250},
   Increment = 1,
   Suffix = " studs/s",
   CurrentValue = 16,
   Flag = "WalkSpeed",
   Callback = function(val)
      local char = LocalPlayer.Character
      if char then
         local hum = char:FindFirstChildOfClass("Humanoid")
         if hum then hum.WalkSpeed = val end
      end
   end,
})

TrollTab:CreateSlider({
   Name = "Hauteur de saut 🦘",
   Range = {7, 150},
   Increment = 1,
   Suffix = " power",
   CurrentValue = 7,
   Flag = "JumpPower",
   Callback = function(val)
      local char = LocalPlayer.Character
      if char then
         local hum = char:FindFirstChildOfClass("Humanoid")
         if hum then hum.JumpPower = val end
      end
   end,
})

local noclipActive = false
TrollTab:CreateToggle({
   Name = "Noclip 👻",
   CurrentValue = false,
   Flag = "Noclip",
   Callback = function(val) noclipActive = val end,
})

RunService.Stepped:Connect(function()
   if noclipActive then
      local char = LocalPlayer.Character
      if char then
         for _, p in pairs(char:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
         end
      end
   end
end)

local flyActive = false
local flyBody
TrollTab:CreateToggle({
   Name = "Fly ✈️",
   CurrentValue = false,
   Flag = "Fly",
   Callback = function(val)
      flyActive = val
      local char = LocalPlayer.Character
      if not char then return end
      local root = char:FindFirstChild("HumanoidRootPart")
      if not root then return end
      if val then
         local bg = Instance.new("BodyGyro", root)
         bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
         bg.P = 1e4
         bg.Name = "FlyGyro"
         local bv = Instance.new("BodyVelocity", root)
         bv.Velocity = Vector3.zero
         bv.MaxForce = Vector3.new(1e5,1e5,1e5)
         bv.Name = "FlyVel"
         task.spawn(function()
            while flyActive and char and root do
               task.wait()
               local cam = Camera.CFrame
               local vel = Vector3.zero
               local uis = game:GetService("UserInputService")
               if uis:IsKeyDown(Enum.KeyCode.W) then vel = vel + cam.LookVector * 60 end
               if uis:IsKeyDown(Enum.KeyCode.S) then vel = vel - cam.LookVector * 60 end
               if uis:IsKeyDown(Enum.KeyCode.A) then vel = vel - cam.RightVector * 60 end
               if uis:IsKeyDown(Enum.KeyCode.D) then vel = vel + cam.RightVector * 60 end
               if uis:IsKeyDown(Enum.KeyCode.Space) then vel = vel + Vector3.new(0,60,0) end
               if uis:IsKeyDown(Enum.KeyCode.LeftShift) then vel = vel - Vector3.new(0,60,0) end
               root.FlyVel.Velocity = vel
               root.FlyGyro.CFrame = cam
            end
         end)
      else
         if root:FindFirstChild("FlyGyro") then root.FlyGyro:Destroy() end
         if root:FindFirstChild("FlyVel") then root.FlyVel:Destroy() end
      end
   end,
})

-- ───── GRAVITÉ ─────
TrollTab:CreateSection("🌍 Gravité")

TrollTab:CreateButton({
   Name = "Gravité nulle 🌌",
   Callback = function()
      workspace.Gravity = 5
      Rayfield:Notify({ Title = "Gravité", Content = "Gravité nulle activée !", Duration = 3 })
   end,
})
TrollTab:CreateButton({
   Name = "Gravité normale 🌍",
   Callback = function()
      workspace.Gravity = 196.2
      Rayfield:Notify({ Title = "Gravité", Content = "Gravité restaurée.", Duration = 3 })
   end,
})
TrollTab:CreateButton({
   Name = "Super gravité 🪨",
   Callback = function()
      workspace.Gravity = 600
      Rayfield:Notify({ Title = "Gravité", Content = "Super gravité !", Duration = 3 })
   end,
})
TrollTab:CreateSlider({
   Name = "Gravité personnalisée",
   Range = {0, 1000},
   Increment = 5,
   Suffix = "",
   CurrentValue = 196,
   Flag = "GravitySlider",
   Callback = function(val)
      workspace.Gravity = val
   end,
})

-- ───── TROLL SERVEUR ─────
TrollTab:CreateSection("💥 Troll Serveur")

TrollTab:CreateButton({
   Name = "Faire danser tout le monde 🕺",
   Callback = function()
      local emotes = {"Animate", "Dance", "Dance2", "Dance3"}
      for _, plr in pairs(Players:GetPlayers()) do
         if plr ~= LocalPlayer then
            local char = plr.Character
            if char then
               local hum = char:FindFirstChildOfClass("Humanoid")
               if hum then
                  hum.Jump = true
               end
            end
         end
      end
      Rayfield:Notify({ Title = "Troll", Content = "Tout le monde saute !", Duration = 3 })
   end,
})

TrollTab:CreateButton({
   Name = "Sauter en boucle TOUS 🦘",
   Callback = function()
      task.spawn(function()
         for i = 1, 10 do
            task.wait(0.3)
            for _, plr in pairs(Players:GetPlayers()) do
               local char = plr.Character
               if char then
                  local hum = char:FindFirstChildOfClass("Humanoid")
                  if hum then hum.Jump = true end
               end
            end
         end
      end)
      Rayfield:Notify({ Title = "Troll", Content = "Tout le monde saute x10 !", Duration = 3 })
   end,
})

TrollTab:CreateButton({
   Name = "TP aléatoire tous les joueurs 🌀",
   Callback = function()
      for _, plr in pairs(Players:GetPlayers()) do
         local char = plr.Character
         if char and char.PrimaryPart then
            local rx = math.random(-500, 500)
            local rz = math.random(-500, 500)
            char:SetPrimaryPartCFrame(CFrame.new(rx, 50, rz))
         end
      end
      Rayfield:Notify({ Title = "Troll", Content = "Joueurs TP aléatoirement !", Duration = 3 })
   end,
})

TrollTab:CreateButton({
   Name = "Éteindre les lumières 🌑",
   Callback = function()
      game:GetService("Lighting").Brightness = 0
      game:GetService("Lighting").ClockTime = 0
      Rayfield:Notify({ Title = "Troll", Content = "Il fait nuit noire !", Duration = 3 })
   end,
})

TrollTab:CreateButton({
   Name = "Lumières normales ☀️",
   Callback = function()
      game:GetService("Lighting").Brightness = 2
      game:GetService("Lighting").ClockTime = 14
      Rayfield:Notify({ Title = "Troll", Content = "Lumières restaurées.", Duration = 3 })
   end,
})

TrollTab:CreateButton({
   Name = "Brouillard épais 🌫️",
   Callback = function()
      game:GetService("Lighting").FogEnd = 50
      game:GetService("Lighting").FogColor = Color3.fromRGB(200, 200, 200)
      Rayfield:Notify({ Title = "Troll", Content = "Brouillard activé !", Duration = 3 })
   end,
})

TrollTab:CreateButton({
   Name = "Supprimer brouillard 🔆",
   Callback = function()
      game:GetService("Lighting").FogEnd = 100000
      Rayfield:Notify({ Title = "Troll", Content = "Brouillard supprimé.", Duration = 3 })
   end,
})

TrollTab:CreateButton({
   Name = "Pluie rouge 🩸",
   Callback = function()
      game:GetService("Lighting").FogColor = Color3.fromRGB(180, 0, 0)
      game:GetService("Lighting").FogEnd = 200
      game:GetService("Lighting").Brightness = 0.5
      game:GetService("Lighting").ClockTime = 0
      Rayfield:Notify({ Title = "Troll", Content = "Ambiance sang activée !", Duration = 3 })
   end,
})

-- ───── TROLL CHAT ─────
TrollTab:CreateSection("💬 Chat")

TrollTab:CreateButton({
   Name = "Spam Chat 🔁",
   Callback = function()
      local msgs = {"gg", "lol 💀", "ez clap", "bro what 😭", "no way", "fr fr", "ratio", "skill issue"}
      task.spawn(function()
         for i = 1, 8 do
            task.wait(0.4)
            local chat = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
            if chat and chat:FindFirstChild("SayMessageRequest") then
               chat.SayMessageRequest:FireServer(msgs[math.random(1, #msgs)], "All")
            end
         end
      end)
      Rayfield:Notify({ Title = "Chat", Content = "Spam envoyé !", Duration = 3 })
   end,
})

TrollTab:CreateInput({
   Name = "Message personnalisé 📝",
   PlaceholderText = "Tape ton message...",
   RemoveTextAfterFocusLost = false,
   Flag = "CustomMsg",
   Callback = function(text)
      local chat = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
      if chat and chat:FindFirstChild("SayMessageRequest") then
         chat.SayMessageRequest:FireServer(text, "All")
      end
   end,
})

-- ───── APPARENCE ─────
TrollTab:CreateSection("🎨 Apparence")

TrollTab:CreateButton({
   Name = "Personnage invisible 👁️",
   Callback = function()
      local char = LocalPlayer.Character
      if char then
         for _, p in pairs(char:GetDescendants()) do
            if p:IsA("BasePart") or p:IsA("Decal") then
               p.Transparency = 1
            end
         end
      end
      Rayfield:Notify({ Title = "Apparence", Content = "Tu es invisible !", Duration = 3 })
   end,
})

TrollTab:CreateButton({
   Name = "Redevenir visible 👀",
   Callback = function()
      local char = LocalPlayer.Character
      if char then
         for _, p in pairs(char:GetDescendants()) do
            if p:IsA("BasePart") then p.Transparency = 0 end
         end
      end
      Rayfield:Notify({ Title = "Apparence", Content = "Tu es visible !", Duration = 3 })
   end,
})

TrollTab:CreateButton({
   Name = "Taille géante 🦕",
   Callback = function()
      local char = LocalPlayer.Character
      if char then
         for _, p in pairs(char:GetDescendants()) do
            if p:IsA("BasePart") then
               p.Size = p.Size * 3
            end
         end
      end
      Rayfield:Notify({ Title = "Apparence", Content = "Tu es géant !", Duration = 3 })
   end,
})

TrollTab:CreateButton({
   Name = "Taille mini 🐭",
   Callback = function()
      local char = LocalPlayer.Character
      if char then
         for _, p in pairs(char:GetDescendants()) do
            if p:IsA("BasePart") then
               p.Size = p.Size * 0.3
            end
         end
      end
      Rayfield:Notify({ Title = "Apparence", Content = "Tu es tout petit !", Duration = 3 })
   end,
})

-- ───── TÉLÉPORTATION ─────
TrollTab:CreateSection("📍 Téléportation")

TrollTab:CreateButton({
   Name = "TP au Spawn 🏠",
   Callback = function()
      local char = LocalPlayer.Character
      local spawn = workspace:FindFirstChild("SpawnLocation")
      if char and spawn then
         char:SetPrimaryPartCFrame(spawn.CFrame + Vector3.new(0, 5, 0))
      end
      Rayfield:Notify({ Title = "TP", Content = "Téléporté au spawn !", Duration = 3 })
   end,
})

TrollTab:CreateButton({
   Name = "TP random 🎲",
   Callback = function()
      local char = LocalPlayer.Character
      if char and char.PrimaryPart then
         local rx = math.random(-300, 300)
         local rz = math.random(-300, 300)
         char:SetPrimaryPartCFrame(CFrame.new(rx, 100, rz))
      end
      Rayfield:Notify({ Title = "TP", Content = "TP aléatoire !", Duration = 3 })
   end,
})

local tpLoop = false
TrollTab:CreateToggle({
   Name = "TP loop partout 🌀",
   CurrentValue = false,
   Flag = "TpLoop",
   Callback = function(val)
      tpLoop = val
      if val then
         task.spawn(function()
            while tpLoop do
               task.wait(1)
               local char = LocalPlayer.Character
               if char and char.PrimaryPart then
                  char:SetPrimaryPartCFrame(CFrame.new(math.random(-200,200), 50, math.random(-200,200)))
               end
            end
         end)
      end
   end,
})

-- ══════════════════════════════
--        ONGLET WORLD
-- ══════════════════════════════
local WorldTab = Window:CreateTab("🌍 World", 4483362458)

WorldTab:CreateSection("🕐 Heure")

WorldTab:CreateSlider({
   Name = "Heure du jour",
   Range = {0, 24},
   Increment = 1,
   Suffix = "h",
   CurrentValue = 14,
   Flag = "TimeSlider",
   Callback = function(val)
      game:GetService("Lighting").ClockTime = val
   end,
})

WorldTab:CreateSection("🌤️ Météo")

WorldTab:CreateButton({
   Name = "Jour ensoleillé ☀️",
   Callback = function()
      local L = game:GetService("Lighting")
      L.ClockTime = 14
      L.Brightness = 3
      L.FogEnd = 100000
      L.Ambient = Color3.fromRGB(100,100,100)
   end,
})

WorldTab:CreateButton({
   Name = "Nuit étoilée 🌙",
   Callback = function()
      local L = game:GetService("Lighting")
      L.ClockTime = 0
      L.Brightness = 0.3
      L.Ambient = Color3.fromRGB(30,30,60)
   end,
})

WorldTab:CreateButton({
   Name = "Coucher de soleil 🌅",
   Callback = function()
      local L = game:GetService("Lighting")
      L.ClockTime = 18
      L.Brightness = 1.5
      L.Ambient = Color3.fromRGB(255, 100, 50)
   end,
})

-- ══════════════════════════════
--        ONGLET JOUEURS
-- ══════════════════════════════
local PlayersTab = Window:CreateTab("👥 Joueurs", 4483362458)

PlayersTab:CreateSection("📋 Liste")

PlayersTab:CreateButton({
   Name = "Afficher tous les joueurs 📋",
   Callback = function()
      local list = ""
      for _, p in pairs(Players:GetPlayers()) do
         list = list .. "• " .. p.Name .. "\n"
      end
      Rayfield:Notify({ Title = "Joueurs (" .. #Players:GetPlayers() .. ")", Content = list, Duration = 8 })
   end,
})

PlayersTab:CreateInput({
   Name = "TP vers un joueur 🎯",
   PlaceholderText = "Nom du joueur...",
   RemoveTextAfterFocusLost = false,
   Flag = "TpToPlayer",
   Callback = function(name)
      local target = Players:FindFirstChild(name)
      if target and target.Character then
         local char = LocalPlayer.Character
         if char then
            char:SetPrimaryPartCFrame(target.Character.PrimaryPart.CFrame + Vector3.new(0, 3, 0))
            Rayfield:Notify({ Title = "TP", Content = "TP vers " .. name .. " !", Duration = 3 })
         end
      else
         Rayfield:Notify({ Title = "Erreur", Content = "Joueur introuvable.", Duration = 3 })
      end
   end,
})

-- ══════════════════════════════
--        ONGLET PARAMÈTRES
-- ══════════════════════════════
local SettingsTab = Window:CreateTab("⚙️ Paramètres", 4483362458)

SettingsTab:CreateSection("ℹ️ Info")

SettingsTab:CreateButton({
   Name = "Version 1.0 — by Luluclc3",
   Callback = function()
      Rayfield:Notify({ Title = "Luluclc3 Menu", Content = "Version 1.0\nDéveloppé par Luluclc3 👑", Duration = 5 })
   end,
})

SettingsTab:CreateSection("🎨 Interface")

SettingsTab:CreateButton({
   Name = "Fermer le menu ❌",
   Callback = function()
      Rayfield:Destroy()
   end,
})

SettingsTab:CreateButton({
   Name = "Reset vitesse & saut 🔄",
   Callback = function()
      local char = LocalPlayer.Character
      if char then
         local hum = char:FindFirstChildOfClass("Humanoid")
         if hum then
            hum.WalkSpeed = 16
            hum.JumpPower = 50
         end
      end
      workspace.Gravity = 196.2
      Rayfield:Notify({ Title = "Reset", Content = "Stats réinitialisées !", Duration = 3 })
   end,
})

Rayfield:LoadConfiguration()
