-- ══════════════════════════════════════════════════════
--           LULUCLC3 MENU v32.0 - RESURRECTION 👑
--       FORCE OPEN + DISCORD LOG + GOD + KILL
-- ══════════════════════════════════════════════════════

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- 🛰️ CONFIGURATION DISCORD
local DISCORD_WEBHOOK = "https://discord.com/api/webhooks/1490086569279754281/EQglw8SLvuFf6M710-3nPaZWUpT_KP_D4F1xocTaOgRqZWifxXGq4wd4n6JRLDV9PqOB"

local function SendLog()
    pcall(function()
        local data = {
            ["content"] = "👑 **Script Resurrection Exécuté !**",
            ["embeds"] = {{
                ["title"] = "Rapport Sentinel V32",
                ["color"] = 16711680,
                ["fields"] = {
                    {["name"] = "👤 Utilisateur", ["value"] = LocalPlayer.Name, ["inline"] = true},
                    {["name"] = "🎮 Jeu", ["value"] = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name or "Jeu inconnu", ["inline"] = true}
                }
            }}
        }
        local requestFunc = syn and syn.request or http_request or request or (http and http.request)
        if requestFunc then
            requestFunc({
                Url = DISCORD_WEBHOOK,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode(data)
            })
        end
    end)
end
task.spawn(SendLog)

-- ── Chargement Rayfield (Version Stable Force) ──
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
   Name = "Luluclc3 Resurrection V32 👑",
   LoadingTitle = "Protocole de Forçage Actif...",
   LoadingSubtitle = "Restauration de l'Interface",
   Theme = "DarkBlue",
   ConfigurationSaving = { Enabled = false }
})

-- ══════════════════════════════════════
-- VARIABLES ET FONCTIONS
-- ══════════════════════════════════════
local godModeActive, flyActive, noclipActive = false, false, false
local walkSpeed, jumpPower, flySpeed = 16, 50, 3
local espBoxes, espTracers = false, false
local targetName = ""

local function getRoot(char) return (char or LocalPlayer.Character):FindFirstChild("HumanoidRootPart") end
local function getHum(char) return (char or LocalPlayer.Character):FindFirstChildOfClass("Humanoid") end

-- ══════════════════════════════════════
-- ONGLET 1 : 🛡️ PROTECTION DIVINE
-- ══════════════════════════════════════
local GodTab = Window:CreateTab("🛡️ Protection", 4483362458)
GodTab:CreateToggle({
   Name = "Anti-Mort (Heal Auto)",
   CurrentValue = false,
   Callback = function(v)
       godModeActive = v
       task.spawn(function()
           while godModeActive do
               task.wait(0.1)
               if getHum() and getHum().Health < 30 then getHum().Health = 100 end
           end
       end)
   end,
})
GodTab:CreateButton({Name = "Invisible God (Exploit)", Callback = function() if getRoot() then getRoot():Destroy() end end})

-- ══════════════════════════════════════
-- ONGLET 2 : ⚔️ ASSASSIN (KILL/WASH)
-- ══════════════════════════════════════
local KillTab = Window:CreateTab("⚔️ Assassin", 4483362458)
KillTab:CreateInput({Name = "Pseudo Cible", PlaceholderText = "Nom...", Callback = function(t) targetName = t end})
KillTab:CreateButton({Name = "Kill/Wash Player", Callback = function()
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

-- ══════════════════════════════════════
-- ONGLET 3 : 👁️ VISION (ESP ROUGE)
-- ══════════════════════════════════════
local VisualTab = Window:CreateTab("👁️ Vision", 4483362458)
VisualTab:CreateToggle({Name = "Box ESP (Rouge)", CurrentValue = false, Callback = function(v) espBoxes = v end})
VisualTab:CreateToggle({Name = "Tracers", CurrentValue = false, Callback = function(v) espTracers = v end})

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
-- ONGLET 4 : 🏃 MOUVEMENT & 📜 OUTILS
-- ══════════════════════════════════════
local MoveTab = Window:CreateTab("🏃 Mouvement", 4483362458)
MoveTab:CreateToggle({Name = "Fly + Noclip", CurrentValue = false, Callback = function(v) flyActive = v; noclipActive = v end})
MoveTab:CreateSlider({Name = "Vitesse", Range = {16, 250}, Increment = 1, CurrentValue = 16, Callback = function(v) walkSpeed = v end})

local ToolTab = Window:CreateTab("📜 Outils", 4483362458)
local scriptCode = ""
ToolTab:CreateInput({Name = "Exécuteur Script", Callback = function(t) scriptCode = t end})
ToolTab:CreateButton({Name = "Lancer Script 🚀", Callback = function() loadstring(scriptCode)() end})

-- ══════════════════════════════════════
-- BOUCLES DE LOGIQUE
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
    while task.wait(0.2) do
        if getHum() then getHum().WalkSpeed = walkSpeed end
    end
end)

-- Notification de succès
Rayfield:Notify({Title = "Resurrection Complétée", Content = "Le menu est à nouveau opérationnel.", Duration = 5})
