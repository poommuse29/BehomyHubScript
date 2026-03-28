-- โหลด Rayfield
local Rayfield = loadstring(game:HttpGet(
    'https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "BehomyHub",
    LoadingTitle = "Split the Sea",
    LoadingSubtitle = "Loading...",
    KeySystem = false,
})

local MainTab = Window:CreateTab("Main", nil)
local OtherTab = Window:CreateTab("Other", nil)

local Remote = game:GetService("ReplicatedStorage")
    :WaitForChild("Remotes")
local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

local autoCollect = false
local autoHit = false
local autoSell = false
local autoRebirth = false
local collectDistance = 20
local collectConnection = nil

-- ===== Main Tab =====

-- Auto Collect
MainTab:CreateToggle({
    Name = "Auto Collect",
    CurrentValue = false,
    Callback = function(val)
        autoCollect = val
        if autoCollect then
            collectConnection = RunService.Heartbeat:Connect(function()
                local activeLoot = workspace:FindFirstChild("ActiveLoot")
                if activeLoot then
                    for _, obj in ipairs(activeLoot:GetDescendants()) do
                        if obj:IsA("BasePart") then
                            local distance = (obj.Position - rootPart.Position).Magnitude
                            if distance < collectDistance then
                                obj.Position = rootPart.Position
                            end
                        end
                    end
                end
            end)
        else
            if collectConnection then
                collectConnection:Disconnect()
                collectConnection = nil
            end
        end
    end,
})

MainTab:CreateSlider({
    Name = "Range",
    Range = {10, 1000000},
    Increment = 5,
    CurrentValue = 20,
    Callback = function(val)
        collectDistance = val
    end,
})

-- Auto Hit
MainTab:CreateToggle({
    Name = "Auto Hit (ต้องยืนใน Plot)",
    CurrentValue = false,
    Callback = function(val)
        autoHit = val
    end,
})

MainTab:CreateSlider({
    Name = "ความเร็ว",
    Range = {16, 200},
    Increment = 1,
    CurrentValue = 100,
    Callback = function(val)
        humanoid.WalkSpeed = val
    end,
})

-- ===== Other Tab =====

-- Auto Sell
OtherTab:CreateToggle({
    Name = "Auto Sell",
    CurrentValue = false,
    Callback = function(val)
        autoSell = val
    end,
})

-- Auto Rebirth
OtherTab:CreateToggle({
    Name = "Auto Rebirth",
    CurrentValue = false,
    Callback = function(val)
        autoRebirth = val
    end,
})

-- ===== Loop Auto Hit =====
task.spawn(function()
    while true do
        if autoHit then
            pcall(function()
                Remote:WaitForChild("SplitRequest")
                    :FireServer(0.9741009626828829, true)
            end)
            task.wait(3)
        end
        task.wait(0.5)
    end
end)

-- ===== Loop Auto Sell =====
task.spawn(function()
    while true do
        if autoSell then
            pcall(function()
                Remote:WaitForChild("SellRequest")
                    :FireServer({Mode = "SellAll"})
            end)
            task.wait(3)
        end
        task.wait(0.5)
    end
end)

-- ===== Loop Auto Rebirth =====
task.spawn(function()
    while true do
        if autoRebirth then
            pcall(function()
                Remote:WaitForChild("RebirthRequest")
                    :FireServer()
            end)
            task.wait(3)
        end
        task.wait(0.5)
    end
end)