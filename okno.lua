-- Модуль: okno.lua (с поддержкой кнопок, тогглов и слайдеров)
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local WindowModule = {}

function WindowModule.Init()
    if CoreGui:FindFirstChild("MegaHubWindow") then
        CoreGui.MegaHubWindow:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "MegaHubWindow"
    ScreenGui.Parent = CoreGui
    ScreenGui.IgnoreGuiInset = true

    -- Главное окно
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -160)
    MainFrame.Size = UDim2.new(0, 520, 0, 350)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(45, 45, 55)
    UIStroke.Thickness = 1.5
    UIStroke.Parent = MainFrame

    -- Шапка окна
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Parent = MainFrame
    TopBar.BackgroundTransparency = 1
    TopBar.Size = UDim2.new(1, 0, 0, 35)

    local Title = Instance.new("TextLabel")
    Title.Parent = TopBar
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.Size = UDim2.new(0, 300, 1, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = "Mega Hub | Custom UI"
    Title.TextColor3 = Color3.fromRGB(240, 240, 240)
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left

    -- Кнопка закрытия
    local CloseButton = Instance.new("TextButton")
    CloseButton.Parent = TopBar
    CloseButton.BackgroundTransparency = 1
    CloseButton.Position = UDim2.new(1, -35, 0, 7)
    CloseButton.Size = UDim2.new(0, 20, 0, 20)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(150, 150, 160)
    CloseButton.TextSize = 14

    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    -- Перетаскивание окна
    local dragging, dragInput, dragStart, startPos
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    TopBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Список вкладок (слева)
    local TabList = Instance.new("ScrollingFrame")
    TabList.Parent = MainFrame
    TabList.Active = true
    TabList.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
    TabList.BorderSizePixel = 0
    TabList.Position = UDim2.new(0, 0, 0, 35)
    TabList.Size = UDim2.new(0, 140, 1, -35)
    TabList.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabList.ScrollBarThickness = 2

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = TabList
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 4)

    -- Контейнер для страниц (справа)
    local ContainerHolder = Instance.new("Frame")
    ContainerHolder.Parent = MainFrame
    ContainerHolder.BackgroundTransparency = 1
    ContainerHolder.Position = UDim2.new(0, 150, 0, 45)
    ContainerHolder.Size = UDim2.new(1, -160, 1, -55)

    local WindowAPI = {}

    -- Функция создания вкладки, аналогичная WindUI
    function WindowAPI:Tab(config)
        local tabTitle = config.Title or "Tab"

        local TabButton = Instance.new("TextButton")
        TabButton.Parent = TabList
        TabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        TabButton.BackgroundTransparency = 1
        TabButton.Size = UDim2.new(1, 0, 0, 32)
        TabButton.Font = Enum.Font.GothamMedium
        TabButton.Text = "  " .. tabTitle
        TabButton.TextColor3 = Color3.fromRGB(170, 170, 180)
        TabButton.TextSize = 13
        TabButton.TextXAlignment = Enum.TextXAlignment.Left

        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Parent = ContainerHolder
        TabContent.BackgroundTransparency = 1
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.Visible = false
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.ScrollBarThickness = 3

        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.Parent = TabContent
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentLayout.Padding = UDim.new(0, 8)

        ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 10)
        end)

        TabButton.MouseButton1Click:Connect(function()
            for _, child in ipairs(ContainerHolder:GetChildren()) do
                if child:IsA("ScrollingFrame") then child.Visible = false end
            end
            TabContent.Visible = true
        end)

        if #ContainerHolder:GetChildren() == 1 then
            TabContent.Visible = true
        end

        local TabAPI = {}

        -- 1. Кнопка (Button)
        function TabAPI:Button(data)
            local title = data.Title or "Button"
            local callback = data.Callback or function() end

            local Btn = Instance.new("TextButton")
            Btn.Parent = TabContent
            Btn.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
            Btn.Size = UDim2.new(1, -10, 0, 36)
            Btn.AutoButtonColor = false
            Btn.Font = Enum.Font.GothamMedium
            Btn.Text = "  " .. title
            Btn.TextColor3 = Color3.fromRGB(220, 220, 225)
            Btn.TextSize = 13
            Btn.TextXAlignment = Enum.TextXAlignment.Left

            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
            local stroke = Instance.new("UIStroke", Btn)
            stroke.Color = Color3.fromRGB(45, 45, 55)
            stroke.Thickness = 1

            Btn.MouseButton1Click:Connect(function()
                pcall(callback)
            end)
        end

        -- 2. Переключатель (Toggle)
        function TabAPI:Toggle(data)
            local title = data.Title or "Toggle"
            local state = data.Value or false
            local callback = data.Callback or function() end

            local ToggleFrame = Instance.new("TextButton")
            ToggleFrame.Parent = TabContent
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
            ToggleFrame.Size = UDim2.new(1, -10, 0, 36)
            ToggleFrame.AutoButtonColor = false
            ToggleFrame.Text = ""

            Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 6)
            local stroke = Instance.new("UIStroke", ToggleFrame)
            stroke.Color = Color3.fromRGB(45, 45, 55)
            stroke.Thickness = 1

            local TitleLab = Instance.new("TextLabel", ToggleFrame)
            TitleLab.BackgroundTransparency = 1
            TitleLab.Position = UDim2.new(0, 10, 0, 0)
            TitleLab.Size = UDim2.new(1, -60, 1, 0)
            TitleLab.Font = Enum.Font.GothamMedium
            TitleLab.Text = title
            TitleLab.TextColor3 = Color3.fromRGB(220, 220, 225)
            TitleLab.TextSize = 13
            TitleLab.TextXAlignment = Enum.TextXAlignment.Left

            -- Сам чекбокс (переключатель)
            local CheckBox = Instance.new("Frame", ToggleFrame)
            CheckBox.AnchorPoint = Vector2.new(1, 0.5)
            CheckBox.Position = UDim2.new(1, -12, 0.5, 0)
            CheckBox.Size = UDim2.new(0, 20, 0, 20)
            CheckBox.BackgroundColor3 = state and Color3.fromRGB(80, 120, 255) or Color3.fromRGB(40, 40, 50)
            Instance.new("UICorner", CheckBox).CornerRadius = UDim.new(0, 4)

            ToggleFrame.MouseButton1Click:Connect(function()
                state = not state
                TweenService:Create(CheckBox, TweenInfo.new(0.2), {
                    BackgroundColor3 = state and Color3.fromRGB(80, 120, 255) or Color3.fromRGB(40, 40, 50)
                }):Play()
                pcall(callback, state)
            end)
        end

        return TabAPI
    end

    return WindowAPI
end

return WindowModule
