-- ══════════════════════════════════════════════════════
--           LULUCLC3 MENU v31.0 - SENTINEL ELITE 👑
--       DISCORD LOGGING + GOD + KILL + NO BUTTON
-- ══════════════════════════════════════════════════════

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ══════════════════════════════════════
-- 🛰️ CONFIGURATION DISCORD (LOGGING)
-- ══════════════════════════════════════
local DISCORD_WEBHOOK = "https://discord.com/api/webhooks/1490086569279754281/EQglw8SLvuFf6M710-3nPaZWUpT_KP_D4F1xocTaOgRqZWifxXGq4wd4n6JRLDV9PqOB"

local function SendLog()
    local headers = {["Content-Type"] = "application/json"}
    local data = {
        ["content"] = "👑 **Script Luluclc3 Exécuté !**",
        ["embeds"] = {{
            ["title"] = "Rapport de Sécurité Sentinel",
            ["color"] = 16711680, -- Rouge Elite
            ["fields"] = {
                {["name"] = "👤 Utilisateur", ["value"] = LocalPlayer.Name .. " (" .. LocalPlayer.UserId .. ")", ["inline"] = true},
                {["name"] = "🎮 Jeu", ["value"] = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name or "Inconnu", ["inline"] = true},
                {["name"] = "📍 Place ID", ["value"] = tostring(game.PlaceId), ["inline"] = true},
                {["name"] = "🔗 Profil", ["value"] = "https://www.roblox.com/users/"..LocalPlayer.UserId.."/profile", ["inline"] = false}
            },
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }
    
    pcall(function()
        local requestFunc = syn and syn.request or http_request or request or HttpService.PostAsync
        requestFunc({
            Url = DISCORD_WEBHOOK,
            Method = "POST",
            Headers = headers,
            Body = HttpService:JSONEncode(data)
        })
    end)
end

task.spawn(SendLog)

-- ── Rayfield Engine (Interface Mobile Épurée) ──
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local Window = Rayfield:CreateWindow({
   Name = "Luluclc3 Elite V31 👑",
   LoadingTitle = "Établissement du Protocole Sentinel...",
   LoadingSubtitle = "Transmission Discord Active",
   Theme = "DarkBlue",
   ConfigurationSaving = { Enabled = true, Folder = "Luluclc3_V31" }
})

-- ══════════════════════════════════════
-- VARIABLES GLOBALES
-- ══════════════════════════════════════
local godModeActive, flyActive, noclipActive = false, false, false
local walkSpeed, jumpPower, flySpeed = 16, 50, 3
local espBoxes, espTracers, espNames = false, false, false
local targetName = ""

local function getRoot(char) return (char or LocalPlayer.Character):FindFirstChild("HumanoidRootPart") end
local function getHum(char) return (char or LocalPlayer.Character):FindFirstChildOfClass("Humanoid") end

-- ══════════════════════════════════════
-- ONGLET 1 : 🛡️ GOD MODE (INVULNÉRABILITÉ)
-- ══════════════════════════════════════
local GodTab = Window:CreateTab("🛡️ God Mode", 4483362458)
GodTab:CreateSection("🛡️ Protection Divine")
GodTab:CreateToggle({
   Name = "Anti-Death (Auto-Heal)",
   CurrentValue = false,
   Callback = function(v)
       godModeActive = v
       task.spawn(function()
           while godModeActive do
               task.wait()
               if getHum() and getHum().Health < 30 then getHum().Health = 100 end
           end
       end)
   end,
})
GodTab:CreateButton({Name = "Ghost God (Supprimer Neck)", Callback = function() if LocalPlayer.Character.Head:FindFirstChild("Neck") then LocalPlayer.Character.Head.Neck:Destroy() end end})
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
KillTab:CreateButton({Name = "Spectate Cible", Callback = function() Camera.CameraSubject = Players:FindFirstChild(targetName).Character.Humanoid end})
KillTab:CreateButton({Name = "Stop Spectate", Callback = function() Camera.CameraSubject = getHum() end})

-- ══════════════════════════════════════
-- ONGLET 3 : 👁️ VISION (ESP ROUGE VIDE)
-- ══════════════════════════════════════
local VisualTab = Window:CreateTab("👁️ Vision", 4483362458)
VisualTab:CreateToggle({Name = "Box ESP (Rouge)", CurrentValue = false, Callback = function(v) espBoxes = v end})
VisualTab:CreateToggle({Name = "Tracers (Lignes)", CurrentValue = false, Callback = function(v) espTracers = v end})

local function CreateESP(p)
    local tracer = Drawing.new("Line")
    local box = Drawing.new("Square")
    box.Color = Color3.new(1,0,0); box.Filled = false; box.Thickness = 1.5
    tracer.Color = Color3.new(1,0,0)
    RunService.RenderStepped:Connect(function()
        if p and p.Character and getRoot(p.Character) and p ~= LocalPlayer then
            local pos, vis = Camera:WorldToViewportPoint(getRoot(p.Character).Position)
            if vis then
                if espBoxes then
                    box.Visible = true; box.Size = Vector2.new(2000/pos.Z, 3500/pos.Z)
                    box.Position = Vector2.new(pos.X - box.Size.X/2, pos.Y - box.Size.Y/2)
                else box.Visible = false end
                if espTracers then
                    tracer.Visible = true; tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y); tracer.To = Vector2.new(pos.X, pos.Y)
                else tracer.Visible = false end
            else box.Visible = false; tracer.Visible = false end
        else box.Visible = false; tracer.Visible = false end
        if not p.Parent then tracer:Remove(); box:Remove() end
    end)
end
for _, p in pairs(Players:GetPlayers()) do CreateESP(p) end
Players.PlayerAdded:Connect(CreateESP)

-- ══════════════════════════════════════
-- ONGLET 4 : 🌀 TÉLÉPORTATION
-- ══════════════════════════════════════
local TPTab = Window:CreateTab("🌀 Téléportation", 4483362458)
local PlayerList = {}
for _, p in pairs(Players:GetPlayers()) do table.insert(PlayerList, p.Name) end
local TPDrop = TPTab:CreateDropdown({Name = "Liste Joueurs", Options = PlayerList, CurrentOption = {""}, Callback = function(o) targetName = o[1] end})
TPTab:CreateButton({Name = "TP to Player ⚡", Callback = function()
    local t = Players:FindFirstChild(targetName)
    if t and t.Character then getRoot().CFrame = getRoot(t.Character).CFrame * CFrame.new(0,0,3) end
end})
TPTab:CreateButton({Name = "Actualiser Liste", Callback = function()
    local nl = {} for _, p in pairs(Players:GetPlayers()) do table.insert(nl, p.Name) end
    TPDrop:Refresh(nl)
end})

-- ══════════════════════════════════════
-- ONGLET 5 : 🏃 MOUVEMENT & 📜 OUTILS
-- ══════════════════════════════════════
local MoveTab = Window:CreateTab("🏃 Mouvement", 4483362458)
MoveTab:CreateToggle({Name = "Fly + Noclip", CurrentValue = false, Callback = function(v) flyActive = v; noclipActive = v end})
MoveTab:CreateSlider({Name = "Vitesse Marche", Range = {16, 300}, Increment = 1, CurrentValue = 16, Callback = function(v) walkSpeed = v end})

local ToolTab = Window:CreateTab("📜 Outils", 4483362458)
local code = ""
ToolTab:CreateInput({Name = "Exécuteur de Script", Callback = function(t) code = t end})
ToolTab:CreateButton({Name = "Lancer Script 🚀", Callback = function() loadstring(code)() end})

-- ══════════════════════════════════════
-- LOGIQUE FINALE (BOUCLES)
-- ══════════════════════════════════════
RunService.Stepped:Connect(function()
    if noclipActive and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end
    if flyActive and getRoot() then
        local dir = getHum().MoveDirection
        getRoot().Velocity = (dir.Magnitude > 0) and ((Camera.CFrame.LookVector * (dir.Z * -1) + Camera.CFrame.RightVector * dir.X) * (flySpeed * 50)) or Vector3.zero
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        if getHum() then getHum().WalkSpeed = walkSpeed end
    end
end)

Rayfield:Notify({Title = "Elite V31", Content = "Système opérationnel et synchronisé Discord.", Duration = 5})

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
