local lib = {RainbowColorValue = 0, HueSelectionPosition = 0}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local PresetColor = Color3.fromRGB(255,255,255)
local CloseBind = Enum.KeyCode.RightControl
local HttpService = game:GetService("HttpService")
local TextService = game:GetService("TextService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local GuiService = game:GetService("GuiService")
local CoreGui = game:GetService("CoreGui")

local ui = Instance.new("ScreenGui")
ui.Name = "ui"
ui.Parent = game.CoreGui
ui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ui.ResetOnSpawn = false
ui.DisplayOrder = 999
ui.IgnoreGuiInset = true

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

local function CreateGradient(color1, color2, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, color1), ColorSequenceKeypoint.new(1, color2)})
    gradient.Rotation = rotation or 0
    return gradient
end

local function CreateStroke(color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Color3.fromRGB(255,255,255)
    stroke.Thickness = thickness or 1
    stroke.Transparency = transparency or 0
    return stroke
end

local function CreateCorner(radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    return corner
end

local function CreateShadow(parent, transparency, sizeOffset)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Parent = parent
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 1
    shadow.Size = UDim2.new(1, sizeOffset or 40, 1, sizeOffset or 40)
    shadow.Position = UDim2.new(-0.035, 0, -0.06, 0)
    shadow.Image = "rbxassetid://13112884258"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = transparency or 0.6
    shadow.ZIndex = -1
    return shadow
end

function lib:Window(text, preset, closebind)
    CloseBind = closebind or Enum.KeyCode.RightControl
    PresetColor = preset or Color3.fromRGB(255,255,255)
    local fs = false
    local minimized = false
    local maximized = false
    local originalSize = UDim2.new(0, 560, 0, 319)
    local minimizedSize = UDim2.new(0, 560, 0, 45)
    local maximizedSize = UDim2.new(0, 900, 0, 600)
    local originalPos = UDim2.new(0.5, 0, 0.5, 0)
    
    local Main = Instance.new("ImageLabel")
    local MainCorner = CreateCorner(12)
    local MainStroke = CreateStroke(Color3.fromRGB(45, 45, 45), 1.5, 0.5)
    local MainShadow = CreateShadow(Main, 0.6, 40)
    
    local TopBar = Instance.new("Frame")
    local TopBarGradient = CreateGradient(Color3.fromRGB(30, 30, 30), Color3.fromRGB(20, 20, 20), 90)
    local TopBarCorner = CreateCorner(12)
    
    local TitleIcon = Instance.new("ImageLabel")
    local Title = Instance.new("TextLabel")
    local SubTitle = Instance.new("TextLabel")
    
    local WindowControls = Instance.new("Frame")
    local MinimizeBtn = Instance.new("ImageButton")
    local MaximizeBtn = Instance.new("ImageButton")
    local CloseBtn = Instance.new("ImageButton")
    local PinBtn = Instance.new("ImageButton")
    local SettingsBtn = Instance.new("ImageButton")
    local HelpBtn = Instance.new("ImageButton")
    
    local TabHold = Instance.new("ScrollingFrame")
    local TabHoldLayout = Instance.new("UIListLayout")
    local TabHoldPadding = Instance.new("UIPadding")
    local TabFolder = Instance.new("Folder")
    
    local DragFrame = Instance.new("Frame")
    
    local ResizeDragger = Instance.new("ImageButton")
    local ResizeCorner = CreateCorner(6)
    local ResizeDraggerGradient = CreateGradient(PresetColor, PresetColor:Lerp(Color3.fromRGB(255,255,255), 0.5), 45)
    
    local GlowEffect = Instance.new("ImageLabel")
    
    local StatusBar = Instance.new("Frame")
    local StatusBarCorner = CreateCorner(6)
    local StatusBarGradient = CreateGradient(Color3.fromRGB(25, 25, 25), Color3.fromRGB(20, 20, 20), 90)
    local FPSLabel = Instance.new("TextLabel")
    local MemoryLabel = Instance.new("TextLabel")
    local PingLabel = Instance.new("TextLabel")
    local TimeLabel = Instance.new("TextLabel")
    
    local SearchBar = Instance.new("Frame")
    local SearchBarCorner = CreateCorner(6)
    local SearchIcon = Instance.new("ImageLabel")
    local SearchBox = Instance.new("TextBox")
    local ClearSearchBtn = Instance.new("ImageButton")
    
    Main.Name = "Main"
    Main.Parent = ui
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    Main.BorderSizePixel = 0
    Main.Position = originalPos
    Main.Size = originalSize
    Main.ClipsDescendants = true
    Main.Visible = true
    Main.BackgroundTransparency = 0
    MainCorner.Parent = Main
    MainStroke.Parent = Main
    
    TopBar.Name = "TopBar"
    TopBar.Parent = Main
    TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TopBar.BackgroundTransparency = 0
    TopBar.Size = UDim2.new(1, 0, 0, 50)
    TopBar.ZIndex = 2
    TopBarGradient.Parent = TopBar
    TopBarCorner.Parent = TopBar
    
    TitleIcon.Name = "TitleIcon"
    TitleIcon.Parent = TopBar
    TitleIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TitleIcon.BackgroundTransparency = 1
    TitleIcon.Size = UDim2.new(0, 28, 0, 28)
    TitleIcon.Position = UDim2.new(0.02, 0, 0.5, -14)
    TitleIcon.Image = "rbxassetid://116535712789945"
    TitleIcon.ImageColor3 = PresetColor
    
    Title.Name = "Title"
    Title.Parent = TopBar
    Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0.08, 0, 0, 5)
    Title.Size = UDim2.new(0, 200, 0, 20)
    Title.Font = Enum.Font.GothamBold
    Title.Text = text
    Title.TextColor3 = Color3.fromRGB(255,255,255)
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    SubTitle.Name = "SubTitle"
    SubTitle.Parent = TopBar
    SubTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SubTitle.BackgroundTransparency = 1
    SubTitle.Position = UDim2.new(0.08, 0, 0, 25)
    SubTitle.Size = UDim2.new(0, 200, 0, 16)
    SubTitle.Font = Enum.Font.Gotham
    SubTitle.Text = "v2.0.0 | Premium"
    SubTitle.TextColor3 = Color3.fromRGB(150,150,150)
    SubTitle.TextSize = 12
    SubTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    WindowControls.Name = "WindowControls"
    WindowControls.Parent = TopBar
    WindowControls.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    WindowControls.BackgroundTransparency = 1
    WindowControls.Position = UDim2.new(1, -200, 0, 5)
    WindowControls.Size = UDim2.new(0, 200, 0, 40)
    
    local function CreateControlButton(parent, pos, img, tooltip)
        local btn = Instance.new("ImageButton")
        local tooltipFrame = Instance.new("Frame")
        local tooltipLabel = Instance.new("TextLabel")
        local tooltipCorner = CreateCorner(4)
        
        btn.Parent = parent
        btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        btn.BackgroundTransparency = 1
        btn.Position = UDim2.new(0, pos, 0.5, -14)
        btn.Size = UDim2.new(0, 28, 0, 28)
        btn.Image = img
        btn.ImageColor3 = Color3.fromRGB(180, 180, 180)
        
        tooltipFrame.Name = "Tooltip"
        tooltipFrame.Parent = btn
        tooltipFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        tooltipFrame.Position = UDim2.new(0.5, -40, -1, -25)
        tooltipFrame.Size = UDim2.new(0, 80, 0, 20)
        tooltipFrame.Visible = false
        tooltipFrame.ZIndex = 10
        tooltipFrame.Active = false
        tooltipCorner.Parent = tooltipFrame
        
        local tooltipStroke = CreateStroke(Color3.fromRGB(45,45,45), 1, 0.5)
        tooltipStroke.Parent = tooltipFrame
        
        tooltipLabel.Parent = tooltipFrame
        tooltipLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        tooltipLabel.BackgroundTransparency = 1
        tooltipLabel.Size = UDim2.new(1, 0, 1, 0)
        tooltipLabel.Font = Enum.Font.Gotham
        tooltipLabel.Text = tooltip
        tooltipLabel.TextColor3 = Color3.fromRGB(255,255,255)
        tooltipLabel.TextSize = 12
        
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {ImageColor3 = PresetColor, Size = UDim2.new(0, 30, 0, 30)}):Play()
            tooltipFrame.Visible = true
        end)
        
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(180,180,180), Size = UDim2.new(0, 28, 0, 28)}):Play()
            tooltipFrame.Visible = false
        end)
        
        return btn
    end
    
    MinimizeBtn = CreateControlButton(WindowControls, 0, "rbxassetid://116269596042539", "Minimize")
    MaximizeBtn = CreateControlButton(WindowControls, 35, "rbxassetid://137492887754537", "Maximize")
    CloseBtn = CreateControlButton(WindowControls, 70, "rbxassetid://110786993356448", "Close")
    PinBtn = CreateControlButton(WindowControls, 105, "rbxassetid://104067089444415", "Pin")
    SettingsBtn = CreateControlButton(WindowControls, 140, "rbxassetid://135684703553372", "Settings")
    HelpBtn = CreateControlButton(WindowControls, 175, "rbxassetid://124560466474914", "Help")
    
    TabHold.Name = "TabHold"
    TabHold.Parent = Main
    TabHold.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TabHold.BackgroundTransparency = 0
    TabHold.Position = UDim2.new(0, 10, 0, 60)
    TabHold.Size = UDim2.new(0, 130, 1, -80)
    TabHold.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabHold.ScrollBarThickness = 4
    TabHold.ScrollBarImageColor3 = PresetColor
    TabHold.BorderSizePixel = 0
    TabHold.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    local TabHoldCorner = CreateCorner(8)
    TabHoldCorner.Parent = TabHold
    
    TabHoldPadding.Parent = TabHold
    TabHoldPadding.PaddingTop = UDim.new(0, 8)
    TabHoldPadding.PaddingBottom = UDim.new(0, 8)
    TabHoldPadding.PaddingLeft = UDim.new(0, 5)
    TabHoldPadding.PaddingRight = UDim.new(0, 5)
    
    TabHoldLayout.Name = "TabHoldLayout"
    TabHoldLayout.Parent = TabHold
    TabHoldLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabHoldLayout.Padding = UDim.new(0, 4)
    TabHoldLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    SearchBar.Name = "SearchBar"
    SearchBar.Parent = Main
    SearchBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    SearchBar.Position = UDim2.new(0, 150, 0, 60)
    SearchBar.Size = UDim2.new(1, -170, 0, 35)
    SearchBar.BackgroundTransparency = 0
    SearchBarCorner.Parent = SearchBar
    
    SearchIcon.Name = "SearchIcon"
    SearchIcon.Parent = SearchBar
    SearchIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SearchIcon.BackgroundTransparency = 1
    SearchIcon.Size = UDim2.new(0, 20, 0, 20)
    SearchIcon.Position = UDim2.new(0.01, 0, 0.5, -10)
    SearchIcon.Image = "rbxassetid://121018724060431"
    SearchIcon.ImageColor3 = Color3.fromRGB(150, 150, 150)
    
    SearchBox.Name = "SearchBox"
    SearchBox.Parent = SearchBar
    SearchBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SearchBox.BackgroundTransparency = 1
    SearchBox.Position = UDim2.new(0.05, 0, 0, 0)
    SearchBox.Size = UDim2.new(0.9, -30, 1, 0)
    SearchBox.Font = Enum.Font.Gotham
    SearchBox.PlaceholderText = "Search tabs, settings, features..."
    SearchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    SearchBox.Text = ""
    SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    SearchBox.TextSize = 14
    SearchBox.ClearTextOnFocus = false
    
    ClearSearchBtn.Name = "ClearSearchBtn"
    ClearSearchBtn.Parent = SearchBar
    ClearSearchBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ClearSearchBtn.BackgroundTransparency = 1
    ClearSearchBtn.Size = UDim2.new(0, 20, 0, 20)
    ClearSearchBtn.Position = UDim2.new(0.98, -20, 0.5, -10)
    ClearSearchBtn.Image = "rbxassetid://110786993356448"
    ClearSearchBtn.ImageColor3 = Color3.fromRGB(150, 150, 150)
    ClearSearchBtn.Visible = false
    
    ClearSearchBtn.MouseButton1Click:Connect(function()
        SearchBox.Text = ""
        ClearSearchBtn.Visible = false
        for _, v in pairs(TabHold:GetChildren()) do
            if v:IsA("TextButton") then
                v.Visible = true
            end
        end
    end)
    
    SearchBox.Changed:Connect(function(prop)
        if prop == "Text" then
            ClearSearchBtn.Visible = #SearchBox.Text > 0
            local searchTerm = SearchBox.Text:lower()
            for _, v in pairs(TabHold:GetChildren()) do
                if v:IsA("TextButton") and v:FindFirstChild("TabTitle") then
                    v.Visible = #searchTerm == 0 or v.TabTitle.Text:lower():find(searchTerm) ~= nil
                end
            end
        end
    end)
    
    TabFolder.Name = "TabFolder"
    TabFolder.Parent = Main
    
    DragFrame.Name = "DragFrame"
    DragFrame.Parent = TopBar
    DragFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    DragFrame.BackgroundTransparency = 1
    DragFrame.Size = UDim2.new(0.7, -200, 1, 0)
    DragFrame.Position = UDim2.new(0.15, 0, 0, 0)
    
    MakeDraggable(DragFrame, Main)
    
    ResizeDragger.Name = "ResizeDragger"
    ResizeDragger.Parent = Main
    ResizeDragger.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    ResizeDragger.BackgroundTransparency = 0
    ResizeDragger.Size = UDim2.new(0, 24, 0, 24)
    ResizeDragger.Position = UDim2.new(1, -24, 1, -24)
    ResizeDragger.Image = "rbxassetid://137987229582002"
    ResizeDragger.ImageColor3 = PresetColor
    ResizeDragger.ZIndex = 10
    ResizeCorner.Parent = ResizeDragger
    ResizeDraggerGradient.Parent = ResizeDragger
    
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
    
    StatusBar.Name = "StatusBar"
    StatusBar.Parent = Main
    StatusBar.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    StatusBar.Position = UDim2.new(0, 150, 1, -25)
    StatusBar.Size = UDim2.new(1, -160, 0, 20)
    StatusBar.BackgroundTransparency = 0
    StatusBarCorner.Parent = StatusBar
    StatusBarGradient.Parent = StatusBar
    
    FPSLabel.Name = "FPSLabel"
    FPSLabel.Parent = StatusBar
    FPSLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    FPSLabel.BackgroundTransparency = 1
    FPSLabel.Position = UDim2.new(0.02, 0, 0, 0)
    FPSLabel.Size = UDim2.new(0, 60, 1, 0)
    FPSLabel.Font = Enum.Font.Gotham
    FPSLabel.Text = "FPS: 60"
    FPSLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
    FPSLabel.TextSize = 12
    FPSLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    MemoryLabel.Name = "MemoryLabel"
    MemoryLabel.Parent = StatusBar
    MemoryLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    MemoryLabel.BackgroundTransparency = 1
    MemoryLabel.Position = UDim2.new(0.15, 0, 0, 0)
    MemoryLabel.Size = UDim2.new(0, 80, 1, 0)
    MemoryLabel.Font = Enum.Font.Gotham
    MemoryLabel.Text = "MEM: 128MB"
    MemoryLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
    MemoryLabel.TextSize = 12
    MemoryLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    PingLabel.Name = "PingLabel"
    PingLabel.Parent = StatusBar
    PingLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    PingLabel.BackgroundTransparency = 1
    PingLabel.Position = UDim2.new(0.35, 0, 0, 0)
    PingLabel.Size = UDim2.new(0, 60, 1, 0)
    PingLabel.Font = Enum.Font.Gotham
    PingLabel.Text = "PING: 45ms"
    PingLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
    PingLabel.TextSize = 12
    PingLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    TimeLabel.Name = "TimeLabel"
    TimeLabel.Parent = StatusBar
    TimeLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TimeLabel.BackgroundTransparency = 1
    TimeLabel.Position = UDim2.new(0.8, 0, 0, 0)
    TimeLabel.Size = UDim2.new(0.2, -10, 1, 0)
    TimeLabel.Font = Enum.Font.Gotham
    TimeLabel.Text = os.date("%H:%M:%S")
    TimeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    TimeLabel.TextSize = 12
    TimeLabel.TextXAlignment = Enum.TextXAlignment.Right
    
    coroutine.wrap(function()
        while task.wait(1) do
            TimeLabel.Text = os.date("%H:%M:%S")
            local stats = game:GetService("Stats")
            local ping = stats:GetValue("DataPing") / 1000
            PingLabel.Text = string.format("PING: %dms", math.floor(ping))
            
            local mem = stats:GetValue("MemoryPhysics") / 1048576
            MemoryLabel.Text = string.format("MEM: %dMB", math.floor(mem))
            
            local fps = stats:GetValue("FPS")
            FPSLabel.Text = string.format("FPS: %d", math.floor(fps))
        end
    end)()
    
    coroutine.wrap(function()
        while task.wait() do
            TitleIcon.ImageColor3 = PresetColor
            ResizeDragger.ImageColor3 = PresetColor
            GlowEffect.ImageColor3 = PresetColor
            TabHold.ScrollBarImageColor3 = PresetColor
        end
    end)()
    
    local uitoggled = true
    
    local function animateButton(btn, isHover)
        local targetColor = isHover and PresetColor or Color3.fromRGB(180,180,180)
        local targetSize = isHover and UDim2.new(0, 30, 0, 30) or UDim2.new(0, 28, 0, 28)
        TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {ImageColor3 = targetColor, Size = targetSize}):Play()
    end
    
    MinimizeBtn.MouseEnter:Connect(function() animateButton(MinimizeBtn, true) end)
    MinimizeBtn.MouseLeave:Connect(function() animateButton(MinimizeBtn, false) end)
    MaximizeBtn.MouseEnter:Connect(function() animateButton(MaximizeBtn, true) end)
    MaximizeBtn.MouseLeave:Connect(function() animateButton(MaximizeBtn, false) end)
    CloseBtn.MouseEnter:Connect(function() animateButton(CloseBtn, true) end)
    CloseBtn.MouseLeave:Connect(function() animateButton(CloseBtn, false) end)
    PinBtn.MouseEnter:Connect(function() animateButton(PinBtn, true) end)
    PinBtn.MouseLeave:Connect(function() animateButton(PinBtn, false) end)
    SettingsBtn.MouseEnter:Connect(function() animateButton(SettingsBtn, true) end)
    SettingsBtn.MouseLeave:Connect(function() animateButton(SettingsBtn, false) end)
    HelpBtn.MouseEnter:Connect(function() animateButton(HelpBtn, true) end)
    HelpBtn.MouseLeave:Connect(function() animateButton(HelpBtn, false) end)
    
    MinimizeBtn.MouseButton1Click:Connect(function()
        if not minimized then
            originalSize = Main.Size
            originalPos = Main.Position
            TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = minimizedSize, Position = UDim2.new(0.5, 0, 0, -22)}):Play()
            TweenService:Create(TabHold, TweenInfo.new(0.3), {BackgroundTransparency = 1, Visible = false}):Play()
            TweenService:Create(SearchBar, TweenInfo.new(0.3), {BackgroundTransparency = 1, Visible = false}):Play()
            TweenService:Create(StatusBar, TweenInfo.new(0.3), {BackgroundTransparency = 1, Visible = false}):Play()
            for _, v in pairs(TabFolder:GetChildren()) do
                if v:IsA("ScrollingFrame") then
                    TweenService:Create(v, TweenInfo.new(0.3), {BackgroundTransparency = 1, Visible = false}):Play()
                end
            end
            minimized = true
        else
            TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = originalSize, Position = originalPos}):Play()
            TweenService:Create(TabHold, TweenInfo.new(0.3), {BackgroundTransparency = 0, Visible = true}):Play()
            TweenService:Create(SearchBar, TweenInfo.new(0.3), {BackgroundTransparency = 0, Visible = true}):Play()
            TweenService:Create(StatusBar, TweenInfo.new(0.3), {BackgroundTransparency = 0, Visible = true}):Play()
            for _, v in pairs(TabFolder:GetChildren()) do
                if v:IsA("ScrollingFrame") then
                    TweenService:Create(v, TweenInfo.new(0.3), {BackgroundTransparency = 0, Visible = true}):Play()
                end
            end
            minimized = false
        end
    end)
    
    MaximizeBtn.MouseButton1Click:Connect(function()
        if not maximized then
            originalSize = Main.Size
            originalPos = Main.Position
            TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = maximizedSize, Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
            TabHold.Size = UDim2.new(0, 150, 1, -80)
            for _, v in pairs(TabFolder:GetChildren()) do
                if v:IsA("ScrollingFrame") then
                    v.Size = UDim2.new(1, -170, 1, -90)
                end
            end
            maximized = true
        else
            TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = originalSize, Position = originalPos}):Play()
            TabHold.Size = UDim2.new(0, 130, 1, -80)
            for _, v in pairs(TabFolder:GetChildren()) do
                if v:IsA("ScrollingFrame") then
                    v.Size = UDim2.new(1, -150, 1, -90)
                end
            end
            maximized = false
        end
    end)
    
    CloseBtn.MouseButton1Click:Connect(function()
        if uitoggled then
            uitoggled = false
            TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0), Transparency = 1}):Play()
            task.wait(0.3)
            ui.Enabled = false
        else
            uitoggled = true
            ui.Enabled = true
            TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 560, 0, 319), Transparency = 0}):Play()
        end
    end)
    
    PinBtn.MouseButton1Click:Connect(function()
        ui.Enabled = not ui.Enabled
    end)
    
    SettingsBtn.MouseButton1Click:Connect(function()
        lib:Notification("Settings", "Opening settings panel...", "OK")
    end)
    
    HelpBtn.MouseButton1Click:Connect(function()
        lib:Notification("Help", "Press RightControl to toggle UI\nDrag the top bar to move\nUse search to find tabs", "Got it")
    end)
    
    UserInputService.InputBegan:Connect(function(io, p)
        if io.KeyCode == CloseBind and not p then
            if uitoggled then
                uitoggled = false
                TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
                task.wait(0.3)
                ui.Enabled = false
            else
                uitoggled = true
                ui.Enabled = true
                TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = originalSize}):Play()
            end
        end
    end)
    
    local resizing = false
    local resizeStart = nil
    local resizeStartSize = nil
    local minSize = Vector2.new(500, 300)
    
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
            TabHold.Size = UDim2.new(0, 130, 1, -80)
            SearchBar.Size = UDim2.new(1, -170, 0, 35)
            StatusBar.Size = UDim2.new(1, -160, 0, 20)
            for _, v in pairs(TabFolder:GetChildren()) do
                if v:IsA("ScrollingFrame") then
                    v.Size = UDim2.new(1, -150, 1, -90)
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
        local NotificationCorner = CreateCorner(12)
        local NotificationStroke = CreateStroke(PresetColor, 2, 0.5)
        local NotificationIcon = Instance.new("ImageLabel")
        local NotificationTitle = Instance.new("TextLabel")
        local NotificationDesc = Instance.new("TextLabel")
        local NotificationProgress = Instance.new("Frame")
        local ProgressBar = Instance.new("Frame")
        local ProgressCorner = CreateCorner(2)
        local OkayBtn = Instance.new("TextButton")
        local OkayBtnCorner = CreateCorner(8)
        local CancelBtn = Instance.new("TextButton")
        local CancelBtnCorner = CreateCorner(8)
        local CloseIcon = Instance.new("ImageButton")
        
        NotificationHold.Name = "NotificationHold"
        NotificationHold.Parent = Main
        NotificationHold.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        NotificationHold.BackgroundTransparency = 1
        NotificationHold.BorderSizePixel = 0
        NotificationHold.Size = UDim2.new(1, 0, 1, 0)
        NotificationHold.AutoButtonColor = false
        NotificationHold.Font = Enum.Font.SourceSans
        NotificationHold.Text = ""
        NotificationHold.ZIndex = 100
        
        TweenService:Create(NotificationHold, TweenInfo.new(0.3), {BackgroundTransparency = 0.7}):Play()
        task.wait(0.2)
        
        NotificationFrame.Name = "NotificationFrame"
        NotificationFrame.Parent = NotificationHold
        NotificationFrame.AnchorPoint = Vector2.new(0.5, 0.5)
        NotificationFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        NotificationFrame.BorderSizePixel = 0
        NotificationFrame.ClipsDescendants = true
        NotificationFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        NotificationFrame.Size = UDim2.new(0, 0, 0, 0)
        NotificationFrame.ZIndex = 101
        NotificationCorner.Parent = NotificationFrame
        NotificationStroke.Parent = NotificationFrame
        
        NotificationIcon.Name = "NotificationIcon"
        NotificationIcon.Parent = NotificationFrame
        NotificationIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        NotificationIcon.BackgroundTransparency = 1
        NotificationIcon.Size = UDim2.new(0, 50, 0, 50)
        NotificationIcon.Position = UDim2.new(0.5, -25, 0.1, 0)
        NotificationIcon.Image = "rbxassetid://116535712789945"
        NotificationIcon.ImageColor3 = PresetColor
        NotificationIcon.ZIndex = 102
        
        NotificationTitle.Name = "NotificationTitle"
        NotificationTitle.Parent = NotificationFrame
        NotificationTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        NotificationTitle.BackgroundTransparency = 1
        NotificationTitle.Position = UDim2.new(0, 20, 0, 60)
        NotificationTitle.Size = UDim2.new(1, -40, 0, 30)
        NotificationTitle.Font = Enum.Font.GothamBold
        NotificationTitle.Text = texttitle
        NotificationTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        NotificationTitle.TextSize = 20
        NotificationTitle.TextXAlignment = Enum.TextXAlignment.Center
        NotificationTitle.ZIndex = 102
        
        NotificationDesc.Name = "NotificationDesc"
        NotificationDesc.Parent = NotificationFrame
        NotificationDesc.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        NotificationDesc.BackgroundTransparency = 1
        NotificationDesc.Position = UDim2.new(0, 20, 0, 100)
        NotificationDesc.Size = UDim2.new(1, -40, 0, 60)
        NotificationDesc.Font = Enum.Font.Gotham
        NotificationDesc.Text = textdesc
        NotificationDesc.TextColor3 = Color3.fromRGB(200, 200, 200)
        NotificationDesc.TextSize = 14
        NotificationDesc.TextWrapped = true
        NotificationDesc.TextXAlignment = Enum.TextXAlignment.Center
        NotificationDesc.ZIndex = 102
        
        NotificationProgress.Name = "NotificationProgress"
        NotificationProgress.Parent = NotificationFrame
        NotificationProgress.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        NotificationProgress.Position = UDim2.new(0.1, 0, 0.7, 0)
        NotificationProgress.Size = UDim2.new(0.8, 0, 0, 4)
        NotificationProgress.ZIndex = 102
        ProgressCorner.Parent = NotificationProgress
        
        ProgressBar.Name = "ProgressBar"
        ProgressBar.Parent = NotificationProgress
        ProgressBar.BackgroundColor3 = PresetColor
        ProgressBar.Size = UDim2.new(0, 0, 1, 0)
        ProgressBar.ZIndex = 103
        
        local progress = 0
        local progressTween = TweenService:Create(ProgressBar, TweenInfo.new(3), {Size = UDim2.new(1, 0, 1, 0)})
        progressTween:Play()
        
        OkayBtn.Name = "OkayBtn"
        OkayBtn.Parent = NotificationFrame
        OkayBtn.BackgroundColor3 = PresetColor
        OkayBtn.Position = UDim2.new(0.25, -60, 0.85, -15)
        OkayBtn.Size = UDim2.new(0, 100, 0, 35)
        OkayBtn.AutoButtonColor = false
        OkayBtn.Font = Enum.Font.GothamBold
        OkayBtn.Text = textbtn or "OK"
        OkayBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        OkayBtn.TextSize = 14
        OkayBtn.ZIndex = 102
        OkayBtnCorner.Parent = OkayBtn
        
        CancelBtn.Name = "CancelBtn"
        CancelBtn.Parent = NotificationFrame
        CancelBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        CancelBtn.Position = UDim2.new(0.75, -40, 0.85, -15)
        CancelBtn.Size = UDim2.new(0, 100, 0, 35)
        CancelBtn.AutoButtonColor = false
        CancelBtn.Font = Enum.Font.GothamBold
        CancelBtn.Text = "Cancel"
        CancelBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        CancelBtn.TextSize = 14
        CancelBtn.ZIndex = 102
        CancelBtnCorner.Parent = CancelBtn
        
        CloseIcon.Name = "CloseIcon"
        CloseIcon.Parent = NotificationFrame
        CloseIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        CloseIcon.BackgroundTransparency = 1
        CloseIcon.Size = UDim2.new(0, 20, 0, 20)
        CloseIcon.Position = UDim2.new(1, -30, 0.05, 0)
        CloseIcon.Image = "rbxassetid://110786993356448"
        CloseIcon.ImageColor3 = Color3.fromRGB(150, 150, 150)
        CloseIcon.ZIndex = 102
        
        TweenService:Create(NotificationFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 350, 0, 220)}):Play()
        
        local function closeNotification()
            progressTween:Cancel()
            TweenService:Create(NotificationFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
            task.wait(0.2)
            TweenService:Create(NotificationHold, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
            task.wait(0.2)
            NotificationHold:Destroy()
        end
        
        OkayBtn.MouseEnter:Connect(function()
            TweenService:Create(OkayBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 255, 255), TextColor3 = PresetColor}):Play()
        end)
        
        OkayBtn.MouseLeave:Connect(function()
            TweenService:Create(OkayBtn, TweenInfo.new(0.2), {BackgroundColor3 = PresetColor, TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        end)
        
        CancelBtn.MouseEnter:Connect(function()
            TweenService:Create(CancelBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
        end)
        
        CancelBtn.MouseLeave:Connect(function()
            TweenService:Create(CancelBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
        end)
        
        CloseIcon.MouseEnter:Connect(function()
            TweenService:Create(CloseIcon, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        end)
        
        CloseIcon.MouseLeave:Connect(function()
            TweenService:Create(CloseIcon, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(150, 150, 150)}):Play()
        end)
        
        OkayBtn.MouseButton1Click:Connect(closeNotification)
        CancelBtn.MouseButton1Click:Connect(closeNotification)
        CloseIcon.MouseButton1Click:Connect(closeNotification)
        
        progressTween.Completed:Connect(closeNotification)
    end
    
    local tabhold = {}
    function tabhold:Tab(text)
        local TabBtn = Instance.new("TextButton")
        local TabBtnCorner = CreateCorner(8)
        local TabIcon = Instance.new("ImageLabel")
        local TabTitle = Instance.new("TextLabel")
        local TabBtnIndicator = Instance.new("Frame")
        local TabBtnIndicatorCorner = CreateCorner(2)
        local TabBtnGradient = CreateGradient(Color3.fromRGB(35, 35, 35), Color3.fromRGB(25, 25, 25), 90)
        local TabBtnStroke = CreateStroke(Color3.fromRGB(45, 45, 45), 1, 0.5)
        
        TabBtn.Name = "TabBtn"
        TabBtn.Parent = TabHold
        TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        TabBtn.BackgroundTransparency = 0
        TabBtn.Size = UDim2.new(0, 110, 0, 45)
        TabBtn.AutoButtonColor = false
        TabBtn.Font = Enum.Font.SourceSans
        TabBtn.Text = ""
        TabBtnCorner.Parent = TabBtn
        TabBtnGradient.Parent = TabBtn
        TabBtnStroke.Parent = TabBtn
        
        TabIcon.Name = "TabIcon"
        TabIcon.Parent = TabBtn
        TabIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TabIcon.BackgroundTransparency = 1
        TabIcon.Size = UDim2.new(0, 24, 0, 24)
        TabIcon.Position = UDim2.new(0, 10, 0.5, -12)
        TabIcon.Image = "rbxassetid://116535712789945"
        TabIcon.ImageColor3 = Color3.fromRGB(150, 150, 150)
        
        TabTitle.Name = "TabTitle"
        TabTitle.Parent = TabBtn
        TabTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TabTitle.BackgroundTransparency = 1
        TabTitle.Position = UDim2.new(0, 40, 0, 0)
        TabTitle.Size = UDim2.new(0, 70, 1, 0)
        TabTitle.Font = Enum.Font.Gotham
        TabTitle.Text = text
        TabTitle.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabTitle.TextSize = 14
        TabTitle.TextXAlignment = Enum.TextXAlignment.Left
        
        TabBtnIndicator.Name = "TabBtnIndicator"
        TabBtnIndicator.Parent = TabBtn
        TabBtnIndicator.BackgroundColor3 = PresetColor
        TabBtnIndicator.BorderSizePixel = 0
        TabBtnIndicator.Position = UDim2.new(0, 0, 1, -3)
        TabBtnIndicator.Size = UDim2.new(0, 0, 0, 3)
        TabBtnIndicatorCorner.Parent = TabBtnIndicator
        
        local Tab = Instance.new("ScrollingFrame")
        local TabLayout = Instance.new("UIListLayout")
        local TabPadding = Instance.new("UIPadding")
        local TabCorner = CreateCorner(8)
        local TabStroke = CreateStroke(Color3.fromRGB(45, 45, 45), 1, 0.5)
        
        Tab.Name = "Tab"
        Tab.Parent = TabFolder
        Tab.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        Tab.BackgroundTransparency = 0
        Tab.BorderSizePixel = 0
        Tab.Position = UDim2.new(0, 150, 0, 105)
        Tab.Size = UDim2.new(1, -160, 1, -135)
        Tab.CanvasSize = UDim2.new(0, 0, 0, 0)
        Tab.ScrollBarThickness = 6
        Tab.ScrollBarImageColor3 = PresetColor
        Tab.Visible = false
        Tab.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabCorner.Parent = Tab
        TabStroke.Parent = Tab
        
        TabPadding.Parent = Tab
        TabPadding.PaddingTop = UDim.new(0, 12)
        TabPadding.PaddingBottom = UDim.new(0, 12)
        TabPadding.PaddingLeft = UDim.new(0, 12)
        TabPadding.PaddingRight = UDim.new(0, 12)
        
        TabLayout.Name = "TabLayout"
        TabLayout.Parent = Tab
        TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
        TabLayout.Padding = UDim.new(0, 8)
        TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        
        if fs == false then
            fs = true
            TabBtnIndicator.Size = UDim2.new(0, 40, 0, 3)
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
                    TweenService:Create(v.TabBtnIndicator, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 3)}):Play()
                    TweenService:Create(v.TabTitle, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(150, 150, 150)}):Play()
                    TweenService:Create(v.TabIcon, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(150, 150, 150)}):Play()
                end
            end
            TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
            TweenService:Create(TabBtnIndicator, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 40, 0, 3)}):Play()
            TweenService:Create(TabTitle, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            TweenService:Create(TabIcon, TweenInfo.new(0.2), {ImageColor3 = PresetColor}):Play()
            Tab.Visible = true
            Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
        end)
        
        local tabcontent = {}
        
        function tabcontent:CreateBase(elementType, text, icon, customHeight)
            local Base = Instance.new("Frame")
            local Corner = CreateCorner(8)
            local Stroke = CreateStroke(Color3.fromRGB(45, 45, 45), 1, 0.5)
            local Gradient = CreateGradient(Color3.fromRGB(35, 35, 35), Color3.fromRGB(25, 25, 25), 90)
            local Icon = Instance.new("ImageLabel")
            local Title = Instance.new("TextLabel")
            local Divider = Instance.new("Frame")
            local DividerCorner = CreateCorner(2)
            
            Base.Name = elementType
            Base.Parent = Tab
            Base.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Base.Size = UDim2.new(1, 0, 0, customHeight or 50)
            Base.BackgroundTransparency = 0
            Base.ClipsDescendants = true
            
            Corner.Parent = Base
            Stroke.Parent = Base
            Gradient.Parent = Base
            
            Divider.Name = "Divider"
            Divider.Parent = Base
            Divider.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            Divider.Position = UDim2.new(0.02, 0, 0, 0)
            Divider.Size = UDim2.new(0.96, 0, 0, 1)
            Divider.Visible = false
            DividerCorner.Parent = Divider
            
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
            
            return Base, Title, Icon, Divider
        end
        
        function tabcontent:Button(text, callback)
            local Base, Title, Icon = tabcontent:CreateBase("Button", text, "rbxassetid://120408917249739", 45)
            
            local ClickEffect = Instance.new("Frame")
            local ClickCorner = CreateCorner(8)
            ClickEffect.Name = "ClickEffect"
            ClickEffect.Parent = Base
            ClickEffect.BackgroundColor3 = PresetColor
            ClickEffect.BackgroundTransparency = 1
            ClickEffect.Size = UDim2.new(1, 0, 1, 0)
            ClickEffect.ZIndex = 5
            ClickCorner.Parent = ClickEffect
            
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
                    TweenService:Create(ClickEffect, TweenInfo.new(0.2), {BackgroundTransparency = 0.7}):Play()
                    task.wait(0.1)
                    TweenService:Create(Base, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
                    TweenService:Create(ClickEffect, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
                    pcall(callback)
                end
            end)
            
            Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
            return Base
        end
        
        function tabcontent:Toggle(text, default, callback)
            local toggled = default or false
            local Base, Title, Icon, Divider = tabcontent:CreateBase("Toggle", text, "rbxassetid://103871245626488", 50)
            
            local ToggleFrame = Instance.new("Frame")
            local ToggleInner = Instance.new("Frame")
            local ToggleCircle = Instance.new("Frame")
            local ToggleCorner = CreateCorner(15)
            local ToggleInnerCorner = CreateCorner(13)
            local ToggleCircleCorner = CreateCorner(13)
            
            ToggleFrame.Parent = Base
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            ToggleFrame.Position = UDim2.new(1, -60, 0.5, -14)
            ToggleFrame.Size = UDim2.new(0, 50, 0, 28)
            ToggleCorner.Parent = ToggleFrame
            
            ToggleInner.Parent = ToggleFrame
            ToggleInner.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            ToggleInner.Position = UDim2.new(0.06, 0, 0.1, 0)
            ToggleInner.Size = UDim2.new(0, 44, 0, 24)
            ToggleInnerCorner.Parent = ToggleInner
            
            ToggleCircle.Parent = ToggleInner
            ToggleCircle.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
            ToggleCircle.Position = UDim2.new(0.1, 0, 0.1, 0)
            ToggleCircle.Size = UDim2.new(0, 20, 0, 20)
            ToggleCircleCorner.Parent = ToggleCircle
            
            local Glow = Instance.new("ImageLabel")
            Glow.Parent = ToggleCircle
            Glow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Glow.BackgroundTransparency = 1
            Glow.Size = UDim2.new(1.5, 0, 1.5, 0)
            Glow.Position = UDim2.new(-0.25, 0, -0.25, 0)
            Glow.Image = "rbxassetid://5028857640"
            Glow.ImageColor3 = PresetColor
            Glow.ImageTransparency = 0.5
            Glow.ZIndex = -1
            Glow.Visible = false
            
            local function setState(state)
                toggled = state
                if state then
                    TweenService:Create(ToggleCircle, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.6, 0, 0.1, 0), BackgroundColor3 = PresetColor}):Play()
                    TweenService:Create(Icon, TweenInfo.new(0.2), {ImageColor3 = PresetColor}):Play()
                    TweenService:Create(Glow, TweenInfo.new(0.2), {Visible = true}):Play()
                else
                    TweenService:Create(ToggleCircle, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.1, 0, 0.1, 0), BackgroundColor3 = Color3.fromRGB(150, 150, 150)}):Play()
                    TweenService:Create(Icon, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(150, 150, 150)}):Play()
                    TweenService:Create(Glow, TweenInfo.new(0.2), {Visible = false}):Play()
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
            local Base, Title, Icon = tabcontent:CreateBase("Slider", text, "rbxassetid://110273524101447", 70)
            
            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Parent = Base
            ValueLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            ValueLabel.Position = UDim2.new(1, -70, 0, 8)
            ValueLabel.Size = UDim2.new(0, 60, 0, 24)
            ValueLabel.Font = Enum.Font.GothamBold
            ValueLabel.Text = tostring(default or min)
            ValueLabel.TextColor3 = PresetColor
            ValueLabel.TextSize = 16
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Center
            
            local ValueCorner = CreateCorner(6)
            ValueCorner.Parent = ValueLabel
            
            local SliderBack = Instance.new("Frame")
            local SliderFill = Instance.new("Frame")
            local SliderButton = Instance.new("ImageButton")
            local SliderCorner = CreateCorner(4)
            local SliderFillCorner = CreateCorner(4)
            local SliderGlow = Instance.new("ImageLabel")
            
            SliderBack.Parent = Base
            SliderBack.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            SliderBack.Position = UDim2.new(0.12, 0, 1, -22)
            SliderBack.Size = UDim2.new(0.8, -20, 0, 8)
            SliderCorner.Parent = SliderBack
            
            SliderFill.Parent = SliderBack
            SliderFill.BackgroundColor3 = PresetColor
            SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            SliderFillCorner.Parent = SliderFill
            
            SliderButton.Parent = SliderBack
            SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SliderButton.BackgroundTransparency = 1
            SliderButton.Size = UDim2.new(0, 24, 0, 24)
            SliderButton.Position = UDim2.new((default - min) / (max - min), -12, -8, 0)
            SliderButton.Image = "rbxassetid://117825834972403"
            SliderButton.ImageColor3 = PresetColor
            SliderButton.ZIndex = 5
            
            SliderGlow.Parent = SliderButton
            SliderGlow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SliderGlow.BackgroundTransparency = 1
            SliderGlow.Size = UDim2.new(1.5, 0, 1.5, 0)
            SliderGlow.Position = UDim2.new(-0.25, 0, -0.25, 0)
            SliderGlow.Image = "rbxassetid://5028857640"
            SliderGlow.ImageColor3 = PresetColor
            SliderGlow.ImageTransparency = 0.5
            SliderGlow.ZIndex = 4
            
            local ValueUpdater = Instance.new("Frame")
            ValueUpdater.Parent = Base
            ValueUpdater.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ValueUpdater.BackgroundTransparency = 1
            ValueUpdater.Size = UDim2.new(0.8, 0, 0, 0)
            ValueUpdater.Position = UDim2.new(0.12, 0, 1, -30)
            
            local dragging = false
            
            local function updateSlider(input)
                local posX = math.clamp((input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
                SliderButton.Position = UDim2.new(posX, -12, -8, 0)
                SliderFill.Size = UDim2.new(posX, 0, 1, 0)
                local value = math.floor(min + (posX * (max - min)))
                ValueLabel.Text = tostring(value)
                pcall(callback, value)
            end
            
            SliderButton.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    TweenService:Create(SliderButton, TweenInfo.new(0.2), {Size = UDim2.new(0, 28, 0, 28)}):Play()
                end
            end)
            
            SliderButton.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                    TweenService:Create(SliderButton, TweenInfo.new(0.2), {Size = UDim2.new(0, 24, 0, 24)}):Play()
                end
            end)
            
            ValueUpdater.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    updateSlider(input)
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
            local Base, Title, Icon, Divider = tabcontent:CreateBase("Dropdown", text, "rbxassetid://83881670383280", 50)
            
            local Arrow = Instance.new("ImageLabel")
            Arrow.Parent = Base
            Arrow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Arrow.BackgroundTransparency = 1
            Arrow.Position = UDim2.new(1, -40, 0.5, -12)
            Arrow.Size = UDim2.new(0, 24, 0, 24)
            Arrow.Image = "rbxassetid://81081164158885"
            Arrow.ImageColor3 = Color3.fromRGB(150, 150, 150)
            
            local Selection = Instance.new("TextLabel")
            Selection.Parent = Base
            Selection.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            Selection.Position = UDim2.new(0.5, 20, 0.5, -15)
            Selection.Size = UDim2.new(0.4, -20, 0, 30)
            Selection.Font = Enum.Font.Gotham
            Selection.Text = "Select..."
            Selection.TextColor3 = Color3.fromRGB(150, 150, 150)
            Selection.TextSize = 14
            Selection.TextXAlignment = Enum.TextXAlignment.Center
            
            local SelectionCorner = CreateCorner(6)
            SelectionCorner.Parent = Selection
            
            local DropdownContainer = Instance.new("Frame")
            local DropdownList = Instance.new("UIListLayout")
            
            DropdownContainer.Parent = Base
            DropdownContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            DropdownContainer.BorderSizePixel = 0
            DropdownContainer.Position = UDim2.new(0.5, 20, 1, 5)
            DropdownContainer.Size = UDim2.new(0.4, -20, 0, 0)
            DropdownContainer.ClipsDescendants = true
            DropdownContainer.Visible = false
            DropdownContainer.ZIndex = 10
            
            local ContainerCorner = CreateCorner(8)
            ContainerCorner.Parent = DropdownContainer
            local ContainerStroke = CreateStroke(Color3.fromRGB(60, 60, 60), 1, 0.5)
            ContainerStroke.Parent = DropdownContainer
            
            DropdownList.Parent = DropdownContainer
            DropdownList.SortOrder = Enum.SortOrder.LayoutOrder
            DropdownList.Padding = UDim.new(0, 2)
            DropdownList.HorizontalAlignment = Enum.HorizontalAlignment.Center
            
            local open = false
            local containerHeight = 0
            
            for _, option in ipairs(options) do
                local OptionBtn = Instance.new("TextButton")
                local OptionCorner = CreateCorner(6)
                
                OptionBtn.Parent = DropdownContainer
                OptionBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                OptionBtn.Size = UDim2.new(0.9, 0, 0, 35)
                OptionBtn.AutoButtonColor = false
                OptionBtn.Font = Enum.Font.Gotham
                OptionBtn.Text = "   " .. option
                OptionBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
                OptionBtn.TextSize = 14
                OptionBtn.TextXAlignment = Enum.TextXAlignment.Left
                OptionBtn.ZIndex = 11
                OptionCorner.Parent = OptionBtn
                
                local OptionStroke = CreateStroke(Color3.fromRGB(60, 60, 60), 1, 0.5)
                OptionStroke.Parent = OptionBtn
                
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
                    
                    TweenService:Create(Base, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 50)}):Play()
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
                        TweenService:Create(Base, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 50 + containerHeight)}):Play()
                        TweenService:Create(Arrow, TweenInfo.new(0.3), {Rotation = 180}):Play()
                        DropdownContainer.Size = UDim2.new(0.4, -20, 0, containerHeight)
                        DropdownContainer.Visible = true
                    else
                        TweenService:Create(Base, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(1, 0, 0, 50)}):Play()
                        TweenService:Create(Arrow, TweenInfo.new(0.3), {Rotation = 0}):Play()
                        DropdownContainer.Size = UDim2.new(0.4, -20, 0, 0)
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
            local Base, Title, Icon = tabcontent:CreateBase("MultiDropdown", text, "rbxassetid://107643418926671", 50)
            
            local Arrow = Instance.new("ImageLabel")
            Arrow.Parent = Base
            Arrow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Arrow.BackgroundTransparency = 1
            Arrow.Position = UDim2.new(1, -40, 0.5, -12)
            Arrow.Size = UDim2.new(0, 24, 0, 24)
            Arrow.Image = "rbxassetid://81081164158885"
            Arrow.ImageColor3 = Color3.fromRGB(150, 150, 150)
            
            local Selection = Instance.new("TextLabel")
            Selection.Parent = Base
            Selection.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            Selection.Position = UDim2.new(0.5, 20, 0.5, -15)
            Selection.Size = UDim2.new(0.4, -20, 0, 30)
            Selection.Font = Enum.Font.Gotham
            Selection.Text = "0 selected"
            Selection.TextColor3 = Color3.fromRGB(150, 150, 150)
            Selection.TextSize = 14
            Selection.TextXAlignment = Enum.TextXAlignment.Center
            
            local SelectionCorner = CreateCorner(6)
            SelectionCorner.Parent = Selection
            
            local DropdownContainer = Instance.new("Frame")
            local DropdownList = Instance.new("UIListLayout")
            local selected = {}
            
            DropdownContainer.Parent = Base
            DropdownContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            DropdownContainer.BorderSizePixel = 0
            DropdownContainer.Position = UDim2.new(0.5, 20, 1, 5)
            DropdownContainer.Size = UDim2.new(0.4, -20, 0, 0)
            DropdownContainer.ClipsDescendants = true
            DropdownContainer.Visible = false
            DropdownContainer.ZIndex = 10
            
            local ContainerCorner = CreateCorner(8)
            ContainerCorner.Parent = DropdownContainer
            local ContainerStroke = CreateStroke(Color3.fromRGB(60, 60, 60), 1, 0.5)
            ContainerStroke.Parent = DropdownContainer
            
            DropdownList.Parent = DropdownContainer
            DropdownList.SortOrder = Enum.SortOrder.LayoutOrder
            DropdownList.Padding = UDim.new(0, 2)
            DropdownList.HorizontalAlignment = Enum.HorizontalAlignment.Center
            
            local open = false
            local containerHeight = 0
            
            for _, option in ipairs(options) do
                local OptionBtn = Instance.new("TextButton")
                local OptionCorner = CreateCorner(6)
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
                OptionBtn.ZIndex = 11
                OptionCorner.Parent = OptionBtn
                
                local OptionStroke = CreateStroke(Color3.fromRGB(60, 60, 60), 1, 0.5)
                OptionStroke.Parent = OptionBtn
                
                CheckIcon.Parent = OptionBtn
                CheckIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                CheckIcon.BackgroundTransparency = 1
                CheckIcon.Size = UDim2.new(0, 20, 0, 20)
                CheckIcon.Position = UDim2.new(1, -30, 0.5, -10)
                CheckIcon.Image = "rbxassetid://93898873302694"
                CheckIcon.ImageColor3 = Color3.fromRGB(100, 100, 100)
                CheckIcon.Visible = false
                CheckIcon.ZIndex = 12
                
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
                        TweenService:Create(Base, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 50 + containerHeight)}):Play()
                        TweenService:Create(Arrow, TweenInfo.new(0.3), {Rotation = 180}):Play()
                        DropdownContainer.Size = UDim2.new(0.4, -20, 0, containerHeight)
                        DropdownContainer.Visible = true
                    else
                        TweenService:Create(Base, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(1, 0, 0, 50)}):Play()
                        TweenService:Create(Arrow, TweenInfo.new(0.3), {Rotation = 0}):Play()
                        DropdownContainer.Size = UDim2.new(0.4, -20, 0, 0)
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
            local Base, Title, Icon = tabcontent:CreateBase("Colorpicker", text, "rbxassetid://135684703553372", 50)
            
            local ColorBox = Instance.new("Frame")
            local ColorCorner = CreateCorner(6)
            local ColorGlow = Instance.new("ImageLabel")
            
            ColorBox.Parent = Base
            ColorBox.BackgroundColor3 = default or PresetColor
            ColorBox.Position = UDim2.new(1, -50, 0.5, -15)
            ColorBox.Size = UDim2.new(0, 40, 0, 30)
            ColorCorner.Parent = ColorBox
            
            ColorGlow.Parent = ColorBox
            ColorGlow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ColorGlow.BackgroundTransparency = 1
            ColorGlow.Size = UDim2.new(1.2, 0, 1.2, 0)
            ColorGlow.Position = UDim2.new(-0.1, 0, -0.1, 0)
            ColorGlow.Image = "rbxassetid://5028857640"
            ColorGlow.ImageColor3 = ColorBox.BackgroundColor3
            ColorGlow.ImageTransparency = 0.5
            ColorGlow.ZIndex = 4
            
            local PickerContainer = Instance.new("Frame")
            local PickerCorner = CreateCorner(8)
            local PickerStroke = CreateStroke(Color3.fromRGB(60, 60, 60), 1, 0.5)
            
            PickerContainer.Parent = Base
            PickerContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            PickerContainer.BorderSizePixel = 0
            PickerContainer.Position = UDim2.new(1, -220, 1, 5)
            PickerContainer.Size = UDim2.new(0, 200, 0, 200)
            PickerContainer.Visible = false
            PickerContainer.ZIndex = 10
            PickerCorner.Parent = PickerContainer
            PickerStroke.Parent = PickerContainer
            
            local ColorPicker = Instance.new("ImageLabel")
            ColorPicker.Parent = PickerContainer
            ColorPicker.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ColorPicker.Position = UDim2.new(0.05, 0, 0.1, 0)
            ColorPicker.Size = UDim2.new(0, 140, 0, 140)
            ColorPicker.Image = "rbxassetid://4155801252"
            ColorPicker.ZIndex = 11
            
            local HuePicker = Instance.new("ImageLabel")
            HuePicker.Parent = PickerContainer
            HuePicker.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            HuePicker.Position = UDim2.new(0.8, 0, 0.1, 0)
            HuePicker.Size = UDim2.new(0, 30, 0, 140)
            HuePicker.Image = "rbxassetid://108217585014571"
            HuePicker.ZIndex = 11
            
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
            
            local ColorSelector = Instance.new("ImageLabel")
            ColorSelector.Parent = ColorPicker
            ColorSelector.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ColorSelector.BackgroundTransparency = 1
            ColorSelector.Size = UDim2.new(0, 18, 0, 18)
            ColorSelector.Position = UDim2.new(1, -9, 0, -9)
            ColorSelector.Image = "rbxassetid://17345436140"
            ColorSelector.ZIndex = 12
            
            local HueSelector = Instance.new("ImageLabel")
            HueSelector.Parent = HuePicker
            HueSelector.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            HueSelector.BackgroundTransparency = 1
            HueSelector.Size = UDim2.new(0, 18, 0, 18)
            HueSelector.Position = UDim2.new(0.5, -9, 0, 0)
            HueSelector.Image = "rbxassetid://108217585014571"
            HueSelector.ZIndex = 12
            
            local ConfirmBtn = Instance.new("TextButton")
            ConfirmBtn.Parent = PickerContainer
            ConfirmBtn.BackgroundColor3 = PresetColor
            ConfirmBtn.Position = UDim2.new(0.05, 0, 0.85, 0)
            ConfirmBtn.Size = UDim2.new(0.4, -5, 0, 25)
            ConfirmBtn.Font = Enum.Font.GothamBold
            ConfirmBtn.Text = "OK"
            ConfirmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            ConfirmBtn.TextSize = 14
            ConfirmBtn.ZIndex = 11
            
            local ConfirmCorner = CreateCorner(6)
            ConfirmCorner.Parent = ConfirmBtn
            
            local CancelBtn = Instance.new("TextButton")
            CancelBtn.Parent = PickerContainer
            CancelBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            CancelBtn.Position = UDim2.new(0.55, 5, 0.85, 0)
            CancelBtn.Size = UDim2.new(0.4, -5, 0, 25)
            CancelBtn.Font = Enum.Font.Gotham
            CancelBtn.Text = "Cancel"
            CancelBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            CancelBtn.TextSize = 14
            CancelBtn.ZIndex = 11
            
            local CancelCorner = CreateCorner(6)
            CancelCorner.Parent = CancelBtn
            
            local open = false
            local h, s, v = default and Color3.toHSV(default) or 1, 1, 1
            
            local function updateColorFromPicker()
                ColorBox.BackgroundColor3 = Color3.fromHSV(h, s, v)
                ColorGlow.ImageColor3 = ColorBox.BackgroundColor3
                Icon.ImageColor3 = ColorBox.BackgroundColor3
                pcall(callback, ColorBox.BackgroundColor3)
            end
            
            ColorPicker.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local con
                    con = RunService.RenderStepped:Connect(function()
                        local pos = UDim2.new(
                            math.clamp((Mouse.X - ColorPicker.AbsolutePosition.X) / ColorPicker.AbsoluteSize.X, 0, 1),
                            0,
                            math.clamp((Mouse.Y - ColorPicker.AbsolutePosition.Y) / ColorPicker.AbsoluteSize.Y, 0, 1),
                            0
                        )
                        ColorSelector.Position = pos
                        s = pos.X.Scale
                        v = 1 - pos.Y.Scale
                        updateColorFromPicker()
                    end)
                    
                    local ended
                    ended = input.Changed:Connect(function()
                        if input.UserInputState == Enum.UserInputState.End then
                            con:Disconnect()
                            ended:Disconnect()
                        end
                    end)
                end
            end)
            
            HuePicker.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local con
                    con = RunService.RenderStepped:Connect(function()
                        local pos = UDim2.new(
                            0.48, 0,
                            math.clamp((Mouse.Y - HuePicker.AbsolutePosition.Y) / HuePicker.AbsoluteSize.Y, 0, 1),
                            0
                        )
                        HueSelector.Position = pos
                        h = 1 - pos.Y.Scale
                        updateColorFromPicker()
                    end)
                    
                    local ended
                    ended = input.Changed:Connect(function()
                        if input.UserInputState == Enum.UserInputState.End then
                            con:Disconnect()
                            ended:Disconnect()
                        end
                    end)
                end
            end)
            
            Base.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if not open then
                        TweenService:Create(Base, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 50)}):Play()
                        PickerContainer.Visible = true
                    else
                        PickerContainer.Visible = false
                        Base.Size = UDim2.new(1, 0, 0, 50)
                    end
                    open = not open
                    Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
                end
            end)
            
            ConfirmBtn.MouseButton1Click:Connect(function()
                PickerContainer.Visible = false
                Base.Size = UDim2.new(1, 0, 0, 50)
                open = false
                Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
            end)
            
            CancelBtn.MouseButton1Click:Connect(function()
                PickerContainer.Visible = false
                Base.Size = UDim2.new(1, 0, 0, 50)
                open = false
                Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
            end)
            
            Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
            return Base
        end
        
        function tabcontent:Label(text)
            local Base, Title, Icon, Divider = tabcontent:CreateBase("Label", text, "rbxassetid://116620312917084", 40)
            Title.TextColor3 = Color3.fromRGB(150, 150, 150)
            Title.TextSize = 13
            Icon.ImageColor3 = Color3.fromRGB(150, 150, 150)
            Divider.Visible = true
            
            Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
            return Base
        end
        
        function tabcontent:Textbox(text, placeholder, callback)
            local Base, Title, Icon = tabcontent:CreateBase("Textbox", text, "rbxassetid://122180020814574", 50)
            
            local TextBox = Instance.new("TextBox")
            local BoxCorner = CreateCorner(6)
            local BoxStroke = CreateStroke(Color3.fromRGB(60, 60, 60), 1, 0.5)
            
            TextBox.Parent = Base
            TextBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            TextBox.Position = UDim2.new(0.5, 20, 0.5, -15)
            TextBox.Size = UDim2.new(0.4, -20, 0, 30)
            TextBox.Font = Enum.Font.Gotham
            TextBox.PlaceholderText = placeholder
            TextBox.Text = ""
            TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextBox.TextSize = 14
            TextBox.ClearTextOnFocus = false
            BoxCorner.Parent = TextBox
            BoxStroke.Parent = TextBox
            
            local ClearBtn = Instance.new("ImageButton")
            ClearBtn.Parent = TextBox
            ClearBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ClearBtn.BackgroundTransparency = 1
            ClearBtn.Size = UDim2.new(0, 16, 0, 16)
            ClearBtn.Position = UDim2.new(1, -25, 0.5, -8)
            ClearBtn.Image = "rbxassetid://110786993356448"
            ClearBtn.ImageColor3 = Color3.fromRGB(150, 150, 150)
            ClearBtn.Visible = false
            
            TextBox.Changed:Connect(function(prop)
                if prop == "Text" then
                    ClearBtn.Visible = #TextBox.Text > 0
                end
            end)
            
            ClearBtn.MouseButton1Click:Connect(function()
                TextBox.Text = ""
            end)
            
            TextBox.FocusLost:Connect(function(ep)
                if ep then
                    pcall(callback, TextBox.Text)
                end
            end)
            
            Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
            return Base
        end
        
        function tabcontent:Bind(text, default, callback)
            local Base, Title, Icon = tabcontent:CreateBase("Bind", text, "rbxassetid://78408734580845", 50)
            
            local BindLabel = Instance.new("TextLabel")
            BindLabel.Parent = Base
            BindLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            BindLabel.Position = UDim2.new(0.5, 20, 0.5, -15)
            BindLabel.Size = UDim2.new(0.4, -20, 0, 30)
            BindLabel.Font = Enum.Font.GothamBold
            BindLabel.Text = default.Name
            BindLabel.TextColor3 = PresetColor
            BindLabel.TextSize = 14
            BindLabel.TextXAlignment = Enum.TextXAlignment.Center
            
            local BindCorner = CreateCorner(6)
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
            local Base, Title, Icon = tabcontent:CreateBase("Progress", text, "rbxassetid://89496630185293", 70)
            
            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Parent = Base
            ValueLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            ValueLabel.Position = UDim2.new(1, -70, 0, 8)
            ValueLabel.Size = UDim2.new(0, 60, 0, 24)
            ValueLabel.Font = Enum.Font.GothamBold
            ValueLabel.Text = tostring(default or 0) .. "%"
            ValueLabel.TextColor3 = PresetColor
            ValueLabel.TextSize = 16
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Center
            
            local ValueCorner = CreateCorner(6)
            ValueCorner.Parent = ValueLabel
            
            local ProgressBack = Instance.new("Frame")
            local ProgressFill = Instance.new("Frame")
            local ProgressCorner = CreateCorner(4)
            local FillCorner = CreateCorner(4)
            
            ProgressBack.Parent = Base
            ProgressBack.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            ProgressBack.Position = UDim2.new(0.12, 0, 1, -22)
            ProgressBack.Size = UDim2.new(0.8, -20, 0, 8)
            ProgressCorner.Parent = ProgressBack
            
            ProgressFill.Parent = ProgressBack
            ProgressFill.BackgroundColor3 = PresetColor
            ProgressFill.Size = UDim2.new((default or 0) / 100, 0, 1, 0)
            FillCorner.Parent = ProgressFill
            
            local Glow = Instance.new("ImageLabel")
            Glow.Parent = ProgressFill
            Glow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Glow.BackgroundTransparency = 1
            Glow.Size = UDim2.new(1.5, 0, 1.5, 0)
            Glow.Position = UDim2.new(-0.25, 0, -0.25, 0)
            Glow.Image = "rbxassetid://5028857640"
            Glow.ImageColor3 = PresetColor
            Glow.ImageTransparency = 0.5
            Glow.ZIndex = 4
            
            local function setValue(val)
                val = math.clamp(val, 0, 100)
                ProgressFill.Size = UDim2.new(val / 100, 0, 1, 0)
                ValueLabel.Text = tostring(math.floor(val)) .. "%"
                pcall(callback, val)
            end
            
            Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
            return Base, setValue
        end
        
        function tabcontent:Keybind(text, default, callback)
            return tabcontent:Bind(text, default, callback)
        end
        
        function tabcontent:Paragraph(title, content)
            local Base = Instance.new("Frame")
            local Corner = CreateCorner(8)
            local Stroke = CreateStroke(Color3.fromRGB(45, 45, 45), 1, 0.5)
            local Gradient = CreateGradient(Color3.fromRGB(35, 35, 35), Color3.fromRGB(25, 25, 25), 90)
            local TitleLabel = Instance.new("TextLabel")
            local ContentLabel = Instance.new("TextLabel")
            
            Base.Parent = Tab
            Base.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Base.Size = UDim2.new(1, 0, 0, 100)
            Base.BackgroundTransparency = 0
            Corner.Parent = Base
            Stroke.Parent = Base
            Gradient.Parent = Base
            
            TitleLabel.Parent = Base
            TitleLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TitleLabel.BackgroundTransparency = 1
            TitleLabel.Position = UDim2.new(0, 12, 0, 8)
            TitleLabel.Size = UDim2.new(1, -24, 0, 20)
            TitleLabel.Font = Enum.Font.GothamBold
            TitleLabel.Text = title
            TitleLabel.TextColor3 = PresetColor
            TitleLabel.TextSize = 16
            TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            ContentLabel.Parent = Base
            ContentLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ContentLabel.BackgroundTransparency = 1
            ContentLabel.Position = UDim2.new(0, 12, 0, 32)
            ContentLabel.Size = UDim2.new(1, -24, 0, 60)
            ContentLabel.Font = Enum.Font.Gotham
            ContentLabel.Text = content
            ContentLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            ContentLabel.TextSize = 14
            ContentLabel.TextWrapped = true
            ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
            ContentLabel.TextYAlignment = Enum.TextYAlignment.Top
            
            Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
            return Base
        end
        
        function tabcontent:Separator()
            local Base = Instance.new("Frame")
            Base.Parent = Tab
            Base.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            Base.Size = UDim2.new(1, 0, 0, 2)
            Base.BackgroundTransparency = 0
            
            Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
            return Base
        end
        
        function tabcontent:Line()
            return tabcontent:Separator()
        end
        
        function tabcontent:Space(height)
            local Base = Instance.new("Frame")
            Base.Parent = Tab
            Base.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Base.BackgroundTransparency = 1
            Base.Size = UDim2.new(1, 0, 0, height or 10)
            
            Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
            return Base
        end
        
        function tabcontent:Timer(text, default, callback)
            local Base, Title, Icon = tabcontent:CreateBase("Timer", text, "rbxassetid://85473888890506", 70)
            
            local TimeLabel = Instance.new("TextLabel")
            TimeLabel.Parent = Base
            TimeLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            TimeLabel.Position = UDim2.new(0.5, 20, 0.5, -15)
            TimeLabel.Size = UDim2.new(0.4, -20, 0, 30)
            TimeLabel.Font = Enum.Font.GothamBold
            TimeLabel.Text = tostring(default or 0) .. "s"
            TimeLabel.TextColor3 = PresetColor
            TimeLabel.TextSize = 16
            TimeLabel.TextXAlignment = Enum.TextXAlignment.Center
            
            local TimeCorner = CreateCorner(6)
            TimeCorner.Parent = TimeLabel
            
            local StartBtn = Instance.new("TextButton")
            StartBtn.Parent = Base
            StartBtn.BackgroundColor3 = PresetColor
            StartBtn.Position = UDim2.new(0.85, -35, 0.5, -12)
            StartBtn.Size = UDim2.new(0, 30, 0, 24)
            StartBtn.Font = Enum.Font.GothamBold
            StartBtn.Text = "▶"
            StartBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            StartBtn.TextSize = 14
            
            local StartCorner = CreateCorner(6)
            StartCorner.Parent = StartBtn
            
            local ResetBtn = Instance.new("TextButton")
            ResetBtn.Parent = Base
            ResetBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            ResetBtn.Position = UDim2.new(0.95, -30, 0.5, -12)
            ResetBtn.Size = UDim2.new(0, 24, 0, 24)
            ResetBtn.Font = Enum.Font.GothamBold
            ResetBtn.Text = "↺"
            ResetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            ResetBtn.TextSize = 14
            
            local ResetCorner = CreateCorner(6)
            ResetCorner.Parent = ResetBtn
            
            local running = false
            local time = default or 0
            local connection
            
            StartBtn.MouseButton1Click:Connect(function()
                running = not running
                StartBtn.Text = running and "⏸" or "▶"
                if running then
                    connection = RunService.Heartbeat:Connect(function(dt)
                        if running then
                            time = time + dt
                            TimeLabel.Text = string.format("%.1fs", time)
                            pcall(callback, time)
                        end
                    end)
                else
                    if connection then
                        connection:Disconnect()
                    end
                end
            end)
            
            ResetBtn.MouseButton1Click:Connect(function()
                running = false
                StartBtn.Text = "▶"
                time = 0
                TimeLabel.Text = "0.0s"
                pcall(callback, 0)
                if connection then
                    connection:Disconnect()
                end
            end)
            
            Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
            return Base
        end
        
        function tabcontent:DatePicker(text, callback)
            local Base, Title, Icon = tabcontent:CreateBase("DatePicker", text, "rbxassetid://126259032907535", 50)
            
            local DateLabel = Instance.new("TextLabel")
            DateLabel.Parent = Base
            DateLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            DateLabel.Position = UDim2.new(0.5, 20, 0.5, -15)
            DateLabel.Size = UDim2.new(0.4, -20, 0, 30)
            DateLabel.Font = Enum.Font.Gotham
            DateLabel.Text = os.date("%Y-%m-%d")
            DateLabel.TextColor3 = PresetColor
            DateLabel.TextSize = 14
            DateLabel.TextXAlignment = Enum.TextXAlignment.Center
            
            local DateCorner = CreateCorner(6)
            DateCorner.Parent = DateLabel
            
            Base.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    pcall(callback, os.date("%Y-%m-%d"))
                end
            end)
            
            Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
            return Base
        end
        
        function tabcontent:FilePicker(text, callback)
            local Base, Title, Icon = tabcontent:CreateBase("FilePicker", text, "rbxassetid://126116963775616", 50)
            
            local FileLabel = Instance.new("TextLabel")
            FileLabel.Parent = Base
            FileLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            FileLabel.Position = UDim2.new(0.5, 20, 0.5, -15)
            FileLabel.Size = UDim2.new(0.4, -20, 0, 30)
            FileLabel.Font = Enum.Font.Gotham
            FileLabel.Text = "Choose File..."
            FileLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
            FileLabel.TextSize = 14
            FileLabel.TextXAlignment = Enum.TextXAlignment.Center
            
            local FileCorner = CreateCorner(6)
            FileCorner.Parent = FileLabel
            
            Base.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    FileLabel.Text = "selected.txt"
                    FileLabel.TextColor3 = PresetColor
                    pcall(callback, "selected.txt")
                end
            end)
            
            Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
            return Base
        end
        
        function tabcontent:RadioButton(text, group, default, callback)
            local Base, Title, Icon = tabcontent:CreateBase("RadioButton", text, "rbxassetid://113157136350384", 45)
            
            local RadioFrame = Instance.new("Frame")
            local RadioInner = Instance.new("Frame")
            local RadioCorner = CreateCorner(15)
            local RadioInnerCorner = CreateCorner(10)
            
            RadioFrame.Parent = Base
            RadioFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            RadioFrame.Position = UDim2.new(1, -40, 0.5, -12)
            RadioFrame.Size = UDim2.new(0, 24, 0, 24)
            RadioCorner.Parent = RadioFrame
            
            RadioInner.Parent = RadioFrame
            RadioInner.BackgroundColor3 = PresetColor
            RadioInner.Position = UDim2.new(0.1, 0, 0.1, 0)
            RadioInner.Size = UDim2.new(0, 19, 0, 19)
            RadioInnerCorner.Parent = RadioInner
            RadioInner.Visible = default or false
            
            Base.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    RadioInner.Visible = true
                    Icon.ImageColor3 = PresetColor
                    pcall(callback, text)
                end
            end)
            
            Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
            return Base
        end
        
        function tabcontent:Checkbox(text, default, callback)
            return tabcontent:Toggle(text, default, callback)
        end
        
        function tabcontent:List(text, items, callback)
            local Base, Title, Icon = tabcontent:CreateBase("List", text, "rbxassetid://138463010991471", 50 + (#items * 35))
            
            local ListContainer = Instance.new("Frame")
            local ListLayout = Instance.new("UIListLayout")
            
            ListContainer.Parent = Base
            ListContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ListContainer.BackgroundTransparency = 1
            ListContainer.Position = UDim2.new(0, 44, 0, 25)
            ListContainer.Size = UDim2.new(1, -54, 0, #items * 35)
            
            ListLayout.Parent = ListContainer
            ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ListLayout.Padding = UDim.new(0, 2)
            
            for _, item in ipairs(items) do
                local ItemBtn = Instance.new("TextButton")
                local ItemCorner = CreateCorner(6)
                
                ItemBtn.Parent = ListContainer
                ItemBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                ItemBtn.Size = UDim2.new(1, 0, 0, 30)
                ItemBtn.Font = Enum.Font.Gotham
                ItemBtn.Text = "   " .. item
                ItemBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
                ItemBtn.TextSize = 14
                ItemBtn.TextXAlignment = Enum.TextXAlignment.Left
                ItemCorner.Parent = ItemBtn
                
                ItemBtn.MouseButton1Click:Connect(function()
                    pcall(callback, item)
                end)
            end
            
            Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
            return Base
        end
        
        function tabcontent:Table(data, callback)
            local Base = Instance.new("Frame")
            local Corner = CreateCorner(8)
            local Stroke = CreateStroke(Color3.fromRGB(45, 45, 45), 1, 0.5)
            local Gradient = CreateGradient(Color3.fromRGB(35, 35, 35), Color3.fromRGB(25, 25, 25), 90)
            
            Base.Parent = Tab
            Base.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Base.Size = UDim2.new(1, 0, 0, 150)
            Base.BackgroundTransparency = 0
            Corner.Parent = Base
            Stroke.Parent = Base
            Gradient.Parent = Base
            
            local TableLayout = Instance.new("UIListLayout")
            TableLayout.Parent = Base
            TableLayout.SortOrder = Enum.SortOrder.LayoutOrder
            TableLayout.Padding = UDim.new(0, 2)
            TableLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            
            for key, value in pairs(data) do
                local Row = Instance.new("Frame")
                local KeyLabel = Instance.new("TextLabel")
                local ValueLabel = Instance.new("TextLabel")
                
                Row.Parent = Base
                Row.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                Row.Size = UDim2.new(0.95, 0, 0, 25)
                
                KeyLabel.Parent = Row
                KeyLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                KeyLabel.BackgroundTransparency = 1
                KeyLabel.Position = UDim2.new(0, 5, 0, 0)
                KeyLabel.Size = UDim2.new(0.4, -5, 1, 0)
                KeyLabel.Font = Enum.Font.GothamBold
                KeyLabel.Text = tostring(key)
                KeyLabel.TextColor3 = PresetColor
                KeyLabel.TextSize = 14
                KeyLabel.TextXAlignment = Enum.TextXAlignment.Left
                
                ValueLabel.Parent = Row
                ValueLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ValueLabel.BackgroundTransparency = 1
                ValueLabel.Position = UDim2.new(0.4, 0, 0, 0)
                ValueLabel.Size = UDim2.new(0.6, -5, 1, 0)
                ValueLabel.Font = Enum.Font.Gotham
                ValueLabel.Text = tostring(value)
                ValueLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                ValueLabel.TextSize = 14
                ValueLabel.TextXAlignment = Enum.TextXAlignment.Left
            end
            
            Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
            return Base
        end
        
        return tabcontent
    end
    return tabhold
end
return lib