-- ══════════════════════════════════════════════════════
--           LULUCLC3 MENU v25.0 - APEX PERFORMANCE 👑
--        ESP ROUGE, CUSTOM SPEEDS & VULN LIST
-- ══════════════════════════════════════════════════════

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ── Chargement Rayfield (Optimisé) ──
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
   Name = "Luluclc3 Master V25 👑",
   LoadingTitle = "Protocoles Apex en cours...",
   LoadingSubtitle = "Performance & Élégance",
   Theme = "DarkBlue",
   ConfigurationSaving = { Enabled = true, Folder = "Luluclc3_V25" }
})

-- ══════════════════════════════════════
-- VARIABLES GLOBALES (Performances)
-- ══════════════════════════════════════
local flyActive, noclipActive = false, false
local flySpeed, walkSpeed, jumpPower = 3, 16, 50
local espTracers, espBoxes, espNames = false, false, false
local spinning, spinSpeed = false, 50
local jerkActive = false

local function getRoot() return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") end
local function getHum() return LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") end

-- ══════════════════════════════════════
-- ONGLET 1 : 🔍 SERVER SENTINEL (LISTE DES FAILLES)
-- ══════════════════════════════════════
local ScanTab = Window:CreateTab("🔍 Failles & Serveur", 4483362458)

ScanTab:CreateSection("🛡️ Scanner de Vulnérabilités")

local VulnParagraph = ScanTab:CreateParagraph({Title = "Failles Détectées :", Content = "Aucun scan effectué."})

ScanTab:CreateButton({
   Name = "Lancer l'Analyse du Serveur 🚀",
   Callback = function()
       VulnParagraph:Set({Title = "Analyse...", Content = "Recherche des remotes en cours..."})
       task.wait(0.5) -- Petite pause pour ne pas figer le jeu
       
       local foundRemotes = {}
       -- Scan ciblé pour plus de performances (ReplicatedStorage et workspace sont les plus courants)
       local targets = {game:GetService("ReplicatedStorage"), workspace}
       
       for _, directory in pairs(targets) do
           for _, v in pairs(directory:GetDescendants()) do
               if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
                   local n = v.Name:lower()
                   -- Mots-clés de failles (Backdoors/Admin)
                   if n:find("admin") or n:find("give") or n:find("money") or n:find("cash") or n:find("ban") or n:find("kill") or n:find("kick") then
                       table.insert(foundRemotes, "⚠️ " .. v.Name .. " (" .. v.ClassName .. ")")
                   end
               end
           end
       end
       
       if #foundRemotes > 0 then
           VulnParagraph:Set({Title = "Failles Détectées (" .. #foundRemotes .. ") :", Content = table.concat(foundRemotes, "\n")})
           Rayfield:Notify({Title = "Succès", Content = "Failles listées dans le menu !", Duration = 3})
       else
           VulnParagraph:Set({Title = "Résultat :", Content = "Aucune faille critique apparente trouvée dans ReplicatedStorage/Workspace."})
       end
   end,
})

-- ══════════════════════════════════════
-- ONGLET 2 : 👁️ VISUALS (ESP ROUGE & VIDE)
-- ══════════════════════════════════════
local VisualTab = Window:CreateTab("👁️ Visuals ESP", 4483362458)

VisualTab:CreateToggle({Name = "Box (Cadres Rouges Vides)", CurrentValue = false, Callback = function(v) espBoxes = v end})
VisualTab:CreateToggle({Name = "Tracers (Lignes)", CurrentValue = false, Callback = function(v) espTracers = v end})
VisualTab:CreateToggle({Name = "Noms des Joueurs", CurrentValue = false, Callback = function(v) espNames = v end})

-- Moteur ESP Haute Performance (Drawing API)
local function CreateESP(p)
    local tracer = Drawing.new("Line")
    local box = Drawing.new("Square")
    local name = Drawing.new("Text")
    
    -- Configuration stricte du cadre selon vos ordres
    box.Color = Color3.fromRGB(255, 0, 0) -- Rouge pur
    box.Filled = false -- Pas de remplissage
    box.Thickness = 1.5

    local connection
    connection = RunService.RenderStepped:Connect(function()
        if p and p.Parent and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p ~= LocalPlayer then
            local rootPos, onScreen = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if onScreen then
                -- BOX ROUGE
                if espBoxes then
                    box.Visible = true
                    box.Size = Vector2.new(2000 / rootPos.Z, 3500 / rootPos.Z)
                    box.Position = Vector2.new(rootPos.X - box.Size.X / 2, rootPos.Y - box.Size.Y / 2)
                else box.Visible = false end
                
                -- TRACERS
                if espTracers then
                    tracer.Visible = true
                    tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    tracer.To = Vector2.new(rootPos.X, rootPos.Y)
                    tracer.Color = Color3.fromRGB(255, 0, 0)
                else tracer.Visible = false end
                
                -- NOMS
                if espNames then
                    name.Visible = true
                    name.Text = p.Name
                    name.Position = Vector2.new(rootPos.X, rootPos.Y - (box.Size.Y / 2) - 15)
                    name.Center = true; name.Outline = true; name.Color = Color3.new(1,1,1)
                else name.Visible = false end
            else
                tracer.Visible = false; box.Visible = false; name.Visible = false
            end
        else
            tracer.Visible = false; box.Visible = false; name.Visible = false
            -- Nettoyage de la mémoire si le joueur quitte
            if not p or not p.Parent then
                tracer:Remove(); box:Remove(); name:Remove()
                if connection then connection:Disconnect() end
            end
        end
    end)
end

for _, p in pairs(Players:GetPlayers()) do CreateESP(p) end
Players.PlayerAdded:Connect(CreateESP)

-- ══════════════════════════════════════
-- ONGLET 3 : 🏃 MODIFICATEURS & FLY
-- ══════════════════════════════════════
local MoveTab = Window:CreateTab("🏃 Mouvement & Vitesses", 4483362458)

MoveTab:CreateSection("✈️ Vol Ultime")
MoveTab:CreateToggle({
   Name = "Fly + Noclip",
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
               if bv then bv:Destroy() end
               if bg then bg:Destroy() end
               if getHum() then getHum().PlatformStand = false end
           end)
       end
   end,
})

MoveTab:CreateSlider({Name = "Vitesse du Vol", Range = {1, 100}, Increment = 1, CurrentValue = 3, Callback = function(v) flySpeed = v end})

MoveTab:CreateSection("⚡ Personnalisation Vitesse Physique")
MoveTab:CreateSlider({
   Name = "WalkSpeed (Vitesse de marche)",
   Range = {16, 200}, Increment = 1, CurrentValue = 16,
   Callback = function(v)
       walkSpeed = v
       if getHum() then getHum().WalkSpeed = walkSpeed end
   end,
})

MoveTab:CreateSlider({
   Name = "JumpPower (Hauteur de saut)",
   Range = {50, 300}, Increment = 1, CurrentValue = 50,
   Callback = function(v)
       jumpPower = v
       if getHum() then getHum().JumpPower = jumpPower end
   end,
})

-- Boucle pour forcer le WalkSpeed/JumpPower (certains jeux le remettent à zéro)
task.spawn(function()
    while task.wait(0.5) do
        if getHum() then
            if walkSpeed > 16 then getHum().WalkSpeed = walkSpeed end
            if jumpPower > 50 then getHum().JumpPower = jumpPower end
        end
    end
end)

-- ══════════════════════════════════════
-- ONGLET 4 : 🤡 TROLL & CHAOS
-- ══════════════════════════════════════
local TrollTab = Window:CreateTab("🤡 Troll", 4483362458)

TrollTab:CreateToggle({
   Name = "Forcer Jerk 💦",
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

TrollTab:CreateToggle({Name = "Tornado Spin", CurrentValue = false, Callback = function(v) spinning = v end})
TrollTab:CreateSlider({Name = "Vitesse du Spin", Range = {10, 500}, Increment = 10, CurrentValue = 50, Callback = function(v) spinSpeed = v end})

-- ══════════════════════════════════════
-- OPTIMISATION GLOBALE (Stepped)
-- ══════════════════════════════════════
RunService.Stepped:Connect(function()
    -- Noclip optimisé
    if noclipActive and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
    -- Spin optimisé
    if spinning and getRoot() then 
        getRoot().CFrame = getRoot().CFrame * CFrame.Angles(0, math.rad(spinSpeed), 0) 
    end
end)

Rayfield:Notify({Title = "Luluclc3 V25", Content = "Systèmes calibrés. Prêt à l'emploi.", Duration = 5})
