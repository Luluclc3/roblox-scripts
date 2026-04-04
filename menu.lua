-- ══════════════════════════════════════════════════════
--           LULUCLC3 MENU v26.0 - PRESTIGE MOBILE 👑
--      ÉLÉGANCE ABSOLUE, BOUTON TACTILE & SCANNER PRO
-- ══════════════════════════════════════════════════════

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ══════════════════════════════════════
-- 📱 BOUTON FLOTTANT MOBILE (ÉLÉGANT)
-- ══════════════════════════════════════
local LuluUI = Instance.new("ScreenGui")
LuluUI.Name = "Luluclc3MobileUI"
LuluUI.Parent = CoreGui

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleMenu"
ToggleBtn.Parent = LuluUI
ToggleBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
ToggleBtn.Position = UDim2.new(0, 10, 0.5, 0) -- Milieu gauche de l'écran
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Text = "👑"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 215, 0) -- Or
ToggleBtn.TextSize = 25
ToggleBtn.AutoButtonColor = true
ToggleBtn.BorderSizePixel = 0

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0) -- Bouton parfaitement rond
UICorner.Parent = ToggleBtn

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(255, 215, 0)
UIStroke.Thickness = 2
UIStroke.Parent = ToggleBtn

-- Permet de déplacer le bouton sur l'écran
local dragging, dragInput, dragStart, startPos
ToggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = ToggleBtn.Position
    end
end)
ToggleBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        ToggleBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

-- ── Chargement Rayfield (Interface Luxueuse) ──
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
   Name = "Luluclc3 Prestige V26 👑",
   LoadingTitle = "Ouverture du Salon Privé...",
   LoadingSubtitle = "Adaptation Mobile Parfaite",
   Theme = "DarkBlue",
   ConfigurationSaving = { Enabled = true, Folder = "Luluclc3_V26" }
})

-- Action du bouton flottant
local menuOpen = true
ToggleBtn.MouseButton1Click:Connect(function()
    if not dragging then
        -- Simule l'appui sur RightControl (Touche par défaut de Rayfield) pour ouvrir/fermer
        game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.RightControl, false, game)
        game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.RightControl, false, game)
    end
end)

-- ══════════════════════════════════════
-- VARIABLES GLOBALES
-- ══════════════════════════════════════
local flyActive, noclipActive = false, false
local flySpeed, walkSpeed, jumpPower = 3, 16, 50
local espTracers, espBoxes, espNames = false, false, false
local spinning, spinSpeed = false, 50
local jerkActive = false

local function getRoot() return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") end
local function getHum() return LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") end

-- ══════════════════════════════════════
-- ONGLET 1 : 🔍 SENTINEL (SCANNER DE FAILLES)
-- ══════════════════════════════════════
local ScanTab = Window:CreateTab("🔍 Failles", 4483362458)

ScanTab:CreateSection("📜 Rapport d'Analyse du Serveur")
local VulnList = ScanTab:CreateParagraph({Title = "Status : En attente", Content = "Appuyez sur Scanner pour inspecter l'architecture du jeu."})

ScanTab:CreateButton({
   Name = "🔍 Lancer l'Inspection Profonde",
   Callback = function()
       VulnList:Set({Title = "Analyse en cours...", Content = "Veuillez patienter, examen des paquets..."})
       task.wait(1)
       
       local foundRemotes = {}
       local scanTargets = {game:GetService("ReplicatedStorage"), workspace, game:GetService("Lighting")}
       
       for _, directory in pairs(scanTargets) do
           for _, v in pairs(directory:GetDescendants()) do
               if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
                   local n = v.Name:lower()
                   if n:find("admin") or n:find("give") or n:find("money") or n:find("cash") or n:find("ban") or n:find("kill") or n:find("kick") or n:find("exploit") then
                       table.insert(foundRemotes, "▶ ["..v.ClassName.."] : " .. v.Name)
                   end
               end
           end
       end
       
       if #foundRemotes > 0 then
           VulnList:Set({Title = "⚠️ Vulnérabilités Potentielles (" .. #foundRemotes .. ") :", Content = table.concat(foundRemotes, "\n")})
           Rayfield:Notify({Title = "Scan Terminé", Content = "Le rapport de failles a été mis à jour.", Duration = 4})
       else
           VulnList:Set({Title = "✅ Résultat Sécurisé", Content = "Aucune faille majeure (Admin/Give/Kill) n'a été trouvée dans les dossiers principaux."})
       end
   end,
})

-- ══════════════════════════════════════
-- ONGLET 2 : 👁️ VISUALS (ESP ROUGE & VIDE)
-- ══════════════════════════════════════
local VisualTab = Window:CreateTab("👁️ Vision", 4483362458)

VisualTab:CreateSection("🔴 Scanner Thermique (Rouge Pur)")
VisualTab:CreateToggle({Name = "Cadres (Box Vides)", CurrentValue = false, Callback = function(v) espBoxes = v end})
VisualTab:CreateToggle({Name = "Lignes (Tracers)", CurrentValue = false, Callback = function(v) espTracers = v end})
VisualTab:CreateToggle({Name = "Identités (Noms)", CurrentValue = false, Callback = function(v) espNames = v end})

local function CreateESP(p)
    local tracer = Drawing.new("Line")
    local box = Drawing.new("Square")
    local name = Drawing.new("Text")
    
    box.Color = Color3.fromRGB(255, 0, 0); box.Filled = false; box.Thickness = 1.5
    tracer.Color = Color3.fromRGB(255, 0, 0); tracer.Thickness = 1.5
    
    local conn
    conn = RunService.RenderStepped:Connect(function()
        if p and p.Parent and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p ~= LocalPlayer then
            local rootPos, onScreen = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if onScreen then
                if espBoxes then
                    box.Visible = true; box.Size = Vector2.new(2000 / rootPos.Z, 3500 / rootPos.Z)
                    box.Position = Vector2.new(rootPos.X - box.Size.X / 2, rootPos.Y - box.Size.Y / 2)
                else box.Visible = false end
                
                if espTracers then
                    tracer.Visible = true; tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    tracer.To = Vector2.new(rootPos.X, rootPos.Y)
                else tracer.Visible = false end
                
                if espNames then
                    name.Visible = true; name.Text = p.Name
                    name.Position = Vector2.new(rootPos.X, rootPos.Y - (box.Size.Y / 2) - 15)
                    name.Center = true; name.Outline = true; name.Color = Color3.fromRGB(255, 0, 0)
                else name.Visible = false end
            else
                tracer.Visible = false; box.Visible = false; name.Visible = false
            end
        else
            tracer.Visible = false; box.Visible = false; name.Visible = false
            if not p or not p.Parent then
                tracer:Remove(); box:Remove(); name:Remove()
                if conn then conn:Disconnect() end
            end
        end
    end)
end

for _, p in pairs(Players:GetPlayers()) do CreateESP(p) end
Players.PlayerAdded:Connect(CreateESP)

-- ══════════════════════════════════════
-- ONGLET 3 : 🏃 MOUVEMENT (FLY MOBILE)
-- ══════════════════════════════════════
local MoveTab = Window:CreateTab("🏃 Mouvement", 4483362458)

MoveTab:CreateSection("✈️ Lévitation Mobile")
MoveTab:CreateToggle({
   Name = "Activer Fly + Noclip",
   CurrentValue = false,
   Callback = function(v)
       flyActive, noclipActive = v, v
       if v then
           task.spawn(function()
               local bv = Instance.new("BodyVelocity", getRoot())
               local bg = Instance.new("BodyGyro", getRoot())
               bv.MaxForce = Vector3.new(9e9, 9e9, 9e9); bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
               while flyActive do
                   RunService.RenderStepped:Wait()
                   if getRoot() and getHum() then
                       getHum().PlatformStand = true
                       bg.CFrame = Camera.CFrame
                       local dir = getHum().MoveDirection
                       bv.Velocity = (dir.Magnitude > 0) and ((Camera.CFrame.LookVector * (dir.Z * -1) + Camera.CFrame.RightVector * dir.X) * (flySpeed * 50)) or Vector3.zero
                   end
               end
               if bv then bv:Destroy() end; if bg then bg:Destroy() end
               if getHum() then getHum().PlatformStand = false end
           end)
       end
   end,
})
MoveTab:CreateSlider({Name = "Vitesse de Vol", Range = {1, 100}, Increment = 1, CurrentValue = 3, Callback = function(v) flySpeed = v end})

MoveTab:CreateSection("⚡ Capacités Physiques")
MoveTab:CreateSlider({Name = "Vitesse de Marche", Range = {16, 200}, Increment = 1, CurrentValue = 16, Callback = function(v) walkSpeed = v end})
MoveTab:CreateSlider({Name = "Hauteur de Saut", Range = {50, 300}, Increment = 1, CurrentValue = 50, Callback = function(v) jumpPower = v end})

task.spawn(function()
    while task.wait(0.5) do
        if getHum() then
            if walkSpeed > 16 then getHum().WalkSpeed = walkSpeed end
            if jumpPower > 50 then getHum().JumpPower = jumpPower end
        end
    end
end)

-- ══════════════════════════════════════
-- ONGLET 4 : 🤡 TROLL
-- ══════════════════════════════════════
local TrollTab = Window:CreateTab("🤡 Troll", 4483362458)

TrollTab:CreateToggle({
   Name = "Jerk Emote 💦 (Forcé)",
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
TrollTab:CreateSlider({Name = "Vitesse Spin", Range = {10, 500}, Increment = 10, CurrentValue = 50, Callback = function(v) spinSpeed = v end})

-- ══════════════════════════════════════
-- ONGLET 5 : ⚙️ SYSTÈME & APPARENCE
-- ══════════════════════════════════════
local SysTab = Window:CreateTab("⚙️ Système", 4483362458)

SysTab:CreateSection("📱 Interface Mobile")
SysTab:CreateToggle({
   Name = "Afficher le Bouton Flottant Couronne 👑",
   CurrentValue = true,
   Callback = function(v)
       if LuluUI then LuluUI.Enabled = v end
   end,
})

SysTab:CreateSection("🛑 Sécurité")
SysTab:CreateButton({
   Name = "Détruire le Script (Panic Button)",
   Callback = function()
       Rayfield:Destroy()
       if LuluUI then LuluUI:Destroy() end
       flyActive = false; noclipActive = false; spinning = false; jerkActive = false
       espBoxes = false; espTracers = false; espNames = false
       if getHum() then getHum().WalkSpeed = 16; getHum().JumpPower = 50 end
   end,
})

-- ══════════════════════════════════════
-- OPTIMISATION
-- ══════════════════════════════════════
RunService.Stepped:Connect(function()
    if noclipActive and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
    if spinning and getRoot() then getRoot().CFrame = getRoot().CFrame * CFrame.Angles(0, math.rad(spinSpeed), 0) end
end)

Rayfield:Notify({Title = "Luluclc3 V26", Content = "Le Menu Prestige est à votre service.", Duration = 5})
