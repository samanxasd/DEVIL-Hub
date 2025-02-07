--[[ 
    DEVIL UI Library
    Versión: 1.0
    Autor: smnaznk
]]

-- Limpiar instancias previas
for i,v in pairs(game.CoreGui:GetChildren()) do
    if v.Name == "DEVIL_UI_Lib" then
        v:Remove()
    end
end

-- Configuración global
_G.ToggleUI = "RightControl" -- Tecla para mostrar/ocultar la UI

local DEVIL_UI_Library = {}

function DEVIL_UI_Library:CreateWindow(GuiName, GameName)
    GuiName = GuiName or "DEVIL Hub"
    GameName = GameName or "Universal"

    -- Crear ScreenGui principal
    local ScreenGui = Instance.new("ScreenGui")
    local Main = Instance.new("Frame")
    local TitleBar = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local TabContainer = Instance.new("ScrollingFrame")
    local TabList = Instance.new("UIListLayout")
    local ContentContainer = Instance.new("Frame")

    -- Configurar ScreenGui
    ScreenGui.Name = "DEVIL_UI_Lib"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false

    -- Configurar frame principal
    Main.Name = "Main"
    Main.Parent = ScreenGui
    Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Main.BorderColor3 = Color3.fromRGB(60, 60, 60)
    Main.Position = UDim2.new(0.5, -250, 0.5, -150)
    Main.Size = UDim2.new(0, 500, 0, 300)
    Main.ClipsDescendants = true

    -- Configurar barra de título
    TitleBar.Name = "TitleBar"
    TitleBar.Parent = Main
    TitleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TitleBar.BorderSizePixel = 0
    TitleBar.Size = UDim2.new(1, 0, 0, 30)

    Title.Name = "Title"
    Title.Parent = TitleBar
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.Size = UDim2.new(1, -20, 1, 0)
    Title.Font = Enum.Font.SourceSansBold
    Title.Text = GuiName .. " | " .. GameName
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left

    -- Configurar contenedor de pestañas
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = Main
    TabContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TabContainer.BorderSizePixel = 0
    TabContainer.Position = UDim2.new(0, 10, 0, 40)
    TabContainer.Size = UDim2.new(0, 120, 1, -50)
    TabContainer.ScrollBarThickness = 2
    TabContainer.ScrollingDirection = Enum.ScrollingDirection.Y
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)

    TabList.Parent = TabContainer
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Padding = UDim.new(0, 5)

    -- Configurar contenedor de contenido
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Parent = Main
    ContentContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    ContentContainer.BorderSizePixel = 0
    ContentContainer.Position = UDim2.new(0, 140, 0, 40)
    ContentContainer.Size = UDim2.new(1, -150, 1, -50)

    -- Sistema de pestañas
    local TabHandlers = {}

    local function CreateTab(tabName)
        local tab = {}
        
        -- Crear botón de pestaña
        local tabButton = Instance.new("TextButton")
        tabButton.Name = tabName
        tabButton.Parent = TabContainer
        tabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        tabButton.BorderSizePixel = 0
        tabButton.Size = UDim2.new(1, -10, 0, 25)
        tabButton.Font = Enum.Font.SourceSans
        tabButton.Text = tabName
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabButton.TextSize = 14

        -- Crear contenedor de contenido de pestaña
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Name = tabName .. "Content"
        tabContent.Parent = ContentContainer
        tabContent.BackgroundTransparency = 1
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.ScrollBarThickness = 2
        tabContent.Visible = false
        tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)

        local contentList = Instance.new("UIListLayout")
        contentList.Parent = tabContent
        contentList.SortOrder = Enum.SortOrder.LayoutOrder
        contentList.Padding = UDim.new(0, 5)

        -- Funciones para crear elementos

        function tab:CreateButton(text, callback)
            callback = callback or function() end
            
            local button = Instance.new("TextButton")
            button.Name = text
            button.Parent = tabContent
            button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            button.Size = UDim2.new(1, -10, 0, 30)
            button.Font = Enum.Font.SourceSans
            button.Text = text
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
            button.TextSize = 14
            
            button.MouseButton1Click:Connect(callback)
            return button
        end

        function tab:CreateToggle(text, callback)
            callback = callback or function() end
            local toggled = false
            
            local toggleFrame = Instance.new("Frame")
            toggleFrame.Name = text
            toggleFrame.Parent = tabContent
            toggleFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            toggleFrame.Size = UDim2.new(1, -10, 0, 30)

            local toggleButton = Instance.new("TextButton")
            toggleButton.Parent = toggleFrame
            toggleButton.Position = UDim2.new(1, -40, 0.5, -10)
            toggleButton.Size = UDim2.new(0, 20, 0, 20)
            toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            
            toggleButton.MouseButton1Click:Connect(function()
                toggled = not toggled
                callback(toggled)
                toggleButton.BackgroundColor3 = toggled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(60, 60, 60)
            end)
            
            local label = Instance.new("TextLabel")
            label.Parent = toggleFrame
            label.BackgroundTransparency = 1
            label.Position = UDim2.new(0, 10, 0, 0)
            label.Size = UDim2.new(1, -60, 1, 0)
            label.Font = Enum.Font.SourceSans
            label.Text = text
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.TextSize = 14
            label.TextXAlignment = Enum.TextXAlignment.Left
            
            return toggleFrame
        end

        function tab:CreateSlider(text, options, callback)
            callback = callback or function() end
            options = options or {
                Min = 0,
                Max = 100,
                Default = 50
            }
            
            local sliderFrame = Instance.new("Frame")
            sliderFrame.Name = text
            sliderFrame.Parent = tabContent
            sliderFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            sliderFrame.Size = UDim2.new(1, -10, 0, 45)

            local label = Instance.new("TextLabel")
            label.Parent = sliderFrame
            label.BackgroundTransparency = 1
            label.Position = UDim2.new(0, 10, 0, 0)
            label.Size = UDim2.new(1, -20, 0, 20)
            label.Font = Enum.Font.SourceSans
            label.Text = text
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.TextSize = 14
            label.TextXAlignment = Enum.TextXAlignment.Left

            local sliderBG = Instance.new("Frame")
            sliderBG.Parent = sliderFrame
            sliderBG.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            sliderBG.Position = UDim2.new(0, 10, 0, 25)
            sliderBG.Size = UDim2.new(1, -20, 0, 5)

            local sliderFill = Instance.new("Frame")
            sliderFill.Parent = sliderBG
            sliderFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            sliderFill.Size = UDim2.new(0.5, 0, 1, 0)

            local valueLabel = Instance.new("TextLabel")
            valueLabel.Parent = sliderFrame
            valueLabel.BackgroundTransparency = 1
            valueLabel.Position = UDim2.new(1, -30, 0, 0)
            valueLabel.Size = UDim2.new(0, 20, 0, 20)
            valueLabel.Font = Enum.Font.SourceSans
            valueLabel.Text = tostring(options.Default)
            valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            valueLabel.TextSize = 14

            -- Implementar lógica del slider
            local UserInputService = game:GetService("UserInputService")
            local dragging = false

            sliderBG.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local mousePos = UserInputService:GetMouseLocation()
                    local relativePos = mousePos - sliderBG.AbsolutePosition
                    local percentage = math.clamp(relativePos.X / sliderBG.AbsoluteSize.X, 0, 1)
                    local value = math.floor(options.Min + (options.Max - options.Min) * percentage)
                    
                    sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
                    valueLabel.Text = tostring(value)
                    callback(value)
                end
            end)
            
            return sliderFrame
        end

        -- Sistema de visibilidad de pestañas
        tabButton.MouseButton1Click:Connect(function()
            for _, content in pairs(ContentContainer:GetChildren()) do
                content.Visible = false
            end
            tabContent.Visible = true
        end)

        return tab
    end

    -- Función para crear pestañas
    function DEVIL_UI_Library:CreateTab(tabName)
        local tab = CreateTab(tabName)
        table.insert(TabHandlers, tab)
        return tab
    end

    -- Implementar arrastre de ventana
    local UserInputService = game:GetService("UserInputService")
    local dragging
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)

    -- Tecla para mostrar/ocultar
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode[_G.ToggleUI] then
            ScreenGui.Enabled = not ScreenGui.Enabled
        end
    end)

    return DEVIL_UI_Library
end

return DEVIL_UI_Library 
