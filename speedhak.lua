-- Модуль: SpeedHack
local Tab, Fluent = ...
local plr = game.Players.LocalPlayer
local walkSpeed = 16

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

Tab:AddSlider("WalkSpeedSlider", {
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
