-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Charger Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Mon Menu 🎮",
   LoadingTitle = "Chargement...",
   LoadingSubtitle = "by lucascl0606",
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

TrollTab:CreateToggle({
   Name = "Speed Boost ⚡",
   CurrentValue = false,
   Flag = "SpeedBoost",
   Callback = function(val)
      local char = LocalPlayer.Character
      if char then
         local hum = char:FindFirstChildOfClass("Humanoid")
         if hum then hum.WalkSpeed = val and 60 or 16 end
      end
   end,
})

TrollTab:CreateSlider({
   Name = "Vitesse de marche 🏃",
   Range = {16, 150},
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

local noclipActive = false
TrollTab:CreateToggle({
   Name = "Noclip 👻",
   CurrentValue = false,
   Flag = "Noclip",
   Callback = function(val)
      noclipActive = val
   end,
})

game:GetService("RunService").Stepped:Connect(function()
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
