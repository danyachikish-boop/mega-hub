-- Главный скрипт: main.lua
local GITHUB_RAW = "https://raw.githubusercontent.com/danyachikish-boop/mega-hub/refs/heads/main/"

-- 1. Загружаем и запускаем экран загрузки
local LoadScreen = loadstring(game:HttpGet(GITHUB_RAW .. "load.lua"))()
local loader = LoadScreen.Init("Mega Hub", "Запуск системы...")

-- 2. Ждем окончания анимации загрузки
loader.Tween.Completed:Connect(function()
    task.wait(0.3)
    loader.Close()

    -- 3. После закрытия загрузчика открываем само окно (okno.lua)
    local WindowModule = loadstring(game:HttpGet(GITHUB_RAW .. "okno.lua"))()
    
    -- Если файл okno.lua создан, он автоматически развернет интерфейс
    if WindowModule and type(WindowModule.Init) == "function" then
        WindowModule.Init()
    end
end)
