local Zenith = {
    Flags = {},
    Themes = {
        Default = {
            Main = Color3.fromRGB(25, 25, 25),
            Second = Color3.fromRGB(32, 32, 32),
            Stroke = Color3.fromRGB(60, 60, 60),
            Accent = Color3.fromRGB(0, 85, 255),
            Text = Color3.fromRGB(240, 240, 240)
        }
    }
}

local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

function Zenith:Window(Config)
    local WindowInit = {Tabs = {}}
    local MainUI = Instance.new("ScreenGui")
    local Main = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local TopBar = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local TabHolder = Instance.new("Frame")
    local TabContainer = Instance.new("ScrollingFrame")
    local TabList = Instance.new("UIListLayout")
    local ContainerHolder = Instance.new("Frame")

    MainUI.Name = "ZenithUI"
    MainUI.Parent = CoreGui
    MainUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    Main.Name = "Main"
    Main.Parent = MainUI
    Main.BackgroundColor3 = Zenith.Themes[Config.Theme].Main
    Main.Position = UDim2.new(0.5, -300, 0.5, -175)
    Main.Size = UDim2.new(0, 600, 0, 350)

    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = Main

    TopBar.Name = "TopBar"
    TopBar.Parent = Main
    TopBar.BackgroundColor3 = Zenith.Themes[Config.Theme].Second
    TopBar.Size = UDim2.new(1, 0, 0, 30)

    Title.Name = "Title"
    Title.Parent = TopBar
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.Size = UDim2.new(1, -20, 1, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = Config.Name
    Title.TextColor3 = Zenith.Themes[Config.Theme].Text
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left

    TabHolder.Name = "TabHolder"
    TabHolder.Parent = Main
    TabHolder.BackgroundColor3 = Zenith.Themes[Config.Theme].Second
    TabHolder.Position = UDim2.new(0, 0, 0, 30)
    TabHolder.Size = UDim2.new(0, 150, 1, -30)

    TabContainer.Name = "TabContainer"
    TabContainer.Parent = TabHolder
    TabContainer.BackgroundTransparency = 1
    TabContainer.Position = UDim2.new(0, 0, 0, 5)
    TabContainer.Size = UDim2.new(1, 0, 1, -10)
    TabContainer.ScrollBarThickness = 2
    TabContainer.ScrollingDirection = Enum.ScrollingDirection.Y
    TabContainer.BorderSizePixel = 0

    TabList.Name = "TabList"
    TabList.Parent = TabContainer
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Padding = UDim.new(0, 5)

    ContainerHolder.Name = "ContainerHolder"
    ContainerHolder.Parent = Main
    ContainerHolder.BackgroundTransparency = 1
    ContainerHolder.Position = UDim2.new(0, 155, 0, 35)
    ContainerHolder.Size = UDim2.new(1, -160, 1, -40)

    local function MakeDraggable(topbarobject, object)
        local Dragging = nil
        local DragInput = nil
        local DragStart = nil
        local StartPosition = nil

        topbarobject.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                Dragging = true
                DragStart = Input.Position
                StartPosition = object.Position
            end
        end)

        topbarobject.InputEnded:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                Dragging = false
            end
        end)

        UserInputService.InputChanged:Connect(function(Input)
            if Dragging and Input.UserInputType == Enum.UserInputType.MouseMovement then
                local Delta = Input.Position - DragStart
                TweenService:Create(object, TweenInfo.new(0.1), {
                    Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
                }):Play()
            end
        end)
    end

    MakeDraggable(TopBar, Main)

    function WindowInit:Tab(Info)
        local TabInit = {}
        local Selected = false
        local TabButton = Instance.new("TextButton")
        local TabContainer = Instance.new("ScrollingFrame")
        local ElementList = Instance.new("UIListLayout")

        TabButton.Name = "TabButton"
        TabButton.Parent = TabContainer
        TabButton.BackgroundColor3 = Selected and Zenith.Themes[Config.Theme].Accent or Zenith.Themes[Config.Theme].Second
        TabButton.Size = UDim2.new(1, -10, 0, 30)
        TabButton.Font = Enum.Font.Gotham
        TabButton.Text = Info.Name
        TabButton.TextColor3 = Zenith.Themes[Config.Theme].Text
        TabButton.TextSize = 14
        TabButton.AutoButtonColor = false

        TabContainer.Name = "TabContainer_" .. Info.Name
        TabContainer.Parent = ContainerHolder
        TabContainer.BackgroundTransparency = 1
        TabContainer.Size = UDim2.new(1, 0, 1, 0)
        TabContainer.ScrollBarThickness = 2
        TabContainer.Visible = Selected

        ElementList.Name = "ElementList"
        ElementList.Parent = TabContainer
        ElementList.SortOrder = Enum.SortOrder.LayoutOrder
        ElementList.Padding = UDim.new(0, 5)

        TabButton.MouseButton1Click:Connect(function()
            for _, Tab in pairs(WindowInit.Tabs) do
                Tab.Container.Visible = false
                TweenService:Create(Tab.Button, TweenInfo.new(0.2), {
                    BackgroundColor3 = Zenith.Themes[Config.Theme].Second
                }):Play()
            end
            TabContainer.Visible = true
            TweenService:Create(TabButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Zenith.Themes[Config.Theme].Accent
            }):Play()
        end)

        table.insert(WindowInit.Tabs, {Button = TabButton, Container = TabContainer})

        function TabInit:Slider(Info)
            local SliderFrame = Instance.new("Frame")
            local SliderTitle = Instance.new("TextLabel")
            local SliderValue = Instance.new("TextLabel")
            local SliderButton = Instance.new("TextButton")
            local SliderInner = Instance.new("Frame")
            local UICorner = Instance.new("UICorner")
            
            SliderFrame.Name = "SliderFrame"
            SliderFrame.Parent = TabContainer
            SliderFrame.BackgroundColor3 = Zenith.Themes[Config.Theme].Second
            SliderFrame.Size = UDim2.new(1, -10, 0, 45)
            
            SliderTitle.Name = "SliderTitle"
            SliderTitle.Parent = SliderFrame
            SliderTitle.BackgroundTransparency = 1
            SliderTitle.Position = UDim2.new(0, 10, 0, 0)
            SliderTitle.Size = UDim2.new(1, -20, 0, 25)
            SliderTitle.Font = Enum.Font.Gotham
            SliderTitle.Text = Info.Name
            SliderTitle.TextColor3 = Zenith.Themes[Config.Theme].Text
            SliderTitle.TextSize = 14
            SliderTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            SliderValue.Name = "SliderValue"
            SliderValue.Parent = SliderFrame
            SliderValue.BackgroundTransparency = 1
            SliderValue.Position = UDim2.new(1, -60, 0, 0)
            SliderValue.Size = UDim2.new(0, 50, 0, 25)
            SliderValue.Font = Enum.Font.Gotham
            SliderValue.Text = tostring(Info.Default or Info.Min)
            SliderValue.TextColor3 = Zenith.Themes[Config.Theme].Text
            SliderValue.TextSize = 14
            
            SliderButton.Name = "SliderButton"
            SliderButton.Parent = SliderFrame
            SliderButton.BackgroundColor3 = Zenith.Themes[Config.Theme].Stroke
            SliderButton.Position = UDim2.new(0, 10, 0, 30)
            SliderButton.Size = UDim2.new(1, -20, 0, 5)
            SliderButton.AutoButtonColor = false
            SliderButton.Text = ""
            
            SliderInner.Name = "SliderInner"
            SliderInner.Parent = SliderButton
            SliderInner.BackgroundColor3 = Zenith.Themes[Config.Theme].Accent
            SliderInner.Size = UDim2.new(0, 0, 1, 0)
            
            UICorner.CornerRadius = UDim.new(0, 2)
            UICorner.Parent = SliderButton
            
            local MinValue = Info.Min or 0
            local MaxValue = Info.Max or 100
            local CurrentValue = Info.Default or MinValue
            
            local function UpdateSlider(Input)
                local SizeScale = math.clamp((Input.Position.X - SliderButton.AbsolutePosition.X) / SliderButton.AbsoluteSize.X, 0, 1)
                local Value = math.floor(MinValue + ((MaxValue - MinValue) * SizeScale))
                
                CurrentValue = Value
                SliderValue.Text = tostring(Value)
                SliderInner.Size = UDim2.new(SizeScale, 0, 1, 0)
                
                if Info.Callback then
                    Info.Callback(Value)
                end
            end
            
            SliderButton.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local Connection
                    Connection = RunService.RenderStepped:Connect(function()
                        if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                            UpdateSlider(Input)
                        else
                            Connection:Disconnect()
                        end
                    end)
                end
            end)
        end

        function TabInit:Dropdown(Info)
            local DropFrame = Instance.new("Frame")
            local DropButton = Instance.new("TextButton")
            local DropTitle = Instance.new("TextLabel")
            local DropContainer = Instance.new("ScrollingFrame")
            local UIListLayout = Instance.new("UIListLayout")
            local UICorner = Instance.new("UICorner")
            
            DropFrame.Name = "DropFrame"
            DropFrame.Parent = TabContainer
            DropFrame.BackgroundColor3 = Zenith.Themes[Config.Theme].Second
            DropFrame.Size = UDim2.new(1, -10, 0, 30)
            DropFrame.ClipsDescendants = true
            
            DropButton.Name = "DropButton"
            DropButton.Parent = DropFrame
            DropButton.BackgroundTransparency = 1
            DropButton.Size = UDim2.new(1, 0, 0, 30)
            DropButton.Font = Enum.Font.Gotham
            DropButton.Text = ""
            DropButton.TextColor3 = Zenith.Themes[Config.Theme].Text
            
            DropTitle.Name = "DropTitle"
            DropTitle.Parent = DropButton
            DropTitle.BackgroundTransparency = 1
            DropTitle.Position = UDim2.new(0, 10, 0, 0)
            DropTitle.Size = UDim2.new(1, -20, 1, 0)
            DropTitle.Font = Enum.Font.Gotham
            DropTitle.Text = Info.Name
            DropTitle.TextColor3 = Zenith.Themes[Config.Theme].Text
            DropTitle.TextSize = 14
            DropTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            DropContainer.Name = "DropContainer"
            DropContainer.Parent = DropFrame
            DropContainer.BackgroundTransparency = 1
            DropContainer.Position = UDim2.new(0, 0, 0, 30)
            DropContainer.Size = UDim2.new(1, 0, 0, 0)
            DropContainer.ScrollBarThickness = 2
            DropContainer.Visible = false
            
            UIListLayout.Parent = DropContainer
            UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            UIListLayout.Padding = UDim.new(0, 5)
            
            local Opened = false
            local SelectedOption = Info.Default
            
            local function UpdateDropdown()
                DropTitle.Text = Info.Name .. ": " .. tostring(SelectedOption)
                if Info.Callback then
                    Info.Callback(SelectedOption)
                end
            end
            
            local function ToggleDropdown()
                Opened = not Opened
                DropContainer.Visible = Opened
                TweenService:Create(DropFrame, TweenInfo.new(0.2), {
                    Size = UDim2.new(1, -10, 0, Opened and (35 + DropContainer.AbsoluteSize.Y) or 30)
                }):Play()
            end

            DropButton.MouseButton1Click:Connect(ToggleDropdown)

            for _, Option in pairs(Info.Options) do
                local OptionButton = Instance.new("TextButton")
                OptionButton.Name = "OptionButton"
                OptionButton.Parent = DropContainer
                OptionButton.BackgroundColor3 = Zenith.Themes[Config.Theme].Second
                OptionButton.Size = UDim2.new(1, -10, 0, 25)
                OptionButton.Font = Enum.Font.Gotham
                OptionButton.Text = tostring(Option)
                OptionButton.TextColor3 = Zenith.Themes[Config.Theme].Text
                OptionButton.TextSize = 14
                
                OptionButton.MouseButton1Click:Connect(function()
                    SelectedOption = Option
                    UpdateDropdown()
                    ToggleDropdown()
                end)
            end
            
            if Info.Default then
                SelectedOption = Info.Default
                UpdateDropdown()
            end
            
            function TabInit:ColorPicker(Info)
                local ColorFrame = Instance.new("Frame")
                local ColorButton = Instance.new("TextButton")
                local ColorTitle = Instance.new("TextLabel")
                local ColorDisplay = Instance.new("Frame")
                local UICorner = Instance.new("UICorner")
                
                ColorFrame.Name = "ColorFrame"
                ColorFrame.Parent = TabContainer
                ColorFrame.BackgroundColor3 = Zenith.Themes[Config.Theme].Second
                ColorFrame.Size = UDim2.new(1, -10, 0, 30)
                
                ColorButton.Name = "ColorButton"
                ColorButton.Parent = ColorFrame
                ColorButton.BackgroundTransparency = 1
                ColorButton.Size = UDim2.new(1, 0, 1, 0)
                ColorButton.Font = Enum.Font.Gotham
                ColorButton.Text = ""
                
                ColorTitle.Name = "ColorTitle"
                ColorTitle.Parent = ColorButton
                ColorTitle.BackgroundTransparency = 1
                ColorTitle.Position = UDim2.new(0, 10, 0, 0)
                ColorTitle.Size = UDim2.new(1, -50, 1, 0)
                ColorTitle.Font = Enum.Font.Gotham
                ColorTitle.Text = Info.Name
                ColorTitle.TextColor3 = Zenith.Themes[Config.Theme].Text
                ColorTitle.TextSize = 14
                ColorTitle.TextXAlignment = Enum.TextXAlignment.Left
                
                ColorDisplay.Name = "ColorDisplay"
                ColorDisplay.Parent = ColorFrame
                ColorDisplay.BackgroundColor3 = Info.Default or Color3.fromRGB(255, 255, 255)
                ColorDisplay.Position = UDim2.new(1, -40, 0.5, -10)
                ColorDisplay.Size = UDim2.new(0, 20, 0, 20)
                
                UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = ColorDisplay
                
                ColorButton.MouseButton1Click:Connect(function()
                    if Info.Callback then
                        Info.Callback(ColorDisplay.BackgroundColor3)
                    end
                end)
            end
            
            function TabInit:Keybind(Info)
                local KeybindFrame = Instance.new("Frame")
                local KeybindButton = Instance.new("TextButton")
                local KeybindTitle = Instance.new("TextLabel")
                local KeybindValue = Instance.new("TextLabel")
                local UICorner = Instance.new("UICorner")
                
                KeybindFrame.Name = "KeybindFrame"
                KeybindFrame.Parent = TabContainer
                KeybindFrame.BackgroundColor3 = Zenith.Themes[Config.Theme].Second
                KeybindFrame.Size = UDim2.new(1, -10, 0, 30)
                
                KeybindButton.Name = "KeybindButton"
                KeybindButton.Parent = KeybindFrame
                KeybindButton.BackgroundTransparency = 1
                KeybindButton.Size = UDim2.new(1, 0, 1, 0)
                KeybindButton.Font = Enum.Font.Gotham
                KeybindButton.Text = ""
                
                KeybindTitle.Name = "KeybindTitle"
                KeybindTitle.Parent = KeybindButton
                KeybindTitle.BackgroundTransparency = 1
                KeybindTitle.Position = UDim2.new(0, 10, 0, 0)
                KeybindTitle.Size = UDim2.new(1, -80, 1, 0)
                KeybindTitle.Font = Enum.Font.Gotham
                KeybindTitle.Text = Info.Name
                KeybindTitle.TextColor3 = Zenith.Themes[Config.Theme].Text
                KeybindTitle.TextSize = 14
                KeybindTitle.TextXAlignment = Enum.TextXAlignment.Left
                
                KeybindValue.Name = "KeybindValue"
                KeybindValue.Parent = KeybindButton
                KeybindValue.BackgroundTransparency = 1
                KeybindValue.Position = UDim2.new(1, -70, 0, 0)
                KeybindValue.Size = UDim2.new(0, 60, 1, 0)
                KeybindValue.Font = Enum.Font.Gotham
                KeybindValue.Text = Info.Default and Info.Default.Name or "None"
                KeybindValue.TextColor3 = Zenith.Themes[Config.Theme].Text
                KeybindValue.TextSize = 14
                
                local Selecting = false
                local Selected = Info.Default
                
                KeybindButton.MouseButton1Click:Connect(function()
                    Selecting = true
                    KeybindValue.Text = "..."
                    
                    local Input = UserInputService.InputBegan:Wait()
                    
                    if Input.UserInputType == Enum.UserInputType.Keyboard then
                        Selected = Input.KeyCode
                        KeybindValue.Text = Selected.Name
                        if Info.Callback then
                            Info.Callback(Selected)
                        end
                    end
                    
                    Selecting = false
                end)
                
                UserInputService.InputBegan:Connect(function(Input)
                    if not Selecting and Input.KeyCode == Selected then
                        if Info.Callback then
                            Info.Callback(Selected)
                        end
                    end
                end)
            end
        
        return TabInit
    end
    
    return WindowInit
end

return Zenith
