-- example script by https://github.com/mstudio45/LinoriaLib/blob/main/Example.lua and modified by deivid
-- You can suggest changes with a pull request or something

local REPO = "https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/"

local BACKGROUND_URL = "https://raw.githubusercontent.com/JanseJYC/Script/refs/heads/main/Django_Monochrome_Frontier.jpg"
local STARTUP_AUDIO_URL = "https://github.com/JanseJYC/Script/raw/refs/heads/main/Django_Startup.ogg"

local Library = loadstring(game:HttpGet(REPO .. "Library.lua"))()
local Options = Library.Options
local Toggles = Library.Toggles

-- Sequential Django loading title.
local function PlayDjangoIntro()
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local CoreGui = game:GetService("CoreGui")

    local Parent
    pcall(function()
        if gethui then
            Parent = gethui()
        end
    end)

    if not Parent then
        local Player = Players.LocalPlayer
        Parent = Player and Player:FindFirstChildOfClass("PlayerGui")
    end
    Parent = Parent or CoreGui

    local Previous = Parent:FindFirstChild("DjangoIntro")
    if Previous then
        Previous:Destroy()
    end

    local Screen = Instance.new("ScreenGui")
    Screen.Name = "DjangoIntro"
    Screen.IgnoreGuiInset = true
    Screen.ResetOnSpawn = false
    Screen.DisplayOrder = 999999
    Screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    Screen.Parent = Parent

    local Holder = Instance.new("Frame")
    Holder.Name = "Letters"
    Holder.BackgroundTransparency = 1
    Holder.AnchorPoint = Vector2.new(0.5, 0.5)
    Holder.Position = UDim2.fromScale(0.5, 0.48)
    Holder.Size = UDim2.fromOffset(420, 100)
    Holder.Parent = Screen

    local Letters = { "D", "J", "a", "n", "g", "o" }
    local LetterWidth = 60
    local Gap = 8
    local TotalWidth = #Letters * LetterWidth + (#Letters - 1) * Gap
    local StartX = (420 - TotalWidth) / 2

    for Index, Character in ipairs(Letters) do
        local Label = Instance.new("TextLabel")
        Label.Name = "Letter" .. Index
        Label.BackgroundTransparency = 1
        Label.Size = UDim2.fromOffset(LetterWidth, 82)
        Label.Position = UDim2.fromOffset(StartX + (Index - 1) * (LetterWidth + Gap), 18)
        Label.Font = Enum.Font.Garamond
        Label.Text = Character
        Label.TextSize = 64
        Label.TextColor3 = Color3.fromRGB(238, 239, 242)
        Label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        Label.TextStrokeTransparency = 0.45
        Label.TextTransparency = 1
        Label.Parent = Holder

        local TargetPosition = Label.Position - UDim2.fromOffset(0, 18)
        task.delay((Index - 1) * 0.16, function()
            if not Label.Parent then
                return
            end

            TweenService:Create(
                Label,
                TweenInfo.new(0.42, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                {
                    Position = TargetPosition,
                    TextTransparency = 0,
                    TextStrokeTransparency = 0.45,
                }
            ):Play()
        end)
    end

    task.wait((#Letters - 1) * 0.16 + 0.95)
    if Screen.Parent then
        Screen:Destroy()
    end
end

task.spawn(PlayDjangoIntro)

-- SaveManager is optional.
local SaveManager
pcall(function()
    SaveManager = loadstring(game:HttpGet(REPO .. "addons/SaveManager.lua"))()
    SaveManager:SetLibrary(Library)
    SaveManager:SetFolder("DjangoFrontier")
end)

Library.ForceCheckbox = false
Library.ShowToggleFrameInKeybinds = true
Library.NotifyOnError = true

Library.Scheme.BackgroundColor = Color3.fromRGB(8, 8, 9)
Library.Scheme.MainColor = Color3.fromRGB(18, 18, 20)
Library.Scheme.AccentColor = Color3.fromRGB(145, 148, 153)
Library.Scheme.OutlineColor = Color3.fromRGB(48, 48, 52)
Library.Scheme.FontColor = Color3.fromRGB(224, 224, 226)
Library.Scheme.RedColor = Color3.fromRGB(155, 65, 65)
Library.Scheme.DestructiveColor = Color3.fromRGB(125, 42, 45)
Library.Scheme.DarkColor = Color3.fromRGB(3, 3, 4)
Library.Scheme.WhiteColor = Color3.fromRGB(248, 248, 250)

Library:SetFont(Enum.Font.Garamond)

local Window = Library:CreateWindow({
    Title = "DJANGO",
    Footer = "THE FRONTIER DOSSIER  /  WESTERN TERRITORY",
    NotifySide = "Right",
    ShowCustomCursor = true,
    Font = Enum.Font.Garamond,

    Size = UDim2.fromOffset(920, 610),
    Center = true,
    AutoShow = true,
    Resizable = true,
    CornerRadius = 10,

    SearchbarSize = UDim2.fromScale(1, 1),
    GlobalSearch = false,

    EnableSidebarResize = true,
    EnableCompacting = true,
    MinSidebarWidth = 150,
    MinContainerWidth = 340,
    SidebarCompactWidth = 52,
    SidebarCollapseThreshold = 0.55,
    CompactWidthActivation = 124,

    Animations = {
        ToggleWindow = false,
        TabSwitch = false,
        Groupbox = false,
        Dropdown = false,
        KeyPicker = false,
    },
    TabTransitionTime = 0,
    TabSwipeOffset = 0,
    TabSwipeFrom = "right",
})

Window:SetSidebarWidth(150)

if BACKGROUND_URL ~= "" then
    local BackgroundOK, BackgroundError = pcall(function()
        Window:SetBackgroundImage(BACKGROUND_URL)
    end)
    if not BackgroundOK then
        warn("[Django UI] Background image failed:", BackgroundError)
    end
else
    warn("[Django UI] Set BACKGROUND_URL to the hosted direct image URL to enable the prairie backdrop.")
end

local Watermark = Library:AddDraggableLabel("DJango | -- FPS | -- Ping")
Watermark:SetVisible(true)

local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local FrameCount = 0
local LastUpdate = os.clock()
local CurrentFPS = 0

local WatermarkConnection = RunService.RenderStepped:Connect(function()
    FrameCount += 1
    local Now = os.clock()

    if Now - LastUpdate >= 1 then
        CurrentFPS = math.floor(FrameCount / (Now - LastUpdate))
        FrameCount = 0
        LastUpdate = Now

        local Ping = 0
        pcall(function()
            Ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        end)

        Watermark:SetText(string.format("DJango | %d FPS | %d Ping", CurrentFPS, Ping))
    end
end)

-- Load the OGG Vorbis startup voice clip and wait until Roblox reports a valid duration.
local function PlayStartupAudio()
    if not (writefile and getcustomasset and isfile and isfolder and makefolder) then
        warn("[Django UI] Executor does not support local custom audio assets.")
        return
    end

    local Folder = "DjangoFrontier"
    local AudioFile = Folder .. "/Django_Startup.ogg"

    local Success, ErrorMessage = pcall(function()
        if not isfolder(Folder) then
            makefolder(Folder)
        end

        local AudioData = game:HttpGet(STARTUP_AUDIO_URL)
        assert(string.sub(AudioData, 1, 4) == "OggS", "Downloaded audio is not a valid OGG file")
        assert(#AudioData > 12000, "Downloaded audio is incomplete")

        writefile(AudioFile, AudioData)

        local SoundService = game:GetService("SoundService")
        local PreviousSound = SoundService:FindFirstChild("DjangoStartupAudio")
        if PreviousSound then
            PreviousSound:Destroy()
        end

        local Sound = Instance.new("Sound")
        Sound.Name = "DjangoStartupAudio"
        Sound.SoundId = getcustomasset(AudioFile)
        Sound.Volume = 0.85
        Sound.Looped = false
        Sound.Parent = SoundService

        local Loaded = false
        local LoadConnection = Sound.Loaded:Connect(function()
            Loaded = true
        end)

        local StartedAt = os.clock()
        while not Sound.IsLoaded and not Loaded and os.clock() - StartedAt < 12 do
            task.wait(0.1)
        end
        LoadConnection:Disconnect()

        assert((Sound.IsLoaded or Loaded) and Sound.TimeLength > 0, "Roblox did not decode the startup audio")
        Sound:Play()
        Sound.Ended:Wait()
        Sound:Destroy()
    end)

    if not Success then
        warn("[Django UI] Startup audio failed:", ErrorMessage)
        local SoundService = game:GetService("SoundService")
        local Sound = SoundService:FindFirstChild("DjangoStartupAudio")
        if Sound then
            Sound:Destroy()
        end
    end
end

task.spawn(PlayStartupAudio)

local function Notify(Title, Description)
    Library:Notify({
        Title = Title,
        Description = Description,
        Time = 3,
    })
end

local PageGap = 18
local NativeSetSidebarWidth = Window.SetSidebarWidth

local function ApplyPageGap()
    local ContentFrame = Library.WindowContainer
    if not ContentFrame or not ContentFrame.Parent then
        return
    end

    local SidebarWidth = Window:GetSidebarWidth()
    local WindowWidth = ContentFrame.Parent.AbsoluteSize.X
    local MinContentWidth = 340
    local MaxUsableGap = math.max(0, WindowWidth - SidebarWidth - MinContentWidth - 1)
    local EffectiveGap = math.clamp(PageGap, 0, math.min(72, MaxUsableGap))

    ContentFrame.Size = UDim2.new(
        1,
        -SidebarWidth - 1 - EffectiveGap,
        1,
        -70
    )
end

function Window:SetSidebarWidth(Width)
    NativeSetSidebarWidth(self, Width)
    task.defer(ApplyPageGap)
end

local Tabs = {
    Dossier = Window:AddTab("Dossier", "scroll", "The Django file / overview"),
    Bounties = Window:AddTab("Bounty Board", "target", "Frontier notices and contracts"),
    FieldKit = Window:AddTab("Field Kit", "backpack", "Equipment and field preferences"),
    Preferences = Window:AddTab("Preferences", "settings", "Personalize the interface"),
}

local DossierLeft = Tabs.Dossier:AddGroupbox({
    Side = "Left",
    Name = "The Frontier File",
    Description = "CLASSIFIED RECORD  /  WESTERN TERRITORY",
    IconName = "scroll",
})

DossierLeft:AddLabel({
    Text = '<font color="#BFC2C7">DJANGO</font>\n<font color="#E5E5E7">THE MAN IN THE BLUE COAT</font>',
    DoesWrap = true,
    Size = 20,
})
DossierLeft:AddDivider()
DossierLeft:AddLabel(
    "A name carried across the frontier. A quiet stare, a steady hand, and a story still being written.",
    true
)
DossierLeft:AddDivider()
DossierLeft:AddLabel('FIELD STATUS     <font color="#BFC2C7">ACTIVE</font>')
DossierLeft:AddLabel("TERRITORY       THE FRONTIER")
DossierLeft:AddLabel("DOSSIER CLASS   RESTRICTED")

local DossierRight = Tabs.Dossier:AddGroupbox({
    Side = "Right",
    Name = "Field Notes",
    Description = "A WESTERN PROFILE",
    IconName = "notebook-text",
})
DossierRight:AddLabel("THE CODE", false)
DossierRight:AddLabel(
    "Keep your eyes open. Keep your powder dry. Let the work speak for itself.",
    true
)
DossierRight:AddDivider()
DossierRight:AddLabel("VISUAL IDENTITY", false)
DossierRight:AddLabel("Obsidian black  /  charcoal  /  silver  /  cool white", true)
DossierRight:AddButton({
    Text = "Review the dossier",
    Tooltip = "Sample UI action; connect this to your own feature.",
    Func = function()
        Notify("Dossier reviewed", "The Django file is marked as reviewed.")
    end,
})

local BountyLeft = Tabs.Bounties:AddGroupbox({
    Side = "Left",
    Name = "Frontier Notices",
    Description = "CONTRACTS AND FIELD REPORTS",
    IconName = "scroll-text",
})
BountyLeft:AddLabel('<font color="#BFC2C7">WANTED / FRONTIER DOSSIER</font>', true)
BountyLeft:AddDivider()
BountyLeft:AddLabel("SUBJECT       Django")
BountyLeft:AddLabel("STATUS        Open record")
BountyLeft:AddLabel("CLASS         Frontier notice")
BountyLeft:AddLabel("REWARD        Set by your own game logic")
BountyLeft:AddButton({
    Text = "Mark notice as read",
    Tooltip = "Example callback only.",
    Func = function()
        Notify("Notice logged", "The notice has been marked as read.")
    end,
})

local BountyRight = Tabs.Bounties:AddGroupbox({
    Side = "Right",
    Name = "Contract Filters",
    Description = "DISPLAY OPTIONS",
    IconName = "filter",
})
-- Read the selected value with Options.ContractRegion.Value; update it with Options.ContractRegion:SetValue("Dustland").
BountyRight:AddDropdown("ContractRegion", {
    Text = "Territory",
    Values = { "All territories", "Dustland", "Southern rail", "Canyon pass" },
    Default = 1,
    Tooltip = "Display filter example; connect it to your contract data.",
    Callback = function(Value)
        Notify("Territory filter", "Selected: " .. tostring(Value))
    end,
})
-- Read the state with Toggles.ShowOpenNotices.Value; change it with Toggles.ShowOpenNotices:SetValue(false).
BountyRight:AddToggle("ShowOpenNotices", {
    Text = "Show open notices only",
    Default = true,
    Tooltip = "Display toggle example; connect it to your notice list.",
    Callback = function(Value)
        print("[Django UI] Show open notices only:", Value)
    end,
})
BountyRight:AddToggle("HighlightPriority", {
    Text = "Highlight priority entries",
    Default = true,
    Callback = function(Value)
        print("[Django UI] Highlight priority entries:", Value)
    end,
})

local KitLeft = Tabs.FieldKit:AddGroupbox({
    Side = "Left",
    Name = "Field Equipment",
    Description = "PRESENTATION CONTROLS",
    IconName = "briefcase-business",
})
KitLeft:AddLabel("Tune the interface to match the monochrome night-frontier atmosphere.", true)
KitLeft:AddToggle("CompactSidebar", {
    Text = "Compact the page sidebar",
    Default = false,
    Tooltip = "Collapse the left navigation into icon-only mode.",
    Callback = function(Value)
        Window:SetCompact(Value)
        task.defer(ApplyPageGap)
    end,
})

local KitRight = Tabs.FieldKit:AddGroupbox({
    Side = "Right",
    Name = "Interface Notes",
    Description = "DESIGN LANGUAGE",
    IconName = "palette",
})
KitRight:AddLabel("PALETTE", false)
KitRight:AddLabel("Obsidian black / charcoal / silver / cool white", true)
KitRight:AddDivider()
KitRight:AddLabel("TYPE", false)
KitRight:AddLabel("Garamond-inspired western editorial styling", true)
KitRight:AddDivider()
KitRight:AddLabel("MOTION", false)
KitRight:AddLabel("Instant page changes; no fade or slide transitions.", true)
KitRight:AddDivider()
KitRight:AddLabel("BACKDROP", false)
KitRight:AddLabel("Moonlit monochrome frontier, fog, mesas and a distant settlement.", true)

local LayoutGroup = Tabs.Preferences:AddGroupbox({
    Side = "Left",
    Name = "Layout Tuning",
    Description = "ADJUST NAVIGATION AND CONTENT SPACING",
    IconName = "sliders-horizontal",
})

-- Read the gap with Options.PageGap.Value; set it with Options.PageGap:SetValue(24).
LayoutGroup:AddSlider("PageGap", {
    Text = "Page area distance",
    Tooltip = "Distance between the left page navigation and the main page area.",
    Default = PageGap,
    Min = 0,
    Max = 72,
    Rounding = 0,
    Suffix = " px",
    Callback = function(Value)
        PageGap = Value
        ApplyPageGap()
    end,
})

-- Read the navigation width with Options.SidebarWidth.Value; set it with Options.SidebarWidth:SetValue(160).
LayoutGroup:AddSlider("SidebarWidth", {
    Text = "Sidebar width",
    Tooltip = "Adjust the width of the left page navigation.",
    Default = Window:GetSidebarWidth(),
    Min = 150,
    Max = 320,
    Rounding = 0,
    Suffix = " px",
    Callback = function(Value)
        Window:SetSidebarWidth(Value)
    end,
})

local GeneralGroup = Tabs.Preferences:AddGroupbox({
    Side = "Right",
    Name = "General",
    Description = "PERSONAL SETTINGS",
    IconName = "settings-2",
})
-- Read the selection through Options.NotificationSide.Value; changes apply immediately.
GeneralGroup:AddDropdown("NotificationSide", {
    Text = "Notification position",
    Values = { "Left", "Right" },
    Default = "Right",
    Callback = function(Value)
        Library:SetNotifySide(Value)
    end,
})
GeneralGroup:AddDropdown("UIScale", {
    Text = "Interface scale",
    Values = { "75%", "90%", "100%", "110%", "125%", "150%" },
    Default = "100%",
    Callback = function(Value)
        local Scale = tonumber(Value:gsub("%%", ""))
        if Scale then
            Library:SetDPIScale(Scale)
        end
    end,
})
-- Change the menu key here; the selected key is stored in Options.MenuKeybind.
GeneralGroup:AddLabel("MENU KEY")
    :AddKeyPicker("MenuKeybind", {
        Default = "RightShift",
        NoUI = true,
        Text = "Toggle Django UI",
    })
GeneralGroup:AddButton({
    Text = "Unload interface",
    Tooltip = "Close and remove the interface.",
    Risky = true,
    Func = function()
        Library:Unload()
    end,
})

-- RightShift is the default menu key; the key picker can change it.
Library.ToggleKeybind = Options.MenuKeybind

if SaveManager then
    pcall(function()
        SaveManager:BuildConfigSection(Tabs.Preferences)
        SaveManager:LoadAutoloadConfig()
    end)
end

Library:OnUnload(function()
    if WatermarkConnection then
        WatermarkConnection:Disconnect()
    end
    Watermark:SetVisible(false)
    print("[Django UI] Blue Frontier dossier closed.")
end)

task.defer(ApplyPageGap)

if Library.WindowContainer then
    Library.WindowContainer:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        ApplyPageGap()
    end)
end
