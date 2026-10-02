-- Модуль: okno.lua
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local WindowModule = {}

function WindowModule.Init()
    -- Удаляем старое окно, если оно уже было открыто
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
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
    MainFrame.Size = UDim2.new(0, 500, 0, 320)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(45, 45, 55)
    UIStroke.Thickness = 1.5
    UIStroke.Parent = MainFrame

    -- Шапка окна (для перетаскивания)
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Parent = MainFrame
    TopBar.BackgroundTransparency = 1
    TopBar.Size = UDim2.new(1, 0, 0, 35)

    local Title = Instance.new("TextLabel")
    Title.Parent = TopBar
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = "Mega Hub | Modular"
    Title.TextColor3 = Color3.fromRGB(240, 240, 240)
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left

    -- Кнопка закрытия (крестик)
    local CloseButton = Instance.new("TextButton")
    CloseButton.Parent = TopBar
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    CloseButton.BackgroundTransparency = 1
    CloseButton.Position = UDim2.new(1, -30, 0, 7)
    CloseButton.Size = UDim2.new(0, 20, 0, 20)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(150, 150, 160)
    CloseButton.TextSize = 14

    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    -- Логика перетаскивания окна мышкой
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

    -- Контейнер для вкладок (левая панель)
    local TabList = Instance.new("ScrollingFrame")
    TabList.Parent = MainFrame
    TabList.Active = true
    TabList.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
    TabList.BorderSizePixel = 0
    TabList.Position = UDim2.new(0, 0, 0, 35)
    TabList.Size = UDim2.new(0, 130, 1, -35)
    TabList.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabList.ScrollBarThickness = 2

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = TabList
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 5)

    -- Контейнер для содержимого активной вкладки (правая часть)
    local ContainerHolder = Instance.new("Frame")
    ContainerHolder.Parent = MainFrame
    ContainerHolder.BackgroundTransparency = 1
    ContainerHolder.Position = UDim2.new(0, 140, 0, 45)
    ContainerHolder.Size = UDim2.new(1, -150, 1, -55)

    -- Таблица с методами управления окном
    local WindowAPI = {}

    function WindowAPI:AddTab(tabName)
        local TabButton = Instance.new("TextButton")
        TabButton.Parent = TabList
        TabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
        TabButton.BackgroundTransparency = 1
        TabButton.Size = UDim2.new(1, 0, 0, 30)
        TabButton.Font = Enum.Font.GothamMedium
        TabButton.Text = tabName
        TabButton.TextColor3 = Color3.fromRGB(170, 170, 180)
        TabButton.TextSize = 13

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

        TabButton.MouseButton1Click:Connect(function()
            for _, child in ipairs(ContainerHolder:GetChildren()) do
                if child:IsA("ScrollingFrame") then child.Visible = false end
            end
            TabContent.Visible = true
        end)

        -- Автоматически открываем первую вкладку
        if #ContainerHolder:GetChildren() == 1 then
            TabContent.Visible = true
        end

        return TabContent
    end

    return WindowAPI
end

return WindowModule
