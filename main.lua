-- Главный скрипт: Ultimate Hub (Fluent UI)
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Ultimate Hub | Modular",
    SubTitle = "by Roblox Player",
    TabWidth = 160,
    Size = UDim2.fromOffset(480, 350),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Главная", Icon = "home" })
}

-- Ссылки на ваши будущие файлы на GitHub (замените ссылки на свои после загрузки)
local GITHUB_RAW = "https://raw.githubusercontent.com/ВАШ_НИК/РЕПОЗИТОРИЙ/main/"

-- Загружаем модули
loadstring(game:HttpGet(GITHUB_RAW .. "fly.lua"))(Tabs.Main, Fluent)
loadstring(game:HttpGet(GITHUB_RAW .. "noclip.lua"))(Tabs.Main, Fluent)
loadstring(game:HttpGet(GITHUB_RAW .. "speedhack.lua"))(Tabs.Main, Fluent)

Fluent:Notify({
    Title = "Успешно!",
    Content = "Все 5 модулей и интерфейс загружены!",
    Duration = 3
})
