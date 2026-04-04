-- ══════════════════════════════════════════════════════
--           LULUCLC3 MENU v29.0 - SHADOW DEITY 👑
--       SANS BOUTON FLOTTANT - DISCRÉTION TOTALE
-- ══════════════════════════════════════════════════════

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ── Rayfield Engine (Interface Élégante) ──
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
   Name = "Luluclc3 Shadow V29 👑",
   LoadingTitle = "Initialisation de l'Ombre...",
   LoadingSubtitle = "Discrétion & Puissance Absolue",
   Theme = "DarkBlue",
   ConfigurationSaving = { Enabled = true, Folder = "Luluclc3_V29" }
})

-- ══════════════════════════════════════
-- VARIABLES GLOBALES
-- ══════════════════════════════════════
local godModeActive = false
local flyActive, noclipActive, flySpeed = false, false, 3
local walkSpeed, jumpPower = 16, 50
local espBoxes, espTracers, espNames = false, false, false
local targetName = ""

local function getRoot(char) return (char or LocalPlayer.Character):FindFirstChild("HumanoidRootPart") end
local function getHum(char) return (char or LocalPlayer.Character):FindFirstChildOfClass("Humanoid") end

-- ══════════════════════════════════════
-- ONGLET 1 : 🛡️ GOD MODE (INVULNÉRABILITÉ)
-- ══════════════════════════════════════
local GodTab = Window:CreateTab("🛡️ God Mode", 4483362458)

GodTab:CreateToggle({
   Name = "Anti-Death (Santé Forcée)",
   CurrentValue = false,
   Callback = function(v)
       godModeActive = v
       if v then
           task.spawn(function()
               while godModeActive do
                   task.wait()
                   if getHum() and getHum().Health > 0 and getHum().Health < 25 then
                       getHum().Health = 100
                   end
               end
           end)
       end
   end,
})

GodTab:CreateButton({
   Name = "Ghost God (Supprimer Neck)",
   Callback = function()
       local char = LocalPlayer.Character
       if char and char:FindFirstChild("Head") and char.Head:FindFirstChild("Neck") then
           char.Head.Neck:Destroy()
           Rayfield:Notify({Title = "God Mode", Content = "Jointure détruite.", Duration = 3})
       end
   end,
})

GodTab:CreateButton({Name = "Full Heal Instant", Callback = function() if getHum() then getHum().Health = 100 end end})
GodTab:CreateButton({Name = "Anti-Void", Callback = function()
    task.spawn(function()
        while task.wait(1) do
            if getRoot() and getRoot().Position.Y < -500 then getRoot().CFrame = CFrame.new(getRoot().Position.X, 200, getRoot().Position.Z) end
        end
    end)
end})

-- ══════════════════════════════════════
-- ONGLET 2 : ⚔️ ASSASSIN (KILL/WASH)
-- ══════════════════════════════════════
local KillTab = Window:CreateTab("⚔️ Assassin", 4483362458)
KillTab:CreateInput({Name = "Cible", PlaceholderText = "Pseudo...", Callback = function(t) targetName = t end})
KillTab:CreateButton({Name = "Wash/Kill Player", Callback = function()
    local t = Players:FindFirstChild(targetName)
    if t and t.Character and getRoot() then
        local p = getRoot().CFrame
        getRoot().CFrame = getRoot(t.Character).CFrame
        task.wait(0.2)
        local v = Instance.new("BodyVelocity", getRoot())
        v.Velocity = Vector3.new(0, -10000, 0); v.MaxForce = Vector3.new(9e9,9e9,9e9)
        task.wait(0.2); v:Destroy(); getRoot().CFrame = p
    end
end})
KillTab:CreateButton({Name = "Spectate", Callback = function() Camera.CameraSubject = Players:FindFirstChild(targetName).Character.Humanoid end})
KillTab:CreateButton({Name = "Stop Spectate", Callback = function() Camera.CameraSubject = getHum() end})

-- ══════════════════════════════════════
-- ONGLET 3 : 🌀 TÉLÉPORTATION
-- ══════════════════════════════════════
local TPTab = Window:CreateTab("🌀 Téléportation", 4483362458)
local PlayerList = {}
for _, p in pairs(Players:GetPlayers()) do table.insert(PlayerList, p.Name) end
local TPDrop = TPTab:CreateDropdown({Name = "Liste Joueurs", Options = PlayerList, CurrentOption = {""}, Callback = function(o) targetName = o[1] end})
TPTab:CreateButton({Name = "TP to Player ⚡", Callback = function()
    local t = Players:FindFirstChild(targetName)
    if t and t.Character then getRoot().CFrame = getRoot(t.Character).CFrame * CFrame.new(0,0,3) end
end})
TPTab:CreateButton({Name = "Refresh List", Callback = function()
    local nl = {} for _, p in pairs(Players:GetPlayers()) do table.insert(nl, p.Name) end
    TPDrop:Refresh(nl)
end})

-- ══════════════════════════════════════
-- ONGLET 4 : 👁️ VISION (ESP ROUGE)
-- ══════════════════════════════════════
local VisualTab = Window:CreateTab("👁️ Vision", 4483362458)
VisualTab:CreateToggle({Name = "Box ESP (Rouge)", CurrentValue = false, Callback = function(v) espBoxes = v end})
VisualTab:CreateToggle({Name = "Tracers (Lignes)", CurrentValue = false, Callback = function(v) espTracers = v end})
VisualTab:CreateToggle({Name = "Noms", CurrentValue = false, Callback = function(v) espNames = v end})

-- [Moteur ESP Drawing API Intégré]
local function CreateESP(p)
    local tracer = Drawing.new("Line")
    local box = Drawing.new("Square")
    local name = Drawing.new("Text")
    box.Color = Color3.new(1,0,0); box.Filled = false; box.Thickness = 1.5
    tracer.Color = Color3.new(1,0,0); name.Color = Color3.new(1,1,1)
    
    RunService.RenderStepped:Connect(function()
        if p and p.Character and getRoot(p.Character) and p ~= LocalPlayer then
            local pos, vis = Camera:WorldToViewportPoint(getRoot(p.Character).Position)
            if vis then
                if espBoxes then
                    box.Visible = true; box.Size = Vector2.new(2000/pos.Z, 3500/pos.Z)
                    box.Position = Vector2.new(pos.X - box.Size.X/2, pos.Y - box.Size.Y/2)
                else box.Visible = false end
                if espTracers then
                    tracer.Visible = true; tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                    tracer.To = Vector2.new(pos.X, pos.Y)
                else tracer.Visible = false end
                if espNames then
                    name.Visible = true; name.Text = p.Name; name.Position = Vector2.new(pos.X, pos.Y - 20); name.Center = true; name.Outline = true
                else name.Visible = false end
            else box.Visible = false; tracer.Visible = false; name.Visible = false end
        else box.Visible = false; tracer.Visible = false; name.Visible = false end
        if not p.Parent then tracer:Remove(); box:Remove(); name:Remove() end
    end)
end
for _, p in pairs(Players:GetPlayers()) do CreateESP(p) end
Players.PlayerAdded:Connect(CreateESP)

-- ══════════════════════════════════════
-- ONGLET 5 : 🏃 MOUVEMENT
-- ══════════════════════════════════════
local MoveTab = Window:CreateTab("🏃 Mouvement", 4483362458)
MoveTab:CreateToggle({Name = "Fly + Noclip", CurrentValue = false, Callback = function(v) flyActive = v; noclipActive = v end})
MoveTab:CreateSlider({Name = "Vitesse Fly", Range = {1, 100}, Increment = 1, CurrentValue = 3, Callback = function(v) flySpeed = v end})
MoveTab:CreateSlider({Name = "WalkSpeed", Range = {16, 250}, Increment = 1, CurrentValue = 16, Callback = function(v) walkSpeed = v end})

-- ══════════════════════════════════════
-- ONGLET 6 : 🔍 FAILLES & EXÉCUTEUR
-- ══════════════════════════════════════
local ExtraTab = Window:CreateTab("📜 Outils", 4483362458)
ExtraTab:CreateSection("🔍 Scanner de Remotes")
local VulnPara = ExtraTab:CreateParagraph({Title = "Status", Content = "Prêt."})
ExtraTab:CreateButton({Name = "Scan Failles", Callback = function()
    local f
