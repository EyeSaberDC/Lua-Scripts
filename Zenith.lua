local Zenith = {}
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

function Zenith:CreateWindow(WindowConfig)
    WindowConfig = WindowConfig or {
        Name = "Zenith UI Library",
        LoadingTitle = "Loading Interface...",
        LoadingSubtitle = "by YourName",
        ConfigurationSaving = {
            Enabled = true,
            FolderName = "ZenithConfig",
            FileName = "Config"
        }
    }
    
    local ZenithUI = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local Container = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    
    ZenithUI.Name = "ZenithUI"
    ZenithUI.Parent = CoreGui
    
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ZenithUI
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
    MainFrame.Size = UDim2.new(0, 500, 0, 300)
    
    local function EnableDragging()
        local dragging
        local dragInput
        local dragStart
        local startPos
        
        MainFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = MainFrame.Position
            end
        end)
        
        MainFrame.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        game:GetService("UserInputService").InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - dragStart
                local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                TweenService:Create(MainFrame, TweenInfo.new(0.1), {Position = targetPos}):Play()
            end
        end)
    end
    
    EnableDragging()
    
    function Zenith:AddButton(text, callback)
        local Button = Instance.new("TextButton")
        Button.Parent = Container
        Button.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        Button.Size = UDim2.new(0, 180, 0, 30)
        Button.Text = text
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        
        Button.MouseEnter:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 65)}):Play()
        end)
        
        Button.MouseLeave:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 45)}):Play()
        end)
        
        Button.MouseButton1Click:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.1), {Size = UDim2.new(0, 175, 0, 28)}):Play()
            wait(0.1)
            TweenService:Create(Button, TweenInfo.new(0.1), {Size = UDim2.new(0, 180, 0, 30)}):Play()
            
            if callback then
                callback()
            end
        end)
    end
    
    return Zenith
end

return Zenith
