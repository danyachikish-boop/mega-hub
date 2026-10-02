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

-- Прямая ссылка на твой репозиторий GitHub
local GITHUB_RAW = "https://raw.githubusercontent.com/danyachikish-boop/mega-hub/refs/heads/main/"

-- Загружаем и подключаем модули
local success, err = pcall(function()
    loadstring(game:HttpGet(GITHUB_RAW .. "fly.lua"))(Tabs.Main, Fluent)
    loadstring(game:HttpGet(GITHUB_RAW .. "noclip.lua"))(Tabs.Main, Fluent)
    loadstring(game:HttpGet(GITHUB_RAW .. "speedhack.lua"))(Tabs.Main, Fluent)
end)

if not success then
    warn("Ошибка при загрузке модулей: " .. tostring(err))
end

Fluent:Notify({
    Title = "Успешно!",
    Content = "Интерфейс и все модули загружены!",
    Duration = 3
})
