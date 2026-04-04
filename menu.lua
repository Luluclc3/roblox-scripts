-- ══════════════════════════════════════════════════════
--           LULUCLC3 MENU v24.0 - OMNISCIENT 👑
--        FLY + ESP TRACERS + TROLL + SERVER SCANNER
-- ══════════════════════════════════════════════════════

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ── Chargement Rayfield ──
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
   Name = "Luluclc3 Master V24 👑",
   LoadingTitle = "Chargement de l'Arsenal Omniscient...",
   LoadingSubtitle = "by Luluclc3 - L'Excellence Gentleman",
   Theme = "DarkBlue",
   ConfigurationSaving = { Enabled = true, Folder = "Luluclc3_V24" }
})

-- ══════════════════════════════════════
-- VARIABLES GLOBALES
-- ══════════════════════════════════════
local flyActive, noclipActive, flySpeed = false, false, 3
local AimbotActive, TargetPlayer = false, "Tous"
local espTracers, espBoxes, espNames = false, false, false
local spinning, spinSpeed = false, 50
local jerkActive = false

local function getRoot() return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") end
local function getHum() return LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") end

-- ══════════════════════════════════════
-- ONGLET 1 : 🔍 SERVER SENTINEL (FAILLES)
-- ══════════════════════════════════════
local ScanTab = Window:CreateTab("🔍 Server Failles", 4483362458)

ScanTab:CreateSection("🛡️ Analyseur de Remotes")
local ScanLabel = ScanTab:CreateLabel("Prêt pour l'analyse du serveur...")

ScanTab:CreateButton({
   Name = "Scanner les Vulnérabilités 🚀",
   Callback = function()
       ScanLabel:Set("Analyse des failles en cours...")
       task.wait(1)
       local remotes = 0
       local found = {}
       for _, v in pairs(game:GetDescendants()) do
           if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
               remotes = remotes + 1
               local n = v.Name:lower()
               if n:find("admin") or n:find("give") or n:find("money") or n:find("cash") or n:find("ban") or n:find("kill") then
                   table.insert(found, v.Name)
               end
           end
       end
       ScanLabel:Set(remotes .. " Remotes détectés.")
       if #found > 0 then
           Rayfield:Notify({Title = "FAILLE DÉTECTÉE", Content = "Remotes suspects : " .. table.concat(found, ", "), Duration = 6})
       else
           Rayfield:Notify({Title = "Analyse", Content = "Aucune faille critique nommée n'a été trouvée.", Duration = 3})
       end
   end,
})

-- ══════════════════════════════════════
-- ONGLET 2 : 👁️ VISUALS (ESP & TRACERS)
-- ══════════════════════════════════════
local VisualTab = Window:CreateTab("👁️ Visuals & ESP", 4483362458)

VisualTab:CreateToggle({Name = "Tracers (Lignes)", CurrentValue = false, Callback = function(v) espTracers = v end})
VisualTab:CreateToggle({Name = "Box (Cadres)", CurrentValue = false, Callback = function(v) espBoxes = v end})
VisualTab:CreateToggle({Name = "Noms", CurrentValue = false, Callback = function(v) espNames = v end})

local function CreateESP(p)
    local tracer = Drawing.new("Line")
    local box = Drawing.new("Square")
    local name = Drawing.new("Text")
    RunService.RenderStepped:Connect(function()
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p ~= LocalPlayer then
            local rootPos, onScreen = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if onScreen then
                if espTracers then
                    tracer.Visible = true
                    tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    tracer.To = Vector2.new(rootPos.X, rootPos.Y)
                    tracer.Color = Color3.fromRGB(255, 0, 0)
                else tracer.Visible = false end
                if espBoxes then
                    box.Visible = true
                    box.Size = Vector2.new(2000 / rootPos.Z, 3500 / rootPos.Z)
                    box.Position = Vector2.new(rootPos.X - box.Size.X / 2, rootPos.Y - box.Size.Y / 2)
                    box.Color = Color3.fromRGB(255, 255, 255)
                else box.Visible = false end
                if espNames then
                    name.Visible = true
                    name.Text = p.Name
                    name.Position = Vector2.new(rootPos.X, rootPos.Y - (box.Size.Y / 2) - 15)
                    name.Center = true; name.Outline = true; name.Color = Color3.new(1,1,1)
                else name.Visible = false end
            else tracer.Visible = false; box.Visible = false; name.Visible = false end
        else tracer.Visible = false; box.Visible = false; name.Visible = false end
        if not p.Parent then tracer:Remove(); box:Remove(); name:Remove() end
    end)
end
for _, p in pairs(Players:GetPlayers()) do CreateESP(p) end
Players.PlayerAdded:Connect(CreateESP)

-- ══════════════════════════════════════
-- ONGLET 3 : ✈️ MOUVEMENT (FLY MOBILE)
-- ══════════════════════════════════════
local MoveTab = Window:CreateTab("✈️ Fly & Noclip", 4483362458)

MoveTab:CreateToggle({
   Name = "Fly + Noclip (Perfect Mobile)",
   CurrentValue = false,
   Callback = function(v)
       flyActive, noclipActive = v, v
       if v then
           task.spawn(function()
               local bv = Instance.new("BodyVelocity", getRoot())
               local bg = Instance.new("BodyGyro", getRoot())
               bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
               bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
               while flyActive do
                   RunService.RenderStepped:Wait()
                   if getRoot() and getHum() then
                       getHum().PlatformStand = true
                       bg.CFrame = Camera.CFrame
                       local dir = getHum().MoveDirection
                       bv.Velocity = (dir.Magnitude > 0) and ((Camera.CFrame.LookVector * (dir.Z * -1) + Camera.CFrame.RightVector * dir.X) * (flySpeed * 50)) or Vector3.zero
                   end
               end
               bv:Destroy(); bg:Destroy()
               if getHum() then getHum().PlatformStand = false end
           end)
       end
   end,
})

MoveTab:CreateSlider({Name = "Vitesse", Range = {1, 50}, Increment = 1, CurrentValue = 3, Callback = function(v) flySpeed = v end})

-- ══════════════════════════════════════
-- ONGLET 4 : 🤡 TROLL (CHAOS)
-- ══════════════════════════════════════
local TrollTab = Window:CreateTab("🤡 Troll", 4483362458)

TrollTab:CreateToggle({
   Name = "Activer Jerk 💦",
   CurrentValue = false,
   Callback = function(v)
       jerkActive = v
       if v then
           task.spawn(function()
               while jerkActive do
                   local h = getHum()
                   if h then
                       local anim = Instance.new("Animation")
                       anim.AnimationId = "rbxassetid://35154961" 
                       local track = h:LoadAnimation(anim)
                       track:Play(); track:AdjustSpeed(10)
                       task.wait(0.2); track:Stop()
                   end
               end
           end)
       end
   end,
})

TrollTab:CreateToggle({Name = "Spin-Bot (Tornado)", CurrentValue = false, Callback = function(v) spinning = v end})
TrollTab:CreateSlider({Name = "Vitesse Spin", Range = {10, 300}, Increment = 10, CurrentValue = 50, Callback = function(v) spinSpeed = v end})

-- ══════════════════════════════════════
-- LOGIQUE FINALE (BOUCLES)
-- ══════════════════════════════════════
RunService.Stepped:Connect(function()
    if noclipActive and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if spinning and getRoot() then 
        getRoot().CFrame = getRoot().CFrame * CFrame.Angles(0, math.rad(spinSpeed), 0) 
    end
end)

Rayfield:Notify({Title = "Luluclc3 Master V24", Content = "Arsenal complet prêt, mon cher !", Duration = 5})
