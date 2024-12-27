local VertexUI = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

function VertexUI.new(title)
    local gui = Instance.new("ScreenGui")
    gui.Name = "VertexUI"
    gui.Parent = game.CoreGui
    
    -- Main frame with modern gradient
    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Size = UDim2.new(0, 550, 0, 400)
    main.Position = UDim2.new(0.5, -275, 0.5, -200)
    main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    main.BorderSizePixel = 0
    main.Active = true
    main.Draggable = true
    main.Parent = gui
    
    -- Add gradient
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 35)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 25))
    })
    gradient.Rotation = 45
    gradient.Parent = main
    
    -- Sleek corner rounding
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = main
    
    -- Modern title bar with accent
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 35)
    titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = main
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = titleBar
    
    -- Glowing accent line
    local accent = Instance.new("Frame")
    accent.Size = UDim2.new(1, 0, 0, 2)
    accent.Position = UDim2.new(0, 0, 1, -2)
    accent.BackgroundColor3 = Color3.fromRGB(90, 160, 255)
    accent.BorderSizePixel = 0
    accent.Parent = titleBar
    
    -- Title text with modern font
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 16
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = title or "Vertex UI"
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar
    
    -- Modern container with smooth scrolling
    local container = Instance.new("ScrollingFrame")
    container.Name = "Container"
    container.Size = UDim2.new(1, -20, 1, -50)
    container.Position = UDim2.new(0, 10, 0, 45)
    container.BackgroundTransparency = 1
    container.ScrollBarThickness = 2
    container.ScrollBarImageColor3 = Color3.fromRGB(90, 160, 255)
    container.Parent = main
    
    local interface = {
        gui = gui,
        main = main,
        container = container,
        elements = {}
    }
    
    -- Enhanced button styling
    function interface:addButton(text, callback)
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, -10, 0, 40)
        button.Position = UDim2.new(0, 5, 0, #self.elements * 50)
        button.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.Text = text
        button.TextSize = 14
        button.Font = Enum.Font.GothamSemibold
        button.Parent = self.container
        
        -- Button effects
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = button
        
        local btnGradient = Instance.new("UIGradient")
        btnGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 45, 50)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 40))
        })
        btnGradient.Rotation = 45
        btnGradient.Parent = button
        
        -- Hover effect
        button.MouseEnter:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(90, 160, 255)}):Play()
        end)
        
        button.MouseLeave:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}):Play()
        end)
        
        button.MouseButton1Click:Connect(callback)
        table.insert(self.elements, button)
        
        return button
    end
    
    -- Modern toggle switch
    function interface:addToggle(text, default, callback)
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Size = UDim2.new(1, -10, 0, 40)
        toggleFrame.Position = UDim2.new(0, 5, 0, #self.elements * 50)
        toggleFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
        toggleFrame.Parent = self.container
        
        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(0, 6)
        toggleCorner.Parent = toggleFrame
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.Position = UDim2.new(0, 15, 0, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 14
        label.Font = Enum.Font.GothamSemibold
        label.Text = text
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = toggleFrame
        
        local switch = Instance.new("TextButton")
        switch.Size = UDim2.new(0, 50, 0, 24)
        switch.Position = UDim2.new(0.85, 0, 0.5, -12)
        switch.BackgroundColor3 = default and Color3.fromRGB(90, 160, 255) or Color3.fromRGB(45, 45, 50)
        switch.Text = ""
        switch.Parent = toggleFrame
        
        local switchCorner = Instance.new("UICorner")
        switchCorner.CornerRadius = UDim.new(1, 0)
        switchCorner.Parent = switch
        
        local knob = Instance.new("Frame")
        knob.Size = UDim2.new(0, 20, 0, 20)
        knob.Position = UDim2.new(default and 0.6 or 0, 2, 0, 2)
        knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        knob.Parent = switch
        
        local knobCorner = Instance.new("UICorner")
        knobCorner.CornerRadius = UDim.new(1, 0)
        knobCorner.Parent = knob
        
        local enabled = default or false
        switch.MouseButton1Click:Connect(function()
            enabled = not enabled
            TweenService:Create(switch, TweenInfo.new(0.2), {
                BackgroundColor3 = enabled and Color3.fromRGB(90, 160, 255) or Color3.fromRGB(45, 45, 50)
            }):Play()
            TweenService:Create(knob, TweenInfo.new(0.2), {
                Position = enabled and UDim2.new(0.6, 2, 0, 2) or UDim2.new(0, 2, 0, 2)
            }):Play()
            callback(enabled)
        end)
        
        table.insert(self.elements, toggleFrame)
        return toggleFrame
    end
    
    return interface
end

return VertexUI
