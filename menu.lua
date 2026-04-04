-- ══════════════════════════════════════════════════════
--           LULUCLC3 MENU v4.0 - ULTIMATE EDITION 👑
--                EMOTES, AIMBOT & SPIN-BOT
-- ══════════════════════════════════════════════════════

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- ── Chargement Rayfield ──
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
   Name = "Luluclc3 Ultimate 👑",
   LoadingTitle = "Chargement du Menu...",
   LoadingSubtitle = "by Luluclc3 • Multi-Outils",
   Theme = "Default",
   ConfigurationSaving = { Enabled = true, Folder = "Luluclc3_V4" }
})

-- ══════════════════════════════════════
-- HELPERS
-- ══════════════════════════════════════
local function getRoot() return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") end
local function getHum() return LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") end

-- ══════════════════════════════════════
-- ONGLET 1 : COMBAT (AIMBOT & HITBOX)
-- ══════════════════════════════════════
local CombatTab = Window:CreateTab("⚔️ Combat", 4483362458)
local AimbotEnabled = false
local AimSmoothing = 5

local function getClosestPlayer()
    local closest, dist = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            local pos, onScreen = Camera:WorldToViewportPoint(p.Character.Head.Position)
            if onScreen then
                local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if mag < dist then
                    dist = mag
                    closest = p.Character.Head
                end
            end
        end
    end
    return closest
end

CombatTab:CreateToggle({
   Name = "Aimbot (Auto-Lock)",
   CurrentValue = false,
   Callback = function(v) AimbotEnabled = v end,
})

CombatTab:CreateSlider({
   Name = "Lissage Aimbot (Smoothing)",
   Range = {1, 20}, Increment = 1, CurrentValue = 5,
   Callback = function(v) AimSmoothing = v end,
})

RunService.RenderStepped:Connect(function()
    if AimbotEnabled then
        local target = getClosestPlayer()
        if target then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Position), 1/AimSmoothing)
        end
    end
end)

-- ══════════════════════════════════════
-- ONGLET 2 : EMOTES & SPIN (FUN)
-- ══════════════════════════════════════
local EmoteTab = Window:CreateTab("💃 Emotes & Spin", 4483362458)
local spinSpeed = 20
local spinning = false

EmoteTab:CreateSection("🌪️ Spin-Bot (Tornade)")
EmoteTab:CreateToggle({
   Name = "Activer le Spin",
   CurrentValue = false,
   Callback = function(v)
       spinning = v
       task.spawn(function()
           while spinning do
               local root = getRoot()
               if root then
                   root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(spinSpeed), 0)
               end
               task.wait()
           end
       end)
   end,
})

EmoteTab:CreateSlider({
   Name = "Vitesse du Spin",
   Range = {5, 150}, Increment = 5, Suffix = " deg", CurrentValue = 20,
   Callback = function(v) spinSpeed = v end,
})

EmoteTab:CreateSection("🎭 Emotes Serveur")
local emotes = {
    ["Dancer"] = "rbxassetid://3333499508",
    ["Joy"] = "rbxassetid://3337768730",
    ["Point"] = "rbxassetid://128744474",
    ["Wave"] = "rbxassetid://128745032"
}

for name, id in pairs(emotes) do
    EmoteTab:CreateButton({
        Name = "Jouer : " .. name,
        Callback = function()
            local h = getHum()
            if h then
                local anim = Instance.new("Animation")
                anim.AnimationId = id
                local load = h:LoadAnimation(anim)
                load:Play()
            end
        end,
    })
end

-- ══════════════════════════════════════
-- ONGLET 3 : MOUVEMENT (FLY & SPEED)
-- ══════════════════════════════════════
local MoveTab = Window:CreateTab("🏃 Mouvement", 4483362458)

MoveTab:CreateSlider({
   Name = "Vitesse de Marche",
   Range = {16, 500}, Increment = 1, CurrentValue = 16,
   Callback = function(v) if getHum() then getHum().WalkSpeed = v end end,
})

MoveTab:CreateButton({
    Name = "Noclip (Traverser les murs)",
    Callback = function()
        _G.Noclip = not _G.Noclip
        RunService.Stepped:Connect(function()
            if _G.Noclip and LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
        Rayfield:Notify({Title = "Noclip", Content = _G.Noclip and "Activé" or "Désactivé"})
    end
})

-- ══════════════════════════════════════
-- ONGLET 4 : VISUELS (ESP)
-- ══════════════════════════════════════
local VisualTab = Window:CreateTab("👁️ Visuals", 4483362458)

VisualTab:CreateButton({
   Name = "ESP Box & Name",
   Callback = function()
       for _, p in pairs(Players:GetPlayers()) do
           if p ~= LocalPlayer and p.Character then
               local h = Instance.new("Highlight", p.Character)
               h.FillColor = Color3.fromRGB(0, 255, 100)
               h.OutlineTransparency = 0
           end
       end
   end,
})

-- ══════════════════════════════════════
-- PARAMÈTRES
-- ══════════════════════════════════════
local SettTab = Window:CreateTab("⚙️ Paramètres", 4483362458)
SettTab:CreateButton({Name = "Détruire le Menu", Callback = function() Rayfield:Destroy() end})

Rayfield:LoadConfiguration()
Rayfield:Notify({Title = "Luluclc3 V4 Loaded", Content = "Le menu est prêt pour le serveur !", Duration = 5})
