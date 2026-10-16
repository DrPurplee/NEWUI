-- TEL-AVIV UI — external library
-- FiveM/Sky-inspired keyboard UI for TEL-AVIV
-- Loaded remotely by the main menu to keep the main Luau chunk below the local-register limit.

-- ═══════════════════════════════════════════════════════════════
-- TEL-AVIV SKY STYLE UI — keyboard-first compatibility layer
-- Replaces the old remote UI library while preserving the menu callbacks.
-- ═══════════════════════════════════════════════════════════════
local Library = {}
Library.Version = "TEL-AVIV SKY UI V7 THEMES+MOUSE"
Library.Font = Font.fromEnum(Enum.Font.Gotham)
Library.Theme = {
    ["Background"] = Color3.fromRGB(8, 8, 10),
    ["Window"] = Color3.fromRGB(8, 8, 10),
    ["Inline"] = Color3.fromRGB(12, 12, 15),
    ["Panel"] = Color3.fromRGB(12, 12, 15),
    ["Accent"] = Color3.fromRGB(157, 45, 255),
    ["Tab"] = Color3.fromRGB(22, 22, 27),
    ["Dark Icon"] = Color3.fromRGB(120, 120, 130),
    ["Element"] = Color3.fromRGB(17, 17, 21),
    ["Liner"] = Color3.fromRGB(45, 45, 52),
    ["Outline"] = Color3.fromRGB(55, 55, 64),
    ["Dark Text"] = Color3.fromRGB(145, 145, 155),
    ["Text"] = Color3.fromRGB(245, 245, 248),
    ["Toggle"] = Color3.fromRGB(25, 25, 30),
    ["Hovered Element"] = Color3.fromRGB(27, 27, 33),
}


Library.BannerThemes = {
    ["Netanyahu"] = {
        Banner = "71553416281640",
        Accent = Color3.fromRGB(35, 108, 255),
        Accent2 = Color3.fromRGB(10, 61, 184),
    },

    ["Laurent Voulzy"] = {
    Banner = "132112594039411",
    Accent = Color3.fromRGB(255, 174, 72),
    Accent2 = Color3.fromRGB(224, 73, 92),
    },

    ["4CHAN"] = {
        Banner = "132366429521821",
        Accent = Color3.fromRGB(74, 163, 74),
        Accent2 = Color3.fromRGB(38, 101, 42),
    },

    ["Omerta Chinoise"] = {
        Banner = "137610941148819",
        Accent = Color3.fromRGB(220, 35, 35),
        Accent2 = Color3.fromRGB(140, 15, 15),
    },

    ["Orlax Le Barbar"] = {
    Banner = "133009653771654",
    Accent = Color3.fromRGB(170, 10, 15),
    Accent2 = Color3.fromRGB(85, 0, 5),
    },

    ["Femboy"] = {
        Banner = "127306439312431",
        Accent = Color3.fromRGB(255, 105, 180),
        Accent2 = Color3.fromRGB(255, 182, 193),
    },

    ["Meow"] = {
    Banner = "133319056177654",
    Accent = Color3.fromRGB(142, 255, 252),
    Accent2 = Color3.fromRGB(52, 199, 215),
    },

    ["Rabbits"] = {
    Banner = "78587601887193",
    Accent = Color3.fromRGB(170, 10, 15),
    Accent2 = Color3.fromRGB(85, 0, 5),
    },

    ["Totally Spies"] = {
    Banner = "73104258218019",
    Accent = Color3.fromRGB(157, 0, 181),
    Accent2 = Color3.fromRGB(255, 182, 193),
    },

    ["Mamadou Segpa"] = {
    Banner = "128642969518145",
    Accent = Color3.fromRGB(255, 105, 180),
    Accent2 = Color3.fromRGB(187, 0, 216),
    },

    ["Silver"] = {
    Banner = "129256246711574",
    Accent = Color3.fromRGB(192, 192, 192),
    Accent2 = Color3.fromRGB(105, 110, 120),
    },
}

local function getBannerTheme(name)
    return Library.BannerThemes[tostring(name or "")]
        or Library.BannerThemes["Netanyahu"]
end

local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer

local function uiParent()
    if typeof(gethui) == "function" then
        local ok, h = pcall(gethui)
        if ok and h then return h end
    end
    return game:GetService("CoreGui")
end

local function corner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = obj
    return c
end

local function stroke(obj, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or Color3.fromRGB(50,50,55)
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = obj
    return s
end

local function pad(obj, l, r, t, b)
    local p = Instance.new("UIPadding")
    p.PaddingLeft = UDim.new(0, l or 0)
    p.PaddingRight = UDim.new(0, r or 0)
    p.PaddingTop = UDim.new(0, t or 0)
    p.PaddingBottom = UDim.new(0, b or 0)
    p.Parent = obj
    return p
end

local function textLabel(parent, text, size, bold)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text = tostring(text or "")
    l.TextColor3 = Library.Theme.Text
    l.TextSize = size or 14
    l.Font = bold and Enum.Font.GothamBold or Enum.Font.GothamMedium
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.TextYAlignment = Enum.TextYAlignment.Center
    l.Parent = parent
    return l
end

local DESCRIPTION_HINTS = {
    ["god"] = "Makes you invincible.",
    ["god mode"] = "Makes you invincible.",
    ["fly"] = "Lets you fly. Use left/right to choose the fly method.",
    ["fly speed"] = "Changes your fly movement speed.",
    ["flymode"] = "Changes the animation used while flying.",
    ["noclip"] = "Lets you move through walls and solid objects.",
    ["walk speed"] = "Changes your character movement speed.",
    ["jump power"] = "Changes how high your character can jump.",
    ["infinite jump"] = "Lets you jump again while already in the air.",
    ["fov"] = "Changes the camera field of view.",
    ["esp"] = "Shows extra visual information about targets.",
    ["vehicle fly"] = "Lets you fly while controlling your vehicle.",
    ["auto exec"] = "Automatically runs TEL-AVIV after a teleport/server change.",
}

local function descriptionFor(options, kind)
    local explicit = options and (options.Description or options.Desc or options.Tooltip)
    if explicit and tostring(explicit) ~= "" then return tostring(explicit) end
    local name = tostring(options and (options.Name or options.name) or "Option")
    local low = string.lower(name)
    for k, v in pairs(DESCRIPTION_HINTS) do
        if string.find(low, k, 1, true) then return v end
    end
    if kind == "toggle" then return "Enable or disable " .. name .. "." end
    if kind == "slider" then return "Adjust " .. name .. " with the left/right arrows." end
    if kind == "dropdown" then return "Choose a value for " .. name .. " with the left/right arrows." end
    if kind == "button" then return "Run " .. name .. "." end
    if kind == "textbox" then return "Press Enter to edit " .. name .. "." end
    if kind == "keybind" then return "Press Enter, then press a key to bind " .. name .. "." end
    if kind == "color" then return "Adjust the color of " .. name .. " with the left/right arrows." end
    return name
end

local function safeCall(fn, ...)
    if type(fn) ~= "function" then return end
    local args = table.pack(...)
    task.spawn(function()
        pcall(function() fn(table.unpack(args, 1, args.n)) end)
    end)
end

local function parentGuiAlive(gui)
    return gui and gui.Parent ~= nil
end

Library._ActiveWindow = nil

local function destroyOld()
    local parent = uiParent()
    local old = parent:FindFirstChild("TELAVIV_SKY_UI")
    if old then pcall(function() old:Destroy() end) end
end

local function makeScreen()
    destroyOld()
    local gui = Instance.new("ScreenGui")
    gui.Name = "TELAVIV_SKY_UI"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 999900
    gui.Parent = uiParent()
    return gui
end

local function formatValue(v)
    if typeof(v) == "Color3" then
        return string.format("#%02X%02X%02X", math.floor(v.R*255+0.5), math.floor(v.G*255+0.5), math.floor(v.B*255+0.5))
    end
    if typeof(v) == "EnumItem" then return v.Name end
    if type(v) == "number" then
        if math.abs(v - math.floor(v)) < 0.0001 then return tostring(math.floor(v)) end
        return string.format("%.2f", v):gsub("0+$",""):gsub("%.$","")
    end
    return tostring(v)
end

local WindowMethods = {}
local CategoryMethods = {}
local TabMethods = {}
local SectionMethods = {}

local function refreshCanvas(tab)
    if not tab or not tab.Scroller then return end
    task.defer(function()
        if tab.Layout and tab.Scroller then
            tab.Scroller.CanvasSize = UDim2.new(0,0,0,tab.Layout.AbsoluteContentSize.Y + 18)
        end
    end)
end

local function setVisibleTab(window, tab)
    if not tab then return end
    window.CurrentTab = tab
    window.CurrentCategory = tab.Category
    for _, cat in ipairs(window.Categories) do
        for _, t in ipairs(cat.Tabs) do
            if t.Scroller then t.Scroller.Visible = (t == tab) end
            if t.TabButton then
                t.TabButton.TextColor3 = (t == tab) and window.Accent or Library.Theme["Dark Text"]
                if t.TabStroke then
                    t.TabStroke.Color = (t == tab) and window.Accent or Library.Theme.Outline
                    t.TabStroke.Transparency = (t == tab) and 0.05 or 0.62
                end
                t.TabButton.BackgroundTransparency = (t == tab) and 0.28 or 1
            end
        end
    end
    window:RefreshHeader()
    window:RebuildSelectable()
end

local function buildTabButtons(window)
    for _, c in ipairs(window.TabBar:GetChildren()) do
        c:Destroy()
    end
    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.Padding = UDim.new(0,3)
    layout.Parent = window.TabBar

    local cat = window.CurrentCategory
    if not cat then return end
    for _, tab in ipairs(cat.Tabs) do
        local b = Instance.new("TextButton")
        b.AutoButtonColor = false
        b.BackgroundColor3 = window.PanelColor
        b.BackgroundTransparency = 1
        b.BorderSizePixel = 0
        local count = math.max(1, #cat.Tabs)
        b.Size = UDim2.new(1/count, -4, 1, -8)
        b.Text = tab.Name
        b.TextSize = 12
        b.TextColor3 = Library.Theme["Dark Text"]
        b.Font = Enum.Font.GothamBold
        b.Parent = window.TabBar
        corner(b, 11)
        local st = stroke(b, Library.Theme.Outline, 1.4, 0.78)
        tab.TabButton = b
        tab.TabStroke = st
        b.MouseButton1Click:Connect(function() setVisibleTab(window, tab) end)
    end
end

function WindowMethods:RefreshHeader()
    local cat = self.CurrentCategory
    if cat then
        self.CategoryName.Text = cat.DisplayName or cat.Name
        local ci = table.find(self.Categories, cat) or 1
        self.CategoryCount.Text = tostring(ci) .. "/" .. tostring(#self.Categories)
        if self.FooterCount then self.FooterCount.Text = tostring(ci) .. "/" .. tostring(#self.Categories) end
    end
    buildTabButtons(self)
    local tab = self.CurrentTab
    if tab and tab.TabButton then
        tab.TabButton.TextColor3 = self.Accent
        tab.TabButton.BackgroundTransparency = 0.28
        if tab.TabStroke then
            tab.TabStroke.Color = self.Accent
            tab.TabStroke.Transparency = 0.05
        end
    end
end

function WindowMethods:RegisterAccent(obj, prop)
    table.insert(self.AccentObjects, {Object=obj, Property=prop or "BackgroundColor3"})
end

function WindowMethods:ApplyTheme(theme)
    if type(theme) ~= "table" then return end

    self.Accent = theme.Accent or self.Accent
    self.Accent2 = theme.Accent2 or self.Accent2
    Library.Theme.Accent = self.Accent

    if theme.Banner
        and tostring(theme.Banner) ~= ""
        and tostring(theme.Banner) ~= "0"
    then
        local raw = tostring(theme.Banner):gsub("rbxassetid://", "")
        self.BannerAsset = raw

        if self.Banner then
            self.Banner.Image = "rbxassetid://" .. raw
        end
    end

    for _, it in ipairs(self.AccentObjects) do
        local object = it.Object
        if object and object.Parent then
            pcall(function()
                object[it.Property] = self.Accent
            end)
        end
    end

    for _, category in ipairs(self.Categories or {}) do
        for _, tab in ipairs(category.Tabs or {}) do
            if tab.Scroller then
                tab.Scroller.ScrollBarImageColor3 = self.Accent
            end

            for _, control in ipairs(tab.Controls or {}) do
                if control.Render then
                    pcall(function()
                        control:Render()
                    end)
                end
            end
        end
    end

    self:RefreshHeader()
    self:RefreshSelection()
    self:RefreshCategoryChooser()
end

function WindowMethods:SaveInterface()
    if typeof(writefile) ~= "function" then return end
    pcall(function()
        if typeof(makefolder) == "function" and (typeof(isfolder) ~= "function" or not isfolder("TELAVIV")) then
            makefolder("TELAVIV")
        end
        local data = {
            Theme = self.ThemeName,
            Opacity = self.InterfaceOpacity,
            Notifications = self.NotificationsEnabled,
            MaxItems = self.MaxItems,
            Position = self.MenuPosition,
            CustomXScale = self.Main and self.Main.Position.X.Scale or nil,
            CustomXOffset = self.Main and self.Main.Position.X.Offset or nil,
            CustomYScale = self.Main and self.Main.Position.Y.Scale or nil,
            CustomYOffset = self.Main and self.Main.Position.Y.Offset or nil,
        }
        writefile("TELAVIV/interface.json", HttpService:JSONEncode(data))
    end)
end

function WindowMethods:LoadInterface()
    if typeof(readfile) ~= "function" then return end
    pcall(function()
        local raw = readfile("TELAVIV/interface.json")
        local data = HttpService:JSONDecode(raw)
        if type(data) ~= "table" then return end
        if data.Theme then
            self.ThemeName = tostring(data.Theme)
        end
        if tonumber(data.Opacity) then self.InterfaceOpacity = math.clamp(tonumber(data.Opacity),0,0.85) end
        if data.Notifications ~= nil then self.NotificationsEnabled = data.Notifications == true end
        if tonumber(data.MaxItems) then self.MaxItems = math.clamp(math.floor(tonumber(data.MaxItems)),4,16) end
        if data.Position then
            self.MenuPosition = tostring(data.Position)
        end

        if self.MenuPosition == "Custom"
            and tonumber(data.CustomXScale)
            and tonumber(data.CustomXOffset)
            and tonumber(data.CustomYScale)
            and tonumber(data.CustomYOffset)
        then
            self.CustomMenuPosition = UDim2.new(
                tonumber(data.CustomXScale),
                tonumber(data.CustomXOffset),
                tonumber(data.CustomYScale),
                tonumber(data.CustomYOffset)
            )
        end
    end)
end

function WindowMethods:ApplyMenuPosition(value)
    value = tostring(value or "Right")
    self.MenuPosition = value

    if not self.Main then return end

    if value == "Custom"
        and self.CustomMenuPosition
    then
        self.Main.AnchorPoint = Vector2.new(0, 0)
        self.Main.Position = self.CustomMenuPosition
    elseif value == "Left" then
        self.Main.AnchorPoint = Vector2.new(0, 0)
        self.Main.Position = UDim2.new(0.025, 0, 0.035, 0)
    elseif value == "Center" then
        self.Main.AnchorPoint = Vector2.new(0.5, 0)
        self.Main.Position = UDim2.new(0.5, 0, 0.035, 0)
    else
        self.MenuPosition = "Right"
        self.Main.AnchorPoint = Vector2.new(1, 0)
        self.Main.Position = UDim2.new(0.975, 0, 0.035, 0)
    end
end

function WindowMethods:SetOpen(value)
    self.Open = value == true
    _G.TA_SKY_MENU_OPEN = self.Open
    self.Main.Visible = self.Open
    if self.Shadow then self.Shadow.Visible = self.Open end

    if not self.Open then
        self.DescriptionBox.Visible = false
        self.CategoryChooser.Visible = false
        return
    end

    -- Preserve the current navigation level when reopening the menu.
    -- On first launch CategorySelectMode is true, so ONLY the root
    -- category list is shown (no Main/Status/Owner tabs behind it).
    if self.CategorySelectMode then
        self.CategoryChooser.Visible = true
        if self.TabBar then self.TabBar.Visible = false end
        if self.Content then self.Content.Visible = false end
        self.DescriptionBox.Visible = false
        self:RefreshCategoryChooser()
    else
        self.CategoryChooser.Visible = false
        if self.TabBar then self.TabBar.Visible = true end
        if self.Content then self.Content.Visible = true end
        self:RebuildSelectable()
    end
end

function WindowMethods:Toggle()
    self:SetOpen(not self.Open)
end

function WindowMethods:AddCategory(options)
    options = options or {}
    local name = tostring(options.Name or options.name or "Category")
    local display = name == "Config" and "Settings" or name
    local cat = setmetatable({
        Window = self,
        Name = name,
        DisplayName = display,
        Tabs = {},
        Icon = options.Icon,
        Hidden = options.Hidden == true,
    }, {__index = CategoryMethods})

    -- Hidden/internal categories still work, but don't appear in the root menu.
    if not cat.Hidden then
        table.insert(self.Categories, cat)
        if not self.CurrentCategory or options.AutoSelect == true then
            self.CurrentCategory = cat
        end
    end

    return cat
end

function CategoryMethods:_CreateTab(name, internal)
    local w = self.Window
    local sc = Instance.new("ScrollingFrame")
    sc.Name = "Tab_" .. tostring(name)
    sc.BackgroundTransparency = 1
    sc.BorderSizePixel = 0
    sc.Size = UDim2.fromScale(1,1)
    sc.CanvasSize = UDim2.new(0,0,0,0)
    sc.ScrollBarThickness = 3
    sc.ScrollBarImageColor3 = w.Accent
    w:RegisterAccent(sc, "ScrollBarImageColor3")
    sc.Visible = false
    sc.Parent = w.Content
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0,8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = sc
    pad(sc, 9, 9, 8, 8)
    local tab = setmetatable({
        Window = w,
        Category = self,
        Name = tostring(name),
        Scroller = sc,
        Frame = sc,
        Layout = layout,
        Sections = {},
        Controls = {},
        Internal = internal == true,
    }, {__index = TabMethods})
    table.insert(self.Tabs, tab)
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() refreshCanvas(tab) end)
    return tab
end

function CategoryMethods:AddTab(name)
    local tab = self:_CreateTab(name, false)
    if self.Name == "Config" and not self._InterfaceCreated then
        self._InterfaceCreated = true
        local interfaceTab = self:_CreateTab("Interface", true)
        task.defer(function() self.Window:BuildInterfaceTab(interfaceTab) end)
    end
    if not self.Window.CurrentTab and self.Window.CurrentCategory == self then
        setVisibleTab(self.Window, tab)
    end
    return tab
end

function CategoryMethods:Select()
    local w = self.Window
    w.CurrentCategory = self
    local tab = self.Tabs[1]
    if tab then setVisibleTab(w, tab) else w:RefreshHeader() end
end

function TabMethods:Select()
    setVisibleTab(self.Window, self)
end

function TabMethods:AddSection(name, side, options)
    options = options or {}
    local frame = Instance.new("Frame")
    frame.Name = "Section_" .. tostring(name)
    frame.BackgroundColor3 = Color3.fromRGB(8,8,9)
    frame.BackgroundTransparency = 0.28
    frame.BorderSizePixel = 0
    frame.Size = UDim2.new(1, -2, 0, 0)
    frame.AutomaticSize = Enum.AutomaticSize.Y
    frame.Parent = self.Scroller
    corner(frame, 0)
    stroke(frame, Library.Theme.Outline, 0, 1)
    local title = textLabel(frame, tostring(name), 11, true)
    title.TextColor3 = self.Window.Accent
    title.TextSize = 10
    title.Size = UDim2.new(0,150,0,24)
    title.Position = UDim2.fromOffset(31,2)
    local star = textLabel(frame, "☆", 16, true)
    star.TextColor3 = self.Window.Accent
    star.Size = UDim2.fromOffset(22,24)
    star.Position = UDim2.fromOffset(8,2)
    star.TextXAlignment = Enum.TextXAlignment.Center
    self.Window:RegisterAccent(star, "TextColor3")
    local line = Instance.new("Frame")
    line.BorderSizePixel = 0
    line.BackgroundColor3 = self.Window.Accent
    line.BackgroundTransparency = 0.38
    line.Position = UDim2.fromOffset(170,14)
    line.Size = UDim2.new(1,-184,0,1)
    line.Parent = frame
    self.Window:RegisterAccent(title, "TextColor3")
    self.Window:RegisterAccent(line)
    local items = Instance.new("Frame")
    items.Name = "Items"
    items.BackgroundTransparency = 1
    items.Position = UDim2.fromOffset(0,30)
    items.Size = UDim2.new(1,0,0,0)
    items.AutomaticSize = Enum.AutomaticSize.Y
    items.Parent = frame
    pad(items, 7, 7, 2, 7)
    local lay = Instance.new("UIListLayout")
    lay.Padding = UDim.new(0,4)
    lay.SortOrder = Enum.SortOrder.LayoutOrder
    lay.Parent = items
    local sec = setmetatable({
        Window=self.Window, Tab=self, Name=tostring(name), Frame=frame, Scroller=items, Layout=lay,
        Controls={}, LastVisibleControl=nil,
    }, {__index=SectionMethods})
    table.insert(self.Sections, sec)
    lay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() refreshCanvas(self) end)
    return sec
end

local function createRow(section, options, kind, selectable)
    options = options or {}
    local w = section.Window
    local row = Instance.new("Frame")
    row.Name = "Item_" .. tostring(options.Name or kind)
    row.BackgroundColor3 = Color3.fromRGB(13,13,14)
    row.BackgroundTransparency = 0.48
    row.BorderSizePixel = 0
    row.Size = UDim2.new(1,0,0,41)
    row.Parent = section.Scroller
    corner(row, 11)
    local st = stroke(row, Library.Theme.Outline, 1.2, 1)
    local name = textLabel(row, options.Name or kind, 13, true)
    name.Size = UDim2.new(1,-170,1,0)
    name.Position = UDim2.fromOffset(14,0)
    local right = textLabel(row, "", 12, false)
    right.Size = UDim2.fromOffset(150,41)
    right.Position = UDim2.new(1,-155,0,0)
    right.TextXAlignment = Enum.TextXAlignment.Right
    right.TextColor3 = Library.Theme["Dark Text"]
    local c = {
        Section=section, Tab=section.Tab, Window=w, Frame=row, Stroke=st, NameLabel=name, ValueLabel=right,
        Options=options, Kind=kind, Name=tostring(options.Name or kind), Description=descriptionFor(options,kind),
        Selectable = selectable ~= false,
    }
    table.insert(section.Controls, c)
    table.insert(section.Tab.Controls, c)
    if c.Selectable then section.LastVisibleControl = c end
    return c
end

local function controlMouse(c)
    if not c.Frame then return end
    c.Frame.Active = true
    c.Frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            c.Window:SelectControlObject(c)
            if c.Activate then c:Activate() end
        end
    end)
end

function SectionMethods:AddToggle(options)
    local c = createRow(self, options, "toggle", true)
    c.Value = options.Default == true
    local pill = Instance.new("Frame")
    pill.Size = UDim2.fromOffset(38,20)
    pill.Position = UDim2.new(1,-52,0.5,-10)
    pill.BackgroundColor3 = Color3.fromRGB(36,36,42)
    pill.BorderSizePixel = 0
    pill.Parent = c.Frame
    corner(pill, 99)
    local dot = Instance.new("Frame")
    dot.Size = UDim2.fromOffset(14,14)
    dot.Position = UDim2.fromOffset(3,3)
    dot.BackgroundColor3 = Color3.fromRGB(115,115,123)
    dot.BorderSizePixel = 0
    dot.Parent = pill
    corner(dot,99)
    c.Pill, c.Dot = pill, dot
    c.ValueLabel.Size = UDim2.fromOffset(170,38)
    c.ValueLabel.Position = UDim2.new(1,-225,0,0)
    function c:Render()
        if self.Value then
            self.Pill.BackgroundColor3 = self.Window.Accent
            self.Dot.BackgroundColor3 = Color3.fromRGB(255,255,255)
            self.Dot.Position = UDim2.fromOffset(21,3)
        else
            self.Pill.BackgroundColor3 = Color3.fromRGB(36,36,42)
            self.Dot.BackgroundColor3 = Color3.fromRGB(115,115,123)
            self.Dot.Position = UDim2.fromOffset(3,3)
        end
        if self.ModeControl then self.ValueLabel.Text = "- " .. formatValue(self.ModeControl:Get()) .. " -" else self.ValueLabel.Text = "" end
    end
    function c:Get() return self.Value end
    function c:Set(v)
        self.Value = v == true
        self:Render()
        safeCall(self.Options.Callback, self.Value)
    end
    function c:Activate() self:Set(not self.Value) end
    function c:Adjust(dir)
        if self.ModeControl and self.ModeControl.Cycle then self.ModeControl:Cycle(dir) end
    end
    c:Render(); controlMouse(c)
    return c
end

function SectionMethods:AddSlider(options)
    local c = createRow(self, options, "slider", true)
    c.Min = tonumber(options.Min) or 0
    c.Max = tonumber(options.Max) or 100
    c.Step = tonumber(options.Step or options.Decimals) or 1
    if c.Step <= 0 then c.Step = 1 end
    c.Value = math.clamp(tonumber(options.Default) or c.Min, c.Min, c.Max)
    local track = Instance.new("Frame")
    track.Size = UDim2.new(0,105,0,5)
    track.Position = UDim2.new(1,-120,0.5,8)
    track.BackgroundColor3 = Color3.fromRGB(32,32,37)
    track.BorderSizePixel = 0
    track.Parent = c.Frame
    corner(track,99)
    local fill = Instance.new("Frame")
    fill.Size = UDim2.fromScale(0,1)
    fill.BackgroundColor3 = c.Window.Accent
    fill.BorderSizePixel = 0
    fill.Parent = track
    corner(fill,99)
    c.Track,c.Fill=track,fill
    c.Window:RegisterAccent(fill)
    function c:Render()
        local alpha = (self.Value-self.Min)/math.max(0.0001,self.Max-self.Min)
        self.Fill.Size = UDim2.fromScale(math.clamp(alpha,0,1),1)
        self.ValueLabel.Text = formatValue(self.Value)
    end
    function c:Get() return self.Value end
    function c:Set(v)
        v = math.clamp(tonumber(v) or self.Value, self.Min, self.Max)
        v = math.floor((v/self.Step)+0.5)*self.Step
        self.Value = math.clamp(v,self.Min,self.Max)
        self:Render(); safeCall(self.Options.Callback,self.Value)
    end
    function c:Adjust(dir)
        self:Set(self.Value + self.Step*(dir or 1))
    end

    function c:Activate() end

    local dragging = false

    local function setFromMouseX(mouseX)
        if not c.Track or not c.Track.Parent then
            return
        end

        local width =
            math.max(
                1,
                c.Track.AbsoluteSize.X
            )

        local alpha =
            math.clamp(
                (mouseX - c.Track.AbsolutePosition.X) / width,
                0,
                1
            )

        c:Set(
            c.Min
            + (c.Max - c.Min)
                * alpha
        )

        c.Window:SelectControlObject(c)
    end

    c.Track.Active = true

    c.Track.InputBegan:Connect(function(input)
        if input.UserInputType
            == Enum.UserInputType.MouseButton1
        then
            dragging = true
            setFromMouseX(input.Position.X)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging
            and input.UserInputType
                == Enum.UserInputType.MouseMovement
        then
            setFromMouseX(input.Position.X)
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType
            == Enum.UserInputType.MouseButton1
        then
            dragging = false
        end
    end)

    c:Render()
    controlMouse(c)

    return c
end

function SectionMethods:AddDropdown(options)
    options = options or {}
    local values = options.Values or options.Items or {}
    local hiddenFly = tostring(options.Name or "") == "FlyOptions" and self.LastVisibleControl and self.LastVisibleControl.Name == "Fly"
    local c = hiddenFly and {
        Section=self, Tab=self.Tab, Window=self.Window, Options=options, Kind="dropdown", Name=tostring(options.Name or "Dropdown"),
        Description=descriptionFor(options,"dropdown"), Selectable=false,
    } or createRow(self,options,"dropdown",true)
    c.Values = {}
    for _,v in ipairs(values) do table.insert(c.Values,v) end
    c.Value = options.Default
    if c.Value == nil and #c.Values>0 then c.Value=c.Values[1] end
    function c:Render()
        if self.ValueLabel then self.ValueLabel.Text = "< " .. formatValue(self.Value) .. " >" end
        if self.LinkedToggle and self.LinkedToggle.Render then self.LinkedToggle:Render() end
    end
    function c:Get() return self.Value end
    function c:Set(v)
        self.Value = v
        self:Render(); safeCall(self.Options.Callback,self.Value)
    end
    function c:SetValues(vals)
        self.Values = {}
        if type(vals)=="table" then for _,v in ipairs(vals) do table.insert(self.Values,v) end end
        if #self.Values>0 and table.find(self.Values,self.Value)==nil then self.Value=self.Values[1] end
        self:Render()
    end
    c.Refresh=c.SetValues; c.UpdateValues=c.SetValues
    function c:Update(tbl) if type(tbl)=="table" then self:SetValues(tbl.Values or tbl.Items or {}) end end
    function c:Cycle(dir)
        if #self.Values==0 then return end
        local idx = table.find(self.Values,self.Value) or 1
        idx = ((idx - 1 + (dir or 1)) % #self.Values) + 1
        self:Set(self.Values[idx])
    end
    function c:Adjust(dir) self:Cycle(dir) end
    function c:Activate() self:Cycle(1) end
    if hiddenFly then
        local fly = self.LastVisibleControl
        fly.ModeControl = c; c.LinkedToggle = fly
        fly.Description = "Lets you fly. Left/right changes the fly method; Enter toggles it."
        c:Render()
    else
        c:Render(); controlMouse(c)
    end
    return c
end

function SectionMethods:AddButton(options)
    options = options or {}
    local c = createRow(self,options,"button",true)

    local values = options.Values or options.Items
    local hasValues = type(values) == "table" and #values > 0

    c.ValueLabel.TextColor3 = c.Window.Accent
    c.Window:RegisterAccent(c.ValueLabel,"TextColor3")

    if hasValues then
        c.Values = {}
        for _,v in ipairs(values) do
            table.insert(c.Values,v)
        end

        c.Value = options.Default
        if c.Value == nil or table.find(c.Values,c.Value) == nil then
            c.Value = c.Values[1]
        end

        function c:Render()
            self.ValueLabel.Text = "- " .. formatValue(self.Value) .. " -"
        end

        function c:Get()
            return self.Value
        end

        function c:Set(v)
            if table.find(self.Values,v) then
                self.Value = v
                self:Render()
                safeCall(self.Options.OnValueChanged,self.Value)
            end
        end

        function c:Cycle(dir)
            if #self.Values == 0 then return end
            local idx = table.find(self.Values,self.Value) or 1
            idx = ((idx - 1 + (dir or 1)) % #self.Values) + 1
            self:Set(self.Values[idx])
        end

        function c:Adjust(dir)
            self:Cycle(dir)
        end

        function c:Activate()
            safeCall(self.Options.Callback,self.Value)
        end

        c:Render()
    else
        c.ValueLabel.Text = "ENTER"
        function c:Get() return nil end
        function c:Set() end
        function c:Activate()
            safeCall(self.Options.Callback)
        end
    end

    controlMouse(c)
    return c
end

function SectionMethods:AddLabel(value)
    local options = type(value)=="table" and value or {Name=tostring(value or "")}
    local c = createRow(self,options,"label",false)
    c.Frame.BackgroundTransparency = 1
    c.Stroke.Transparency = 1
    c.NameLabel.Size = UDim2.new(1,-20,1,0)
    c.NameLabel.TextColor3 = Library.Theme["Dark Text"]
    c.ValueLabel.Visible = false
    c.TextLabel = c.NameLabel
    function c:Set(v) self.NameLabel.Text = tostring(v or "") end
    function c:Get() return self.NameLabel.Text end
    return c.NameLabel
end

function SectionMethods:AddTextbox(options)
    local c = createRow(self,options,"textbox",true)
    local box = Instance.new("TextBox")
    box.BackgroundColor3 = Color3.fromRGB(20,20,24)
    box.BackgroundTransparency = 0.1
    box.BorderSizePixel = 0
    box.Size = UDim2.fromOffset(155,26)
    box.Position = UDim2.new(1,-167,0.5,-13)
    box.Text = tostring(options.Default or "")
    box.PlaceholderText = tostring(options.Placeholder or "")
    box.PlaceholderColor3 = Library.Theme["Dark Text"]
    box.TextColor3 = Library.Theme.Text
    box.TextSize = 11
    box.Font = Enum.Font.Code
    box.ClearTextOnFocus = false
    box.Parent = c.Frame
    corner(box,7); stroke(box,Library.Theme.Outline,1,0.55)
    c.ValueLabel.Visible=false; c.Box=box
    local function fire() safeCall(options.Callback,box.Text) end
    if options.Finished then
        box.FocusLost:Connect(function(enter) if enter then fire() end end)
    else
        box:GetPropertyChangedSignal("Text"):Connect(fire)
    end
    function c:Get() return box.Text end
    function c:Set(v) box.Text=tostring(v or ""); fire() end
    function c:Activate() box:CaptureFocus() end
    controlMouse(c)
    return c
end
SectionMethods.AddTextBox = SectionMethods.AddTextbox

function SectionMethods:AddKeybind(options)
    local c = createRow(self,options,"keybind",true)
    c.Value = options.Default
    c.Capturing=false
    function c:Render() self.ValueLabel.Text = self.Capturing and "PRESS KEY..." or formatValue(self.Value or "NONE") end
    function c:Get() return self.Value end
    function c:Set(v) self.Value=v; self:Render(); safeCall(self.Options.Callback,v) end
    function c:Activate() self.Capturing=true; self:Render(); self.Window.KeyCaptureControl=self end
    c:Render(); controlMouse(c)
    return c
end

function SectionMethods:AddColorPicker(options)
    local c = createRow(self,options,"color",true)
    c.Value = typeof(options.Default)=="Color3" and options.Default or Color3.fromRGB(255,255,255)
    local sw = Instance.new("Frame")
    sw.Size=UDim2.fromOffset(24,18); sw.Position=UDim2.new(1,-37,0.5,-9); sw.BorderSizePixel=0; sw.Parent=c.Frame; corner(sw,5)
    c.Swatch=sw
    function c:Render() self.Swatch.BackgroundColor3=self.Value; self.ValueLabel.Text="" end
    function c:Get() return self.Value end
    function c:Set(v) if typeof(v)=="Color3" then self.Value=v; self:Render(); safeCall(self.Options.Callback,v) end end
    function c:Adjust(dir)
        local h,s,v = self.Value:ToHSV(); h=(h + 0.03*(dir or 1))%1; self:Set(Color3.fromHSV(h,s,v))
    end
    function c:Activate() self:Adjust(1) end
    c:Render(); controlMouse(c)
    return c
end
SectionMethods.AddColorpicker = SectionMethods.AddColorPicker

function WindowMethods:RebuildSelectable()
    local previous =
        self.Selectables
        and self.Selectables[self.SelectedIndex or 0]
        or nil

    self.Selectables = {}

    local tab = self.CurrentTab

    if tab then
        -- Navigation order must follow the visible menu structure.
        -- Player controls are added to Movement / Utilities / Cosmetics at
        -- different moments in the main script, so tab.Controls is NOT the
        -- same as the order shown on screen.
        for _, section in ipairs(tab.Sections or {}) do
            for _, c in ipairs(section.Controls or {}) do
                if c.Selectable
                    and c.Frame
                    and c.Frame.Parent
                    and c.Frame.Visible ~= false
                then
                    table.insert(self.Selectables, c)
                end
            end
        end
    end

    if #self.Selectables == 0 then
        self.SelectedIndex = 0
    else
        local restored = false

        if previous then
            for i, c in ipairs(self.Selectables) do
                if c == previous then
                    self.SelectedIndex = i
                    restored = true
                    break
                end
            end
        end

        if not restored then
            self.SelectedIndex =
                math.clamp(
                    self.SelectedIndex or 1,
                    1,
                    #self.Selectables
                )
        end
    end

    self:RefreshSelection()
end

function WindowMethods:SelectControlObject(target)
    self:RebuildSelectable()
    for i,c in ipairs(self.Selectables) do if c==target then self.SelectedIndex=i; break end end
    self:RefreshSelection()
end

function WindowMethods:RefreshSelection()
    for i,c in ipairs(self.Selectables or {}) do
        local selected = i==(self.SelectedIndex or 0)
        if c.Stroke then
            c.Stroke.Color = selected and self.Accent or Library.Theme.Outline
            c.Stroke.Transparency = selected and 0.02 or 1
            c.Stroke.Thickness = selected and 1.6 or 1
        end
        if c.Frame then c.Frame.BackgroundTransparency = selected and 0.16 or 0.48 end
    end
    local c = self.Selectables and self.Selectables[self.SelectedIndex or 0]
    if c then
        self.DescriptionText.Text = c.Description or c.Name
        self.DescriptionBox.Visible = self.Open and not self.CategorySelectMode
        if c.Frame and c.Tab and c.Tab.Scroller then
            pcall(function()
                local sf = c.Tab.Scroller
                local rel = c.Frame.AbsolutePosition.Y - sf.AbsolutePosition.Y + sf.CanvasPosition.Y
                sf.CanvasPosition = Vector2.new(0, math.max(0, rel - 80))
            end)
        end
    else
        self.DescriptionBox.Visible=false
    end
end

function WindowMethods:MoveSelection(dir)
    if #self.Selectables==0 then return end
    self.SelectedIndex=((self.SelectedIndex-1+(dir or 1)) % #self.Selectables)+1
    self:RefreshSelection()
end

function WindowMethods:CycleTab(dir)
    local cat=self.CurrentCategory; if not cat or #cat.Tabs==0 then return end
    local idx=table.find(cat.Tabs,self.CurrentTab) or 1
    idx=((idx-1+(dir or 1))%#cat.Tabs)+1
    setVisibleTab(self,cat.Tabs[idx])
end

function WindowMethods:ShowCategoryChooser()
    self.CategorySelectMode = true
    self.CategoryChooser.Visible = true
    self.DescriptionBox.Visible = false

    -- Root menu is its OWN page. Hide the selected category UI completely
    -- so the user never sees Main/Status/Owner (or any other tabs) until
    -- a category is actually confirmed with ENTER.
    if self.TabBar then self.TabBar.Visible = false end
    if self.Content then self.Content.Visible = false end
    if self.Footer then self.Footer.Position = UDim2.fromOffset(0,655) end

    self.CategoryChooserIndex = table.find(self.Categories, self.CurrentCategory) or 1
    self:RefreshCategoryChooser()
end

function WindowMethods:HideCategoryChooser()
    self.CategorySelectMode = false
    self.CategoryChooser.Visible = false
    if self.TabBar then self.TabBar.Visible = true end
    if self.Content then self.Content.Visible = true end
    if self.Footer then self.Footer.Position = UDim2.fromOffset(0,596) end
    self:RefreshHeader()
    self:RebuildSelectable()
end

function WindowMethods:RefreshCategoryChooser()
    for i,b in ipairs(self.CategoryButtons) do
        local sel=i==self.CategoryChooserIndex
        b.BackgroundTransparency=sel and 0.14 or 0.42
        local nameLabel=b:FindFirstChild("CategoryNameLabel")
        local arrow=b:FindFirstChild("CategoryArrow")
        if nameLabel then nameLabel.TextColor3=sel and self.Accent or Library.Theme.Text end
        if arrow then arrow.TextColor3=sel and self.Accent or Color3.fromRGB(205,205,210) end
        if b:FindFirstChildOfClass("UIStroke") then
            local st=b:FindFirstChildOfClass("UIStroke"); st.Color=sel and self.Accent or Library.Theme.Outline; st.Transparency=sel and 0.02 or 0.88
        end
    end
end

function WindowMethods:BuildInterfaceTab(tab)
    local sec =
        tab:AddSection(
            "INTERFACE",
            "left",
            {}
        )

    sec:AddDropdown({
        Name = "Banner",
        Values = {
            "Netanyahu",
            "4CHAN",
            "Omerta Chinoise",
            "Orlax Le Barbar",
            "Laurent Voulzy",
            "Femboy",
            "Rabbits",
            "Totally Spies",
            "Meow",
            "Mamadou Segpa",
            "Silver",
        },
        Default = self.ThemeName or "Silver",
        Description = "Choisis une bannière prédéfinie.",

        Callback = function(value)
            self.ThemeName =
                tostring(
                    value
                    or "Netanyahu"
                )

            self:ApplyTheme(
                getBannerTheme(
                    self.ThemeName
                )
            )

            self:SaveInterface()
        end,
    })

    sec:AddDropdown({
        Name = "Menu Position",
        Values = {
            "Left",
            "Center",
            "Right",
        },
        Default = self.MenuPosition or "Right",
        Description = "Déplace le menu à gauche, au centre ou à droite de l'écran.",

        Callback = function(value)
            self:ApplyMenuPosition(value)
            self:SaveInterface()
        end,
    })

    sec:AddToggle({
        Name = "Notifications",
        Default = self.NotificationsEnabled ~= false,
        Description = "Active ou désactive les notifications TEL-AVIV en haut de l'écran.",

        Callback = function(value)
            self.NotificationsEnabled =
                value == true

            self:SaveInterface()
        end,
    })

    local help =
        tab:AddSection(
            "CONTROLS",
            "left",
            {}
        )

    help:AddLabel("SHIFT • Open / close")
    help:AddLabel("↑ ↓ • Navigate")
    help:AddLabel("ENTER • Confirm / toggle")
    help:AddLabel("← → • Value / slider / mode")
    help:AddLabel("Q E • Switch sub-tab")
    help:AddLabel("BACKSPACE / Mouse Back • Back")
    help:AddLabel("Mouse • Click / drag sliders / move menu")
end

function Library.new(options)
    options=options or {}
    local self=setmetatable({}, {__index=WindowMethods})
    self.Categories={}; self.AccentObjects={}; self.Selectables={}; self.SelectedIndex=1
    self.Open=true; self.CategorySelectMode=true; self.CategoryButtons={}; self.KeyCaptureControl=nil
    self.Accent=Color3.fromRGB(35,108,255); self.Accent2=Color3.fromRGB(10,61,184)
    self.PanelColor=Color3.fromRGB(12,12,15)
    self.BannerAsset="71553416281640"
    self.ThemeName="Netanyahu"; self.InterfaceOpacity=0.12; self.NotificationsEnabled=true; self.MaxItems=9
    self.MenuPosition="Right"
    self:LoadInterface()

    local gui=makeScreen(); self.Root=gui

    -- SKY/FiveM layout: floating stack on the right, with real gaps between banner/tabs/body/footer.
    local main=Instance.new("Frame")
    main.Name="Main"
    main.AnchorPoint=Vector2.new(0,0)
    main.Position=UDim2.new(0.52,0,0.035,0)
    main.Size=UDim2.fromOffset(500,710)
    main.BackgroundTransparency=1
    main.BorderSizePixel=0
    main.Parent=gui
    self.Main=main
    self.Panel=main
    self:ApplyMenuPosition(self.MenuPosition)

    local shadow=Instance.new("Frame")
    shadow.Name="Shadow"
    shadow.Position=UDim2.fromOffset(4,5)
    shadow.Size=UDim2.new(1,0,1,0)
    shadow.BackgroundTransparency=1
    shadow.BorderSizePixel=0
    shadow.Parent=main
    self.Shadow=shadow

    local banner=Instance.new("ImageLabel")
    banner.Name="Banner"
    banner.BackgroundColor3=Color3.fromRGB(8,8,9)
    banner.BackgroundTransparency=0
    banner.BorderSizePixel=0
    banner.Position=UDim2.fromOffset(0,0)
    banner.Size=UDim2.new(1,0,0,142)
    banner.Image="rbxassetid://"..self.BannerAsset:gsub("rbxassetid://","")
    banner.ScaleType=Enum.ScaleType.Crop
    banner.Parent=main
    corner(banner,19)
    stroke(banner,Color3.fromRGB(30,30,34),1,0.35)
    self.Banner=banner

    banner.Active = true

    local menuDragging = false
    local dragStart = nil
    local startPosition = nil

    banner.InputBegan:Connect(function(input)
        if input.UserInputType
            == Enum.UserInputType.MouseButton1
        then
            menuDragging = true
            dragStart = input.Position

            local absolute =
                main.AbsolutePosition

            main.AnchorPoint =
                Vector2.new(
                    0,
                    0
                )

            main.Position =
                UDim2.fromOffset(
                    absolute.X,
                    absolute.Y
                )

            startPosition =
                main.Position
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if not menuDragging
            or input.UserInputType
                ~= Enum.UserInputType.MouseMovement
        then
            return
        end

        local delta =
            input.Position
            - dragStart

        main.Position =
            UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )

        self.MenuPosition = "Custom"
        self.CustomMenuPosition =
            main.Position
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType
            == Enum.UserInputType.MouseButton1
        then
            if menuDragging then
                menuDragging = false
                self:SaveInterface()
            end
        end
    end)

    local tabbar=Instance.new("Frame")
    tabbar.Name="Tabs"
    tabbar.BackgroundColor3=Color3.fromRGB(16,16,18)
    tabbar.BackgroundTransparency=0.16
    tabbar.BorderSizePixel=0
    tabbar.Position=UDim2.fromOffset(0,149)
    tabbar.Size=UDim2.new(1,0,0,44)
    tabbar.Parent=main
    corner(tabbar,14)
    stroke(tabbar,Color3.fromRGB(44,44,48),1,0.35)
    self.Header=tabbar
    self.TabBar=tabbar

    -- Kept for compatibility; category selection itself is rendered as a page below.
    local catbar=Instance.new("Frame")
    catbar.Name="CategoryHeader"
    catbar.BackgroundTransparency=1
    catbar.Size=UDim2.fromOffset(1,1)
    catbar.Visible=false
    catbar.Parent=main
    self.Sidebar=catbar
    local catname=textLabel(catbar,"Main",1,true); catname.Visible=false; self.CategoryName=catname
    local catcount=textLabel(catbar,"1/1",1,true); catcount.Visible=false; self.CategoryCount=catcount

    local content=Instance.new("Frame")
    content.Name="Content"
    content.BackgroundColor3=Color3.fromRGB(9,9,10)
    content.BackgroundTransparency=0.20
    content.BorderSizePixel=0
    content.Position=UDim2.fromOffset(0,198)
    content.Size=UDim2.new(1,0,0,392)
    content.ClipsDescendants=true
    content.Parent=main
    corner(content,14)
    stroke(content,Color3.fromRGB(44,44,48),1,0.45)
    self.Content=content

    local footer=Instance.new("Frame")
    footer.Name="Footer"
    footer.BackgroundColor3=Color3.fromRGB(12,12,13)
    footer.BackgroundTransparency=0.10
    footer.BorderSizePixel=0
    footer.Position=UDim2.fromOffset(0,596)
    footer.Size=UDim2.new(1,0,0,39)
    footer.Parent=main
    self.Footer=footer
    corner(footer,14)
    stroke(footer,Color3.fromRGB(43,43,47),1,0.42)

    local avatar=Instance.new("ImageLabel")
    avatar.BackgroundColor3=Color3.fromRGB(35,35,38)
    avatar.BorderSizePixel=0
    avatar.Position=UDim2.fromOffset(7,5)
    avatar.Size=UDim2.fromOffset(29,29)
    avatar.Image = LP and ("rbxthumb://type=AvatarHeadShot&id="..tostring(LP.UserId).."&w=150&h=150") or ""
    avatar.Parent=footer
    corner(avatar,99)
    stroke(avatar,self.Accent,1.2,0.1)
    self:RegisterAccent(avatar:FindFirstChildOfClass("UIStroke"),"Color")

    local user=textLabel(footer, LP and LP.Name or "TEL-AVIV",11,true)
    user.Size=UDim2.fromOffset(155,39)
    user.Position=UDim2.fromOffset(42,0)

    local pill=Instance.new("Frame")
    pill.AnchorPoint=Vector2.new(1,0.5)
    pill.Position=UDim2.new(1,-55,0.5,0)
    pill.Size=UDim2.fromOffset(165,24)
    pill.BackgroundColor3=Color3.fromRGB(18,18,20)
    pill.BackgroundTransparency=0.12
    pill.BorderSizePixel=0
    pill.Parent=footer
    corner(pill,6)
    local pst=stroke(pill,self.Accent,1,0.15)
    self:RegisterAccent(pst,"Color")
    local build=textLabel(pill,"Discord.gg/telavivmenu  V2",10,true)
    build.Size=UDim2.new(1,-12,1,0)
    build.Position=UDim2.fromOffset(6,0)
    build.TextXAlignment=Enum.TextXAlignment.Center
    build.TextColor3=self.Accent
    self:RegisterAccent(build,"TextColor3")

    local pageCount=textLabel(footer,"1/1",10,true)
    pageCount.AnchorPoint=Vector2.new(1,0)
    pageCount.Position=UDim2.new(1,-8,0,0)
    pageCount.Size=UDim2.fromOffset(42,39)
    pageCount.TextXAlignment=Enum.TextXAlignment.Right
    pageCount.TextColor3=Color3.fromRGB(215,215,220)
    self.FooterCount=pageCount

    local hint=textLabel(main,"Press SHIFT • Keybind Mode",10,true)
    hint.AnchorPoint=Vector2.new(0.5,0)
    hint.Position=UDim2.new(0.5,0,1,-9)
    hint.Size=UDim2.fromOffset(250,20)
    hint.TextXAlignment=Enum.TextXAlignment.Center
    hint.TextColor3=Color3.fromRGB(145,145,150)
    hint.TextTransparency=0.22

    local desc=Instance.new("Frame")
    desc.Name="Description"
    desc.AnchorPoint=Vector2.new(0.5,1)
    desc.Position=UDim2.new(0.5,0,1,-75)
    desc.Size=UDim2.fromOffset(485,42)
    desc.BackgroundColor3=Color3.fromRGB(8,8,9)
    desc.BackgroundTransparency=0.08
    desc.BorderSizePixel=0
    desc.Visible=false
    desc.Parent=gui
    corner(desc,6)
    stroke(desc,Color3.fromRGB(35,35,38),1,0.55)
    self.DescriptionBox=desc
    local dt=textLabel(desc,"",12,true)
    dt.Size=UDim2.new(1,-24,1,0)
    dt.Position=UDim2.fromOffset(12,0)
    dt.TextXAlignment=Enum.TextXAlignment.Center
    self.DescriptionText=dt

    -- BACKSPACE category page. It occupies the same body area instead of a center-screen popup.
    local chooser=Instance.new("Frame")
    chooser.Name="CategoryChooser"
    -- Root category page replaces BOTH the tab bar and the normal content area.
    -- This prevents the previous "double window" look on startup.
    chooser.Position=UDim2.fromOffset(0,149)
    chooser.Size=UDim2.new(1,0,0,500)
    chooser.BackgroundColor3=Color3.fromRGB(9,9,10)
    chooser.BackgroundTransparency=0.10
    chooser.BorderSizePixel=0
    chooser.Visible=true
    chooser.ZIndex=50
    chooser.Parent=main
    corner(chooser,14)
    stroke(chooser,Color3.fromRGB(44,44,48),1,0.45)
    self.CategoryChooser=chooser

    -- Initial state: root category chooser only. The internal default category
    -- may already exist for callback compatibility, but it is not rendered yet.
    tabbar.Visible = false
    content.Visible = false
    footer.Position = UDim2.fromOffset(0,655)

    local choList=Instance.new("Frame")
    choList.BackgroundTransparency=1
    choList.Position=UDim2.fromOffset(10,10)
    choList.Size=UDim2.new(1,-20,1,-20)
    choList.ZIndex=51
    choList.Parent=chooser
    local chLay=Instance.new("UIListLayout")
    chLay.Padding=UDim.new(0,6)
    chLay.Parent=choList
    self.CategoryChooserList=choList

    local noteHolder=Instance.new("Frame")
    noteHolder.Name="Notifications"
    noteHolder.AnchorPoint=Vector2.new(0.5,0)
    noteHolder.Position=UDim2.new(0.5,0,0,28)
    noteHolder.Size=UDim2.fromOffset(470,360)
    noteHolder.BackgroundTransparency=1
    noteHolder.Parent=gui
    local noteLayout=Instance.new("UIListLayout")
    noteLayout.Padding=UDim.new(0,8)
    noteLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center
    noteLayout.SortOrder=Enum.SortOrder.LayoutOrder
    noteLayout.Parent=noteHolder
    self.NotificationHolder=noteHolder

    Library._ActiveWindow=self

    -- category chooser buttons are created lazily whenever categories exist
    task.spawn(function()
        while parentGuiAlive(gui) do
            task.wait(0.5)
            if #self.CategoryButtons ~= #self.Categories then
                for _,x in ipairs(self.CategoryChooserList:GetChildren()) do if x:IsA("TextButton") then x:Destroy() end end
                self.CategoryButtons={}
                for i,cat in ipairs(self.Categories) do
                    local b=Instance.new("TextButton")
                    b.AutoButtonColor=false
                    b.BackgroundColor3=Color3.fromRGB(18,18,20)
                    b.BackgroundTransparency=0.42
                    b.BorderSizePixel=0
                    b.Size=UDim2.new(1,0,0,42)
                    b.Text=""
                    b.ZIndex=52
                    b.Parent=self.CategoryChooserList
                    corner(b,10)
                    stroke(b,Library.Theme.Outline,1.2,0.88)

                    local nameLabel=textLabel(b,(cat.DisplayName or cat.Name),14,true)
                    nameLabel.Name="CategoryNameLabel"
                    nameLabel.Position=UDim2.fromOffset(16,0)
                    nameLabel.Size=UDim2.new(1,-62,1,0)
                    nameLabel.TextXAlignment=Enum.TextXAlignment.Left
                    nameLabel.TextColor3=Library.Theme.Text
                    nameLabel.ZIndex=53

                    local arrow=textLabel(b,"›",18,true)
                    arrow.Name="CategoryArrow"
                    arrow.AnchorPoint=Vector2.new(1,0)
                    arrow.Position=UDim2.new(1,-16,0,0)
                    arrow.Size=UDim2.fromOffset(28,42)
                    arrow.TextXAlignment=Enum.TextXAlignment.Right
                    arrow.TextColor3=Color3.fromRGB(205,205,210)
                    arrow.ZIndex=53

                    table.insert(self.CategoryButtons,b)
                    self.CategoryChooserIndex = math.clamp(self.CategoryChooserIndex or 1, 1, math.max(1, #self.Categories))
                    b.MouseButton1Click:Connect(function() self.CategoryChooserIndex=i; cat:Select(); self:HideCategoryChooser() end)
                end
                if self.CategorySelectMode then
                    self:RefreshCategoryChooser()
                end
            end
        end
    end)

    -- Apply saved banner/theme preset.
    if not Library.BannerThemes[self.ThemeName] then
        self.ThemeName =
            "Netanyahu"
    end

    self:ApplyTheme(
        getBannerTheme(
            self.ThemeName
        )
    )

    local function isMouseBackInput(input)
        local inputTypeName =
            tostring(
                input.UserInputType
            )

        local keyName =
            tostring(
                input.KeyCode
            )

        return inputTypeName:find(
            "MouseButton4",
            1,
            true
        ) ~= nil
            or inputTypeName:find(
                "MouseButton5",
                1,
                true
            ) ~= nil
            or keyName:find(
                "BrowserBack",
                1,
                true
            ) ~= nil
            or keyName:find(
                "MouseButton4",
                1,
                true
            ) ~= nil
            or keyName:find(
                "MouseButton5",
                1,
                true
            ) ~= nil
    end

    local function doBack()
        if not self.CategorySelectMode then
            self:ShowCategoryChooser()
        end
    end

    self.InputConnection=UIS.InputBegan:Connect(function(input,gpe)
        if not parentGuiAlive(gui) then return end
        if isMouseBackInput(input) then
            if self.Open then
                doBack()
            end

            return
        end

        if self.KeyCaptureControl and self.KeyCaptureControl.Capturing then
            if input.KeyCode ~= Enum.KeyCode.Unknown then
                local c=self.KeyCaptureControl; self.KeyCaptureControl=nil; c.Capturing=false; c:Set(input.KeyCode)
            end
            return
        end
        local focused=UIS:GetFocusedTextBox()
        if focused then return end
        local k=input.KeyCode
        if k==Enum.KeyCode.LeftShift or k==Enum.KeyCode.RightShift then self:Toggle(); return end
        if not self.Open then return end
        if self.CategorySelectMode then
            if k==Enum.KeyCode.Up then self.CategoryChooserIndex=((self.CategoryChooserIndex-2)%math.max(1,#self.Categories))+1; self:RefreshCategoryChooser()
            elseif k==Enum.KeyCode.Down then self.CategoryChooserIndex=(self.CategoryChooserIndex%math.max(1,#self.Categories))+1; self:RefreshCategoryChooser()
            elseif k==Enum.KeyCode.Return or k==Enum.KeyCode.KeypadEnter then local cat=self.Categories[self.CategoryChooserIndex]; if cat then cat:Select() end; self:HideCategoryChooser()
            elseif k==Enum.KeyCode.Backspace then
                return
            end
            return
        end
        if k==Enum.KeyCode.Up then self:MoveSelection(-1)
        elseif k==Enum.KeyCode.Down then self:MoveSelection(1)
        elseif k==Enum.KeyCode.Left then local c=self.Selectables[self.SelectedIndex]; if c and c.Adjust then c:Adjust(-1) end; self:RefreshSelection()
        elseif k==Enum.KeyCode.Right then local c=self.Selectables[self.SelectedIndex]; if c and c.Adjust then c:Adjust(1) end; self:RefreshSelection()
        elseif k==Enum.KeyCode.Return or k==Enum.KeyCode.KeypadEnter then local c=self.Selectables[self.SelectedIndex]; if c and c.Activate then c:Activate() end
        elseif k==Enum.KeyCode.Q then self:CycleTab(-1)
        elseif k==Enum.KeyCode.E then self:CycleTab(1)
        elseif k==Enum.KeyCode.Backspace then
            doBack()
        end
    end)

    return self
end

function Library:Notify(opts)
    opts=type(opts)=="table" and opts or {Title="TEL-AVIV",Content=tostring(opts or "")}
    local w=self._ActiveWindow
    if not w or not w.NotificationHolder or w.NotificationsEnabled==false then return end

    local card=Instance.new("Frame")
    card.BackgroundColor3=Color3.fromRGB(9,9,10)
    card.BackgroundTransparency=0.03
    card.BorderSizePixel=0
    card.Size=UDim2.fromOffset(445,64)
    card.Position=UDim2.fromOffset(0,-14)
    card.Parent=w.NotificationHolder
    corner(card,8)
    stroke(card,Color3.fromRGB(45,45,49),1,0.38)

    local shadow=Instance.new("Frame")
    shadow.AnchorPoint=Vector2.new(0.5,0.5)
    shadow.Position=UDim2.fromScale(0.5,0.5)
    shadow.Size=UDim2.new(1,10,1,10)
    shadow.BackgroundColor3=Color3.new(0,0,0)
    shadow.BackgroundTransparency=0.68
    shadow.BorderSizePixel=0
    shadow.ZIndex=card.ZIndex-1
    shadow.Parent=card
    corner(shadow,10)

    local icon=Instance.new("Frame")
    icon.Size=UDim2.fromOffset(30,30)
    icon.Position=UDim2.fromOffset(12,11)
    icon.BackgroundColor3=Color3.fromRGB(18,18,20)
    icon.BorderSizePixel=0
    icon.Parent=card
    corner(icon,99)
    local ist=stroke(icon,w.Accent,1.4,0.08)
    w:RegisterAccent(ist,"Color")
    local inner=textLabel(icon,"×",17,true)
    inner.Size=UDim2.fromScale(1,1)
    inner.TextXAlignment=Enum.TextXAlignment.Center
    inner.TextColor3=w.Accent
    w:RegisterAccent(inner,"TextColor3")

    local title=textLabel(card,tostring(opts.Title or "TEL-AVIV"),12,true)
    title.Size=UDim2.new(1,-92,0,22)
    title.Position=UDim2.fromOffset(52,7)

    local content=textLabel(card,tostring(opts.Content or opts.Text or ""),10,false)
    content.Size=UDim2.new(1,-92,0,22)
    content.Position=UDim2.fromOffset(52,28)
    content.TextColor3=Color3.fromRGB(165,165,172)

    local close=Instance.new("TextButton")
    close.AutoButtonColor=false
    close.BackgroundTransparency=1
    close.Size=UDim2.fromOffset(28,28)
    close.Position=UDim2.new(1,-33,0,5)
    close.Text="×"
    close.TextColor3=Color3.fromRGB(145,145,150)
    close.TextSize=17
    close.Font=Enum.Font.GothamBold
    close.Parent=card

    local base=Instance.new("Frame")
    base.BorderSizePixel=0
    base.BackgroundColor3=Color3.fromRGB(35,35,39)
    base.Size=UDim2.new(1,0,0,3)
    base.Position=UDim2.new(0,0,1,-3)
    base.Parent=card
    local bar=Instance.new("Frame")
    bar.BorderSizePixel=0
    bar.BackgroundColor3=w.Accent
    bar.Size=UDim2.new(1,0,1,0)
    bar.Parent=base
    w:RegisterAccent(bar)

    card.BackgroundTransparency=1
    title.TextTransparency=1
    content.TextTransparency=1
    TweenService:Create(card,TweenInfo.new(0.18,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{BackgroundTransparency=0.03,Position=UDim2.fromOffset(0,0)}):Play()
    TweenService:Create(title,TweenInfo.new(0.18),{TextTransparency=0}):Play()
    TweenService:Create(content,TweenInfo.new(0.18),{TextTransparency=0}):Play()

    local dur=tonumber(opts.Duration) or 3
    local removed=false
    local function remove()
        if removed then return end
        removed=true
        TweenService:Create(card,TweenInfo.new(0.16,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{BackgroundTransparency=1,Position=UDim2.fromOffset(0,-10)}):Play()
        TweenService:Create(title,TweenInfo.new(0.12),{TextTransparency=1}):Play()
        TweenService:Create(content,TweenInfo.new(0.12),{TextTransparency=1}):Play()
        task.delay(0.18,function() if card and card.Parent then card:Destroy() end end)
    end
    close.MouseButton1Click:Connect(remove)
    TweenService:Create(bar,TweenInfo.new(dur,Enum.EasingStyle.Linear),{Size=UDim2.new(0,0,1,0)}):Play()
    task.delay(dur,remove)
end

function Library:Notification(message,duration,color)
    self:Notify({Title="TEL-AVIV",Content=tostring(message or ""),Duration=duration or 3})
end





return Library
