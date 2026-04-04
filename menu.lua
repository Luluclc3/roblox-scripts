-- ══════════════════════════════════════════════════════
--              LULUCLC3 MENU - RAYFIELD UI
--                   by Luluclc3
-- ══════════════════════════════════════════════════════

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Charger Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Luluclc3 Menu 👑",
   LoadingTitle = "Luluclc3 Menu",
   LoadingSubtitle = "by Luluclc3",
   Theme = "Default",
   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,
})

-- ══════════════════════════════
--        ONGLET TROLL
-- ══════════════════════════════
local TrollTab = Window:CreateTab("👻 Troll", 4483362458)

-- ───── MOUVEMENT ─────
TrollTab:CreateSection("🏃 Mouvement")

local jumpLoop = false
TrollTab:CreateToggle({
   Name = "Bunny Hop 🐇",
   CurrentValue = false,
   Flag = "BunnyHop",
   Callback = function(val)
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
