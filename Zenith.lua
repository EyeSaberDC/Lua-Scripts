-- ZenithLib Core
local ZenithLib = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local function CreateTween(instance, properties, duration)
    local tweenInfo = TweenInfo.new(duration or 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local tween = TweenService:Create(instance, tweenInfo, properties)
    return tween
end

function ZenithLib:CreateWindow(config)
    config = config or {}
    local windowName = config.Name or "ZenithLib"
    
    -- Main GUI Setup
    local ZenithGUI = Instance.new("ScreenGui")
    ZenithGUI.Name = "ZenithGUI"
    ZenithGUI.Parent = CoreGui
    ZenithGUI.ResetOnSpawn = false
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 600, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ZenithGUI
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame
    
    -- Make window draggable
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

    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    game:GetService("RunService").RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    local TabHolder = Instance.new("Frame")
    TabHolder.Name = "TabHolder"
    TabHolder.Size = UDim2.new(0, 150, 1, 0)
    TabHolder.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TabHolder.BorderSizePixel = 0
    TabHolder.Parent = MainFrame
    
    local UICorner_2 = Instance.new("UICorner")
    UICorner_2.CornerRadius = UDim.new(0, 8)
    UICorner_2.Parent = TabHolder
    
    local TabList = Instance.new("ScrollingFrame")
    TabList.Name = "TabList"
    TabList.Size = UDim2.new(1, 0, 1, -50)
    TabList.Position = UDim2.new(0, 0, 0, 50)
    TabList.BackgroundTransparency = 1
    TabList.ScrollBarThickness = 0
    TabList.Parent = TabHolder
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = TabList
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 5)
    
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -160, 1, -10)
    ContentContainer.Position = UDim2.new(0, 155, 0, 5)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = MainFrame
    
    local WindowTitle = Instance.new("TextLabel")
    WindowTitle.Name = "Title"
    WindowTitle.Size = UDim2.new(1, 0, 0, 40)
    WindowTitle.BackgroundTransparency = 1
    WindowTitle.Text = windowName
    WindowTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    WindowTitle.TextSize = 18
    WindowTitle.Font = Enum.Font.GothamBold
    WindowTitle.Parent = TabHolder
    
    local Window = {}
    
    function Window:CreateTab(tabConfig)
        tabConfig = tabConfig or {}
        local tabName = tabConfig.Name or "New Tab"
        
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName
        TabButton.Size = UDim2.new(1, -10, 0, 40)
        TabButton.Position = UDim2.new(0, 5, 0, 0)
        TabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        TabButton.Text = tabName
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabButton.TextSize = 14
        TabButton.Font = Enum.Font.Gotham
        TabButton.Parent = TabList
        
        local UICorner_3 = Instance.new("UICorner")
        UICorner_3.CornerRadius = UDim.new(0, 6)
        UICorner_3.Parent = TabButton
        
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = tabName.."Content"
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.ScrollBarThickness = 2
        TabContent.Visible = false
        TabContent.Parent = ContentContainer
        
        local UIListLayout_2 = Instance.new("UIListLayout")
        UIListLayout_2.Parent = TabContent
        UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout_2.Padding = UDim.new(0, 5)
        
        TabButton.MouseButton1Click:Connect(function()
            for _, content in pairs(ContentContainer:GetChildren()) do
                content.Visible = false
            end
            TabContent.Visible = true
            
            CreateTween(TabButton, {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
            wait(0.1)
            CreateTween(TabButton, {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
        end)
        
        local Tab = {}
        
        function Tab:CreateButton(buttonConfig)
            buttonConfig = buttonConfig or {}
            local buttonText = buttonConfig.Name or "Button"
            local callback = buttonConfig.Callback or function() end
            
            local Button = Instance.new("TextButton")
            Button.Name = buttonText
            Button.Size = UDim2.new(1, -10, 0, 40)
            Button.Position = UDim2.new(0, 5, 0, 0)
            Button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            Button.Text = buttonText
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.TextSize = 14
            Button.Font = Enum.Font.Gotham
            Button.Parent = TabContent
            
            local UICorner_4 = Instance.new("UICorner")
            UICorner_4.CornerRadius = UDim.new(0, 6)
            UICorner_4.Parent = Button
            
            Button.MouseButton1Click:Connect(function()
                CreateTween(Button, {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
                wait(0.1)
                CreateTween(Button, {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
                callback()
            end)
        end
        
        return Tab
    end
    
    return Window
end

return ZenithLib
