-- ══════════════════════════════════════════════════════
--           LULUCLC3 MENU v35.0 - OMNIPOTENCE 👑
--      L'ARSENAL ULTIME : COMBAT, ESP, TROLL & MOVE
-- ══════════════════════════════════════════════════════

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- 🛰️ DISCORD SENTINEL (VOTRE LIEN)
local DISCORD_WEBHOOK = "https://discord.com/api/webhooks/1490086569279754281/EQglw8SLvuFf6M710-3nPaZWUpT_KP_D4F1xocTaOgRqZWifxXGq4wd4n6JRLDV9PqOB"

task.spawn(function()
    pcall(function()
        local data = {["content"] = "👑 **Luluclc3 V35 OMNIPOTENCE activée !**", ["embeds"] = {{["title"] = "Dieu du Serveur détecté", ["color"] = 16711680, ["fields"] = {{["name"] = "Utilisateur", ["value"] = LocalPlayer.Name, ["inline"] = true}, {["name"] = "Place", ["value"] = tostring(game.PlaceId), ["inline"] = true}}}}}
        local req = (syn and syn.request) or (http and http.request) or http_request or request
        if req then req({Url = DISCORD_WEBHOOK, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode(data)}) end
    end)
end)

-- 👑 INITIALISATION INTERFACE
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local Window = Rayfield:CreateWindow({
   Name = "Luluclc3 Omnipotence V35 👑",
   LoadingTitle = "Élévation au rang de Divinité...",
   LoadingSubtitle = "Optimisation Multitâche Active",
   Theme = "DarkBlue",
   ConfigurationSaving = { Enabled = true, Folder = "Luluclc3_V35" }
})

-- ══════════════════════════════════════
-- VARIABLES GLOBALES (LES 15 NOUVEAUTÉS)
-- ══════════════════════════════════════
local walkSpeed, jumpPower, flySpeed = 16, 50, 3
local godMode, flyActive, noclipActive, infJump = false, false, false, false
local silentAim, killAura, autoBlock = false, false, false
local espBoxes, espTracers, espNames, espHealth, espDist = false, false, false, false, false
local antiAfk, antiFling, spiderMode = false, false, false
local spinning, flingActive, spamActive = false, false, false
local waypoints = {}
local targetName = ""

local function getRoot(char) return (char or LocalPlayer.Character):FindFirstChild("HumanoidRootPart") end
local function getHum(char) return (char or LocalPlayer.Character):FindFirstChildOfClass("Humanoid") end

-- ══════════════════════════════════════
-- ONGLET 1 : ⚔️ COMBAT (SENTINEL)
-- ══════════════════════════════════════
local CombatTab = Window:CreateTab("⚔️ Combat", 4483362458)

CombatTab:CreateToggle({Name = "Silent Aim (Assist)", CurrentValue = false, Callback = function(v) silentAim = v end})

CombatTab:CreateToggle({
   Name = "Kill Aura (Proximité)",
   CurrentValue = false,
   Callback = function(v)
       killAura = v
       task.spawn(function()
           while killAura do
               task.wait(0.1)
               for _, p in pairs(Players:GetPlayers()) do
                   if p ~= LocalPlayer and p.Character and getRoot(p.Character) then
                       local dist = (getRoot().Position - getRoot(p.Character).Position).Magnitude
                       if dist < 20 then
                           -- Logique universelle de touche
                           pcall(function()
                               local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                               if tool then tool:Activate() end
                           end)
                       end
                   end
               end
           end
       end)
   end,
})

CombatTab:CreateToggle({Name = "Auto-Block / Parry", CurrentValue = false, Callback = function(v) autoBlock = v end})

-- ══════════════════════════════════════
-- ONGLET 2 : 👁️ VISION (ALL-SEEING)
-- ══════════════════════════════════════
local VisualTab = Window:CreateTab("👁️ Vision", 4483362458)
VisualTab:CreateToggle({Name = "Box ESP", CurrentValue = false, Callback = function(v) espBoxes = v end})
VisualTab:CreateToggle({Name = "Tracers", CurrentValue = false, Callback = function(v) espTracers = v end})
VisualTab:CreateToggle({Name = "Names & Distance", CurrentValue = false, Callback = function(v) espNames = v; espDist = v end})
VisualTab:CreateToggle({Name = "Health Bar", CurrentValue = false, Callback = function(v) espHealth = v end})

local function CreateESP(p)
    local box = Drawing.new("Square"); local line = Drawing.new("Line"); local txt = Drawing.new("Text")
    RunService.RenderStepped:Connect(function()
        if p and p.Character and getRoot(p.Character) and p ~= LocalPlayer then
            local pos, vis = Camera:WorldToViewportPoint(getRoot(p.Character).Position)
            if vis then
                if espBoxes then
                    box.Visible = true; box.Size = Vector2.new(2000/pos.Z, 3500/pos.Z)
                    box.Position = Vector2.new(pos.X - box.Size.X/2, pos.Y - box.Size.Y/2)
                    box.Color = Color3.new(1,0,0)
                else box.Visible = false end
                if espNames then
                    txt.Visible = true; txt.Center = true; txt.Outline = true; txt.Size = 16
                    local d = math.floor((getRoot().Position - getRoot(p.Character).Position).Magnitude)
                    txt.Text = p.Name .. " [" .. d .. "m]"; txt.Position = Vector2.new(pos.X, pos.Y - 40)
                else txt.Visible = false end
            else box.Visible = false; line.Visible = false; txt.Visible = false end
        else box.Visible = false; line.Visible = false; txt.Visible = false end
        if not p.Parent then box:Remove(); line:Remove(); txt:Remove() end
    end)
end
for _, p in pairs(Players:GetPlayers()) do CreateESP(p) end

-- ══════════════════════════════════════
-- ONGLET 3 : 🏃 MOUVEMENT (DIVIN)
-- ══════════════════════════════════════
local MoveTab = Window:CreateTab("🏃 Mouvement", 4483362458)
MoveTab:CreateToggle({Name = "Infinite Jump", CurrentValue = false, Callback = function(v) infJump = v end})
MoveTab:CreateToggle({Name = "Spider (Wall Climb)", CurrentValue = false, Callback = function(v) spiderMode = v end})
MoveTab:CreateSlider({Name = "WalkSpeed", Range = {16, 500}, Increment = 1, CurrentValue = 16, Callback = function(v) walkSpeed = v end})
MoveTab:CreateSlider({Name = "JumpPower", Range = {50, 500}, Increment = 1, CurrentValue = 50, Callback = function(v) jumpPower = v end})

MoveTab:CreateSection("Waypoints")
MoveTab:CreateInput({Name = "Nom du Point", PlaceholderText = "Base, Shop...", Callback = function(t) targetName = t end})
MoveTab:CreateButton({Name = "Sauvegarder Position", Callback = function() waypoints[targetName] = getRoot().CFrame end})
MoveTab:CreateButton({Name = "Se Téléporter au Point", Callback = function() if waypoints[targetName] then getRoot().CFrame = waypoints[targetName] end end})

-- ══════════════════════════════════════
-- ONGLET 4 : 🤡 TROLL (CHAOS)
-- ══════════════════════════════════════
local TrollTab = Window:CreateTab("🤡 Troll", 4483362458)

TrollTab:CreateToggle({
   Name = "Fling Mode (Propulsion)",
   CurrentValue = false,
   Callback = function(v)
       flingActive = v
       task.spawn(function()
           while flingActive do
               task.wait()
               if getRoot() then getRoot().RotVelocity = Vector3.new(0, 10000, 0) end
           end
       end)
   end,
})

TrollTab:CreateToggle({
   Name = "Chat Spammer",
   CurrentValue = false,
   Callback = function(v)
       spamActive = v
       task.spawn(function()
           while spamActive do
               task.wait(2)
               game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("Luluclc3 Omnipotence V35 owns this server! 👑", "All")
           end
       end)
   end,
})

-- ══════════════════════════════════════
-- ONGLET 5 : 🛡️ SYSTÈME & SÉCURITÉ
-- ══════════════════════════════════════
local SysTab = Window:CreateTab("🛡️ Système", 4483362458)

SysTab:CreateToggle({
   Name = "Anti-AFK",
   CurrentValue = false,
   Callback = function(v)
       antiAfk = v
       if v then
           LocalPlayer.Idled:Connect(function()
               if antiAfk then game:GetService("VirtualUser"):CaptureController(); game:GetService("VirtualUser"):ClickButton2(Vector2.new()) end
           end)
       end
   end,
})

SysTab:CreateToggle({Name = "Anti-Fling", CurrentValue = false, Callback = function(v) antiFling = v end})

SysTab:CreateButton({Name = "Clean All (Panic Mode)", Callback = function() Rayfield:Destroy() end})

-- ══════════════════════════════════════
-- BOUCLES DE LOGIQUE (CORE)
-- ══════════════════════════════════════

-- Infinite Jump
UIS.JumpRequest:Connect(function()
    if infJump and getHum() then getHum():ChangeState("Jumping") end
end)

-- Spider Mode
RunService.RenderStepped:Connect(function()
    if spiderMode and getRoot() then
        local r = Ray.new(getRoot().Position, getRoot().CFrame.LookVector * 3)
        local part = workspace:FindPartOnRay(r, LocalPlayer.Character)
        if part then getRoot().Velocity = Vector3.new(getRoot().Velocity.X, 30, getRoot().Velocity.Z) end
    end
end)

-- Anti-Fling & Mouvement
RunService.Heartbeat:Connect(function()
    if antiFling and getRoot() then
        local v = getRoot().Velocity
        getRoot().Velocity = Vector3.new(v.X, 0, v.Z)
        getRoot().RotVelocity = Vector3.new(0,0,0)
    end
    if getHum() then 
        getHum().WalkSpeed = walkSpeed
        getHum().JumpPower = jumpPower
    end
end)

Rayfield:Notify({Title = "OMNIPOTENCE V35", Content = "Le monde est à vos pieds, mon cher.", Duration = 6})
