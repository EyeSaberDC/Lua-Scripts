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

function Zenith:Window(Config)
    Config = Config or {
        Name = "Zenith Library",
        Theme = "Default"
    }

    local WindowInit = {
        Tabs = {}
    }

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
        Info = Info or {
            Name = "Tab",
            Icon = "rbxassetid://0"
        }

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

        function TabInit:Button(Info)
            Info = Info or {
                Name = "Button",
                Callback = function() end
            }

            local ButtonFrame = Instance.new("Frame")
            local Button = Instance.new("TextButton")
            local ButtonUICorner = Instance.new("UICorner")

            ButtonFrame.Name = "ButtonFrame"
            ButtonFrame.Parent = TabContainer
            ButtonFrame.BackgroundColor3 = Zenith.Themes[Config.Theme].Second
            ButtonFrame.Size = UDim2.new(1, -10, 0, 32)

            Button.Name = "Button"
            Button.Parent = ButtonFrame
            Button.BackgroundColor3 = Zenith.Themes[Config.Theme].Second
            Button.Size = UDim2.new(1, 0, 1, 0)
            Button.Font = Enum.Font.Gotham
            Button.Text = Info.Name
            Button.TextColor3 = Zenith.Themes[Config.Theme].Text
            Button.TextSize = 14
            Button.AutoButtonColor = false

            ButtonUICorner.CornerRadius = UDim.new(0, 4)
            ButtonUICorner.Parent = Button

            Button.MouseEnter:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2), {
                    BackgroundColor3 = Zenith.Themes[Config.Theme].Accent
                }):Play()
            end)

            Button.MouseLeave:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2), {
                    BackgroundColor3 = Zenith.Themes[Config.Theme].Second
                }):Play()
            end)

            Button.MouseButton1Click:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.1), {
                    Size = UDim2.new(0.95, 0, 0.95, 0),
                    Position = UDim2.new(0.025, 0, 0.025, 0)
                }):Play()
                wait(0.1)
                TweenService:Create(Button, TweenInfo.new(0.1), {
                    Size = UDim2.new(1, 0, 1, 0),
                    Position = UDim2.new(0, 0, 0, 0)
                }):Play()
                Info.Callback()
            end)
        end

        return TabInit
    end

    return WindowInit
end

return Zenith
