-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

-- Charger Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "🌊 Neptune Menu",
   LoadingTitle = "Neptune Scripts",
   LoadingSubtitle = "by Luluclc3",
   Theme = "Default",
   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,
})

-- ══════════════════════════════
--        ONGLET TROLL
-- ══════════════════════════════
local TrollTab = Window:CreateTab("👻 Troll", 4483362458)

TrollTab:CreateSection("Mouvement")

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
               task.wait(0.1)
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
   Name = "Vitesse de marche 🏃",
   Range = {16, 250},
   Increment = 1,
   Suffix = " studs/s",
   CurrentValue = 16,
   Flag = "WalkSpeedSlider",
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
   Range = {50, 500},
   Increment = 10,
   Suffix = " power",
   CurrentValue = 50,
   Flag = "JumpPowerSlider",
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
   Callback = function(val)
      noclipActive = val
   end,
})

RunService.Stepped:Connect(function()
   if noclipActive then
      local char = LocalPlayer.Character
      if char then
         for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
               part.CanCollide = false
            end
         end
      end
   end
end)

TrollTab:CreateSection("Troll Joueurs")

TrollTab:CreateButton({
   Name = "Faire danser tout le monde 🕺",
   Callback = function()
      for _, plr in pairs(Players:GetPlayers()) do
         if plr ~= LocalPlayer then
            local char = plr.Character
            if char then
               local hum = char:FindFirstChildOfClass("Humanoid")
               if hum then hum.Jump = true end
            end
         end
      end
      Rayfield:Notify({ Title = "Troll", Content = "Tout le monde saute !", Duration = 3 })
   end,
})

TrollTab:CreateButton({
   Name = "TP tous au même endroit 🌀",
   Callback = function()
      local myChar = LocalPlayer.Character
      if myChar and myChar.PrimaryPart then
         local pos = myChar.PrimaryPart.CFrame
         for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
               local char = plr.Character
               if char then
                  char:SetPrimaryPartCFrame(pos + Vector3.new(math.random(-5,5), 5, math.random(-5,5)))
               end
            end
         end
         Rayfield:Notify({ Title = "TP", Content = "Tout le monde TP chez toi !", Duration = 3 })
      end
   end,
})

TrollTab:CreateButton({
   Name = "Spam saut serveur 🦘",
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
      Rayfield:Notify({ Title = "Troll", Content = "Saut forcé x10 !", Duration = 3 })
   end,
})

TrollTab:CreateSection("Gravité Serveur")

TrollTab:CreateButton({
   Name = "Gravité nulle 🌌",
   Callback = function()
      workspace.Gravity = 5
      Rayfield:Notify({ Title = "Gravité", Content = "Gravité réduite !", Duration = 3 })
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
      Rayfield:Notify({ Title = "Gravité", Content = "Gravité x3 !", Duration = 3 })
   end,
})

TrollTab:CreateSlider({
   Name = "Gravité custom ⚖️",
   Range = {1, 600},
   Increment = 5,
   Suffix = "",
   CurrentValue = 196,
   Flag = "GravitySlider",
   Callback = function(val)
      workspace.Gravity = val
   end,
})

-- ══════════════════════════════
--        ONGLET JOUEUR
-- ══════════════════════════════
local PlayerTab = Window:CreateTab("🧍 Joueur", 4483362458)

PlayerTab:CreateSection("Apparence")

PlayerTab:CreateSlider({
   Name = "Taille du personnage 📏",
   Range = {0.5, 5},
   Increment = 0.1,
   Suffix = "x",
   CurrentValue = 1,
   Flag = "SizeSlider",
   Callback = function(val)
      local char = LocalPlayer.Character
      if char then
         for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
               part.Size = part.Size * val / (part:GetAttribute("LastSize") or 1)
               part:SetAttribute("LastSize", val)
            end
         end
      end
   end,
})

PlayerTab:CreateColorPicker({
   Name = "Couleur du personnage 🎨",
   Color = Color3.fromRGB(255, 255, 255),
   Flag = "CharColor",
   Callback = function(val)
      local char = LocalPlayer.Character
      if char then
         for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
               part.Color = val
            end
         end
      end
   end,
})

PlayerTab:CreateToggle({
   Name = "Invisibilité 🫥",
   CurrentValue = false,
   Flag = "Invisible",
   Callback = function(val)
      local char = LocalPlayer.Character
      if char then
         for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
               part.Transparency = val and 1 or 0
            end
         end
      end
   end,
})

PlayerTab:CreateSection("Stats")

PlayerTab:CreateButton({
   Name = "Reset personnage 🔄",
   Callback = function()
      LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health = 0
   end,
})

PlayerTab:CreateButton({
   Name = "Vie max ❤️",
   Callback = function()
      local char = LocalPlayer.Character
      if char then
         local hum = char:FindFirstChildOfClass("Humanoid")
         if hum then hum.Health = hum.MaxHealth end
      end
   end,
})

PlayerTab:CreateToggle({
   Name = "God Mode ⭐ (local)",
   CurrentValue = false,
   Flag = "GodMode",
   Callback = function(val)
      local char = LocalPlayer.Character
      if char then
         local hum = char:FindFirstChildOfClass("Humanoid")
         if hum then
            if val then
               hum:GetPropertyChangedSignal("Health"):Connect(function()
                  if hum.Health < hum.MaxHealth then
                     hum.Health = hum.MaxHealth
                  end
               end)
            end
         end
      end
      Rayfield:Notify({ Title = "God Mode", Content = val and "Activé !" or "Désactivé", Duration = 3 })
   end,
})

-- ══════════════════════════════
--        ONGLET TÉLÉPORTATION
-- ══════════════════════════════
local TpTab = Window:CreateTab("🌀 Téléportation", 4483362458)

TpTab:CreateSection("Destinations")

TpTab:CreateButton({
   Name = "TP au Spawn 🏠",
   Callback = function()
      local char = LocalPlayer.Character
      local spawn = workspace:FindFirstChild("SpawnLocation")
      if char and spawn then
         char:SetPrimaryPartCFrame(spawn.CFrame + Vector3.new(0, 5, 0))
      end
   end,
})

TpTab:CreateButton({
   Name = "TP dans les airs ✈️",
   Callback = function()
      local char = LocalPlayer.Character
      if char then
         char:SetPrimaryPartCFrame(char.PrimaryPart.CFrame + Vector3.new(0, 100, 0))
      end
   end,
})

TpTab:CreateSection("TP vers Joueur")

local playerNames = {}
for _, plr in pairs(Players:GetPlayers()) do
   if plr ~= LocalPlayer then
      table.insert(playerNames, plr.Name)
   end
end

if #playerNames == 0 then table.insert(playerNames, "Aucun joueur") end

TpTab:CreateDropdown({
   Name = "Choisir un joueur 👤",
   Options = playerNames,
   CurrentOption = {playerNames[1]},
   Flag = "TpTarget",
   Callback = function(option) end,
})

TpTab:CreateButton({
   Name = "TP vers ce joueur 🎯",
   Callback = function()
      local options = Rayfield.Flags["TpTarget"]
      if options then
         local targetName = options.Value[1]
         local target = Players:FindFirstChild(targetName)
         if target and target.Character then
            local char = LocalPlayer.Character
            if char then
               char:SetPrimaryPartCFrame(target.Character.PrimaryPart.CFrame + Vector3.new(0, 3, 0))
               Rayfield:Notify({ Title = "TP", Content = "Téléporté vers " .. targetName, Duration = 3 })
            end
         end
      end
   end,
})

-- ══════════════════════════════
--        ONGLET VISUEL
-- ══════════════════════════════
local VisualTab = Window:CreateTab("🎨 Visuel", 4483362458)

VisualTab:CreateSection("Ambiance")

VisualTab:CreateButton({
   Name = "Nuit noire 🌑",
   Callback = function()
      Lighting.ClockTime = 0
      Lighting.Brightness = 0
      Lighting.Ambient = Color3.fromRGB(0, 0, 0)
      Rayfield:Notify({ Title = "Visuel", Content = "Nuit noire activée !", Duration = 3 })
   end,
})

VisualTab:CreateButton({
   Name = "Coucher de soleil 🌅",
   Callback = function()
      Lighting.ClockTime = 18
      Lighting.Brightness = 1
      Lighting.Ambient = Color3.fromRGB(255, 120, 50)
   end,
})

VisualTab:CreateButton({
   Name = "Journée normale ☀️",
   Callback = function()
      Lighting.ClockTime = 14
      Lighting.Brightness = 2
      Lighting.Ambient = Color3.fromRGB(100, 100, 100)
   end,
})

VisualTab:CreateSlider({
   Name = "Heure de la journée 🕐",
   Range = {0, 24},
   Increment = 1,
   Suffix = "h",
   CurrentValue = 14,
   Flag = "TimeSlider",
   Callback = function(val)
      Lighting.ClockTime = val
   end,
})

VisualTab:CreateColorPicker({
   Name = "Couleur ambiante 🌈",
   Color = Color3.fromRGB(100, 100, 100),
   Flag = "AmbientColor",
   Callback = function(val)
      Lighting.Ambient = val
   end,
})

VisualTab:CreateSection("Effets")

local rainbowActive = false
VisualTab:CreateToggle({
   Name = "Mode Arc-en-ciel 🌈",
   CurrentValue = false,
   Flag = "Rainbow",
   Callback = function(val)
      rainbowActive = val
      if val then
         task.spawn(function()
            local hue = 0
            while rainbowActive do
               task.wait(0.05)
               hue = (hue + 1) % 360
               Lighting.Ambient = Color3.fromHSV(hue/360, 1, 1)
            end
         end)
      end
   end,
})

VisualTab:CreateSlider({
   Name = "Brouillard 🌫️",
   Range = {0, 5000},
   Increment = 100,
   Suffix = " studs",
   CurrentValue = 5000,
   Flag = "FogSlider",
   Callback = function(val)
      Lighting.FogEnd = val
      Lighting.FogStart = val / 2
   end,
})

VisualTab:CreateColorPicker({
   Name = "Couleur brouillard 🌫️",
   Color = Color3.fromRGB(200, 200, 200),
   Flag = "FogColor",
   Callback = function(val)
      Lighting.FogColor = val
   end,
})

-- ══════════════════════════════
--        ONGLET OUTILS
-- ══════════════════════════════
local ToolsTab = Window:CreateTab("🔧 Outils", 4483362458)

ToolsTab:CreateSection("Monde")

ToolsTab:CreateButton({
   Name = "Supprimer tous les effets 🧹",
   Callback = function()
      for _, effect in pairs(Lighting:GetChildren()) do
         if effect:IsA("PostEffect") then
            effect:Destroy()
         end
      end
      Rayfield:Notify({ Title = "Effets", Content = "Tous les effets supprimés !", Duration = 3 })
   end,
})

ToolsTab:CreateButton({
   Name = "Reset Lighting 💡",
   Callback = function()
      Lighting.ClockTime = 14
      Lighting.Brightness = 2
      Lighting.Ambient = Color3.fromRGB(100,100,100)
      Lighting.FogEnd = 100000
      workspace.Gravity = 196.2
      Rayfield:Notify({ Title = "Reset", Content = "Lighting et gravité réinitialisés !", Duration = 3 })
   end,
})

ToolsTab:CreateSection("Infos")

ToolsTab:CreateButton({
   Name = "Infos serveur 📊",
   Callback = function()
      local ping = math.floor(LocalPlayer:GetNetworkPing() * 1000)
      local playerCount = #Players:GetPlayers()
      Rayfield:Notify({
         Title = "Infos Serveur",
         Content = "Joueurs: " .. playerCount .. " | Ping: " .. ping .. "ms",
         Duration = 5,
      })
   end,
})

ToolsTab:CreateButton({
   Name = "Lister les joueurs 👥",
   Callback = function()
      local list = ""
      for _, plr in pairs(Players:GetPlayers()) do
         list = list .. plr.Name .. "\n"
      end
      Rayfield:Notify({
         Title = "Joueurs en ligne",
         Content = list,
         Duration = 6,
      })
   end,
})

-- ══════════════════════════════
--        ONGLET PARAMÈTRES
-- ══════════════════════════════
local SettingsTab = Window:CreateTab("⚙️ Paramètres", 4483362458)

SettingsTab:CreateSection("Interface")

SettingsTab:CreateButton({
   Name = "Fermer le menu ❌",
   Callback = function()
      Rayfield:Destroy()
   end,
})

SettingsTab:CreateSection("Crédits")

SettingsTab:CreateButton({
   Name = "📌 Neptune Scripts - by Luluclc3",
   Callback = function()
      Rayfield:Notify({
         Title = "Neptune Scripts",
         Content = "Fait par Luluclc3 🌊",
         Duration = 4,
      })
   end,
})

Rayfield:LoadConfiguration()      end
   end
end)

TrollTab:CreateSection("Gravité")

TrollTab:CreateButton({
   Name = "Gravité nulle 🌌",
   Callback = function()
      game:GetService("Workspace").Gravity = 5
      Rayfield:Notify({ Title = "Gravité", Content = "Gravité réduite !", Duration = 3 })
   end,
})

TrollTab:CreateButton({
   Name = "Gravité normale 🌍",
   Callback = function()
      game:GetService("Workspace").Gravity = 196.2
      Rayfield:Notify({ Title = "Gravité", Content = "Gravité restaurée.", Duration = 3 })
   end,
})

TrollTab:CreateButton({
   Name = "Super gravité 🪨",
   Callback = function()
      game:GetService("Workspace").Gravity = 500
      Rayfield:Notify({ Title = "Gravité", Content = "Gravité x2.5 !", Duration = 3 })
   end,
})

TrollTab:CreateSection("Téléportation")

TrollTab:CreateButton({
   Name = "TP au Spawn 🏠",
   Callback = function()
      local char = LocalPlayer.Character
      local spawn = workspace:FindFirstChild("SpawnLocation")
      if char and spawn then
         char:SetPrimaryPartCFrame(spawn.CFrame + Vector3.new(0, 5, 0))
      end
   end,
})

-- ══════════════════════════════
--        ONGLET PARAMÈTRES
-- ══════════════════════════════
local SettingsTab = Window:CreateTab("⚙️ Paramètres", 4483362458)

SettingsTab:CreateSection("Interface")

SettingsTab:CreateButton({
   Name = "Fermer le menu",
   Callback = function()
      Rayfield:Destroy()
   end,
})

Rayfield:LoadConfiguration()
