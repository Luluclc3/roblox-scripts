-- ══════════════════════════════════════════════════════
--           LULUCLC3 MENU v3.0 - OMNI EDITION 👑
--                SERVER-INTERACTION FOCUS
-- ══════════════════════════════════════════════════════

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ── Chargement Rayfield ──
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
   Name = "Luluclc3 Omni Menu 👑",
   LoadingTitle = "Luluclc3 V3.0",
   LoadingSubtitle = "Server-Sync Edition",
   Theme = "DarkBlue",
   ConfigurationSaving = { Enabled = true, Folder = "Luluclc3_V3" }
})

-- ══════════════════════════════════════
-- FONCTIONS CORE (Sécurité & Serveur)
-- ══════════════════════════════════════
local function getRoot() return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") end
local function getHum() return LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") end

local function fireServerChat(msg)
    local chatEvents = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
    if chatEvents and chatEvents:FindFirstChild("SayMessageRequest") then
        chatEvents.SayMessageRequest:FireServer(msg, "All")
    end
end

-- ══════════════════════════════════════
-- ONGLET 1 : MOUVEMENT (Visibilité Serveur)
-- ══════════════════════════════════════
local MoveTab = Window:CreateTab("🏃 Physique", 4483362458)

MoveTab:CreateSection("⚡ Synchronisation Serveur")
MoveTab:CreateSlider({
   Name = "Vitesse Réelle",
   Range = {16, 500}, Increment = 1, Suffix = " studs", CurrentValue = 16,
   Callback = function(v) if getHum() then getHum().WalkSpeed = v end end,
})

MoveTab:CreateToggle({
   Name = "Infinite Jump (Visible)",
   CurrentValue = false,
   Callback = function(v)
      _G.InfJump = v
      UIS.JumpRequest:Connect(function()
          if _G.InfJump and getHum() then getHum():ChangeState("Jumping") end
      end)
   end,
})

-- ══════════════════════════════════════
-- ONGLET 2 : COMBAT & HITBOX
-- ══════════════════════════════════════
local CombatTab = Window:CreateTab("⚔️ Combat", 4483362458)

CombatTab:CreateSection("🎯 Avantage Serveur")
CombatTab:CreateSlider({
   Name = "Portée Hitbox (Taille)",
   Range = {2, 20}, Increment = 1, Suffix = " studs", CurrentValue = 2,
   Callback = function(v)
       _G.HitboxSize = v
       task.spawn(function()
           while _G.HitboxSize > 2 do
               task.wait(1)
               for _, p in pairs(Players:GetPlayers()) do
                   if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                       p.Character.HumanoidRootPart.Size = Vector3.new(_G.HitboxSize, _G.HitboxSize, _G.HitboxSize)
                       p.Character.HumanoidRootPart.Transparency = 0.7
                       p.Character.HumanoidRootPart.CanCollide = false
                   end
               end
           end
       end)
   end,
})

-- ══════════════════════════════════════
-- ONGLET 3 : RÉSEAU & LAG (Troll)
-- ══════════════════════════════════════
local NetTab = Window:CreateTab("🌐 Réseau", 4483362458)

NetTab:CreateSection("📡 Simulation Lag")
NetTab:CreateToggle({
   Name = "Invisible / Blink",
   CurrentValue = false,
   Callback = function(v)
       if v then 
           LocalPlayer.Character.LowerTorso.Anchored = true 
           notify("Blink", "Ton corps est resté sur place pour les autres !")
       else 
           LocalPlayer.Character.LowerTorso.Anchored = false 
       end
   end,
})

-- ══════════════════════════════════════
-- ONGLET 4 : INTERACTION OBJETS
-- ══════════════════════════════════════
local ObjectTab = Window:CreateTab("📦 Objets", 4483362458)

ObjectTab:CreateButton({
   Name = "Prendre tous les outils (Tools)",
   Callback = function()
       for _, v in pairs(workspace:GetDescendants()) do
           if v:IsA("Tool") and v:FindFirstChild("Handle") then
               v.Handle.CFrame = getRoot().CFrame
           end
       end
       notify("Serveur", "Tentative de ramassage global terminée.")
   end,
})

-- ══════════════════════════════════════
-- ONGLET 5 : SERVEUR & ANNONCES
-- ══════════════════════════════════════
local ServerTab = Window:CreateTab("📢 Annonces", 4483362458)

ServerTab:CreateInput({
   Name = "Message Serveur Force",
   PlaceholderText = "Texte...",
   Callback = function(txt) fireServerChat("📢 [SYSTEME] : " .. txt) end,
})

ServerTab:CreateButton({
   Name = "Crash Local (Anti-Kick)",
   Callback = function()
       while true do end -- Utile uniquement pour figer votre client avant un ban
   end,
})

-- ══════════════════════════════════════
-- ONGLET 6 : VISUELS (ESP)
-- ══════════════════════════════════════
local VisualTab = Window:CreateTab("👁️ Visuals", 4483362458)

VisualTab:CreateButton({
   Name = "ESP Highlight (X-Ray)",
   Callback = function()
       for _, p in pairs(Players:GetPlayers()) do
           if p ~= LocalPlayer and p.Character then
               local h = Instance.new("Highlight", p.Character)
               h.FillColor = Color3.fromRGB(255, 0, 0)
               h.OutlineColor = Color3.new(1,1,1)
           end
       end
   end,
})

-- ══════════════════════════════════════
-- PARAMÈTRES
-- ══════════════════════════════════════
local SettingsTab = Window:CreateTab("⚙️ Paramètres", 4483362458)
SettingsTab:CreateButton({ Name = "Détruire le Menu", Callback = function() Rayfield:Destroy() end })

Rayfield:LoadConfiguration()
Rayfield:Notify({Title = "Luluclc3 V3", Content = "Prêt pour le serveur, mon cher !", Duration = 5})
