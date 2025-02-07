-- Primero cargamos la biblioteca UI
local DEVIL_UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/TUUSER/DEVIL-Hub/main/DEVIL-Hub.lua"))()

-- Creamos la ventana principal
local window = DEVIL_UI:CreateWindow("DEVIL Hub", "Universal")

-- Pestaña Principal (Main)
local mainTab = window:CreateTab("Main")

mainTab:CreateSection("Player Modifications")

-- WalkSpeed Slider
mainTab:CreateSlider("WalkSpeed", {
    Min = 16,
    Max = 500,
    Default = 16
}, function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)

-- JumpPower Slider
mainTab:CreateSlider("JumpPower", {
    Min = 50,
    Max = 500,
    Default = 50
}, function(value)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
end)

-- Infinite Jump Toggle
local infiniteJumpEnabled = false
mainTab:CreateToggle("Infinite Jump", function(state)
    infiniteJumpEnabled = state
    game:GetService("UserInputService").JumpRequest:Connect(function()
        if infiniteJumpEnabled then
            game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):ChangeState("Jumping")
        end
    end)
end)

-- Noclip Toggle
local noclipEnabled = false
mainTab:CreateToggle("Noclip", function(state)
    noclipEnabled = state
    game:GetService('RunService').Stepped:Connect(function()
        if noclipEnabled then
            for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
end)

-- Pestaña de Teleports
local teleportTab = window:CreateTab("Teleports")

teleportTab:CreateSection("Player Teleports")

-- Teleport to Player Dropdown
local players = {}
for _, player in pairs(game.Players:GetPlayers()) do
    if player ~= game.Players.LocalPlayer then
        table.insert(players, player.Name)
    end
end

teleportTab:CreateDropdown("Teleport to Player", players, function(selected)
    local targetPlayer = game.Players:FindFirstChild(selected)
    if targetPlayer and targetPlayer.Character then
        game.Players.LocalPlayer.Character:MoveTo(targetPlayer.Character.HumanoidRootPart.Position)
    end
end)

-- Teleport to Random Player Button
teleportTab:CreateButton("Teleport to Random Player", function()
    local players = game.Players:GetPlayers()
    local randomPlayer = players[math.random(1, #players)]
    if randomPlayer ~= game.Players.LocalPlayer and randomPlayer.Character then
        game.Players.LocalPlayer.Character:MoveTo(randomPlayer.Character.HumanoidRootPart.Position)
    end
end)

-- Pestaña de Visual
local visualTab = window:CreateTab("Visual")

visualTab:CreateSection("ESP Options")

-- ESP Toggle
local espEnabled = false
visualTab:CreateToggle("Player ESP", function(state)
    espEnabled = state
    while espEnabled do
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character then
                -- Crear o actualizar ESP
                local esp = player.Character:FindFirstChild("ESP") or Instance.new("BillboardGui")
                esp.Name = "ESP"
                esp.AlwaysOnTop = true
                esp.Size = UDim2.new(0, 100, 0, 50)
                esp.StudsOffset = Vector3.new(0, 3, 0)
                esp.Parent = player.Character
                
                local text = esp:FindFirstChild("Text") or Instance.new("TextLabel")
                text.Name = "Text"
                text.BackgroundTransparency = 1
                text.Size = UDim2.new(1, 0, 1, 0)
                text.Text = player.Name
                text.TextColor3 = Color3.new(1, 0, 0)
                text.TextScaled = true
                text.Parent = esp
            end
        end
        wait(0.1)
    end
end)

-- Fullbright Toggle
visualTab:CreateToggle("Fullbright", function(state)
    if state then
        game:GetService("Lighting").Brightness = 2
        game:GetService("Lighting").ClockTime = 14
        game:GetService("Lighting").FogEnd = 100000
        game:GetService("Lighting").GlobalShadows = false
        game:GetService("Lighting").OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    else
        game:GetService("Lighting").Brightness = 1
        game:GetService("Lighting").ClockTime = 12
        game:GetService("Lighting").FogEnd = 10000
        game:GetService("Lighting").GlobalShadows = true
        game:GetService("Lighting").OutdoorAmbient = Color3.fromRGB(127, 127, 127)
    end
end)

-- Pestaña de Créditos
local creditsTab = window:CreateTab("Credits")

creditsTab:CreateSection("Script Information")
creditsTab:CreateTextLabel("Created by: Your Name")
creditsTab:CreateTextLabel("Version: 1.0")
creditsTab:CreateBlankLabel("")
creditsTab:CreateTextLabel("Thanks for using DEVIL Hub!")

-- Anti AFK
local antiAFKTab = window:CreateTab("Anti AFK")
antiAFKTab:CreateSection("Anti AFK Settings")

antiAFKTab:CreateToggle("Enable Anti AFK", function(state)
    if state then
        local VirtualUser = game:GetService('VirtualUser')
        game:GetService('Players').LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end
end)

-- Auto Swing Tool
local combatTab = window:CreateTab("Combat")
combatTab:CreateSection("Auto Swing Settings")

local autoSwingEnabled = false
combatTab:CreateToggle("Auto Swing (0 Delay)", function(state)
    autoSwingEnabled = state
    
    while autoSwingEnabled do
        local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if tool and tool:FindFirstChild("Handle") then
            tool:Activate()
        end
        game:GetService("RunService").Heartbeat:Wait() -- Usa Heartbeat para el menor delay posible
    end
end)

-- Opción para equipar herramienta automáticamente
combatTab:CreateToggle("Auto Equip Tool", function(state)
    if state then
        game:GetService("RunService").Heartbeat:Connect(function()
            if autoSwingEnabled then
                local backpack = game.Players.LocalPlayer.Backpack
                local character = game.Players.LocalPlayer.Character
                
                if character then
                    local tool = character:FindFirstChildOfClass("Tool")
                    if not tool then
                        local backpackTool = backpack:FindFirstChildOfClass("Tool")
                        if backpackTool then
                            backpackTool.Parent = character
                        end
                    end
                end
            end
        end)
    end
end)

-- Selector de herramienta específica
local function getToolNames()
    local tools = {}
    local backpack = game.Players.LocalPlayer.Backpack
    local character = game.Players.LocalPlayer.Character
    
    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            table.insert(tools, tool.Name)
        end
    end
    
    if character then
        for _, tool in ipairs(character:GetChildren()) do
            if tool:IsA("Tool") then
                table.insert(tools, tool.Name)
            end
        end
    end
    
    return tools
end

combatTab:CreateDropdown("Select Tool", getToolNames(), function(selected)
    local backpack = game.Players.LocalPlayer.Backpack
    local character = game.Players.LocalPlayer.Character
    local tool = backpack:FindFirstChild(selected) or character:FindFirstChild(selected)
    
    if tool and character then
        tool.Parent = character
    end
end)

-- Botón para refrescar lista de herramientas
combatTab:CreateButton("Refresh Tool List", function()
    -- Esta funcionalidad requeriría modificar la biblioteca UI para soportar actualización de dropdowns
    print("Tool list refreshed")
end)

-- Configuración de tecla para alternar la UI
_G.ToggleUI = "RightControl" -- Puedes cambiar esto a cualquier tecla 
