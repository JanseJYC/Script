local lib = {RainbowColorValue = 0, HueSelectionPosition = 0}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local PresetColor = Color3.fromRGB(255,255,255)
local CloseBind = Enum.KeyCode.RightControl

local ui = Instance.new("ScreenGui")
ui.Name = "ui"
ui.Parent = game.CoreGui
ui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

coroutine.wrap(
    function()
        while wait() do
            lib.RainbowColorValue = lib.RainbowColorValue + 1 / 255
            lib.HueSelectionPosition = lib.HueSelectionPosition + 1

            if lib.RainbowColorValue >= 1 then
                lib.RainbowColorValue = 0
            end

            if lib.HueSelectionPosition == 80 then
                lib.HueSelectionPosition = 0
            end
        end
    end
)()

local function MakeDraggable(topbarobject, object)
    local Dragging = nil
    local DragInput = nil
    local DragStart = nil
    local StartPosition = nil

    local function Update(input)
        local Delta = input.Position - DragStart
        local pos =
            UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + Delta.X,
            StartPosition.Y.Scale,
            StartPosition.Y.Offset + Delta.Y
        )
        object.Position = pos
    end

    topbarobject.InputBegan:Connect(
        function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                Dragging = true
                DragStart = input.Position
                StartPosition = object.Position

                input.Changed:Connect(
                    function()
                        if input.UserInputState == Enum.UserInputState.End then
                            Dragging = false
                        end
                    end
                )
            end
        end
    )

    topbarobject.InputChanged:Connect(
        function(input)
            if
                input.UserInputType == Enum.UserInputType.MouseMovement or
                    input.UserInputType == Enum.UserInputType.Touch
             then
                DragInput = input
            end
        end
    )

    UserInputService.InputChanged:Connect(
        function(input)
            if input == DragInput and Dragging then
                Update(input)
            end
        end
    )
end

local function MakeResizable(cornerobject, object, minSize)
    local Resizing = false
    local StartMousePos = nil
    local StartSize = nil
    local StartPosition = nil

    cornerobject.InputBegan:Connect(
        function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                Resizing = true
                StartMousePos = input.Position
                StartSize = object.Size
                StartPosition = object.Position

                input.Changed:Connect(
                    function()
                        if input.UserInputState == Enum.UserInputState.End then
                            Resizing = false
                        end
                    end
                )
            end
        end
    )

    cornerobject.InputChanged:Connect(
        function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                DragInput = input
            end
        end
    )

    UserInputService.InputChanged:Connect(
        function(input)
            if Resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
                local Delta = Vector2.new(input.Position.X - StartMousePos.X, input.Position.Y - StartMousePos.Y)
                local newWidth = math.max(minSize.X.Offset, StartSize.X.Offset + Delta.X)
                local newHeight = math.max(minSize.Y.Offset, StartSize.Y.Offset + Delta.Y)
                
                object.Size = UDim2.new(0, newWidth, 0, newHeight)
                
                for i, v in next, object:GetDescendants() do
                    if v.Name == "Tab" and v:IsA("ScrollingFrame") then
                        v.Size = UDim2.new(0, newWidth - 187, 0, newHeight - 65)
                    end
                end
            end
        end
    )
end

function lib:Window(text, preset, closebind)
    CloseBind = closebind or Enum.KeyCode.RightControl
    PresetColor = preset or Color3.fromRGB(255,255,255)
    fs = false
    local Main = Instance.new("ImageLabel")
    local TabHold = Instance.new("Frame")
    local TabHoldLayout = Instance.new("UIListLayout")
    local Title = Instance.new("TextLabel")
    local TabFolder = Instance.new("Folder")
    local DragFrame = Instance.new("Frame")
    local ResizeCorner = Instance.new("ImageButton")
    local MainCorner = Instance.new("UICorner")

    Main.Name = "Main"
    Main.Parent = ui
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.Size = UDim2.new(0, 560, 0, 319)
    Main.ClipsDescendants = true
    Main.Visible = true
    Main.BackgroundTransparency = 0
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = Main

    TabHold.Name = "TabHold"
    TabHold.Parent = Main
    TabHold.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TabHold.BackgroundTransparency = 1.000
    TabHold.Position = UDim2.new(0.0339285731, 0, 0.147335425, 0)
    TabHold.Size = UDim2.new(0, 107, 0, 254)

    TabHoldLayout.Name = "TabHoldLayout"
    TabHoldLayout.Parent = TabHold
    TabHoldLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabHoldLayout.Padding = UDim.new(0, 11)

    Title.Name = "Title"
    Title.Parent = Main
    Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1.000
    Title.Position = UDim2.new(0.0339285731, 0, 0.0564263314, 0)
    Title.Size = UDim2.new(0, 200, 0, 23)
    Title.Font = Enum.Font.GothamSemibold
    Title.Text = text
    Title.TextColor3 = Color3.fromRGB(255,255,255)
    Title.TextSize = 20.000
    Title.TextXAlignment = Enum.TextXAlignment.Left

    DragFrame.Name = "DragFrame"
    DragFrame.Parent = Main
    DragFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    DragFrame.BackgroundTransparency = 1.000
    DragFrame.Size = UDim2.new(1, 0, 0, 41)
    MakeDraggable(DragFrame, Main)

    ResizeCorner.Name = "ResizeCorner"
    ResizeCorner.Parent = Main
    ResizeCorner.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ResizeCorner.BackgroundTransparency = 1.000
    ResizeCorner.Position = UDim2.new(1, -25, 1, -25)
    ResizeCorner.Size = UDim2.new(0, 25, 0, 25)
    ResizeCorner.Image = "rbxassetid://124286465246123"
    ResizeCorner.ImageColor3 = Color3.fromRGB(255, 255, 255)
    ResizeCorner.ImageTransparency = 0.5
    ResizeCorner.ScaleType = Enum.ScaleType.Fit
    
    MakeResizable(ResizeCorner, Main, UDim2.new(0, 400, 0, 250))

    local uitoggled = false
    UserInputService.InputBegan:Connect(
        function(io, p)
            if io.KeyCode == CloseBind then
                if uitoggled == false then
                    uitoggled = true
                    Main:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .6, true, function() ui.Enabled = false end)
                else
                    uitoggled = false
                    ui.Enabled = true
                    Main:TweenSize(UDim2.new(0, 560, 0, 319), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .6, true)
                end
            end
        end
    )
    TabFolder.Name = "TabFolder"
    TabFolder.Parent = Main

    function lib:ChangePresetColor(toch)
        PresetColor = toch
    end

    function lib:Notification(texttitle, textdesc, textbtn)
        -- ... (Notification function remains the same as before) ...
        local NotificationHold = Instance.new("TextButton")
        local NotificationFrame = Instance.new("Frame")
        local OkayBtn = Instance.new("TextButton")
        local OkayBtnCorner = Instance.new("UICorner")
        local OkayBtnTitle = Instance.new("TextLabel")
        local NotificationTitle = Instance.new("TextLabel")
        local NotificationDesc = Instance.new("TextLabel")
        local NotificationFrameCorner = Instance.new("UICorner")

        NotificationHold.Name = "NotificationHold"
        NotificationHold.Parent = Main
        NotificationHold.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        NotificationHold.BackgroundTransparency = 1.000
        NotificationHold.BorderSizePixel = 0
        NotificationHold.Size = UDim2.new(1, 0, 1, 0)
        NotificationHold.AutoButtonColor = false
        NotificationHold.Font = Enum.Font.SourceSans
        NotificationHold.Text = ""
        NotificationHold.TextColor3 = Color3.fromRGB(0, 0, 0)
        NotificationHold.TextSize = 14.000

        TweenService:Create(NotificationHold, TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.7}):Play()
        wait(0.4)

        NotificationFrame.Name = "NotificationFrame"
        NotificationFrame.Parent = NotificationHold
        NotificationFrame.AnchorPoint = Vector2.new(0.5, 0.5)
        NotificationFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        NotificationFrame.BorderSizePixel = 0
        NotificationFrame.ClipsDescendants = true
        NotificationFrame.Position = UDim2.new(0.5, 0, 0.498432577, 0)
        NotificationFrameCorner.CornerRadius = UDim.new(0, 10)
        NotificationFrameCorner.Parent = NotificationFrame

        NotificationFrame:TweenSize(UDim2.new(0, 164, 0, 193), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .6, true)

        OkayBtn.Name = "OkayBtn"
        OkayBtn.Parent = NotificationFrame
        OkayBtn.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
        OkayBtn.Position = UDim2.new(0.0609756112, 0, 0.720207274, 0)
        OkayBtn.Size = UDim2.new(0, 144, 0, 42)
        OkayBtn.AutoButtonColor = false
        OkayBtn.Font = Enum.Font.SourceSans
        OkayBtn.Text = ""
        OkayBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
        OkayBtn.TextSize = 14.000

        OkayBtnCorner.CornerRadius = UDim.new(0, 5)
        OkayBtnCorner.Name = "OkayBtnCorner"
        OkayBtnCorner.Parent = OkayBtn

        OkayBtnTitle.Name = "OkayBtnTitle"
        OkayBtnTitle.Parent = OkayBtn
        OkayBtnTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        OkayBtnTitle.BackgroundTransparency = 1.000
        OkayBtnTitle.Position = UDim2.new(0.0763888881, 0, 0, 0)
        OkayBtnTitle.Size = UDim2.new(0, 181, 0, 42)
        OkayBtnTitle.Font = Enum.Font.Gotham
        OkayBtnTitle.Text = textbtn
        OkayBtnTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        OkayBtnTitle.TextSize = 14.000
        OkayBtnTitle.TextXAlignment = Enum.TextXAlignment.Left

        NotificationTitle.Name = "NotificationTitle"
        NotificationTitle.Parent = NotificationFrame
        NotificationTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        NotificationTitle.BackgroundTransparency = 1.000
        NotificationTitle.Position = UDim2.new(0.0670731738, 0, 0.0829015523, 0)
        NotificationTitle.Size = UDim2.new(0, 143, 0, 26)
        NotificationTitle.Font = Enum.Font.Gotham
        NotificationTitle.Text = texttitle
        NotificationTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        NotificationTitle.TextSize = 18.000
        NotificationTitle.TextXAlignment = Enum.TextXAlignment.Left

        NotificationDesc.Name = "NotificationDesc"
        NotificationDesc.Parent = NotificationFrame
        NotificationDesc.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        NotificationDesc.BackgroundTransparency = 1.000
        NotificationDesc.Position = UDim2.new(0.0670000017, 0, 0.218999997, 0)
        NotificationDesc.Size = UDim2.new(0, 143, 0, 91)
        NotificationDesc.Font = Enum.Font.Gotham
        NotificationDesc.Text = textdesc
        NotificationDesc.TextColor3 = Color3.fromRGB(255, 255, 255)
        NotificationDesc.TextSize = 15.000
        NotificationDesc.TextWrapped = true
        NotificationDesc.TextXAlignment = Enum.TextXAlignment.Left
        NotificationDesc.TextYAlignment = Enum.TextYAlignment.Top

        OkayBtn.MouseEnter:Connect(function() TweenService:Create(OkayBtn, TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(37, 37, 37)}):Play() end)
        OkayBtn.MouseLeave:Connect(function() TweenService:Create(OkayBtn, TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(34, 34, 34)}):Play() end)

        OkayBtn.MouseButton1Click:Connect(
            function()
                NotificationFrame:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .6, true)
                wait(0.4)
                TweenService:Create(NotificationHold, TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
                wait(.3)
                NotificationHold:Destroy()
            end
        )
    end
    
    local tabhold = {}
    function tabhold:Tab(text)
        local TabBtn = Instance.new("TextButton")
        local TabTitle = Instance.new("TextLabel")
        local TabBtnIndicator = Instance.new("Frame")
        local TabBtnIndicatorCorner = Instance.new("UICorner")

        TabBtn.Name = "TabBtn"
        TabBtn.Parent = TabHold
        TabBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TabBtn.BackgroundTransparency = 1.000
        TabBtn.Size = UDim2.new(0, 107, 0, 21)
        TabBtn.Font = Enum.Font.SourceSans
        TabBtn.Text = ""
        TabBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
        TabBtn.TextSize = 14.000

        TabTitle.Name = "TabTitle"
        TabTitle.Parent = TabBtn
        TabTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TabTitle.BackgroundTransparency = 1.000
        TabTitle.Size = UDim2.new(0, 107, 0, 21)
        TabTitle.Font = Enum.Font.Gotham
        TabTitle.Text = text
        TabTitle.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabTitle.TextSize = 14.000
        TabTitle.TextXAlignment = Enum.TextXAlignment.Left

        TabBtnIndicator.Name = "TabBtnIndicator"
        TabBtnIndicator.Parent = TabBtn
        TabBtnIndicator.BackgroundColor3 = PresetColor
        TabBtnIndicator.BorderSizePixel = 0
        TabBtnIndicator.Position = UDim2.new(0, 0, 1, 0)
        TabBtnIndicator.Size = UDim2.new(0, 0, 0, 2)
        TabBtnIndicatorCorner.CornerRadius = UDim.new(0, 2)
        TabBtnIndicatorCorner.Name = "TabBtnIndicatorCorner"
        TabBtnIndicatorCorner.Parent = TabBtnIndicator
        TabBtnIndicator.BackgroundTransparency = 0.25

        coroutine.wrap(function() while wait() do TabBtnIndicator.BackgroundColor3 = PresetColor end end)()

        local Tab = Instance.new("ScrollingFrame")
        local TabLayout = Instance.new("UIListLayout")

        Tab.Name = "Tab"
        Tab.Parent = TabFolder
        Tab.Active = true
        Tab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Tab.BackgroundTransparency = 1.000
        Tab.BorderSizePixel = 0
        Tab.Position = UDim2.new(0.31400001, 0, 0.147, 0)
        Tab.Size = UDim2.new(0, 373, 0, 254)
        Tab.CanvasSize = UDim2.new(0, 0, 0, 0)
        Tab.ScrollBarThickness = 3
        Tab.Visible = false

        TabLayout.Name = "TabLayout"
        TabLayout.Parent = Tab
        TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
        TabLayout.Padding = UDim.new(0, 6)

        if fs == false then
            fs = true
            TabBtnIndicator.Size = UDim2.new(0, 13, 0, 2)
            TabTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            Tab.Visible = true
        end

        TabBtn.MouseButton1Click:Connect(
            function()
                for i, v in next, TabFolder:GetChildren() do
                    if v.Name == "Tab" then v.Visible = false end
                end
                Tab.Visible = true
                for i, v in next, TabHold:GetChildren() do
                    if v.Name == "TabBtn" then
                        v.TabBtnIndicator:TweenSize(UDim2.new(0, 0, 0, 2), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .2, true)
                        TweenService:Create(v.TabTitle, TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(150, 150, 150)}):Play()
                    end
                end
                TabBtnIndicator:TweenSize(UDim2.new(0, 13, 0, 2), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .2, true)
                TweenService:Create(TabTitle, TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            end
        )
        
        local tabcontent = {}
        function tabcontent:Button(text, callback)
            local Button = Instance.new("TextButton")
            local ButtonCorner = Instance.new("UICorner")
            local ButtonTitle = Instance.new("TextLabel")

            Button.Name = "Button"
            Button.Parent = Tab
            Button.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
            Button.Size = UDim2.new(1, -10, 0, 42)
            Button.AutoButtonColor = false
            Button.Font = Enum.Font.SourceSans
            Button.Text = ""
            Button.TextColor3 = Color3.fromRGB(0, 0, 0)
            Button.TextSize = 14.000
            Button.BackgroundTransparency = 0

            ButtonCorner.CornerRadius = UDim.new(0, 5)
            ButtonCorner.Name = "ButtonCorner"
            ButtonCorner.Parent = Button

            ButtonTitle.Name = "ButtonTitle"
            ButtonTitle.Parent = Button
            ButtonTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ButtonTitle.BackgroundTransparency = 1.000
            ButtonTitle.Position = UDim2.new(0.035, 0, 0, 0)
            ButtonTitle.Size = UDim2.new(1, -10, 1, 0)
            ButtonTitle.Font = Enum.Font.Gotham
            ButtonTitle.Text = text
            ButtonTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            ButtonTitle.TextSize = 14.000
            ButtonTitle.TextXAlignment = Enum.TextXAlignment.Left

            Button.MouseEnter:Connect(function() TweenService:Create(Button, TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(37, 37, 37)}):Play() end)
            Button.MouseLeave:Connect(function() TweenService:Create(Button, TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(34, 34, 34)}):Play() end)
            Button.MouseButton1Click:Connect(function() pcall(callback) end)

            Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 10)
        end
        
        function tabcontent:Toggle(text, default, callback)
            local toggled = false
            local Toggle = Instance.new("TextButton")
            local ToggleCorner = Instance.new("UICorner")
            local ToggleTitle = Instance.new("TextLabel")
            local FrameToggle1 = Instance.new("Frame")
            local FrameToggle1Corner = Instance.new("UICorner")
            local FrameToggle2 = Instance.new("Frame")
            local FrameToggle2Corner = Instance.new("UICorner")
            local FrameToggle3 = Instance.new("Frame")
            local FrameToggle3Corner = Instance.new("UICorner")
            local FrameToggleCircle = Instance.new("Frame")
            local FrameToggleCircleCorner = Instance.new("UICorner")

            Toggle.Name = "Toggle"
            Toggle.Parent = Tab
            Toggle.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
            Toggle.Size = UDim2.new(1, -10, 0, 42)
            Toggle.AutoButtonColor = false
            Toggle.Font = Enum.Font.SourceSans
            Toggle.Text = ""
            Toggle.TextColor3 = Color3.fromRGB(0, 0, 0)
            Toggle.TextSize = 14.000
            Toggle.BackgroundTransparency = 0

            ToggleCorner.CornerRadius = UDim.new(0, 5)
            ToggleCorner.Name = "ToggleCorner"
            ToggleCorner.Parent = Toggle

            ToggleTitle.Name = "ToggleTitle"
            ToggleTitle.Parent = Toggle
            ToggleTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ToggleTitle.BackgroundTransparency = 1.000
            ToggleTitle.Position = UDim2.new(0.035, 0, 0, 0)
            ToggleTitle.Size = UDim2.new(1, -80, 1, 0)
            ToggleTitle.Font = Enum.Font.Gotham
            ToggleTitle.Text = text
            ToggleTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            ToggleTitle.TextSize = 14.000
            ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left

            FrameToggle1.Name = "FrameToggle1"
            FrameToggle1.Parent = Toggle
            FrameToggle1.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            FrameToggle1.Position = UDim2.new(1, -55, 0.285714298, 0)
            FrameToggle1.Size = UDim2.new(0, 37, 0, 18)

            FrameToggle1Corner.CornerRadius = UDim.new(0, 10)
            FrameToggle1Corner.Name = "FrameToggle1Corner"
            FrameToggle1Corner.Parent = FrameToggle1

            FrameToggle2.Name = "FrameToggle2"
            FrameToggle2.Parent = FrameToggle1
            FrameToggle2.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
            FrameToggle2.Position = UDim2.new(0.05, 0, 0.1, 0)
            FrameToggle2.Size = UDim2.new(0, 33, 0, 14)

            FrameToggle2Corner.CornerRadius = UDim.new(0, 7)
            FrameToggle2Corner.Name = "FrameToggle2Corner"
            FrameToggle2Corner.Parent = FrameToggle2

            FrameToggle3.Name = "FrameToggle3"
            FrameToggle3.Parent = FrameToggle1
            FrameToggle3.BackgroundColor3 = PresetColor
            FrameToggle3.BackgroundTransparency = 1.000
            FrameToggle3.Size = UDim2.new(1, 0, 1, 0)

            FrameToggle3Corner.CornerRadius = UDim.new(0, 10)
            FrameToggle3Corner.Name = "FrameToggle3Corner"
            FrameToggle3Corner.Parent = FrameToggle3

            FrameToggleCircle.Name = "FrameToggleCircle"
            FrameToggleCircle.Parent = FrameToggle1
            FrameToggleCircle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            FrameToggleCircle.Position = UDim2.new(0.1, 0, 0.15, 0)
            FrameToggleCircle.Size = UDim2.new(0, 12, 0, 12)

            FrameToggleCircleCorner.CornerRadius = UDim.new(1, 0)
            FrameToggleCircleCorner.Name = "FrameToggleCircleCorner"
            FrameToggleCircleCorner.Parent = FrameToggleCircle

            coroutine.wrap(function() while wait() do FrameToggle3.BackgroundColor3 = PresetColor end end)()

            local function updateToggle(state)
                if state then
                    TweenService:Create(FrameToggle1, TweenInfo.new(.3), {BackgroundTransparency = 1}):Play()
                    TweenService:Create(FrameToggle2, TweenInfo.new(.3), {BackgroundTransparency = 1}):Play()
                    TweenService:Create(FrameToggle3, TweenInfo.new(.3), {BackgroundTransparency = 0}):Play()
                    TweenService:Create(FrameToggleCircle, TweenInfo.new(.3), {BackgroundColor3 = PresetColor}):Play()
                    FrameToggleCircle:TweenPosition(UDim2.new(0.65, 0, 0.15, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .2, true)
                else
                    TweenService:Create(FrameToggle1, TweenInfo.new(.3), {BackgroundTransparency = 0}):Play()
                    TweenService:Create(FrameToggle2, TweenInfo.new(.3), {BackgroundTransparency = 0}):Play()
                    TweenService:Create(FrameToggle3, TweenInfo.new(.3), {BackgroundTransparency = 1}):Play()
                    TweenService:Create(FrameToggleCircle, TweenInfo.new(.3), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
                    FrameToggleCircle:TweenPosition(UDim2.new(0.1, 0, 0.15, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .2, true)
                end
                toggled = state
                pcall(callback, toggled)
            end

            Toggle.MouseButton1Click:Connect(function() updateToggle(not toggled) end)

            if default == true then
                updateToggle(true)
            end

            Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 10)
        end
        
        function tabcontent:Slider(text, min, max, start, callback)
            local dragging = false
            local Slider = Instance.new("TextButton")
            local SliderCorner = Instance.new("UICorner")
            local SliderTitle = Instance.new("TextLabel")
            local SliderValue = Instance.new("TextLabel")
            local SlideFrame = Instance.new("Frame")
            local CurrentValueFrame = Instance.new("Frame")
            local SlideCircle = Instance.new("ImageButton")

            Slider.Name = "Slider"
            Slider.Parent = Tab
            Slider.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
            Slider.Size = UDim2.new(1, -10, 0, 60)
            Slider.AutoButtonColor = false
            Slider.Font = Enum.Font.SourceSans
            Slider.Text = ""
            Slider.TextColor3 = Color3.fromRGB(0, 0, 0)
            Slider.TextSize = 14.000
            Slider.BackgroundTransparency = 0

            SliderCorner.CornerRadius = UDim.new(0, 5)
            SliderCorner.Name = "SliderCorner"
            SliderCorner.Parent = Slider

            SliderTitle.Name = "SliderTitle"
            SliderTitle.Parent = Slider
            SliderTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SliderTitle.BackgroundTransparency = 1.000
            SliderTitle.Position = UDim2.new(0.035, 0, 0, 0)
            SliderTitle.Size = UDim2.new(0.5, 0, 0.5, 0)
            SliderTitle.Font = Enum.Font.Gotham
            SliderTitle.Text = text
            SliderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            SliderTitle.TextSize = 14.000
            SliderTitle.TextXAlignment = Enum.TextXAlignment.Left

            SliderValue.Name = "SliderValue"
            SliderValue.Parent = Slider
            SliderValue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SliderValue.BackgroundTransparency = 1.000
            SliderValue.Position = UDim2.new(0.5, 0, 0, 0)
            SliderValue.Size = UDim2.new(0.5, -10, 0.5, 0)
            SliderValue.Font = Enum.Font.Gotham
            SliderValue.Text = tostring(start and math.floor((start / max) * (max - min) + min) or 0)
            SliderValue.TextColor3 = Color3.fromRGB(255, 255, 255)
            SliderValue.TextSize = 14.000
            SliderValue.TextXAlignment = Enum.TextXAlignment.Right

            SlideFrame.Name = "SlideFrame"
            SlideFrame.Parent = Slider
            SlideFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            SlideFrame.BorderSizePixel = 0
            SlideFrame.Position = UDim2.new(0.034, 0, 0.7, 0)
            SlideFrame.Size = UDim2.new(0.93, 0, 0, 3)

            CurrentValueFrame.Name = "CurrentValueFrame"
            CurrentValueFrame.Parent = SlideFrame
            CurrentValueFrame.BackgroundColor3 = PresetColor
            CurrentValueFrame.BorderSizePixel = 0
            CurrentValueFrame.Size = UDim2.new((start or 0) / max, 0, 0, 3)

            SlideCircle.Name = "SlideCircle"
            SlideCircle.Parent = SlideFrame
            SlideCircle.BackgroundColor3 = PresetColor
            SlideCircle.BackgroundTransparency = 1.000
            SlideCircle.Position = UDim2.new((start or 0) / max, -6, -1.3, 0)
            SlideCircle.Size = UDim2.new(0, 12, 0, 12)
            SlideCircle.Image = "rbxassetid://117825834972403"
            SlideCircle.ImageColor3 = PresetColor

            coroutine.wrap(function() while wait() do CurrentValueFrame.BackgroundColor3 = PresetColor SlideCircle.ImageColor3 = PresetColor end end)()

            local function move(input)
                local posX = math.clamp((input.Position.X - SlideFrame.AbsolutePosition.X) / SlideFrame.AbsoluteSize.X, 0, 1)
                CurrentValueFrame.Size = UDim2.new(posX, 0, 0, 3)
                SlideCircle.Position = UDim2.new(posX, -6, -1.3, 0)
                local value = math.floor(min + (max - min) * posX)
                SliderValue.Text = tostring(value)
                pcall(callback, value)
            end
            
            SlideCircle.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end end)
            SlideCircle.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
            UserInputService.InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then move(input) end end)
            
            Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 10)
        end
        
        function tabcontent:Dropdown(text, list, callback)
            local droptog = false
            local Dropdown = Instance.new("Frame")
            local DropdownCorner = Instance.new("UICorner")
            local DropdownBtn = Instance.new("TextButton")
            local DropdownTitle = Instance.new("TextLabel")
            local ArrowImg = Instance.new("ImageLabel")
            local DropItemHolder = Instance.new("ScrollingFrame")
            local DropLayout = Instance.new("UIListLayout")

            Dropdown.Name = "Dropdown"
            Dropdown.Parent = Tab
            Dropdown.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
            Dropdown.ClipsDescendants = true
            Dropdown.Size = UDim2.new(1, -10, 0, 42)
            Dropdown.BackgroundTransparency = 0

            DropdownCorner.CornerRadius = UDim.new(0, 5)
            DropdownCorner.Name = "DropdownCorner"
            DropdownCorner.Parent = Dropdown

            DropdownBtn.Name = "DropdownBtn"
            DropdownBtn.Parent = Dropdown
            DropdownBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            DropdownBtn.BackgroundTransparency = 1.000
            DropdownBtn.Size = UDim2.new(1, 0, 1, 0)
            DropdownBtn.Font = Enum.Font.SourceSans
            DropdownBtn.Text = ""
            DropdownBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
            DropdownBtn.TextSize = 14.000

            DropdownTitle.Name = "DropdownTitle"
            DropdownTitle.Parent = Dropdown
            DropdownTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            DropdownTitle.BackgroundTransparency = 1.000
            DropdownTitle.Position = UDim2.new(0.035, 0, 0, 0)
            DropdownTitle.Size = UDim2.new(1, -60, 1, 0)
            DropdownTitle.Font = Enum.Font.Gotham
            DropdownTitle.Text = text
            DropdownTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            DropdownTitle.TextSize = 14.000
            DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left
            DropdownTitle.TextTruncate = Enum.TextTruncate.AtEnd

            ArrowImg.Name = "ArrowImg"
            ArrowImg.Parent = DropdownTitle
            ArrowImg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ArrowImg.BackgroundTransparency = 1.000
            ArrowImg.Position = UDim2.new(1, -30, 0.2, 0)
            ArrowImg.Size = UDim2.new(0, 26, 0, 26)
            ArrowImg.Image = "rbxassetid://81081164158885"
            ArrowImg.ImageColor3 = Color3.fromRGB(255, 255, 255)
            ArrowImg.ImageTransparency = 0.4

            DropItemHolder.Name = "DropItemHolder"
            DropItemHolder.Parent = DropdownTitle
            DropItemHolder.Active = true
            DropItemHolder.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
            DropItemHolder.BackgroundTransparency = 0
            DropItemHolder.BorderSizePixel = 0
            DropItemHolder.Position = UDim2.new(0, 0, 1, 0)
            DropItemHolder.Size = UDim2.new(1, 20, 0, 0)
            DropItemHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
            DropItemHolder.ScrollBarThickness = 3
            DropItemHolder.Visible = false

            DropLayout.Name = "DropLayout"
            DropLayout.Parent = DropItemHolder
            DropLayout.SortOrder = Enum.SortOrder.LayoutOrder
            DropLayout.Padding = UDim.new(0, 2)

            DropdownBtn.MouseButton1Click:Connect(
                function()
                    droptog = not droptog
                    if droptog then
                        DropItemHolder.Visible = true
                        local itemHeight = DropLayout.AbsoluteContentSize.Y
                        Dropdown:TweenSize(UDim2.new(1, -10, 0, 42 + itemHeight), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .2, true)
                        TweenService:Create(ArrowImg, TweenInfo.new(.3), {Rotation = 270}):Play()
                    else
                        TweenService:Create(ArrowImg, TweenInfo.new(.3), {Rotation = 0}):Play()
                        Dropdown:TweenSize(UDim2.new(1, -10, 0, 42), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .2, true, function() DropItemHolder.Visible = false end)
                    end
                    wait(.2)
                    Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 10)
                end
            )

            for i, v in ipairs(list) do
                local Item = Instance.new("TextButton")
                local ItemCorner = Instance.new("UICorner")

                Item.Name = "Item"
                Item.Parent = DropItemHolder
                Item.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                Item.Size = UDim2.new(1, -10, 0, 25)
                Item.AutoButtonColor = false
                Item.Font = Enum.Font.Gotham
                Item.Text = v
                Item.TextColor3 = Color3.fromRGB(255, 255, 255)
                Item.TextSize = 14.000
                Item.BackgroundTransparency = 0

                ItemCorner.CornerRadius = UDim.new(0, 4)
                ItemCorner.Name = "ItemCorner"
                ItemCorner.Parent = Item

                Item.MouseEnter:Connect(function() TweenService:Create(Item, TweenInfo.new(.2), {BackgroundColor3 = Color3.fromRGB(70, 70, 70)}):Play() end)
                Item.MouseLeave:Connect(function() TweenService:Create(Item, TweenInfo.new(.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play() end)

                Item.MouseButton1Click:Connect(
                    function()
                        DropdownTitle.Text = text .. " - " .. v
                        pcall(callback, v)
                        droptog = false
                        TweenService:Create(ArrowImg, TweenInfo.new(.3), {Rotation = 0}):Play()
                        Dropdown:TweenSize(UDim2.new(1, -10, 0, 42), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .2, true, function() DropItemHolder.Visible = false end)
                        wait(.2)
                        Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 10)
                    end
                )

                DropItemHolder.CanvasSize = UDim2.new(0, 0, 0, DropLayout.AbsoluteContentSize.Y)
                DropItemHolder.Size = UDim2.new(1, 20, 0, math.min(DropLayout.AbsoluteContentSize.Y, 120))
            end
            Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 10)
        end
        
        function tabcontent:NestedDropdown(text, subMenus, callback)
            local mainToggled = false
            local activeSubMenu = nil
            
            local MainDropdown = Instance.new("Frame")
            local MainCorner = Instance.new("UICorner")
            local MainBtn = Instance.new("TextButton")
            local MainTitle = Instance.new("TextLabel")
            local MainArrow = Instance.new("ImageLabel")
            local MainHolder = Instance.new("ScrollingFrame")
            local MainLayout = Instance.new("UIListLayout")

            MainDropdown.Name = "NestedDropdown"
            MainDropdown.Parent = Tab
            MainDropdown.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
            MainDropdown.ClipsDescendants = true
            MainDropdown.Size = UDim2.new(1, -10, 0, 42)
            MainDropdown.BackgroundTransparency = 0

            MainCorner.CornerRadius = UDim.new(0, 5)
            MainCorner.Name = "MainCorner"
            MainCorner.Parent = MainDropdown

            MainBtn.Name = "MainBtn"
            MainBtn.Parent = MainDropdown
            MainBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            MainBtn.BackgroundTransparency = 1.000
            MainBtn.Size = UDim2.new(1, 0, 1, 0)
            MainBtn.Font = Enum.Font.SourceSans
            MainBtn.Text = ""
            MainBtn.TextColor3 = Color3.fromRGB(0, 0, 0)

            MainTitle.Name = "MainTitle"
            MainTitle.Parent = MainDropdown
            MainTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            MainTitle.BackgroundTransparency = 1.000
            MainTitle.Position = UDim2.new(0.035, 0, 0, 0)
            MainTitle.Size = UDim2.new(1, -60, 1, 0)
            MainTitle.Font = Enum.Font.Gotham
            MainTitle.Text = text
            MainTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            MainTitle.TextSize = 14.000
            MainTitle.TextXAlignment = Enum.TextXAlignment.Left
            MainTitle.TextTruncate = Enum.TextTruncate.AtEnd

            MainArrow.Name = "MainArrow"
            MainArrow.Parent = MainTitle
            MainArrow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            MainArrow.BackgroundTransparency = 1.000
            MainArrow.Position = UDim2.new(1, -30, 0.2, 0)
            MainArrow.Size = UDim2.new(0, 26, 0, 26)
            MainArrow.Image = "rbxassetid://137987229582002"
            MainArrow.ImageColor3 = Color3.fromRGB(255, 255, 255)
            MainArrow.ImageTransparency = 0.4

            MainHolder.Name = "MainHolder"
            MainHolder.Parent = MainTitle
            MainHolder.Active = true
            MainHolder.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
            MainHolder.BackgroundTransparency = 0
            MainHolder.BorderSizePixel = 0
            MainHolder.Position = UDim2.new(0, 0, 1, 0)
            MainHolder.Size = UDim2.new(1, 20, 0, 0)
            MainHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
            MainHolder.ScrollBarThickness = 3
            MainHolder.Visible = false
            MainHolder.ZIndex = 10

            MainLayout.Name = "MainLayout"
            MainLayout.Parent = MainHolder
            MainLayout.SortOrder = Enum.SortOrder.LayoutOrder
            MainLayout.Padding = UDim.new(0, 2)

            local subMenuFrames = {}
            
            for menuName, itemList in pairs(subMenus) do
                local SubFrame = Instance.new("Frame")
                local SubCorner = Instance.new("UICorner")
                local SubBtn = Instance.new("TextButton")
                local SubTitle = Instance.new("TextLabel")
                local SubArrow = Instance.new("ImageLabel")
                local SubHolder = Instance.new("ScrollingFrame")
                local SubLayout = Instance.new("UIListLayout")
                
                SubFrame.Name = "SubFrame"
                SubFrame.Parent = MainHolder
                SubFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                SubFrame.ClipsDescendants = true
                SubFrame.Size = UDim2.new(1, -10, 0, 32)
                SubFrame.BackgroundTransparency = 0
                
                SubCorner.CornerRadius = UDim.new(0, 4)
                SubCorner.Name = "SubCorner"
                SubCorner.Parent = SubFrame
                
                SubBtn.Name = "SubBtn"
                SubBtn.Parent = SubFrame
                SubBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                SubBtn.BackgroundTransparency = 1.000
                SubBtn.Size = UDim2.new(1, 0, 1, 0)
                SubBtn.Font = Enum.Font.SourceSans
                SubBtn.Text = ""
                
                SubTitle.Name = "SubTitle"
                SubTitle.Parent = SubFrame
                SubTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                SubTitle.BackgroundTransparency = 1.000
                SubTitle.Position = UDim2.new(0.05, 0, 0, 0)
                SubTitle.Size = UDim2.new(1, -40, 1, 0)
                SubTitle.Font = Enum.Font.Gotham
                SubTitle.Text = menuName
                SubTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
                SubTitle.TextSize = 14.000
                SubTitle.TextXAlignment = Enum.TextXAlignment.Left
                
                SubArrow.Name = "SubArrow"
                SubArrow.Parent = SubFrame
                SubArrow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                SubArrow.BackgroundTransparency = 1.000
                SubArrow.Position = UDim2.new(1, -30, 0.1, 0)
                SubArrow.Size = UDim2.new(0, 20, 0, 20)
                SubArrow.Image = "rbxassetid://137987229582002"
                SubArrow.ImageColor3 = Color3.fromRGB(255, 255, 255)
                SubArrow.ImageTransparency = 0.4
                SubArrow.Rotation = 270
                
                SubHolder.Name = "SubHolder"
                SubHolder.Parent = SubFrame
                SubHolder.Active = true
                SubHolder.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
                SubHolder.BackgroundTransparency = 0
                SubHolder.BorderSizePixel = 0
                SubHolder.Position = UDim2.new(1, 0, 0, 0)
                SubHolder.Size = UDim2.new(0, 150, 0, 0)
                SubHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
                SubHolder.ScrollBarThickness = 3
                SubHolder.Visible = false
                SubHolder.ZIndex = 11
                
                SubLayout.Name = "SubLayout"
                SubLayout.Parent = SubHolder
                SubLayout.SortOrder = Enum.SortOrder.LayoutOrder
                SubLayout.Padding = UDim.new(0, 2)
                
                local subItems = {}
                for _, itemName in ipairs(itemList) do
                    local Item = Instance.new("TextButton")
                    local ItemCorner = Instance.new("UICorner")
                    
                    Item.Name = "Item"
                    Item.Parent = SubHolder
                    Item.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                    Item.Size = UDim2.new(1, -10, 0, 25)
                    Item.AutoButtonColor = false
                    Item.Font = Enum.Font.Gotham
                    Item.Text = itemName
                    Item.TextColor3 = Color3.fromRGB(255, 255, 255)
                    Item.TextSize = 14.000
                    
                    ItemCorner.CornerRadius = UDim.new(0, 4)
                    ItemCorner.Parent = Item
                    
                    Item.MouseEnter:Connect(function() TweenService:Create(Item, TweenInfo.new(.2), {BackgroundColor3 = Color3.fromRGB(70, 70, 70)}):Play() end)
                    Item.MouseLeave:Connect(function() TweenService:Create(Item, TweenInfo.new(.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play() end)
                    
                    Item.MouseButton1Click:Connect(function()
                        MainTitle.Text = text .. " - " .. menuName .. " - " .. itemName
                        pcall(callback, menuName, itemName)
                        if activeSubMenu then
                            activeSubMenu.SubHolder.Visible = false
                        end
                        mainToggled = false
                        TweenService:Create(MainArrow, TweenInfo.new(.3), {Rotation = 0}):Play()
                        MainDropdown:TweenSize(UDim2.new(1, -10, 0, 42), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .2, true, function() MainHolder.Visible = false end)
                        wait(.2)
                        Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 10)
                    end)
                    
                    table.insert(subItems, Item)
                    SubHolder.CanvasSize = UDim2.new(0, 0, 0, SubLayout.AbsoluteContentSize.Y)
                    SubHolder.Size = UDim2.new(0, 150, 0, math.min(SubLayout.AbsoluteContentSize.Y, 120))
                end
                
                SubBtn.MouseButton1Click:Connect(function()
                    if activeSubMenu == SubFrame then
                        SubHolder.Visible = false
                        activeSubMenu = nil
                    else
                        if activeSubMenu then
                            activeSubMenu.SubHolder.Visible = false
                        end
                        SubHolder.Visible = true
                        activeSubMenu = SubFrame
                    end
                end)
                
                SubFrame.MouseEnter:Connect(function()
                    if activeSubMenu and activeSubMenu ~= SubFrame then
                        activeSubMenu.SubHolder.Visible = false
                        SubHolder.Visible = true
                        activeSubMenu = SubFrame
                    end
                end)
                
                subMenuFrames[menuName] = SubFrame
            end

            MainBtn.MouseButton1Click:Connect(
                function()
                    mainToggled = not mainToggled
                    if mainToggled then
                        MainHolder.Visible = true
                        if activeSubMenu then
                            activeSubMenu.SubHolder.Visible = false
                            activeSubMenu = nil
                        end
                        local itemHeight = MainLayout.AbsoluteContentSize.Y
                        MainDropdown:TweenSize(UDim2.new(1, -10, 0, 42 + itemHeight), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .2, true)
                        TweenService:Create(MainArrow, TweenInfo.new(.3), {Rotation = 270}):Play()
                    else
                        if activeSubMenu then
                            activeSubMenu.SubHolder.Visible = false
                            activeSubMenu = nil
                        end
                        TweenService:Create(MainArrow, TweenInfo.new(.3), {Rotation = 0}):Play()
                        MainDropdown:TweenSize(UDim2.new(1, -10, 0, 42), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .2, true, function() MainHolder.Visible = false end)
                    end
                    wait(.2)
                    Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 10)
                end
            )

            MainHolder.CanvasSize = UDim2.new(0, 0, 0, MainLayout.AbsoluteContentSize.Y)
            MainHolder.Size = UDim2.new(1, 20, 0, math.min(MainLayout.AbsoluteContentSize.Y, 120))
            Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 10)
        end
        
        function tabcontent:Colorpicker(text, preset, callback)
            -- ... (Colorpicker function remains the same as before, just update text colors) ...
            local ColorPickerToggled = false
            local OldToggleColor = Color3.fromRGB(0, 0, 0)
            local OldColor = Color3.fromRGB(0, 0, 0)
            local OldColorSelectionPosition = nil
            local OldHueSelectionPosition = nil
            local ColorH, ColorS, ColorV = 1, 1, 1
            local RainbowColorPicker = false
            local ColorInput = nil
            local HueInput = nil

            local Colorpicker = Instance.new("Frame")
            local ColorpickerCorner = Instance.new("UICorner")
            local ColorpickerTitle = Instance.new("TextLabel")
            local BoxColor = Instance.new("Frame")
            local BoxColorCorner = Instance.new("UICorner")
            local ConfirmBtn = Instance.new("TextButton")
            local ConfirmBtnCorner = Instance.new("UICorner")
            local ConfirmBtnTitle = Instance.new("TextLabel")
            local ColorpickerBtn = Instance.new("TextButton")
            local RainbowToggle = Instance.new("TextButton")
            local RainbowToggleCorner = Instance.new("UICorner")
            local RainbowToggleTitle = Instance.new("TextLabel")
            local FrameRainbowToggle1 = Instance.new("Frame")
            local FrameRainbowToggle1Corner = Instance.new("UICorner")
            local FrameRainbowToggle2 = Instance.new("Frame")
            local FrameRainbowToggle2_2 = Instance.new("UICorner")
            local FrameRainbowToggle3 = Instance.new("Frame")
            local FrameToggle3 = Instance.new("UICorner")
            local FrameRainbowToggleCircle = Instance.new("Frame")
            local FrameRainbowToggleCircleCorner = Instance.new("UICorner")
            local Color = Instance.new("ImageLabel")
            local ColorCorner = Instance.new("UICorner")
            local ColorSelection = Instance.new("ImageLabel")
            local Hue = Instance.new("ImageLabel")
            local HueCorner = Instance.new("UICorner")
            local HueGradient = Instance.new("UIGradient")
            local HueSelection = Instance.new("ImageLabel")

            Colorpicker.Name = "Colorpicker"
            Colorpicker.Parent = Tab
            Colorpicker.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
            Colorpicker.ClipsDescendants = true
            Colorpicker.Size = UDim2.new(1, -10, 0, 42)
            Colorpicker.BackgroundTransparency = 0

            ColorpickerCorner.CornerRadius = UDim.new(0, 5)
            ColorpickerCorner.Name = "ColorpickerCorner"
            ColorpickerCorner.Parent = Colorpicker

            ColorpickerTitle.Name = "ColorpickerTitle"
            ColorpickerTitle.Parent = Colorpicker
            ColorpickerTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ColorpickerTitle.BackgroundTransparency = 1.000
            ColorpickerTitle.Position = UDim2.new(0.035, 0, 0, 0)
            ColorpickerTitle.Size = UDim2.new(1, -100, 1, 0)
            ColorpickerTitle.Font = Enum.Font.Gotham
            ColorpickerTitle.Text = text
            ColorpickerTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            ColorpickerTitle.TextSize = 14.000
            ColorpickerTitle.TextXAlignment = Enum.TextXAlignment.Left
            ColorpickerTitle.TextTruncate = Enum.TextTruncate.AtEnd

            BoxColor.Name = "BoxColor"
            BoxColor.Parent = ColorpickerTitle
            BoxColor.BackgroundColor3 = preset or Color3.fromRGB(255,0,0)
            BoxColor.Position = UDim2.new(1, -90, 0.2, 0)
            BoxColor.Size = UDim2.new(0, 30, 0, 23)

            BoxColorCorner.CornerRadius = UDim.new(0, 5)
            BoxColorCorner.Name = "BoxColorCorner"
            BoxColorCorner.Parent = BoxColor

            ConfirmBtn.Name = "ConfirmBtn"
            ConfirmBtn.Parent = ColorpickerTitle
            ConfirmBtn.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
            ConfirmBtn.Position = UDim2.new(1, -50, 0.2, 0)
            ConfirmBtn.Size = UDim2.new(0, 40, 0, 23)
            ConfirmBtn.AutoButtonColor = false
            ConfirmBtn.Font = Enum.Font.SourceSans
            ConfirmBtn.Text = ""
            ConfirmBtn.TextColor3 = Color3.fromRGB(0, 0, 0)

            ConfirmBtnCorner.CornerRadius = UDim.new(0, 5)
            ConfirmBtnCorner.Name = "ConfirmBtnCorner"
            ConfirmBtnCorner.Parent = ConfirmBtn

            ConfirmBtnTitle.Name = "ConfirmBtnTitle"
            ConfirmBtnTitle.Parent = ConfirmBtn
            ConfirmBtnTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ConfirmBtnTitle.BackgroundTransparency = 1.000
            ConfirmBtnTitle.Size = UDim2.new(1, 0, 1, 0)
            ConfirmBtnTitle.Font = Enum.Font.Gotham
            ConfirmBtnTitle.Text = "✓"
            ConfirmBtnTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            ConfirmBtnTitle.TextSize = 18.000
            ConfirmBtnTitle.TextXAlignment = Enum.TextXAlignment.Center

            ColorpickerBtn.Name = "ColorpickerBtn"
            ColorpickerBtn.Parent = ColorpickerTitle
            ColorpickerBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ColorpickerBtn.BackgroundTransparency = 1.000
            ColorpickerBtn.Size = UDim2.new(1, 0, 1, 0)
            ColorpickerBtn.Font = Enum.Font.SourceSans
            ColorpickerBtn.Text = ""

            RainbowToggle.Name = "RainbowToggle"
            RainbowToggle.Parent = ColorpickerTitle
            RainbowToggle.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
            RainbowToggle.Position = UDim2.new(1, -140, 0.2, 0)
            RainbowToggle.Size = UDim2.new(0, 40, 0, 23)
            RainbowToggle.AutoButtonColor = false
            RainbowToggle.Font = Enum.Font.SourceSans
            RainbowToggle.Text = ""

            RainbowToggleCorner.CornerRadius = UDim.new(0, 5)
            RainbowToggleCorner.Name = "RainbowToggleCorner"
            RainbowToggleCorner.Parent = RainbowToggle

            RainbowToggleTitle.Name = "RainbowToggleTitle"
            RainbowToggleTitle.Parent = RainbowToggle
            RainbowToggleTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            RainbowToggleTitle.BackgroundTransparency = 1.000
            RainbowToggleTitle.Size = UDim2.new(1, 0, 1, 0)
            RainbowToggleTitle.Font = Enum.Font.Gotham
            RainbowToggleTitle.Text = "🌈"
            RainbowToggleTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            RainbowToggleTitle.TextSize = 18.000
            RainbowToggleTitle.TextXAlignment = Enum.TextXAlignment.Center

            FrameRainbowToggle1.Name = "FrameRainbowToggle1"
            FrameRainbowToggle1.Parent = RainbowToggle
            FrameRainbowToggle1.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            FrameRainbowToggle1.Position = UDim2.new(1, 5, 0, 0)
            FrameRainbowToggle1.Size = UDim2.new(0, 37, 0, 18)
            FrameRainbowToggle1.Visible = false

            Color.Name = "Color"
            Color.Parent = ColorpickerTitle
            Color.BackgroundColor3 = preset or Color3.fromRGB(255,0,0)
            Color.Position = UDim2.new(0, 0, 1, 5)
            Color.Size = UDim2.new(0, 150, 0, 80)
            Color.Visible = false
            Color.Image = "rbxassetid://4155801252"

            ColorCorner.CornerRadius = UDim.new(0, 3)
            ColorCorner.Parent = Color

            ColorSelection.Name = "ColorSelection"
            ColorSelection.Parent = Color
            ColorSelection.AnchorPoint = Vector2.new(0.5, 0.5)
            ColorSelection.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ColorSelection.BackgroundTransparency = 1.000
            ColorSelection.Size = UDim2.new(0, 18, 0, 18)
            ColorSelection.Image = "rbxassetid://17345436140"
            ColorSelection.Visible = false

            Hue.Name = "Hue"
            Hue.Parent = ColorpickerTitle
            Hue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Hue.Position = UDim2.new(0, 155, 1, 5)
            Hue.Size = UDim2.new(0, 25, 0, 80)
            Hue.Visible = false

            HueCorner.CornerRadius = UDim.new(0, 3)
            HueCorner.Parent = Hue

            HueGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 4)),
                ColorSequenceKeypoint.new(0.20, Color3.fromRGB(234, 255, 0)),
                ColorSequenceKeypoint.new(0.40, Color3.fromRGB(21, 255, 0)),
                ColorSequenceKeypoint.new(0.60, Color3.fromRGB(0, 255, 255)),
                ColorSequenceKeypoint.new(0.80, Color3.fromRGB(0, 17, 255)),
                ColorSequenceKeypoint.new(0.90, Color3.fromRGB(255, 0, 251)),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 4))
            }
            HueGradient.Rotation = 270
            HueGradient.Parent = Hue

            HueSelection.Name = "HueSelection"
            HueSelection.Parent = Hue
            HueSelection.AnchorPoint = Vector2.new(0.5, 0.5)
            HueSelection.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            HueSelection.BackgroundTransparency = 1.000
            HueSelection.Size = UDim2.new(0, 18, 0, 18)
            HueSelection.Image = "rbxassetid://108217585014571"
            HueSelection.Visible = false

            local function UpdateColorPicker()
                BoxColor.BackgroundColor3 = Color3.fromHSV(ColorH, ColorS, ColorV)
                Color.BackgroundColor3 = Color3.fromHSV(ColorH, 1, 1)
                pcall(callback, BoxColor.BackgroundColor3)
            end

            ColorH = 1 - (math.clamp(HueSelection.AbsolutePosition.Y - Hue.AbsolutePosition.Y, 0, Hue.AbsoluteSize.Y) / Hue.AbsoluteSize.Y)
            ColorS = math.clamp(ColorSelection.AbsolutePosition.X - Color.AbsolutePosition.X, 0, Color.AbsoluteSize.X) / Color.AbsoluteSize.X
            ColorV = 1 - (math.clamp(ColorSelection.AbsolutePosition.Y - Color.AbsolutePosition.Y, 0, Color.AbsoluteSize.Y) / Color.AbsoluteSize.Y)

            ColorpickerBtn.MouseButton1Click:Connect(function()
                ColorPickerToggled = not ColorPickerToggled
                if ColorPickerToggled then
                    Color.Visible = true
                    Hue.Visible = true
                    ColorSelection.Visible = true
                    HueSelection.Visible = true
                    Colorpicker:TweenSize(UDim2.new(1, -10, 0, 132), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .2, true)
                else
                    Color.Visible = false
                    Hue.Visible = false
                    ColorSelection.Visible = false
                    HueSelection.Visible = false
                    Colorpicker:TweenSize(UDim2.new(1, -10, 0, 42), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .2, true)
                end
                wait(.2)
                Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 10)
            end)

            Color.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 and not RainbowColorPicker then
                    if ColorInput then ColorInput:Disconnect() end
                    ColorInput = RunService.RenderStepped:Connect(function()
                        local ColorX = math.clamp((Mouse.X - Color.AbsolutePosition.X) / Color.AbsoluteSize.X, 0, 1)
                        local ColorY = math.clamp((Mouse.Y - Color.AbsolutePosition.Y) / Color.AbsoluteSize.Y, 0, 1)
                        ColorSelection.Position = UDim2.new(ColorX, 0, ColorY, 0)
                        ColorS = ColorX
                        ColorV = 1 - ColorY
                        UpdateColorPicker()
                    end)
                end
            end)

            Color.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 and ColorInput then
                    ColorInput:Disconnect()
                end
            end)

            Hue.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 and not RainbowColorPicker then
                    if HueInput then HueInput:Disconnect() end
                    HueInput = RunService.RenderStepped:Connect(function()
                        local HueY = math.clamp((Mouse.Y - Hue.AbsolutePosition.Y) / Hue.AbsoluteSize.Y, 0, 1)
                        HueSelection.Position = UDim2.new(0.48, 0, HueY, 0)
                        ColorH = 1 - HueY
                        UpdateColorPicker()
                    end)
                end
            end)

            Hue.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 and HueInput then
                    HueInput:Disconnect()
                end
            end)

            RainbowToggle.MouseButton1Click:Connect(function()
                RainbowColorPicker = not RainbowColorPicker
                if RainbowColorPicker then
                    OldToggleColor = BoxColor.BackgroundColor3
                    OldColor = Color.BackgroundColor3
                    OldColorSelectionPosition = ColorSelection.Position
                    OldHueSelectionPosition = HueSelection.Position
                    
                    coroutine.wrap(function()
                        while RainbowColorPicker do
                            BoxColor.BackgroundColor3 = Color3.fromHSV(lib.RainbowColorValue, 1, 1)
                            Color.BackgroundColor3 = Color3.fromHSV(lib.RainbowColorValue, 1, 1)
                            ColorSelection.Position = UDim2.new(1, 0, 0, 0)
                            HueSelection.Position = UDim2.new(0.48, 0, 0, lib.HueSelectionPosition)
                            pcall(callback, BoxColor.BackgroundColor3)
                            wait()
                        end
                    end)()
                else
                    BoxColor.BackgroundColor3 = OldToggleColor
                    Color.BackgroundColor3 = OldColor
                    ColorSelection.Position = OldColorSelectionPosition
                    HueSelection.Position = OldHueSelectionPosition
                    UpdateColorPicker()
                end
            end)

            ConfirmBtn.MouseButton1Click:Connect(function()
                ColorPickerToggled = false
                Color.Visible = false
                Hue.Visible = false
                ColorSelection.Visible = false
                HueSelection.Visible = false
                Colorpicker:TweenSize(UDim2.new(1, -10, 0, 42), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .2, true)
                wait(.2)
                Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 10)
            end)

            Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 10)
        end
        
        function tabcontent:Label(text)
            local Label = Instance.new("TextButton")
            local LabelCorner = Instance.new("UICorner")
            local LabelTitle = Instance.new("TextLabel")

            Label.Name = "Label"
            Label.Parent = Tab
            Label.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
            Label.Size = UDim2.new(1, -10, 0, 42)
            Label.AutoButtonColor = false
            Label.Font = Enum.Font.SourceSans
            Label.Text = ""
            Label.TextColor3 = Color3.fromRGB(0, 0, 0)
            Label.TextSize = 14.000
            Label.BackgroundTransparency = 0

            LabelCorner.CornerRadius = UDim.new(0, 5)
            LabelCorner.Name = "LabelCorner"
            LabelCorner.Parent = Label

            LabelTitle.Name = "LabelTitle"
            LabelTitle.Parent = Label
            LabelTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            LabelTitle.BackgroundTransparency = 1.000
            LabelTitle.Position = UDim2.new(0.035, 0, 0, 0)
            LabelTitle.Size = UDim2.new(1, -20, 1, 0)
            LabelTitle.Font = Enum.Font.Gotham
            LabelTitle.Text = text
            LabelTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            LabelTitle.TextSize = 14.000
            LabelTitle.TextXAlignment = Enum.TextXAlignment.Left

            Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 10)
        end
        
        function tabcontent:Textbox(text, disappear, callback)
            local Textbox = Instance.new("Frame")
            local TextboxCorner = Instance.new("UICorner")
            local TextboxTitle = Instance.new("TextLabel")
            local TextboxFrame = Instance.new("Frame")
            local TextboxFrameCorner = Instance.new("UICorner")
            local TextBox = Instance.new("TextBox")

            Textbox.Name = "Textbox"
            Textbox.Parent = Tab
            Textbox.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
            Textbox.ClipsDescendants = true
            Textbox.Size = UDim2.new(1, -10, 0, 42)
            Textbox.BackgroundTransparency = 0

            TextboxCorner.CornerRadius = UDim.new(0, 5)
            TextboxCorner.Name = "TextboxCorner"
            TextboxCorner.Parent = Textbox

            TextboxTitle.Name = "TextboxTitle"
            TextboxTitle.Parent = Textbox
            TextboxTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TextboxTitle.BackgroundTransparency = 1.000
            TextboxTitle.Position = UDim2.new(0.035, 0, 0, 0)
            TextboxTitle.Size = UDim2.new(0.5, 0, 1, 0)
            TextboxTitle.Font = Enum.Font.Gotham
            TextboxTitle.Text = text
            TextboxTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextboxTitle.TextSize = 14.000
            TextboxTitle.TextXAlignment = Enum.TextXAlignment.Left

            TextboxFrame.Name = "TextboxFrame"
            TextboxFrame.Parent = Textbox
            TextboxFrame.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
            TextboxFrame.Position = UDim2.new(1, -110, 0.2, 0)
            TextboxFrame.Size = UDim2.new(0, 100, 0, 23)
            TextboxFrame.BackgroundTransparency = 0

            TextboxFrameCorner.CornerRadius = UDim.new(0, 5)
            TextboxFrameCorner.Name = "TextboxFrameCorner"
            TextboxFrameCorner.Parent = TextboxFrame

            TextBox.Parent = TextboxFrame
            TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TextBox.BackgroundTransparency = 1.000
            TextBox.Size = UDim2.new(1, 0, 1, 0)
            TextBox.Font = Enum.Font.Gotham
            TextBox.Text = ""
            TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextBox.TextSize = 14.000
            TextBox.PlaceholderText = "输入..."
            TextBox.PlaceholderColor3 = Color3.fromRGB(150,150,150)

            TextBox.FocusLost:Connect(function(enterPressed)
                if enterPressed then
                    if #TextBox.Text > 0 then
                        pcall(callback, TextBox.Text)
                        if disappear then
                            TextBox.Text = ""
                        end
                    end
                end
            end)
            
            Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 10)
        end
        
        function tabcontent:Bind(text, keypreset, callback)
            local binding = false
            local Key = keypreset.Name
            local Bind = Instance.new("TextButton")
            local BindCorner = Instance.new("UICorner")
            local BindTitle = Instance.new("TextLabel")
            local BindText = Instance.new("TextLabel")

            Bind.Name = "Bind"
            Bind.Parent = Tab
            Bind.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
            Bind.Size = UDim2.new(1, -10, 0, 42)
            Bind.AutoButtonColor = false
            Bind.Font = Enum.Font.SourceSans
            Bind.Text = ""
            Bind.TextColor3 = Color3.fromRGB(0, 0, 0)
            Bind.TextSize = 14.000
            Bind.BackgroundTransparency = 0

            BindCorner.CornerRadius = UDim.new(0, 5)
            BindCorner.Name = "BindCorner"
            BindCorner.Parent = Bind

            BindTitle.Name = "BindTitle"
            BindTitle.Parent = Bind
            BindTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            BindTitle.BackgroundTransparency = 1.000
            BindTitle.Position = UDim2.new(0.035, 0, 0, 0)
            BindTitle.Size = UDim2.new(0.7, 0, 1, 0)
            BindTitle.Font = Enum.Font.Gotham
            BindTitle.Text = text
            BindTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            BindTitle.TextSize = 14.000
            BindTitle.TextXAlignment = Enum.TextXAlignment.Left

            BindText.Name = "BindText"
            BindText.Parent = Bind
            BindText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            BindText.BackgroundTransparency = 1.000
            BindText.Position = UDim2.new(0.7, 0, 0, 0)
            BindText.Size = UDim2.new(0.3, -10, 1, 0)
            BindText.Font = Enum.Font.Gotham
            BindText.Text = Key
            BindText.TextColor3 = Color3.fromRGB(255, 255, 255)
            BindText.TextSize = 14.000
            BindText.TextXAlignment = Enum.TextXAlignment.Right

            Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 10)

            Bind.MouseButton1Click:Connect(function()
                BindText.Text = "..."
                binding = true
                local inputwait = UserInputService.InputBegan:wait()
                if inputwait.KeyCode.Name ~= "Unknown" then
                    BindText.Text = inputwait.KeyCode.Name
                    Key = inputwait.KeyCode.Name
                    binding = false
                else
                    BindText.Text = Key
                    binding = false
                end
            end)

            UserInputService.InputBegan:Connect(function(current, pressed)
                if not pressed and not binding then
                    if current.KeyCode.Name == Key then
                        pcall(callback)
                    end
                end
            end)
        end
        
        return tabcontent
    end
    return tabhold
end

return lib