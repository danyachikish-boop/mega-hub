-- Загружаем библиотеку Fluent
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

-- Переменные логики
local plr = game.Players.LocalPlayer
local uis = game:GetService("UserInputService")
local runService = game:GetService("RunService")

local flying = false
local flySpeed = 50
local walkSpeed = 16
local nocliped = false
local torso, bg, bv, flyConnection, noclipConnection

-- 1. Логика Полёта
local function startFly()
    local char = plr.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Humanoid") then return end
    torso = char.HumanoidRootPart
    
    flying = true
    char.Humanoid.PlatformStand = true
    
    bg = Instance.new("BodyGyro", torso)
    bg.P = 1e5
    bg.maxTorque = Vector3.new(1e5, 1e5, 1e5)
    bg.cframe = torso.CFrame
    
    bv = Instance.new("BodyVelocity", torso)
    bv.velocity = Vector3.new(0, 0, 0)
    bv.maxForce = Vector3.new(1e5, 1e5, 1e5)
    
    local currentVelocity = Vector3.new(0, 0, 0)
    
    flyConnection = runService.RenderStepped:Connect(function(dt)
        if not flying or not char or not char:FindFirstChild("Humanoid") then return end
        local cam = workspace.CurrentCamera
        
        local moveVector = Vector3.new(0, 0, 0)
        if uis:IsKeyDown(Enum.KeyCode.W) or uis:IsKeyDown(Enum.KeyCode.Up) then moveVector = moveVector + Vector3.new(0, 0, -1) end
        if uis:IsKeyDown(Enum.KeyCode.S) or uis:IsKeyDown(Enum.KeyCode.Down) then moveVector = moveVector + Vector3.new(0, 0, 1) end
        if uis:IsKeyDown(Enum.KeyCode.A) or uis:IsKeyDown(Enum.KeyCode.Left) then moveVector = moveVector + Vector3.new(-1, 0, 0) end
        if uis:IsKeyDown(Enum.KeyCode.D) or uis:IsKeyDown(Enum.KeyCode.Right) then moveVector = moveVector + Vector3.new(1, 0, 0) end
        
        local targetVelocity = Vector3.new(0, 0, 0)
        if moveVector.Magnitude > 0 then
            targetVelocity = cam.CFrame:VectorToWorldSpace(moveVector.Unit) * flySpeed
        end
        
        if uis:IsKeyDown(Enum.KeyCode.E) then targetVelocity = targetVelocity + Vector3.new(0, flySpeed, 0) end
        if uis:IsKeyDown(Enum.KeyCode.Q) then targetVelocity = targetVelocity - Vector3.new(0, flySpeed, 0) end
        
        currentVelocity = currentVelocity:Lerp(targetVelocity, math.clamp(dt * 12, 0, 1))
        bv.velocity = currentVelocity
        bg.cframe = cam.CFrame
    end)
end

local function stopFly()
    flying = false
    if flyConnection then flyConnection:Disconnect() end
    if bg then bg:Destroy() end
    if bv then bv:Destroy() end
    if plr.Character and plr.Character:FindFirstChild("Humanoid") then
        plr.Character.Humanoid.PlatformStand = false
    end
end

-- 2. Логика Noclip
local function startNoclip()
    nocliped = true
    noclipConnection = runService.Stepped:Connect(function()
        local char = plr.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end)
end

local function stopNoclip()
    nocliped = false
    if noclipConnection then noclipConnection:Disconnect() end
end

-- 3. Поддержание SpeedHack
task.spawn(function()
    while true do
        local char = plr.Character
        if char and char:FindFirstChild("Humanoid") then
            if char.Humanoid.WalkSpeed ~= walkSpeed and walkSpeed ~= 16 then
                char.Humanoid.WalkSpeed = walkSpeed
            end
        end
        task.wait(0.5)
    end
end)

-- Создаем элементы в интерфейсе
Tabs.Main:AddToggle("FlyToggle", {
    Title = "Включить Fly (Полет)",
    Default = false,
    Callback = function(state)
        if state then startFly() else stopFly() end
    end
})

Tabs.Main:AddSlider("FlySpeedSlider", {
    Title = "Скорость Полёта",
    Default = 50,
    Min = 10,
    Max = 300,
    Rounding = 1,
    Callback = function(val)
        flySpeed = val
    end
})

Tabs.Main:AddDivider()

Tabs.Main:AddToggle("NoclipToggle", {
    Title = "Включить Noclip (Сквозь стены)",
    Default = false,
    Callback = function(state)
        if state then startNoclip() else stopNoclip() end
    end
})

Tabs.Main:AddDivider()

Tabs.Main:AddSlider("WalkSpeedSlider", {
    Title = "Скорость Бега (SpeedHack)",
    Default = 16,
    Min = 16,
    Max = 200,
    Rounding = 1,
    Callback = function(val)
        walkSpeed = val
        if plr.Character and plr.Character:FindFirstChild("Humanoid") then
            plr.Character.Humanoid.WalkSpeed = walkSpeed
        end
    end
})

Fluent:Notify({
    Title = "Успешно!",
    Content = "Мега-хаб со всеми функциями загружен!",
    Duration = 3
})
