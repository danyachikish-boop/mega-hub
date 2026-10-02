-- Загружаем основной скрипт
local LoadScreen = loadstring(game:HttpGet("https://raw.githubusercontent.com/danyachikish-boop/mega-hub/refs/heads/main/load.lua"))()

-- Запускаем и передаем внутрь элементы интерфейса
LoadScreen.Init("Mega Hub", "Запуск...", function(Window)
    -- Создаем вкладку
    local MainTab = Window:Tab({ Title = "Главная" })

    -- Добавляем кнопку
    MainTab:Button({
        Title = "Тестовая кнопка",
        Callback = function()
            print("Кнопка работает!")
        end
    })

    -- Добавляем переключатель
    MainTab:Toggle({
        Title = "Тестовый Тоггл",
        Value = false,
        Callback = function(state)
            print("Тоггл:", state)
        end
    })
end)
