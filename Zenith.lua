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
    local TopBar = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local Container = Instance.new("ScrollingFrame")
    local UIListLayout = Instance.new("UIListLayout")
    local UIPadding = Instance.new("UIPadding")
    
    ZenithUI.Name = "ZenithUI"
    ZenithUI.Parent = CoreGui
    
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ZenithUI
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
    MainFrame.Size = UDim2.new(0, 500, 0, 300)
    MainFrame.ClipsDescendants = true
    
    TopBar.Name = "TopBar"
    TopBar.Parent = MainFrame
    TopBar.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    TopBar.Size = UDim2.new(1, 0, 0, 30)
    
    Title.Name = "Title"
    Title.Parent = TopBar
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.Size = UDim2.new(1, -20, 1, 0)
    Title.Font = Enum.Font.SourceSansBold
    Title.Text = WindowConfig.Name
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    Container.Name = "Container"
    Container.Parent = MainFrame
    Container.BackgroundTransparency = 1
    Container.Position = UDim2.new(0, 0, 0, 35)
    Container.Size = UDim2.new(1, 0, 1, -35)
    Container.ScrollBarThickness = 4
    Container.ScrollingDirection = Enum.ScrollingDirection.Y
    Container.BorderSizePixel = 0
    
    UIListLayout.Parent = Container
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 5)
    
    UIPadding.Parent = Container
    UIPadding.PaddingLeft = UDim.new(0, 10)
    UIPadding.PaddingRight = UDim.new(0, 10)
    UIPadding.PaddingTop = UDim.new(0, 5)
    
    local function EnableDragging()
        local dragging
        local dragInput
        local dragStart
        local startPos
        
        TopBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = MainFrame.Position
            end
        end)
        
        TopBar.InputEnded:Connect(function(input)
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
        Button.Name = "Button"
        Button.Parent = Container
        Button.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        Button.Size = UDim2.new(1, -20, 0, 30)
        Button.Text = text
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.Font = Enum.Font.SourceSans
        Button.TextSize = 14
        Button.AutoButtonColor = false
        
        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0, 4)
        UICorner.Parent = Button
        
        Button.MouseEnter:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 65)}):Play()
        end)
        
        Button.MouseLeave:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 45)}):Play()
        end)
        
        Button.MouseButton1Click:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.1), {Size = UDim2.new(1, -25, 0, 28)}):Play()
            wait(0.1)
            TweenService:Create(Button, TweenInfo.new(0.1), {Size = UDim2.new(1, -20, 0, 30)}):Play()
            
            if callback then
                callback()
            end
        end)
    end
    
    return Zenith
end

return Zenith
