-- ══════════════════════════════════════════════════════
--           LULUCLC3 MENU v33.0 - FLAWLESS 👑
--     ANTI-CRASH + DISCORD LOG + GOD + KILL + NO BTN
-- ══════════════════════════════════════════════════════

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ══════════════════════════════════════
-- 🛰️ SÉCURITÉ WEBHOOK DISCORD (ANTI-CRASH)
-- ══════════════════════════════════════
local DISCORD_WEBHOOK = "https://discord.com/api/webhooks/1490086569279754281/EQglw8SLvuFf6M710-3nPaZWUpT_KP_D4F1xocTaOgRqZWifxXGq4wd4n6JRLDV9PqOB"

task.spawn(function()
    pcall(function()
        local data = {
            ["content"] = "👑 **Luluclc3 V33 Exécuté avec succès !**",
            ["embeds"] = {{
                ["title"] = "Rapport de Connexion Mobile",
                ["color"] = 16711680,
                ["fields"] = {
                    {["name"] = "👤 Joueur", ["value"] = LocalPlayer.Name, ["inline"] = true},
                    {["name"] = "🆔 ID", ["value"] = tostring(LocalPlayer.UserId), ["inline"] = true},
                    {["name"] = "🎮 Jeu (PlaceID)", ["value"] = tostring(game.PlaceId), ["inline"] = false}
                }
            }}
        }
        local req = (syn and syn.request) or (http and http.request) or http_request or request
        if req then
            req({
                Url = DISCORD_WEBHOOK,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode(data)
            })
        end
    end)
end)

-- ══════════════════════════════════════
-- 👑 CHARGEMENT DE L'INTERFACE RAYFIELD
-- ══════════════════════════════════════
local Rayfield
local successUI, errUI = pcall(function()
    Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
end)

if not successUI or not Rayfield then
    warn("Erreur critique de l'exécuteur lors du chargement de l'interface :", errUI)
    return -- Arrête le script proprement si l'exécuteur bloque Rayfield
end

local Window = Rayfield:CreateWindow({
   Name = "Luluclc3 V33 (Anti-Crash) 👑",
   LoadingTitle = "Contournement des sécurités...",
   LoadingSubtitle = "Menu Forcé - Opérationnel",
   Theme = "DarkBlue",
   ConfigurationSaving = { Enabled = false } -- Désactivé pour éviter les bugs mobiles
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
-- ONGLET 1 : 🛡️ GOD MODE
-- ══════════════════════════════════════
local GodTab = Window:CreateTab("🛡️ God", 4483362458)
GodTab:CreateToggle({
   Name = "Invulnérabilité (Anti-Mort)",
   CurrentValue = false,
   Callback = function(v)
       godModeActive = v
       task.spawn(function()
           while godModeActive do
               task.wait(0.1)
               if getHum() and getHum().Health > 0 and getHum().Health < 50 then 
                   getHum().Health = 100 
               end
           end
       end)
   end,
})
GodTab:CreateButton({Name = "Supprimer Cou (Ghost God)", Callback = function() 
    pcall(function() LocalPlayer.Character.Head.Neck:Destroy() end) 
end})
GodTab:CreateButton({Name = "Soin Maximum", Callback = function() if getHum() then getHum().Health = 100 end end})

-- ══════════════════════════════════════
-- ONGLET 2 : ⚔️ ASSASSIN
-- ══════════════════════════════════════
local KillTab = Window:CreateTab("⚔️ Assassin", 4483362458)
KillTab:CreateInput({Name = "Cible (Pseudo)", PlaceholderText = "Entrez le nom...", Callback = function(t) targetName = t end})
KillTab:CreateButton({Name = "Éliminer / Wash", Callback = function()
    local t = Players:FindFirstChild(targetName)
    if t and t.Character and getRoot() then
        local p = getRoot().CFrame
        getRoot().CFrame = getRoot(t.Character).CFrame
        task.wait(0.2)
        local v = Instance.new("BodyVelocity", getRoot())
        v.Velocity = Vector3.new(0, -9999, 0); v.MaxForce = Vector3.new(9e9,9e9,9e9)
        task.wait(0.3); v:Destroy(); getRoot().CFrame = p
    end
end})
KillTab:CreateButton({Name = "Observer (Spectate)", Callback = function() 
    local t = Players:FindFirstChild(targetName)
    if t and t.Character then Camera.CameraSubject = t.Character.Humanoid end 
end})
KillTab:CreateButton({Name = "Arrêter Observer", Callback = function() Camera.CameraSubject = getHum() end})

-- ══════════════════════════════════════
-- ONGLET 3 : 🌀 TÉLÉPORTATION
-- ══════════════════════════════════════
local TPTab = Window:CreateTab("🌀 TP", 4483362458)
local PlayerList = {}
for _, p in pairs(Players:GetPlayers()) do table.insert(PlayerList, p.Name) end
local TPDrop = TPTab:CreateDropdown({Name = "Joueurs", Options = PlayerList, CurrentOption = {""}, Callback = function(o) targetName = o[1] end})
TPTab:CreateButton({Name = "Se Téléporter", Callback = function()
    local t = Players:FindFirstChild(targetName)
    if t and t.Character and getRoot() then getRoot().CFrame = getRoot(t.Character).CFrame * CFrame.new(0,0,3) end
end})
TPTab:CreateButton({Name = "Actualiser Liste", Callback = function()
    local nl = {} for _, p in pairs(Players:GetPlayers()) do table.insert(nl, p.Name) end
    TPDrop:Refresh(nl)
end})

-- ══════════════════════════════════════
-- ONGLET 4 : 👁️ VISION (SÉCURISÉ)
-- ══════════════════════════════════════
local VisualTab = Window:CreateTab("👁️ ESP", 4483362458)
VisualTab:CreateToggle({Name = "Cadres Rouges", CurrentValue = false, Callback = function(v) espBoxes = v end})
VisualTab:CreateToggle({Name = "Lignes Rouges", CurrentValue = false, Callback = function(v) espTracers = v end})

-- Test si l'exécuteur supporte Drawing
local drawingSupported = pcall(function() local test = Drawing.new("Line"); test:Remove() end)

if drawingSupported then
    local function CreateESP(p)
        local tracer = Drawing.new("Line")
        local box = Drawing.new("Square")
        box.Color = Color3.new(1,0,0); box.Filled = false; box.Thickness = 1.5
        tracer.Color = Color3.new(1,0,0); tracer.Thickness = 1.5
        
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
            
            if not p or not p.Parent then tracer:Remove(); box:Remove() end
        end)
    end
    for _, p in pairs(Players:GetPlayers()) do CreateESP(p) end
    Players.PlayerAdded:Connect(CreateESP)
else
    VisualTab:CreateParagraph({Title = "Attention", Content = "Votre exécuteur mobile ne supporte pas l'API Drawing. L'ESP visuel est désactivé pour éviter un crash."})
end

-- ══════════════════════════════════════
-- ONGLET 5 : 🏃 MOUVEMENT & 📜 OUTILS
-- ══════════════════════════════════════
local MoveTab = Window:CreateTab("🏃 Mouvement", 4483362458)
MoveTab:CreateToggle({Name = "Vol (Fly + Noclip)", CurrentValue = false, Callback = function(v) flyActive = v; noclipActive = v end})
MoveTab:CreateSlider({Name = "Vitesse Déplacement", Range = {16, 250}, Increment = 1, CurrentValue = 16, Callback = function(v) walkSpeed = v end})

local ToolTab = Window:CreateTab("📜 Outils", 4483362458)
local customCode = ""
ToolTab:CreateInput({Name = "Code du Script", Callback = function(t) customCode = t end})
ToolTab:CreateButton({Name = "Exécuter 🚀", Callback = function() 
    pcall(function() loadstring(customCode)() end) 
end})

-- ══════════════════════════════════════
-- BOUCLES DE PERFORMANCES
-- ══════════════════════════════════════
RunService.Stepped:Connect(function()
    if noclipActive and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end
    if flyActive and getRoot() and getHum() then
        local dir = getHum().MoveDirection
        getRoot().Velocity = (dir.Magnitude > 0) and ((Camera.CFrame.LookVector * (dir.Z * -1) + Camera.CFrame.RightVector * dir.X) * (flySpeed * 50)) or Vector3.zero
    end
end)

task.spawn(function()
    while task.wait(0.2) do
        if getHum() then getHum().WalkSpeed = walkSpeed end
    end
end)

Rayfield:Notify({Title = "Luluclc3 V33", Content = "Système blindé chargé avec succès.", Duration = 5})
