-- Модуль: load.lua
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local LoadScreen = {}

function LoadScreen.Init(customTitle, customSubtitle)
    customTitle = customTitle or "Mega Hub"
    customSubtitle = customSubtitle or "Загрузка модулей..."

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CustomLoadingScreen"
    ScreenGui.Parent = CoreGui
    ScreenGui.IgnoreGuiInset = true

    -- Главное окно загрузки (по центру экрана)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.Size = UDim2.new(0, 400, 0, 220)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = MainFrame

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(45, 45, 55)
    UIStroke.Thickness = 1.5
    UIStroke.Parent = MainFrame

    -- Заголовок
    local Title = Instance.new("TextLabel")
    Title.Parent = MainFrame
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 20, 0, 25)
    Title.Size = UDim2.new(1, -40, 0, 30)
    Title.Font = Enum.Font.GothamBold
    Title.Text = customTitle
    Title.TextColor3 = Color3.fromRGB(240, 240, 240)
    Title.TextSize = 22
    Title.TextXAlignment = Enum.TextXAlignment.Left

    -- Подзаголовок
    local Subtitle = Instance.new("TextLabel")
    Subtitle.Parent = MainFrame
    Subtitle.BackgroundTransparency = 1
    Subtitle.Position = UDim2.new(0, 20, 0, 55)
    Subtitle.Size = UDim2.new(1, -40, 0, 20)
    Subtitle.Font = Enum.Font.Gotham
    Subtitle.Text = customSubtitle
    Subtitle.TextColor3 = Color3.fromRGB(150, 150, 160)
    Subtitle.TextSize = 13
    Subtitle.TextXAlignment = Enum.TextXAlignment.Left

    -- Шкала загрузки
    local BarBackground = Instance.new("Frame")
    BarBackground.Parent = MainFrame
    BarBackground.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    BarBackground.BorderSizePixel = 0
    BarBackground.Position = UDim2.new(0, 20, 0, 120)
    BarBackground.Size = UDim2.new(1, -40, 0, 8)

    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(1, 0)
    BarCorner.Parent = BarBackground

    local BarFill = Instance.new("Frame")
    BarFill.Parent = BarBackground
    BarFill.BackgroundColor3 = Color3.fromRGB(80, 120, 255)
    BarFill.BorderSizePixel = 0
    BarFill.Size = UDim2.new(0, 0, 1, 0)

    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = BarFill

    local PercentText = Instance.new("TextLabel")
    PercentText.Parent = MainFrame
    PercentText.BackgroundTransparency = 1
    PercentText.Position = UDim2.new(1, -70, 0, 95)
    PercentText.Size = UDim2.new(0, 50, 0, 20)
    PercentText.Font = Enum.Font.GothamBold
    PercentText.Text = "0%"
    PercentText.TextColor3 = Color3.fromRGB(150, 150, 160)
    PercentText.TextSize = 13
    PercentText.TextXAlignment = Enum.TextXAlignment.Right

    -- Анимация
    local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(BarFill, tweenInfo, {Size = UDim2.new(1, 0, 1, 0)})
    tween:Play()

    task.spawn(function()
        for i = 0, 100 do
            PercentText.Text = i .. "%"
            if i == 50 then
                Subtitle.Text = "Загрузка интерфейса..."
            elseif i == 90 then
                Subtitle.Text = "Готово!"
            end
            task.wait(2 / 100)
        end
    end)

    -- Автоматический запуск okno.lua после завершения анимации
    tween.Completed:Connect(function()
        task.wait(0.3)
        
        -- Плавное закрытие экрана загрузки
        local fadeInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local fadeMain = TweenService:Create(MainFrame, fadeInfo, {BackgroundTransparency = 1})
        fadeMain:Play()

        for _, child in ipairs(MainFrame:GetDescendants()) do
            if child:IsA("TextLabel") then
                TweenService:Create(child, fadeInfo, {TextTransparency = 1}):Play()
            elseif child:IsA("Frame") then
                TweenService:Create(child, fadeInfo, {BackgroundTransparency = 1}):Play()
            end
        end

        fadeMain.Completed:Connect(function()
            ScreenGui:Destroy()
            
            -- Загружаем и открываем окну по твоей ссылке
            local success, err = pcall(function()
                local WindowModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/danyachikish-boop/mega-hub/refs/heads/main/okno.lua"))()
                if WindowModule and type(WindowModule.Init) == "function" then
                    WindowModule.Init()
                end
            end)
            
            if not success then
                warn("Не удалось загрузить okno.lua: " .. tostring(err))
            end
        end)
    end)
end

return LoadScreen
