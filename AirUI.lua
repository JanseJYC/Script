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
ui.ResetOnSpawn = false

coroutine.wrap(
    function()
        while task.wait() do
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
        local pos = UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + Delta.X,
            StartPosition.Y.Scale,
            StartPosition.Y.Offset + Delta.Y
        )
        object.Position = pos
    end

    topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = object.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    topbarobject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            Update(input)
        end
    end)
end

function lib:Window(text, preset, closebind)
    CloseBind = closebind or Enum.KeyCode.RightControl
    PresetColor = preset or Color3.fromRGB(255,255,255)
    local fs = false
    local minimized = false
    local originalSize = UDim2.new(0, 560, 0, 0)
    local targetSize = UDim2.new(0, 560, 0, 319)
    
    local Main = Instance.new("ImageLabel")
    local MainCorner = Instance.new("UICorner")
    local MainStroke = Instance.new("UIStroke")
    local MainShadow = Instance.new("ImageLabel")
    
    local TopBar = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local TitleIcon = Instance.new("ImageLabel")
    
    local WindowControls = Instance.new("Frame")
    local MinimizeBtn = Instance.new("ImageButton")
    local RestoreBtn = Instance.new("ImageButton")
    local CloseBtn = Instance.new("ImageButton")
    
    local TabHold = Instance.new("ScrollingFrame")
    local TabHoldLayout = Instance.new("UIListLayout")
    local TabFolder = Instance.new("Folder")
    
    local DragFrame = Instance.new("Frame")
    local ResizeDragger = Instance.new("ImageButton")
    local ResizeCorner = Instance.new("UICorner")
    
    local GlowEffect = Instance.new("ImageLabel")
    
    Main.Name = "Main"
    Main.Parent = ui
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.Size = targetSize
    Main.ClipsDescendants = true
    Main.Visible = true
    Main.BackgroundTransparency = 0
    
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = Main
    
    MainStroke.Name = "MainStroke"
    MainStroke.Parent = Main
    MainStroke.Color = Color3.fromRGB(45, 45, 45)
    MainStroke.Thickness = 1.5
    MainStroke.Transparency = 0.5
    
    MainShadow.Name = "MainShadow"
    MainShadow.Parent = Main
    MainShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    MainShadow.BackgroundTransparency = 1
    MainShadow.Size = UDim2.new(1, 40, 1, 40)
    MainShadow.Position = UDim2.new(-0.035, 0, -0.06, 0)
    MainShadow.Image = "rbxassetid://13112884258"
    MainShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    MainShadow.ImageTransparency = 0.6
    MainShadow.ZIndex = -1
    
    TopBar.Name = "TopBar"
    TopBar.Parent = Main
    TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TopBar.BackgroundTransparency = 0
    TopBar.Size = UDim2.new(1, 0, 0, 45)
    TopBar.ZIndex = 2
    
    local TopBarGradient = Instance.new("UIGradient")
    TopBarGradient.Parent = TopBar
    TopBarGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))
    })
    TopBarGradient.Rotation = 90
    
    local TopBarCorner = Instance.new("UICorner")
    TopBarCorner.CornerRadius = UDim.new(0, 12)
    TopBarCorner.Parent = TopBar
    
    TitleIcon.Name = "TitleIcon"
    TitleIcon.Parent = TopBar
    TitleIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TitleIcon.BackgroundTransparency = 1
    TitleIcon.Size = UDim2.new(0, 24, 0, 24)
    TitleIcon.Position = UDim2.new(0.02, 0, 0.5, -12)
    TitleIcon.Image = "rbxassetid://116535712789945"
    TitleIcon.ImageColor3 = PresetColor
    
    Title.Name = "Title"
    Title.Parent = TopBar
    Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0.07, 0, 0, 0)
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = text
    Title.TextColor3 = Color3.fromRGB(255,255,255)
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    WindowControls.Name = "WindowControls"
    WindowControls.Parent = TopBar
    WindowControls.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    WindowControls.BackgroundTransparency = 1
    WindowControls.Position = UDim2.new(1, -105, 0, 0)
    WindowControls.Size = UDim2.new(0, 105, 1, 0)
    
    local function CreateControlButton(parent, pos, img, color)
        local btn = Instance.new("ImageButton")
        btn.Parent = parent
        btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        btn.BackgroundTransparency = 1
        btn.Position = UDim2.new(0, pos, 0.5, -12)
        btn.Size = UDim2.new(0, 24, 0, 24)
        btn.Image = img
        btn.ImageColor3 = color or Color3.fromRGB(180, 180, 180)
        return btn
    end
    
    MinimizeBtn = CreateControlButton(WindowControls, 0, "rbxassetid://116269596042539")
    RestoreBtn = CreateControlButton(WindowControls, 35, "rbxassetid://137492887754537")
    CloseBtn = CreateControlButton(WindowControls, 70, "rbxassetid://110786993356448")
    
    for _, btn in pairs({MinimizeBtn, RestoreBtn, CloseBtn}) do
        local hoverTween
        btn.MouseEnter:Connect(function()
            if hoverTween then hoverTween:Cancel() end
            hoverTween = TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageColor3 = Color3.fromRGB(255,255,255), Size = UDim2.new(0, 26, 0, 26)})
            hoverTween:Play()
        end)
        btn.MouseLeave:Connect(function()
            if hoverTween then hoverTween:Cancel() end
            hoverTween = TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageColor3 = Color3.fromRGB(180,180,180), Size = UDim2.new(0, 24, 0, 24)})
            hoverTween:Play()
        end)
    end
    
    TabHold.Name = "TabHold"
    TabHold.Parent = Main
    TabHold.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TabHold.BackgroundTransparency = 0
    TabHold.Position = UDim2.new(0, 10, 0, 55)
    TabHold.Size = UDim2.new(0, 120, 1, -65)
    TabHold.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabHold.ScrollBarThickness = 0
    TabHold.BorderSizePixel = 0
    
    local TabHoldCorner = Instance.new("UICorner")
    TabHoldCorner.CornerRadius = UDim.new(0, 8)
    TabHoldCorner.Parent = TabHold
    
    local TabHoldPadding = Instance.new("UIPadding")
    TabHoldPadding.Parent = TabHold
    TabHoldPadding.PaddingTop = UDim.new(0, 8)
    TabHoldPadding.PaddingBottom = UDim.new(0, 8)
    
    TabHoldLayout.Name = "TabHoldLayout"
    TabHoldLayout.Parent = TabHold
    TabHoldLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabHoldLayout.Padding = UDim.new(0, 4)
    TabHoldLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    TabFolder.Name = "TabFolder"
    TabFolder.Parent = Main
    
    DragFrame.Name = "DragFrame"
    DragFrame.Parent = TopBar
    DragFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    DragFrame.BackgroundTransparency = 1
    DragFrame.Size = UDim2.new(0.7, 0, 1, 0)
    DragFrame.Position = UDim2.new(0.07, 0, 0, 0)
    
    MakeDraggable(DragFrame, Main)
    
    ResizeDragger.Name = "ResizeDragger"
    ResizeDragger.Parent = Main
    ResizeDragger.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    ResizeDragger.BackgroundTransparency = 0
    ResizeDragger.Size = UDim2.new(0, 20, 0, 20)
    ResizeDragger.Position = UDim2.new(1, -20, 1, -20)
    ResizeDragger.Image = "rbxassetid://137987229582002"
    ResizeDragger.ImageColor3 = PresetColor
    ResizeDragger.ZIndex = 10
    
    ResizeCorner.CornerRadius = UDim.new(0, 6)
    ResizeCorner.Parent = ResizeDragger
    
    GlowEffect.Name = "GlowEffect"
    GlowEffect.Parent = Main
    GlowEffect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    GlowEffect.BackgroundTransparency = 1
    GlowEffect.Size = UDim2.new(1, 20, 1, 20)
    GlowEffect.Position = UDim2.new(-0.02, 0, -0.03, 0)
    GlowEffect.Image = "rbxassetid://5028857640"
    GlowEffect.ImageColor3 = PresetColor
    GlowEffect.ImageTransparency = 0.8
    GlowEffect.ZIndex = -1
    
    coroutine.wrap(function()
        while task.wait() do
            TitleIcon.ImageColor3 = PresetColor
            ResizeDragger.ImageColor3 = PresetColor
            GlowEffect.ImageColor3 = PresetColor
        end
    end)()
    
    local uitoggled = true
    
    local function animateButton(btn, isHover)
        local targetColor = isHover and PresetColor or Color3.fromRGB(180,180,180)
        local targetSize = isHover and UDim2.new(0, 26, 0, 26) or UDim2.new(0, 24, 0, 24)
        TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {ImageColor3 = targetColor, Size = targetSize}):Play()
    end
    
    MinimizeBtn.MouseEnter:Connect(function() animateButton(MinimizeBtn, true) end)
    MinimizeBtn.MouseLeave:Connect(function() animateButton(MinimizeBtn, false) end)
    RestoreBtn.MouseEnter:Connect(function() animateButton(RestoreBtn, true) end)
    RestoreBtn.MouseLeave:Connect(function() animateButton(RestoreBtn, false) end)
    CloseBtn.MouseEnter:Connect(function() animateButton(CloseBtn, true) end)
    CloseBtn.MouseLeave:Connect(function() animateButton(CloseBtn, false) end)
    
    MinimizeBtn.MouseButton1Click:Connect(function()
        if not minimized then
            originalSize = Main.Size
            targetSize = UDim2.new(0, 560, 0, 45)
            TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = targetSize}):Play()
            TweenService:Create(TabHold, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            for _, v in pairs(TabFolder:GetChildren()) do
                if v:IsA("ScrollingFrame") then
                    TweenService:Create(v, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
                end
            end
            minimized = true
        else
            TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = originalSize}):Play()
            TweenService:Create(TabHold, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
            for _, v in pairs(TabFolder:GetChildren()) do
                if v:IsA("ScrollingFrame") then
                    TweenService:Create(v, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
                end
            end
            minimized = false
        end
    end)
    
    RestoreBtn.MouseButton1Click:Connect(function()
        TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 560, 0, 319)}):Play()
        TweenService:Create(TabHold, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
        for _, v in pairs(TabFolder:GetChildren()) do
            if v:IsA("ScrollingFrame") then
                TweenService:Create(v, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
            end
        end
        minimized = false
    end)
    
    CloseBtn.MouseButton1Click:Connect(function()
        if uitoggled then
            uitoggled = false
            TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0), Transparency = 1}):Play()
            TweenService:Create(TabHold, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
            task.wait(0.3)
            ui.Enabled = false
        else
            uitoggled = true
            ui.Enabled = true
            TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 560, 0, 319), Transparency = 0}):Play()
            TweenService:Create(TabHold, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
        end
    end)
    
    UserInputService.InputBegan:Connect(function(io, p)
        if io.KeyCode == CloseBind and not p then
            if uitoggled then
                uitoggled = false
                TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
                TweenService:Create(TabHold, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
                task.wait(0.3)
                ui.Enabled = false
            else
                uitoggled = true
                ui.Enabled = true
                TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 560, 0, 319)}):Play()
                TweenService:Create(TabHold, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
            end
        end
    end)
    
    local resizing = false
    local resizeStart = nil
    local resizeStartSize = nil
    local minSize = Vector2.new(400, 250)
    
    ResizeDragger.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = true
            resizeStart = input.Position
            resizeStartSize = Vector2.new(Main.Size.X.Offset, Main.Size.Y.Offset)
        end
    end)
    
    ResizeDragger.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - resizeStart
            local newWidth = math.max(minSize.X, resizeStartSize.X + delta.X)
            local newHeight = math.max(minSize.Y, resizeStartSize.Y + delta.Y)
            Main.Size = UDim2.new(0, newWidth, 0, newHeight)
            TabHold.Size = UDim2.new(0, 120, 1, -65)
            for _, v in pairs(TabFolder:GetChildren()) do
                if v:IsA("ScrollingFrame") then
                    v.Size = UDim2.new(1, -140, 1, -65)
                end
            end
        end
    end)
    
    function lib:ChangePresetColor(toch)
        PresetColor = toch
    end
    
    function lib:Notification(texttitle, textdesc, textbtn)
        local NotificationHold = Instance.new("TextButton")
        local NotificationFrame = Instance.new("Frame")
        local OkayBtn = Instance.new("TextButton")
        local OkayBtnCorner = Instance.new("UICorner")
        local OkayBtnTitle = Instance.new("TextLabel")
        local NotificationTitle = Instance.new("TextLabel")
        local NotificationDesc = Instance.new("TextLabel")
        local NotificationFrameCorner = Instance.new("UICorner")
        local NotificationIcon = Instance.new("ImageLabel")
        
        NotificationHold.Name = "NotificationHold"
        NotificationHold.Parent = Main
        NotificationHold.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        NotificationHold.BackgroundTransparency = 1
        NotificationHold.BorderSizePixel = 0
        NotificationHold.Size = UDim2.new(1, 0, 1, 0)
        NotificationHold.AutoButtonColor = false
        NotificationHold.Font = Enum.Font.SourceSans
        NotificationHold.Text = ""
        NotificationHold.TextColor3 = Color3.fromRGB(0, 0, 0)
        NotificationHold.TextSize = 14
        NotificationHold.ZIndex = 100
        
        TweenService:Create(NotificationHold, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.7}):Play()
        task.wait(0.3)
        
        NotificationFrame.Name = "NotificationFrame"
        NotificationFrame.Parent = NotificationHold
        NotificationFrame.AnchorPoint = Vector2.new(0.5, 0.5)
        NotificationFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        NotificationFrame.BorderSizePixel = 0
        NotificationFrame.ClipsDescendants = true
        NotificationFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        NotificationFrame.Size = UDim2.new(0, 0, 0, 0)
        NotificationFrame.ZIndex = 101
        
        NotificationFrameCorner.CornerRadius = UDim.new(0, 12)
        NotificationFrameCorner.Parent = NotificationFrame
        
        local FrameStroke = Instance.new("UIStroke")
        FrameStroke.Parent = NotificationFrame
        FrameStroke.Color = PresetColor
        FrameStroke.Thickness = 2
        FrameStroke.Transparency = 0.5
        
        NotificationIcon.Name = "NotificationIcon"
        NotificationIcon.Parent = NotificationFrame
        NotificationIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        NotificationIcon.BackgroundTransparency = 1
        NotificationIcon.Size = UDim2.new(0, 40, 0, 40)
        NotificationIcon.Position = UDim2.new(0.5, -20, 0.1, 0)
        NotificationIcon.Image = "rbxassetid://116535712789945"
        NotificationIcon.ImageColor3 = PresetColor
        NotificationIcon.ZIndex = 102
        
        NotificationTitle.Name = "NotificationTitle"
        NotificationTitle.Parent = NotificationFrame
        NotificationTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        NotificationTitle.BackgroundTransparency = 1
        NotificationTitle.Position = UDim2.new(0, 20, 0, 50)
        NotificationTitle.Size = UDim2.new(1, -40, 0, 30)
        NotificationTitle.Font = Enum.Font.GothamBold
        NotificationTitle.Text = texttitle
        NotificationTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        NotificationTitle.TextSize = 18
        NotificationTitle.TextXAlignment = Enum.TextXAlignment.Center
        NotificationTitle.ZIndex = 102
        
        NotificationDesc.Name = "NotificationDesc"
        NotificationDesc.Parent = NotificationFrame
        NotificationDesc.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        NotificationDesc.BackgroundTransparency = 1
        NotificationDesc.Position = UDim2.new(0, 20, 0, 85)
        NotificationDesc.Size = UDim2.new(1, -40, 0, 60)
        NotificationDesc.Font = Enum.Font.Gotham
        NotificationDesc.Text = textdesc
        NotificationDesc.TextColor3 = Color3.fromRGB(200, 200, 200)
        NotificationDesc.TextSize = 14
        NotificationDesc.TextWrapped = true
        NotificationDesc.TextXAlignment = Enum.TextXAlignment.Center
        NotificationDesc.TextYAlignment = Enum.TextYAlignment.Top
        NotificationDesc.ZIndex = 102
        
        OkayBtn.Name = "OkayBtn"
        OkayBtn.Parent = NotificationFrame
        OkayBtn.BackgroundColor3 = PresetColor
        OkayBtn.Position = UDim2.new(0.5, -60, 1, -50)
        OkayBtn.Size = UDim2.new(0, 120, 0, 35)
        OkayBtn.AutoButtonColor = false
        OkayBtn.Font = Enum.Font.GothamBold
        OkayBtn.Text = textbtn
        OkayBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        OkayBtn.TextSize = 14
        OkayBtn.ZIndex = 102
        
        OkayBtnCorner.CornerRadius = UDim.new(0, 8)
        OkayBtnCorner.Parent = OkayBtn
        
        OkayBtnTitle.Name = "OkayBtnTitle"
        OkayBtnTitle.Parent = OkayBtn
        OkayBtnTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        OkayBtnTitle.BackgroundTransparency = 1
        OkayBtnTitle.Size = UDim2.new(1, 0, 1, 0)
        OkayBtnTitle.Font = Enum.Font.GothamBold
        OkayBtnTitle.Text = textbtn
        OkayBtnTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        OkayBtnTitle.TextSize = 14
        OkayBtnTitle.ZIndex = 103
        
        TweenService:Create(NotificationFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 280, 0, 220)}):Play()
        
        OkayBtn.MouseEnter:Connect(function()
            TweenService:Create(OkayBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            TweenService:Create(OkayBtnTitle, TweenInfo.new(0.2), {TextColor3 = PresetColor}):Play()
        end)
        
        OkayBtn.MouseLeave:Connect(function()
            TweenService:Create(OkayBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = PresetColor}):Play()
            TweenService:Create(OkayBtnTitle, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        end)
        
        OkayBtn.MouseButton1Click:Connect(function()
            TweenService:Create(NotificationFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
            task.wait(0.2)
            TweenService:Create(NotificationHold, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
            task.wait(0.2)
            NotificationHold:Destroy()
        end)
    end
    
    local tabhold = {}
    function tabhold:Tab(text)
        local TabBtn = Instance.new("TextButton")
        local TabBtnCorner = Instance.new("UICorner")
        local TabIcon = Instance.new("ImageLabel")
        local TabTitle = Instance.new("TextLabel")
        local TabBtnIndicator = Instance.new("Frame")
        
        TabBtn.Name = "TabBtn"
        TabBtn.Parent = TabHold
        TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        TabBtn.BackgroundTransparency = 0
        TabBtn.Size = UDim2.new(0, 100, 0, 40)
        TabBtn.AutoButtonColor = false
        TabBtn.Font = Enum.Font.SourceSans
        TabBtn.Text = ""
        
        TabBtnCorner.CornerRadius = UDim.new(0, 8)
        TabBtnCorner.Parent = TabBtn
        
        TabIcon.Name = "TabIcon"
        TabIcon.Parent = TabBtn
        TabIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TabIcon.BackgroundTransparency = 1
        TabIcon.Size = UDim2.new(0, 20, 0, 20)
        TabIcon.Position = UDim2.new(0, 10, 0.5, -10)
        TabIcon.Image = "rbxassetid://116535712789945"
        TabIcon.ImageColor3 = Color3.fromRGB(150, 150, 150)
        
        TabTitle.Name = "TabTitle"
        TabTitle.Parent = TabBtn
        TabTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TabTitle.BackgroundTransparency = 1
        TabTitle.Position = UDim2.new(0, 35, 0, 0)
        TabTitle.Size = UDim2.new(0, 60, 1, 0)
        TabTitle.Font = Enum.Font.Gotham
        TabTitle.Text = text
        TabTitle.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabTitle.TextSize = 14
        TabTitle.TextXAlignment = Enum.TextXAlignment.Left
        
        TabBtnIndicator.Name = "TabBtnIndicator"
        TabBtnIndicator.Parent = TabBtn
        TabBtnIndicator.BackgroundColor3 = PresetColor
        TabBtnIndicator.BorderSizePixel = 0
        TabBtnIndicator.Position = UDim2.new(0, 0, 1, -2)
        TabBtnIndicator.Size = UDim2.new(0, 0, 0, 2)
        
        local Tab = Instance.new("ScrollingFrame")
        local TabLayout = Instance.new("UIListLayout")
        local TabPadding = Instance.new("UIPadding")
        
        Tab.Name = "Tab"
        Tab.Parent = TabFolder
        Tab.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        Tab.BackgroundTransparency = 0
        Tab.BorderSizePixel = 0
        Tab.Position = UDim2.new(0, 140, 0, 55)
        Tab.Size = UDim2.new(1, -150, 1, -65)
        Tab.CanvasSize = UDim2.new(0, 0, 0, 0)
        Tab.ScrollBarThickness = 4
        Tab.ScrollBarImageColor3 = PresetColor
        Tab.Visible = false
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 8)
        TabCorner.Parent = Tab
        
        TabPadding.Parent = Tab
        TabPadding.PaddingTop = UDim.new(0, 10)
        TabPadding.PaddingBottom = UDim.new(0, 10)
        TabPadding.PaddingLeft = UDim.new(0, 10)
        TabPadding.PaddingRight = UDim.new(0, 10)
        
        TabLayout.Name = "TabLayout"
        TabLayout.Parent = Tab
        TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
        TabLayout.Padding = UDim.new(0, 8)
        TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        
        if fs == false then
            fs = true
            TabBtnIndicator.Size = UDim2.new(0, 30, 0, 2)
            TabTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabIcon.ImageColor3 = PresetColor
            Tab.Visible = true
        end
        
        TabBtn.MouseEnter:Connect(function()
            if not Tab.Visible then
                TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
            end
        end)
        
        TabBtn.MouseLeave:Connect(function()
            if not Tab.Visible then
                TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
            end
        end)
        
        TabBtn.MouseButton1Click:Connect(function()
            for _, v in next, TabFolder:GetChildren() do
                if v.Name == "Tab" then
                    v.Visible = false
                end
            end
            for _, v in next, TabHold:GetChildren() do
                if v:IsA("TextButton") and v ~= TabBtn then
                    TweenService:Create(v, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
                    TweenService:Create(v.TabBtnIndicator, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 2)}):Play()
                    TweenService:Create(v.TabTitle, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(150, 150, 150)}):Play()
                    TweenService:Create(v.TabIcon, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(150, 150, 150)}):Play()
                end
            end
            TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
            TweenService:Create(TabBtnIndicator, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 30, 0, 2)}):Play()
            TweenService:Create(TabTitle, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            TweenService:Create(TabIcon, TweenInfo.new(0.2), {ImageColor3 = PresetColor}):Play()
            Tab.Visible = true
            Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
        end)
        
        local tabcontent = {}
        
        function tabcontent:CreateBase(elementType, text, icon)
            local Base = Instance.new("Frame")
            local Corner = Instance.new("UICorner")
            local Stroke = Instance.new("UIStroke")
            local Icon = Instance.new("ImageLabel")
            local Title = Instance.new("TextLabel")
            
            Base.Name = elementType
            Base.Parent = Tab
            Base.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Base.Size = UDim2.new(1, -20, 0, 50)
            Base.BackgroundTransparency = 0
            
            Corner.CornerRadius = UDim.new(0, 8)
            Corner.Parent = Base
            
            Stroke.Parent = Base
            Stroke.Color = Color3.fromRGB(45, 45, 45)
            Stroke.Thickness = 1
            Stroke.Transparency = 0.5
            
            if icon then
                Icon.Name = "Icon"
                Icon.Parent = Base
                Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Icon.BackgroundTransparency = 1
                Icon.Size = UDim2.new(0, 24, 0, 24)
                Icon.Position = UDim2.new(0, 12, 0.5, -12)
                Icon.Image = icon
                Icon.ImageColor3 = PresetColor
            end
            
            Title.Name = "Title"
            Title.Parent = Base
            Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Title.BackgroundTransparency = 1
            Title.Position = UDim2.new(0, icon and 44 or 12, 0, 0)
            Title.Size = UDim2.new(0, 150, 1, 0)
            Title.Font = Enum.Font.Gotham
            Title.Text = text
            Title.TextColor3 = Color3.fromRGB(220, 220, 220)
            Title.TextSize = 14
            Title.TextXAlignment = Enum.TextXAlignment.Left
            
            return Base, Title, Icon
        end
        
        function tabcontent:Button(text, callback)
            local Base, Title, Icon = tabcontent:CreateBase("Button", text, "rbxassetid://120408917249739")
            Base.Size = UDim2.new(1, -20, 0, 45)
            
            Base.MouseEnter:Connect(function()
                TweenService:Create(Base, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
                TweenService:Create(Base.Stroke, TweenInfo.new(0.2), {Color = PresetColor, Transparency = 0.3}):Play()
            end)
            
            Base.MouseLeave:Connect(function()
                TweenService:Create(Base, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
                TweenService:Create(Base.Stroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(45, 45, 45), Transparency = 0.5}):Play()
            end)
            
            Base.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    TweenService:Create(Base, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
                    task.wait(0.1)
                    TweenService:Create(Base, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
                    pcall(callback)
                end
            end)
            
            Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
            return Base
        end
        
        function tabcontent:Toggle(text, default, callback)
            local toggled = default or false
            local Base, Title, Icon = tabcontent:CreateBase("Toggle", text, "rbxassetid://103871245626488")
            Base.Size = UDim2.new(1, -20, 0, 45)
            
            local ToggleFrame = Instance.new("Frame")
            local ToggleInner = Instance.new("Frame")
            local ToggleCircle = Instance.new("Frame")
            local ToggleCorner = Instance.new("UICorner")
            local ToggleInnerCorner = Instance.new("UICorner")
            local ToggleCircleCorner = Instance.new("UICorner")
            
            ToggleFrame.Parent = Base
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            ToggleFrame.Position = UDim2.new(1, -55, 0.5, -12)
            ToggleFrame.Size = UDim2.new(0, 44, 0, 24)
            
            ToggleCorner.CornerRadius = UDim.new(1, 0)
            ToggleCorner.Parent = ToggleFrame
            
            ToggleInner.Parent = ToggleFrame
            ToggleInner.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            ToggleInner.Position = UDim2.new(0.05, 0, 0.1, 0)
            ToggleInner.Size = UDim2.new(0, 40, 0, 20)
            
            ToggleInnerCorner.CornerRadius = UDim.new(1, 0)
            ToggleInnerCorner.Parent = ToggleInner
            
            ToggleCircle.Parent = ToggleInner
            ToggleCircle.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
            ToggleCircle.Position = UDim2.new(0.1, 0, 0.1, 0)
            ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
            
            ToggleCircleCorner.CornerRadius = UDim.new(1, 0)
            ToggleCircleCorner.Parent = ToggleCircle
            
            local function setState(state)
                toggled = state
                if state then
                    TweenService:Create(ToggleCircle, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.6, 0, 0.1, 0), BackgroundColor3 = PresetColor}):Play()
                    TweenService:Create(Icon, TweenInfo.new(0.2), {ImageColor3 = PresetColor}):Play()
                else
                    TweenService:Create(ToggleCircle, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.1, 0, 0.1, 0), BackgroundColor3 = Color3.fromRGB(150, 150, 150)}):Play()
                    TweenService:Create(Icon, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(150, 150, 150)}):Play()
                end
                pcall(callback, state)
            end
            
            Base.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    setState(not toggled)
                end
            end)
            
            if default then
                setState(true)
            end
            
            Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
            return Base, setState
        end
        
        function tabcontent:Slider(text, min, max, default, callback)
            local Base, Title, Icon = tabcontent:CreateBase("Slider", text, "rbxassetid://110273524101447")
            Base.Size = UDim2.new(1, -20, 0, 65)
            
            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Parent = Base
            ValueLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Position = UDim2.new(1, -70, 0, 5)
            ValueLabel.Size = UDim2.new(0, 60, 0, 20)
            ValueLabel.Font = Enum.Font.GothamBold
            ValueLabel.Text = tostring(default or min)
            ValueLabel.TextColor3 = PresetColor
            ValueLabel.TextSize = 16
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            
            local SliderBack = Instance.new("Frame")
            local SliderFill = Instance.new("Frame")
            local SliderButton = Instance.new("ImageButton")
            local SliderCorner = Instance.new("UICorner")
            local SliderFillCorner = Instance.new("UICorner")
            
            SliderBack.Parent = Base
            SliderBack.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            SliderBack.Position = UDim2.new(0.05, 0, 1, -25)
            SliderBack.Size = UDim2.new(0.9, 0, 0, 6)
            
            SliderCorner.CornerRadius = UDim.new(1, 0)
            SliderCorner.Parent = SliderBack
            
            SliderFill.Parent = SliderBack
            SliderFill.BackgroundColor3 = PresetColor
            SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            
            SliderFillCorner.CornerRadius = UDim.new(1, 0)
            SliderFillCorner.Parent = SliderFill
            
            SliderButton.Parent = SliderBack
            SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SliderButton.BackgroundTransparency = 1
            SliderButton.Size = UDim2.new(0, 20, 0, 20)
            SliderButton.Position = UDim2.new((default - min) / (max - min), -10, -7, 0)
            SliderButton.Image = "rbxassetid://117825834972403"
            SliderButton.ImageColor3 = PresetColor
            SliderButton.ZIndex = 5
            
            local dragging = false
            
            local function updateSlider(input)
                local pos = UDim2.new(math.clamp((input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1), -10, -7, 0)
                local fillSize = UDim2.new(math.clamp((input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1), 0, 1, 0)
                SliderButton.Position = pos
                SliderFill.Size = fillSize
                local value = math.floor(min + (fillSize.X.Scale * (max - min)))
                ValueLabel.Text = tostring(value)
                pcall(callback, value)
            end
            
            SliderButton.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                end
            end)
            
            SliderButton.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    updateSlider(input)
                end
            end)
            
            Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
            return Base, updateSlider
        end
        
        function tabcontent:Dropdown(text, options, callback)
            local Base, Title, Icon = tabcontent:CreateBase("Dropdown", text, "rbxassetid://83881670383280")
            Base.Size = UDim2.new(1, -20, 0, 45)
            Base.ClipsDescendants = true
            
            local Arrow = Instance.new("ImageLabel")
            Arrow.Parent = Base
            Arrow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Arrow.BackgroundTransparency = 1
            Arrow.Position = UDim2.new(1, -35, 0.5, -12)
            Arrow.Size = UDim2.new(0, 24, 0, 24)
            Arrow.Image = "rbxassetid://81081164158885"
            Arrow.ImageColor3 = Color3.fromRGB(150, 150, 150)
            
            local Selection = Instance.new("TextLabel")
            Selection.Parent = Base
            Selection.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Selection.BackgroundTransparency = 1
            Selection.Position = UDim2.new(0.5, 0, 0, 0)
            Selection.Size = UDim2.new(0.4, -10, 1, 0)
            Selection.Font = Enum.Font.Gotham
            Selection.Text = "Select..."
            Selection.TextColor3 = Color3.fromRGB(150, 150, 150)
            Selection.TextSize = 14
            Selection.TextXAlignment = Enum.TextXAlignment.Right
            
            local DropdownContainer = Instance.new("Frame")
            local DropdownList = Instance.new("UIListLayout")
            
            DropdownContainer.Parent = Base
            DropdownContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            DropdownContainer.BorderSizePixel = 0
            DropdownContainer.Position = UDim2.new(0, 0, 1, 5)
            DropdownContainer.Size = UDim2.new(1, 0, 0, 0)
            DropdownContainer.ClipsDescendants = true
            DropdownContainer.Visible = false
            
            local ContainerCorner = Instance.new("UICorner")
            ContainerCorner.CornerRadius = UDim.new(0, 8)
            ContainerCorner.Parent = DropdownContainer
            
            DropdownList.Parent = DropdownContainer
            DropdownList.SortOrder = Enum.SortOrder.LayoutOrder
            DropdownList.Padding = UDim.new(0, 2)
            DropdownList.HorizontalAlignment = Enum.HorizontalAlignment.Center
            
            local open = false
            local containerHeight = 0
            
            for _, option in ipairs(options) do
                local OptionBtn = Instance.new("TextButton")
                local OptionCorner = Instance.new("UICorner")
                
                OptionBtn.Parent = DropdownContainer
                OptionBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                OptionBtn.Size = UDim2.new(0.9, 0, 0, 35)
                OptionBtn.AutoButtonColor = false
                OptionBtn.Font = Enum.Font.Gotham
                OptionBtn.Text = option
                OptionBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
                OptionBtn.TextSize = 14
                
                OptionCorner.CornerRadius = UDim.new(0, 6)
                OptionCorner.Parent = OptionBtn
                
                OptionBtn.MouseEnter:Connect(function()
                    TweenService:Create(OptionBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(55, 55, 55)}):Play()
                end)
                
                OptionBtn.MouseLeave:Connect(function()
                    TweenService:Create(OptionBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
                end)
                
                OptionBtn.MouseButton1Click:Connect(function()
                    Selection.Text = option
                    Selection.TextColor3 = PresetColor
                    pcall(callback, option)
                    
                    TweenService:Create(Base, TweenInfo.new(0.3), {Size = UDim2.new(1, -20, 0, 45)}):Play()
                    TweenService:Create(Arrow, TweenInfo.new(0.3), {Rotation = 0}):Play()
                    DropdownContainer.Visible = false
                    open = false
                    Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
                end)
                
                containerHeight = containerHeight + 37
            end
            
            Base.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if not open then
                        TweenService:Create(Base, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(1, -20, 0, 45 + containerHeight)}):Play()
                        TweenService:Create(Arrow, TweenInfo.new(0.3), {Rotation = 180}):Play()
                        DropdownContainer.Size = UDim2.new(1, 0, 0, containerHeight)
                        DropdownContainer.Visible = true
                    else
                        TweenService:Create(Base, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(1, -20, 0, 45)}):Play()
                        TweenService:Create(Arrow, TweenInfo.new(0.3), {Rotation = 0}):Play()
                        DropdownContainer.Size = UDim2.new(1, 0, 0, 0)
                        task.wait(0.2)
                        DropdownContainer.Visible = false
                    end
                    open = not open
                    Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
                end
            end)
            
            Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
            return Base
        end
        
        function tabcontent:MultiDropdown(text, options, callback)
            local Base, Title, Icon = tabcontent:CreateBase("MultiDropdown", text, "rbxassetid://107643418926671")
            Base.Size = UDim2.new(1, -20, 0, 45)
            Base.ClipsDescendants = true
            
            local Arrow = Instance.new("ImageLabel")
            Arrow.Parent = Base
            Arrow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Arrow.BackgroundTransparency = 1
            Arrow.Position = UDim2.new(1, -35, 0.5, -12)
            Arrow.Size = UDim2.new(0, 24, 0, 24)
            Arrow.Image = "rbxassetid://81081164158885"
            Arrow.ImageColor3 = Color3.fromRGB(150, 150, 150)
            
            local Selection = Instance.new("TextLabel")
            Selection.Parent = Base
            Selection.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Selection.BackgroundTransparency = 1
            Selection.Position = UDim2.new(0.5, 0, 0, 0)
            Selection.Size = UDim2.new(0.4, -10, 1, 0)
            Selection.Font = Enum.Font.Gotham
            Selection.Text = "0 selected"
            Selection.TextColor3 = Color3.fromRGB(150, 150, 150)
            Selection.TextSize = 14
            Selection.TextXAlignment = Enum.TextXAlignment.Right
            
            local DropdownContainer = Instance.new("Frame")
            local DropdownList = Instance.new("UIListLayout")
            local selected = {}
            
            DropdownContainer.Parent = Base
            DropdownContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            DropdownContainer.BorderSizePixel = 0
            DropdownContainer.Position = UDim2.new(0, 0, 1, 5)
            DropdownContainer.Size = UDim2.new(1, 0, 0, 0)
            DropdownContainer.ClipsDescendants = true
            DropdownContainer.Visible = false
            
            local ContainerCorner = Instance.new("UICorner")
            ContainerCorner.CornerRadius = UDim.new(0, 8)
            ContainerCorner.Parent = DropdownContainer
            
            DropdownList.Parent = DropdownContainer
            DropdownList.SortOrder = Enum.SortOrder.LayoutOrder
            DropdownList.Padding = UDim.new(0, 2)
            DropdownList.HorizontalAlignment = Enum.HorizontalAlignment.Center
            
            local open = false
            local containerHeight = 0
            
            for _, option in ipairs(options) do
                local OptionBtn = Instance.new("TextButton")
                local OptionCorner = Instance.new("UICorner")
                local CheckIcon = Instance.new("ImageLabel")
                
                OptionBtn.Parent = DropdownContainer
                OptionBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                OptionBtn.Size = UDim2.new(0.9, 0, 0, 35)
                OptionBtn.AutoButtonColor = false
                OptionBtn.Font = Enum.Font.Gotham
                OptionBtn.Text = "   " .. option
                OptionBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
                OptionBtn.TextSize = 14
                OptionBtn.TextXAlignment = Enum.TextXAlignment.Left
                
                OptionCorner.CornerRadius = UDim.new(0, 6)
                OptionCorner.Parent = OptionBtn
                
                CheckIcon.Parent = OptionBtn
                CheckIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                CheckIcon.BackgroundTransparency = 1
                CheckIcon.Size = UDim2.new(0, 20, 0, 20)
                CheckIcon.Position = UDim2.new(1, -30, 0.5, -10)
                CheckIcon.Image = "rbxassetid://93898873302694"
                CheckIcon.ImageColor3 = Color3.fromRGB(100, 100, 100)
                CheckIcon.Visible = false
                
                OptionBtn.MouseEnter:Connect(function()
                    TweenService:Create(OptionBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(55, 55, 55)}):Play()
                end)
                
                OptionBtn.MouseLeave:Connect(function()
                    TweenService:Create(OptionBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
                end)
                
                OptionBtn.MouseButton1Click:Connect(function()
                    if selected[option] then
                        selected[option] = nil
                        CheckIcon.Visible = false
                    else
                        selected[option] = option
                        CheckIcon.Visible = true
                        CheckIcon.ImageColor3 = PresetColor
                    end
                    
                    local count = 0
                    for _ in pairs(selected) do
                        count = count + 1
                    end
                    Selection.Text = count .. " selected"
                    if count > 0 then
                        Selection.TextColor3 = PresetColor
                    else
                        Selection.TextColor3 = Color3.fromRGB(150, 150, 150)
                    end
                    
                    pcall(callback, selected)
                end)
                
                containerHeight = containerHeight + 37
            end
            
            Base.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if not open then
                        TweenService:Create(Base, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(1, -20, 0, 45 + containerHeight)}):Play()
                        TweenService:Create(Arrow, TweenInfo.new(0.3), {Rotation = 180}):Play()
                        DropdownContainer.Size = UDim2.new(1, 0, 0, containerHeight)
                        DropdownContainer.Visible = true
                    else
                        TweenService:Create(Base, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(1, -20, 0, 45)}):Play()
                        TweenService:Create(Arrow, TweenInfo.new(0.3), {Rotation = 0}):Play()
                        DropdownContainer.Size = UDim2.new(1, 0, 0, 0)
                        task.wait(0.2)
                        DropdownContainer.Visible = false
                    end
                    open = not open
                    Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
                end
            end)
            
            Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
            return Base
        end
        
        function tabcontent:Colorpicker(text, default, callback)
            local Base, Title, Icon = tabcontent:CreateBase("Colorpicker", text, "rbxassetid://135684703553372")
            Base.Size = UDim2.new(1, -20, 0, 45)
            Base.ClipsDescendants = true
            
            local ColorBox = Instance.new("Frame")
            local ColorCorner = Instance.new("UICorner")
            
            ColorBox.Parent = Base
            ColorBox.BackgroundColor3 = default or PresetColor
            ColorBox.Position = UDim2.new(1, -45, 0.5, -12)
            ColorBox.Size = UDim2.new(0, 30, 0, 24)
            
            ColorCorner.CornerRadius = UDim.new(0, 6)
            ColorCorner.Parent = ColorBox
            
            local PickerContainer = Instance.new("Frame")
            local ColorPicker = Instance.new("ImageLabel")
            local HuePicker = Instance.new("ImageLabel")
            local ColorSelector = Instance.new("ImageLabel")
            local HueSelector = Instance.new("ImageLabel")
            
            PickerContainer.Parent = Base
            PickerContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            PickerContainer.BorderSizePixel = 0
            PickerContainer.Position = UDim2.new(0, 0, 1, 5)
            PickerContainer.Size = UDim2.new(1, 0, 0, 150)
            PickerContainer.Visible = false
            
            local PickerCorner = Instance.new("UICorner")
            PickerCorner.CornerRadius = UDim.new(0, 8)
            PickerCorner.Parent = PickerContainer
            
            ColorPicker.Parent = PickerContainer
            ColorPicker.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ColorPicker.Position = UDim2.new(0.05, 0, 0.1, 0)
            ColorPicker.Size = UDim2.new(0, 150, 0, 120)
            ColorPicker.Image = "rbxassetid://4155801252"
            
            HuePicker.Parent = PickerContainer
            HuePicker.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            HuePicker.Position = UDim2.new(0.75, 0, 0.1, 0)
            HuePicker.Size = UDim2.new(0, 30, 0, 120)
            HuePicker.Image = "rbxassetid://108217585014571"
            
            local HueGradient = Instance.new("UIGradient")
            HueGradient.Parent = HuePicker
            HueGradient.Rotation = 270
            HueGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255,0,0)),
                ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255,255,0)),
                ColorSequenceKeypoint.new(0.4, Color3.fromRGB(0,255,0)),
                ColorSequenceKeypoint.new(0.6, Color3.fromRGB(0,255,255)),
                ColorSequenceKeypoint.new(0.8, Color3.fromRGB(0,0,255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255,0,255))
            })
            
            ColorSelector.Parent = ColorPicker
            ColorSelector.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ColorSelector.BackgroundTransparency = 1
            ColorSelector.Size = UDim2.new(0, 18, 0, 18)
            ColorSelector.Position = UDim2.new(1, -9, 0, -9)
            ColorSelector.Image = "rbxassetid://17345436140"
            
            HueSelector.Parent = HuePicker
            HueSelector.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            HueSelector.BackgroundTransparency = 1
            HueSelector.Size = UDim2.new(0, 18, 0, 18)
            HueSelector.Position = UDim2.new(0.5, -9, 0, 0)
            HueSelector.Image = "rbxassetid://108217585014571"
            
            local open = false
            local h, s, v = 1, 1, 1
            local colorInput, hueInput
            
            Base.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if not open then
                        TweenService:Create(Base, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(1, -20, 0, 200)}):Play()
                        PickerContainer.Visible = true
                    else
                        TweenService:Create(Base, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(1, -20, 0, 45)}):Play()
                        PickerContainer.Visible = false
                    end
                    open = not open
                    Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
                end
            end)
            
            Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
            return Base
        end
        
        function tabcontent:Label(text)
            local Base, Title, Icon = tabcontent:CreateBase("Label", text, "rbxassetid://116620312917084")
            Base.Size = UDim2.new(1, -20, 0, 40)
            Title.TextColor3 = Color3.fromRGB(150, 150, 150)
            Title.TextSize = 13
            Icon.ImageColor3 = Color3.fromRGB(150, 150, 150)
            
            Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
            return Base
        end
        
        function tabcontent:Textbox(text, placeholder, callback)
            local Base, Title, Icon = tabcontent:CreateBase("Textbox", text, "rbxassetid://122180020814574")
            Base.Size = UDim2.new(1, -20, 0, 45)
            
            local TextBox = Instance.new("TextBox")
            local BoxCorner = Instance.new("UICorner")
            
            TextBox.Parent = Base
            TextBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            TextBox.Position = UDim2.new(1, -130, 0.5, -15)
            TextBox.Size = UDim2.new(0, 120, 0, 30)
            TextBox.Font = Enum.Font.Gotham
            TextBox.PlaceholderText = placeholder
            TextBox.Text = ""
            TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextBox.TextSize = 14
            TextBox.ClearTextOnFocus = false
            
            BoxCorner.CornerRadius = UDim.new(0, 6)
            BoxCorner.Parent = TextBox
            
            TextBox.FocusLost:Connect(function(ep)
                if ep then
                    pcall(callback, TextBox.Text)
                end
            end)
            
            Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
            return Base
        end
        
        function tabcontent:Bind(text, default, callback)
            local Base, Title, Icon = tabcontent:CreateBase("Bind", text, "rbxassetid://78408734580845")
            Base.Size = UDim2.new(1, -20, 0, 45)
            
            local BindLabel = Instance.new("TextLabel")
            BindLabel.Parent = Base
            BindLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            BindLabel.Position = UDim2.new(1, -80, 0.5, -15)
            BindLabel.Size = UDim2.new(0, 70, 0, 30)
            BindLabel.Font = Enum.Font.GothamBold
            BindLabel.Text = default.Name
            BindLabel.TextColor3 = PresetColor
            BindLabel.TextSize = 14
            
            local BindCorner = Instance.new("UICorner")
            BindCorner.CornerRadius = UDim.new(0, 6)
            BindCorner.Parent = BindLabel
            
            local binding = false
            local currentKey = default
            
            Base.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    binding = true
                    BindLabel.Text = "..."
                    TweenService:Create(BindLabel, TweenInfo.new(0.2), {BackgroundColor3 = PresetColor, TextColor3 = Color3.fromRGB(0,0,0)}):Play()
                    
                    local con
                    con = UserInputService.InputBegan:Connect(function(key, gp)
                        if gp then return end
                        if key.KeyCode ~= Enum.KeyCode.Unknown then
                            currentKey = key.KeyCode
                            BindLabel.Text = key.KeyCode.Name
                            binding = false
                            TweenService:Create(BindLabel, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40,40,40), TextColor3 = PresetColor}):Play()
                            con:Disconnect()
                        end
                    end)
                end
            end)
            
            UserInputService.InputBegan:Connect(function(key, gp)
                if not gp and not binding and key.KeyCode == currentKey then
                    pcall(callback)
                end
            end)
            
            Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
            return Base
        end
        
        function tabcontent:Progress(text, default, callback)
            local Base, Title, Icon = tabcontent:CreateBase("Progress", text, "rbxassetid://89496630185293")
            Base.Size = UDim2.new(1, -20, 0, 65)
            
            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Parent = Base
            ValueLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Position = UDim2.new(1, -70, 0, 5)
            ValueLabel.Size = UDim2.new(0, 60, 0, 20)
            ValueLabel.Font = Enum.Font.GothamBold
            ValueLabel.Text = tostring(default or 0) .. "%"
            ValueLabel.TextColor3 = PresetColor
            ValueLabel.TextSize = 16
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            
            local ProgressBack = Instance.new("Frame")
            local ProgressFill = Instance.new("Frame")
            local ProgressCorner = Instance.new("UICorner")
            local FillCorner = Instance.new("UICorner")
            
            ProgressBack.Parent = Base
            ProgressBack.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            ProgressBack.Position = UDim2.new(0.05, 0, 1, -25)
            ProgressBack.Size = UDim2.new(0.9, 0, 0, 10)
            
            ProgressCorner.CornerRadius = UDim.new(1, 0)
            ProgressCorner.Parent = ProgressBack
            
            ProgressFill.Parent = ProgressBack
            ProgressFill.BackgroundColor3 = PresetColor
            ProgressFill.Size = UDim2.new((default or 0) / 100, 0, 1, 0)
            
            FillCorner.CornerRadius = UDim.new(1, 0)
            FillCorner.Parent = ProgressFill
            
            local function setValue(val)
                val = math.clamp(val, 0, 100)
                ProgressFill.Size = UDim2.new(val / 100, 0, 1, 0)
                ValueLabel.Text = tostring(math.floor(val)) .. "%"
                pcall(callback, val)
            end
            
            Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
            return Base, setValue
        end
        
        return tabcontent
    end
    return tabhold
end
return lib