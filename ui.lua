-- Made by samet
-- Join for high quality UI Commissions
-- https://discord.gg/VhvTd5HV8d
-- @joestar._3

local Library do 
    local Workspace = game:GetService("Workspace")
    local UserInputService = game:GetService("UserInputService")
    local Players = game:GetService("Players")
    local HttpService = game:GetService("HttpService")
    local RunService = game:GetService("RunService")
    local GuiService = game:GetService("GuiService")
    local CoreGui = cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
    local TweenService = game:GetService("TweenService")
    local Lighting = game:GetService("Lighting")

    gethui = gethui or function()
        return CoreGui
    end

    local LocalPlayer = Players.LocalPlayer
    local Camera = Workspace.CurrentCamera
    local Mouse = LocalPlayer:GetMouse()

    local FromRGB = Color3.fromRGB
    local FromHSV = Color3.fromHSV
    local FromHex = Color3.fromHex

    local RGBSequence = ColorSequence.new
    local RGBSequenceKeypoint = ColorSequenceKeypoint.new
    local NumSequence = NumberSequence.new
    local NumSequenceKeypoint = NumberSequenceKeypoint.new

    local UDim2New = UDim2.new
    local UDimNew = UDim.new
    local UDim2FromOffset = UDim2.fromOffset
    local Vector2New = Vector2.new
    local Vector3New = Vector3.new

    local MathClamp = math.clamp
    local MathMax = math.max
    local MathFloor = math.floor
    local MathAbs = math.abs
    local MathSin = math.sin

    local TableInsert = table.insert
    local TableFind = table.find
    local TableRemove = table.remove
    local TableConcat = table.concat
    local TableClone = table.clone
    local TableUnpack = table.unpack

    local StringFormat = string.format
    local StringFind = string.find
    local StringGSub = string.gsub
    local StringLower = string.lower
    local StringLen = string.len

    local InstanceNew = Instance.new

    local RectNew = Rect.new

    local IsMobile = UserInputService.TouchEnabled or false

    Library = {
        Theme =  { },

        MenuKeybind = tostring(Enum.KeyCode.RightControl), 

        Flags = { },

        Tween = {
            Time = 0.3,
            Style = Enum.EasingStyle.Quad,
            Direction = Enum.EasingDirection.Out
        },

        FadeSpeed = 0.2,

        Folders = {
            Directory = "Samuraa1Hub",
            Configs = "Samuraa1Hub/Configs",
            Assets = "Samuraa1Hub/Assets",
        },

        Pages = { },
        Sections = { },
        Connections = { },
        Threads = { },
        ThemeMap = { },
        ThemeItems = { },
        OpenFrames = { },
        SetFlags = { },
        BlurInstances = {},
        KeybindRows = {},
        KeybindFlagListeners = {},
        Anonymous = false,
        _anonBinds = {},
        UnnamedConnections = 0,
        UnnamedFlags = 0,
        Holder = nil,
        NotifHolder = nil,
        UnusedHolder = nil,
        Font = nil
    }

    Library.__index = Library
    Library.Sections.__index = Library.Sections
    Library.Pages.__index = Library.Pages

    local Keys = {
        ["Unknown"]           = "Unknown",
        ["Backspace"]         = "Back",
        ["Tab"]               = "Tab",
        ["Clear"]             = "Clear",
        ["Return"]            = "Return",
        ["Pause"]             = "Pause",
        ["Escape"]            = "Escape",
        ["Space"]             = "Space",
        ["QuotedDouble"]      = '"',
        ["Hash"]              = "#",
        ["Dollar"]            = "$",
        ["Percent"]           = "%",
        ["Ampersand"]         = "&",
        ["Quote"]             = "'",
        ["LeftParenthesis"]   = "(",
        ["RightParenthesis"]  = " )",
        ["Asterisk"]          = "*",
        ["Plus"]              = "+",
        ["Comma"]             = ",",
        ["Minus"]             = "-",
        ["Period"]            = ".",
        ["Slash"]             = "`",
        ["Three"]             = "3",
        ["Seven"]             = "7",
        ["Eight"]             = "8",
        ["Colon"]             = ":",
        ["Semicolon"]         = ";",
        ["LessThan"]          = "<",
        ["GreaterThan"]       = ">",
        ["Question"]          = "?",
        ["Equals"]            = "=",
        ["At"]                = "@",
        ["LeftBracket"]       = "LeftBracket",
        ["RightBracket"]      = "RightBracked",
        ["BackSlash"]         = "BackSlash",
        ["Caret"]             = "^",
        ["Underscore"]        = "_",
        ["Backquote"]         = "`",
        ["LeftCurly"]         = "{",
        ["Pipe"]              = "|",
        ["RightCurly"]        = "}",
        ["Tilde"]             = "~",
        ["Delete"]            = "Delete",
        ["End"]               = "End",
        ["KeypadZero"]        = "Keypad0",
        ["KeypadOne"]         = "Keypad1",
        ["KeypadTwo"]         = "Keypad2",
        ["KeypadThree"]       = "Keypad3",
        ["KeypadFour"]        = "Keypad4",
        ["KeypadFive"]        = "Keypad5",
        ["KeypadSix"]         = "Keypad6",
        ["KeypadSeven"]       = "Keypad7",
        ["KeypadEight"]       = "Keypad8",
        ["KeypadNine"]        = "Keypad9",
        ["KeypadPeriod"]      = "KeypadP",
        ["KeypadDivide"]      = "KeypadD",
        ["KeypadMultiply"]    = "KeypadM",
        ["KeypadMinus"]       = "KeypadM",
        ["KeypadPlus"]        = "KeypadP",
        ["KeypadEnter"]       = "KeypadE",
        ["KeypadEquals"]      = "KeypadE",
        ["Insert"]            = "Insert",
        ["Home"]              = "Home",
        ["PageUp"]            = "PageUp",
        ["PageDown"]          = "PageDown",
        ["RightShift"]        = "RightShift",
        ["LeftShift"]         = "LeftShift",
        ["RightControl"]      = "RightControl",
        ["LeftControl"]       = "LeftControl",
        ["LeftAlt"]           = "LeftAlt",
        ["RightAlt"]          = "RightAlt"
    }

    local Themes = {
        ["Preset"] = {
            ["Background 2"] = FromRGB(10, 10, 12),
            ["Background"] = FromRGB(12, 12, 14),
            ["Text"] = FromRGB(235, 235, 235),
            ["Outline"] = FromRGB(25, 25, 28),
            ["Section Top"] = FromRGB(28, 27, 31),
            ["Section Background"] = FromRGB(10, 10, 12),
            ["Section Background 2"] = FromRGB(14, 14, 16),
            ["Accent"] = FromRGB(100, 149, 255),
            ["AccentGradient"] = FromRGB(70, 110, 200),
            ["Element"] = FromRGB(16, 16, 18)
        }
    }

    Library.Theme = TableClone(Themes["Preset"])
    Library.PresetTheme = TableClone(Themes["Preset"])
    Library._themeName = "Default"
    Library._themeFull = false
    Library._themeEffect = nil
    Library._halloween = { on = false, flakes = {} }

    local function AccentPalette(r, g, b, r2, g2, b2)
        return {
            Accent = FromRGB(r, g, b),
            AccentGradient = FromRGB(r2, g2, b2),
        }
    end

    Library.Palettes = {
        Default = AccentPalette(100, 149, 255, 70, 110, 200),
        Blue = AccentPalette(100, 149, 255, 70, 110, 200),
        Purple = AccentPalette(160, 100, 255, 120, 70, 200),
        Green = AccentPalette(80, 200, 120, 60, 160, 90),
        Red = AccentPalette(220, 80, 80, 180, 50, 50),
        Orange = AccentPalette(255, 160, 50, 220, 120, 30),
        Halloween = {
            Full = true,
            Effect = "Halloween",
            ["Background"] = FromRGB(22, 12, 8),
            ["Background 2"] = FromRGB(14, 8, 5),
            ["Text"] = FromRGB(255, 236, 220),
            ["Outline"] = FromRGB(78, 40, 18),
            ["Section Top"] = FromRGB(62, 30, 12),
            ["Section Background"] = FromRGB(28, 14, 8),
            ["Section Background 2"] = FromRGB(38, 18, 10),
            ["Accent"] = FromRGB(255, 132, 36),
            ["AccentGradient"] = FromRGB(186, 62, 14),
            ["Element"] = FromRGB(46, 24, 12),
        },
    }

    Library.ListPaletteNames = function(self)
        local list = {}
        for name in self.Palettes do
            TableInsert(list, name)
        end
        table.sort(list)
        return list
    end

    for Index, Value in Library.Folders do 
        if not isfolder(Value) then
            makefolder(Value)
        end
    end

    local Tween = { } do
        Tween.__index = Tween

        Tween.Create = function(self, Item, Info, Goal, IsRawItem)
            if not Item then return setmetatable({}, Tween) end
            local ok, inst = pcall(function() return IsRawItem and Item or Item.Instance end)
            if not ok or not inst then return setmetatable({}, Tween) end
            Item = inst

            Info = Info or TweenInfo.new(Library.Tween.Time, Library.Tween.Style, Library.Tween.Direction)

            local tweenObj
            local ok2 = pcall(function()
                tweenObj = TweenService:Create(Item, Info, Goal)
            end)
            if not ok2 or not tweenObj then return setmetatable({}, Tween) end

            local NewTween = {
                Tween = tweenObj,
                Info = Info,
                Goal = Goal,
                Item = Item
            }

            NewTween.Tween:Play()
            setmetatable(NewTween, Tween)
            return NewTween
        end

        Tween.GetProperty = function(self, Item)
            Item = Item or self.Item 
            if Item:IsA("Frame") then return { "BackgroundTransparency" }
            elseif Item:IsA("TextLabel") or Item:IsA("TextButton") then return { "TextTransparency", "BackgroundTransparency" }
            elseif Item:IsA("ImageLabel") or Item:IsA("ImageButton") then return { "BackgroundTransparency", "ImageTransparency" }
            elseif Item:IsA("ScrollingFrame") then return { "BackgroundTransparency", "ScrollBarImageTransparency" }
            elseif Item:IsA("TextBox") then return { "TextTransparency", "BackgroundTransparency" }
            elseif Item:IsA("UIStroke") then return { "Transparency" }
            end
        end

        Tween.FadeItem = function(self, Item, Property, Visibility, Speed)
            local Item = Item or self.Item 
            local OldTransparency = Item[Property]
            Item[Property] = Visibility and 1 or OldTransparency

            local NewTween = Tween:Create(Item, TweenInfo.new(Speed or Library.Tween.Time, Library.Tween.Style, Library.Tween.Direction), {
                [Property] = Visibility and OldTransparency or 1
            }, true)

            Library:Connect(NewTween.Tween.Completed, function()
                if not Visibility then 
                    task.wait()
                    Item[Property] = OldTransparency
                end
            end)
            return NewTween
        end
    end

    local Instances = { } do
        Instances.__index = Instances

        Instances.Create = function(self, Class, Properties)
            local NewItem = {
                Instance = InstanceNew(Class),
                Properties = Properties,
                Class = Class
            }
            setmetatable(NewItem, Instances)
            for Property, Value in NewItem.Properties do
                NewItem.Instance[Property] = Value
            end
            return NewItem
        end

        Instances.AddToTheme = function(self, Properties)
            if not self.Instance then return end
            Library:AddToTheme(self, Properties)
        end

        Instances.ChangeItemTheme = function(self, Properties)
            if not self.Instance then return end
            Library:ChangeItemTheme(self, Properties)
        end

        Instances.Connect = function(self, Event, Callback, Name)
            if not self.Instance then return end
            if not self.Instance[Event] then return end
            return Library:Connect(self.Instance[Event], Callback, Name)
        end

        Instances.Tween = function(self, Info, Goal)
            if not self.Instance then return end
            return Tween:Create(self, Info, Goal)
        end

        Instances.Clean = function(self)
            if not self.Instance then return end
            self.Instance:Destroy()
            self = nil
        end

        Instances.OnHover = function(self, Function)
            if not self.Instance then return end
            return Library:Connect(self.Instance.MouseEnter, Function)
        end

        Instances.OnHoverLeave = function(self, Function)
            if not self.Instance then return end
            return Library:Connect(self.Instance.MouseLeave, Function)
        end
    end

    local CustomFont = { } do
        local FontId = "rbxassetid://12187365364"
        local Thin = Font.new(FontId, Enum.FontWeight.Thin, Enum.FontStyle.Normal)
        local ExtraLight = Font.new(FontId, Enum.FontWeight.ExtraLight, Enum.FontStyle.Normal)
        local SemiBold = Font.new(FontId, Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
        local Medium = Font.new(FontId, Enum.FontWeight.Medium, Enum.FontStyle.Normal)
        local Regular = Font.new(FontId, Enum.FontWeight.Regular, Enum.FontStyle.Normal)
        local Light = Font.new(FontId, Enum.FontWeight.Light, Enum.FontStyle.Normal)
        local Bold = Font.new(FontId, Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        local ExtraBold = Font.new(FontId, Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal)

        Library.Fonts = {
            ["ExtraBold"] = ExtraBold, ["Bold"] = Bold, ["SemiBold"] = SemiBold,
            ["Medium"] = Medium, ["Regular"] = Regular, ["Light"] = Light,
            ["ExtraLight"] = ExtraLight, ["Thin"] = Thin,
        }
        Library.Font = Light
    end

    do
        local IconModule
        pcall(function()
            IconModule = loadstring(game:HttpGet("https://molto.pages.dev/source.lua"))()
        end)

        local function SplitIcon(Spec)
            local colon = StringFind(Spec, ":", 1, true)
            if not colon or colon <= 1 then return Spec, "lucide" end
            return string.sub(Spec, colon + 1), "lucide"
        end

        Library.GetIcon = function(self, IconName, Provider)
            if not IconModule or type(IconName) ~= "string" or IconName == "" then return nil end
            local name, provider = SplitIcon(IconName)
            local ok, icon = pcall(IconModule.GetAsset, name, provider)
            if ok and type(icon) == "table" and icon.Url then return icon end
            return nil
        end

        Library.ResolveIcon = function(self, Icon)
            if not Icon then return nil, nil, nil end
            if type(Icon) == "table" then return Icon.Url, Icon.ImageRectOffset or Vector2New(0, 0), Icon.ImageRectSize or Vector2New(0, 0) end
            if tonumber(Icon) then return "rbxassetid://" .. tostring(Icon), Vector2New(0, 0), Vector2New(0, 0) end
            if type(Icon) == "string" then
                if StringFind(Icon, "rbxassetid://") or StringFind(Icon, "http") then return Icon, Vector2New(0, 0), Vector2New(0, 0) end
                local name, provider = SplitIcon(Icon)
                local iconData = Library:GetIcon(name, provider)
                if iconData then return iconData.Url, iconData.ImageRectOffset or Vector2New(0, 0), iconData.ImageRectSize or Vector2New(0, 0) end
            end
            return nil, nil, nil
        end

        Library.SetIcon = function(self, ImageLabel, Icon)
            local url, offset, size = Library:ResolveIcon(Icon)
            if url then
                ImageLabel.Image = url
                if offset then ImageLabel.ImageRectOffset = offset end
                if size and size.X > 0 then ImageLabel.ImageRectSize = size else
                    ImageLabel.ImageRectOffset = Vector2New(0, 0)
                    ImageLabel.ImageRectSize = Vector2New(0, 0)
                end
            end
        end
    end

    Library.Holder = Instances:Create("ScreenGui", { Parent = gethui(), Name = "\0", ZIndexBehavior = Enum.ZIndexBehavior.Global, DisplayOrder = 80, ResetOnSpawn = false })
    Library.UnusedHolder = Instances:Create("ScreenGui", { Parent = gethui(), Name = "\0", ZIndexBehavior = Enum.ZIndexBehavior.Global, Enabled = false, ResetOnSpawn = false })
    Library.NotifHolder = Instances:Create("Frame", { Parent = Library.Holder.Instance, Name = "\0", BackgroundTransparency = 1, Size = UDim2New(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X })
    Instances:Create("UIListLayout", { Parent = Library.NotifHolder.Instance, Name = "\0", Padding = UDimNew(0, 12), SortOrder = Enum.SortOrder.LayoutOrder })
    Instances:Create("UIPadding", { Parent = Library.NotifHolder.Instance, Name = "\0", PaddingTop = UDimNew(0, 12), PaddingBottom = UDimNew(0, 12), PaddingRight = UDimNew(0, 12), PaddingLeft = UDimNew(0, 12) })

    Library.Round = function(self, Number, Float)
        local Multiplier = 1 / (Float or 1)
        return MathFloor(Number * Multiplier) / Multiplier
    end

    Library.Thread = function(self, Function)
        local NewThread = coroutine.create(Function)
        coroutine.wrap(function() coroutine.resume(NewThread) end)()
        TableInsert(self.Threads, NewThread)
        return NewThread
    end
    
    Library.SafeCall = function(self, Function, ...)
        local Arguements = { ... }
        local Success, Result = pcall(Function, TableUnpack(Arguements))
        if not Success then return false end
        return Success
    end

    Library.Connect = function(self, Event, Callback, Name)
        Name = Name or StringFormat("connection_number_%s_%s", self.UnnamedConnections + 1, HttpService:GenerateGUID(false))
        local NewConnection = { Event = Event, Callback = Callback, Name = Name, Connection = nil }
        Library:Thread(function() NewConnection.Connection = Event:Connect(Callback) end)
        TableInsert(self.Connections, NewConnection)
        return NewConnection
    end

    Library.NextFlag = function(self)
        local FlagNumber = self.UnnamedFlags + 1
        return StringFormat("flag_number_%s_%s", FlagNumber, HttpService:GenerateGUID(false))
    end

    Library.AddToTheme = function(self, Item, Properties)
        Item = Item.Instance or Item 
        local ThemeData = { Item = Item, Properties = Properties }
        for Property, Value in ThemeData.Properties do
            if type(Value) == "string" then Item[Property] = self.Theme[Value] else Item[Property] = Value() end
        end
        TableInsert(self.ThemeItems, ThemeData)
        self.ThemeMap[Item] = ThemeData
    end

    Library.ChangeItemTheme = function(self, Item, Properties)
        Item = Item.Instance or Item
        if not self.ThemeMap[Item] then return end
        self.ThemeMap[Item].Properties = Properties
    end

    Library.ChangeTheme = function(self, Theme, Color)
        self.Theme[Theme] = Color
        for _, Item in self.ThemeItems do
            for Property, Value in Item.Properties do
                if type(Value) == "string" and Value == Theme then Item.Item[Property] = Color
                elseif type(Value) == "function" then Item.Item[Property] = Value() end
            end
        end
    end

    Library.Window = function(self, Data)
        Data = Data or { }
        local Window = { Name = Data.Name or "Window", SubName = Data.SubName or "Subtitle", Logo = Data.Logo or "1l20959262762131", Pages = { }, Items = { }, IsOpen = false }

        local Items = { } do
            local WINDOW_CORNER_RADIUS = 14
            Items["MainFrame"] = Instances:Create("Frame", {
                Parent = Library.Holder.Instance, Name = "\0", AnchorPoint = Vector2New(0.5, 0.5),
                BackgroundTransparency = 0.12, Position = UDim2New(0.5, 0, 0.5, 0),
                Size = Data.Size or UDim2New(0, 940, 0, 860), ZIndex = 2, BorderSizePixel = 0, ClipsDescendants = true,
                BackgroundColor3 = FromRGB(27, 25, 29)
            })  Items["MainFrame"]:AddToTheme({BackgroundColor3 = "Background"})
            Instances:Create("UICorner", { Parent = Items["MainFrame"].Instance, CornerRadius = UDimNew(0, WINDOW_CORNER_RADIUS) })
            
            Library.MainFrame = Items["MainFrame"]

            Items["LeftTabs"] = Instances:Create("Frame", {
                Parent = Items["MainFrame"].Instance, Name = "\0", Position = UDim2New(0, 0, 0, 55),
                BackgroundTransparency = 0.12, Size = UDim2New(0, 225, 1, -55), ZIndex = 2, BorderSizePixel = 0, ClipsDescendants = true,
                BackgroundColor3 = FromRGB(27, 25, 29)
            })  Items["LeftTabs"]:AddToTheme({BackgroundColor3 = "Background"})
            Instances:Create("UICorner", { Parent = Items["LeftTabs"].Instance, CornerRadius = UDimNew(0, WINDOW_CORNER_RADIUS) })

            Items["LeftTabsScroll"] = Instances:Create("ScrollingFrame", {
                Parent = Items["LeftTabs"].Instance, Name = "\0", BackgroundTransparency = 1, Size = UDim2New(1, -2, 1, -2),
                Position = UDim2New(0, 1, 0, 1), CanvasSize = UDim2New(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y,
                ScrollBarThickness = 5, ClipsDescendants = true, ZIndex = 3
            })
            Instances:Create("UIListLayout", { Parent = Items["LeftTabsScroll"].Instance, Name = "\0", Padding = UDimNew(0, 12), SortOrder = Enum.SortOrder.LayoutOrder })
            Instances:Create("UIPadding", { Parent = Items["LeftTabsScroll"].Instance, Name = "\0", PaddingTop = UDimNew(0, 8), PaddingBottom = UDimNew(0, 12), PaddingRight = UDimNew(0, 12), PaddingLeft = UDimNew(0, 12) })

            local Gui = Items["MainFrame"].Instance
            local Dragging = false 
            local DragStart, StartPosition 

            Items["MainFrame"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = true
                    DragStart = Input.Position
                    StartPosition = Gui.Position
                    Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then Dragging = false end
                    end)
                end
            end)
            Library:Connect(UserInputService.InputChanged, function(Input)
                if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
                    local DragDelta = Input.Position - DragStart
                    Items["MainFrame"].Instance.Position = UDim2New(StartPosition.X.Scale, StartPosition.X.Offset + DragDelta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + DragDelta.Y)
                end
            end)

            -- ═══════════════════════════════════════════════════════════
            -- ⚡ VH LOGO (Ganti Logo default)
            -- ═══════════════════════════════════════════════════════════
            Items["Logo"] = Instances:Create("Frame", {
                Parent = Items["MainFrame"].Instance, Name = "VH_Logo", BackgroundColor3 = FromRGB(15, 15, 20),
                BorderSizePixel = 0, Size = UDim2New(0, 36, 0, 36), Position = UDim2New(0, 12, 0, 12), ZIndex = 2,
            })
            Instances:Create("UICorner", { Parent = Items["Logo"].Instance, CornerRadius = UDimNew(0, 7) })
            Instances:Create("UIGradient", {
                Parent = Items["Logo"].Instance, Rotation = 135,
                Color = RGBSequence{ RGBSequenceKeypoint(0, FromRGB(255, 200, 40)), RGBSequenceKeypoint(0.5, FromRGB(255, 140, 20)), RGBSequenceKeypoint(1, FromRGB(200, 80, 0)) },
            })
            Instances:Create("UIStroke", { Parent = Items["Logo"].Instance, Color = FromRGB(255, 180, 40), Thickness = 1.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Transparency = 0.2 })

            local lightningIcon = Instances:Create("ImageLabel", {
                Parent = Items["Logo"].Instance, BackgroundTransparency = 1, Size = UDim2New(0, 22, 0, 22),
                AnchorPoint = Vector2New(0.5, 0.5), Position = UDim2New(0.5, 0, 0.4, 0),
                ImageColor3 = FromRGB(255, 255, 255), ZIndex = 4, ScaleType = Enum.ScaleType.Fit,
            })
            Library:SetIcon(lightningIcon.Instance, "zap")
            if lightningIcon.Instance.Image == "" then lightningIcon.Instance.Image = "rbxassetid://7733788127" end

            Instances:Create("TextLabel", {
                Parent = Items["Logo"].Instance, BackgroundTransparency = 1, Size = UDim2New(1, 0, 0.4, 0),
                Position = UDim2New(0, 0, 0.6, 0), FontFace = Library.Fonts.ExtraBold, Text = "VH",
                TextSize = 13, TextColor3 = FromRGB(255, 255, 255), TextStrokeColor3 = FromRGB(0, 0, 0),
                TextStrokeTransparency = 0.5, ZIndex = 4,
            })

            Items["Title"] = Instances:Create("TextLabel", {
                Parent = Items["MainFrame"].Instance, Name = "\0", FontFace = Library.Font, TextColor3 = FromRGB(240, 240, 240),
                Text = Window.Name, Size = UDim2New(0, 0, 0, 15), BackgroundTransparency = 1, Position = UDim2New(0, 52, 0, 13),
                ZIndex = 2, TextSize = 16,
            })  Items["Title"]:AddToTheme({TextColor3 = "Text"})
            
            Items["SubTitle"] = Instances:Create("TextLabel", {
                Parent = Items["MainFrame"].Instance, Name = "\0", FontFace = Library.Font, TextColor3 = FromRGB(240, 240, 240),
                TextTransparency = 0.4, Text = Window.SubName, Size = UDim2New(0, 0, 0, 15), BackgroundTransparency = 1,
                Position = UDim2New(0, 52, 0, 30), ZIndex = 2, TextSize = 14,
            })  Items["SubTitle"]:AddToTheme({TextColor3 = "Text"})

            Items["Content"] = Instances:Create("Frame", {
                Parent = Items["MainFrame"].Instance, Name = "\0", BackgroundTransparency = 0.75, Position = UDim2New(0, 225, 0, 55),
                Size = UDim2New(1, -225, 1, -55), ZIndex = 2, BorderSizePixel = 0, ClipsDescendants = true, BackgroundColor3 = FromRGB(27, 25, 29)
            })  Items["Content"]:AddToTheme({BackgroundColor3 = "Background"})
            Instances:Create("UICorner", { Parent = Items["Content"].Instance, CornerRadius = UDimNew(0, WINDOW_CORNER_RADIUS) })

            Items["CloseButton"] = Instances:Create("TextButton", {
                Parent = Items["MainFrame"].Instance, Name = "\0", Text = "", AutoButtonColor = false,
                AnchorPoint = Vector2New(1, 0), Position = UDim2New(1, -14, 0, 11), Size = UDim2New(0, 32, 0, 32),
                BackgroundTransparency = 0.2, ZIndex = 2, BackgroundColor3 = FromRGB(27, 25, 29)
            })  Items["CloseButton"]:AddToTheme({BackgroundColor3 = "Element"})
            Instances:Create("UICorner", { Parent = Items["CloseButton"].Instance, CornerRadius = UDimNew(0, 7) })
            Items["CloseIcon"] = Instances:Create("ImageLabel", {
                Parent = Items["CloseButton"].Instance, ImageColor3 = FromRGB(240, 240, 240), Size = UDim2New(0, 11, 0, 11),
                AnchorPoint = Vector2New(0.5, 0.5), Image = "rbxassetid://130510492706892", BackgroundTransparency = 1,
                Position = UDim2New(0.5, 0, 0.5, 0), ZIndex = 3,
            })  Items["CloseIcon"]:AddToTheme({ImageColor3 = "Text"})
            Items["CloseButton"]:Connect("MouseButton1Down", function() Library:Unload() end)
            
            Window.Items = Items
        end
        
        function Window:SetOpen(Bool)
            Window.IsOpen = Bool
            Items["MainFrame"].Instance.Visible = Bool
        end
        function Window:Toggle() Window:SetOpen(not Window.IsOpen) end

        return setmetatable(Window, Library)
    end

    Library.Page = function(self, Data)
        Data = Data or { }
        local Page = { Window = self, Name = Data.Name or "Page", Icon = Data.Icon or "100050851789190", Columns = Data.Columns or 2, Items = { }, ColumnsData = { }, Sections = { }, Active = false }

        local Items = { } do
            Items["Inactive"] = Instances:Create("TextButton", {
                Parent = Page.Window.Items["LeftTabsScroll"].Instance, Name = "\0", Text = "", AutoButtonColor = false,
                BackgroundTransparency = 1, Size = UDim2New(0, 200, 0, 40), ZIndex = 2
            })  Items["Inactive"]:AddToTheme({BackgroundColor3 = "Accent"})
            Instances:Create("UICorner", { Parent = Items["Inactive"].Instance, CornerRadius = UDimNew(0, 5) })
            Items["Icon"] = Instances:Create("ImageLabel", {
                Parent = Items["Inactive"].Instance, ImageColor3 = FromRGB(255, 255, 255), Size = UDim2New(0, 18, 0, 18),
                AnchorPoint = Vector2New(0, 0.5), BackgroundTransparency = 1, Position = UDim2New(0, 18, 0.5, 0), ZIndex = 2,
            })  Library:SetIcon(Items["Icon"].Instance, Page.Icon)
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Inactive"].Instance, FontFace = Library.Font, TextColor3 = FromRGB(240, 240, 240),
                Text = Page.Name, Size = UDim2New(0, 0, 0, 15), BackgroundTransparency = 1, Position = UDim2New(0, 44, 0.5, 0), ZIndex = 2, TextSize = 14,
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})

            Items["Page"] = Instances:Create("CanvasGroup", {
                Parent = Library.UnusedHolder.Instance, Name = "\0", Visible = false, BackgroundTransparency = 1,
                Size = UDim2New(1, 0, 1, 0), ZIndex = 2, Position = UDim2New(0, 0, 0, 60)
            })
            Instances:Create("UIListLayout", {
                Parent = Items["Page"].Instance, Name = "\0", FillDirection = Enum.FillDirection.Horizontal,
                HorizontalFlex = Enum.UIFlexAlignment.Fill, Padding = UDimNew(0, 10), VerticalFlex = Enum.UIFlexAlignment.Fill
            })
            Instances:Create("UIPadding", { Parent = Items["Page"].Instance, Name = "\0", PaddingTop = UDimNew(0, 10), PaddingBottom = UDimNew(0, 10), PaddingRight = UDimNew(0, 10), PaddingLeft = UDimNew(0, 10) })

            for Index = 1, Page.Columns do 
                local NewColumn = Instances:Create("ScrollingFrame", {
                    Parent = Items["Page"].Instance, Name = "\0", Active = true, AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    ScrollBarThickness = 0, BackgroundTransparency = 1, Size = UDim2New(0, 100, 0, 100), ZIndex = 2
                })
                Instances:Create("UIListLayout", { Parent = NewColumn.Instance, Name = "\0", Padding = UDimNew(0, 5), SortOrder = Enum.SortOrder.LayoutOrder })
                Page.ColumnsData[Index] = NewColumn
            end
            Page.Items = Items
        end

        function Page:Turn(Bool)
            Page.Active = Bool 
            if Page.Active then
                Items["Page"].Instance.Visible = true
                Items["Page"].Instance.Parent = Page.Window.Items["Content"].Instance
                Items["Inactive"]:Tween(nil, {BackgroundTransparency = 0.88})
            else
                Items["Inactive"]:Tween(nil, {BackgroundTransparency = 1})
                Items["Page"].Instance.Visible = false
                Items["Page"].Instance.Parent = Library.UnusedHolder.Instance
            end
        end

        Items["Inactive"]:Connect("MouseButton1Down", function()
            for _, Value in Page.Window.Pages do 
                if Value ~= Page then Value:Turn(false) end
            end
            Page:Turn(true)
        end)

        if #Page.Window.Pages == 0 then Page:Turn(true) end
        TableInsert(Page.Window.Pages, Page)
        return setmetatable(Page, Library.Pages)
    end

    Library.Pages.Section = function(self, Data)
        Data = Data or { }
        local Section = { Window = self.Window, Page = self, Name = Data.Name or "Section", Icon = Data.Icon or "123944728972740", Side = Data.Side or 1, Items = { }, Elements = { } }
        local Items = { } do
            Items["Section"] = Instances:Create("Frame", {
                Parent = Section.Page.ColumnsData[Section.Side].Instance, Name = "\0", BackgroundTransparency = 0.65,
                Size = UDim2New(1, 0, 0, 45), ZIndex = 2, AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = FromRGB(29, 28, 32)
            })  Items["Section"]:AddToTheme({BackgroundColor3 = "Section Background 2"})
            Instances:Create("UICorner", { Parent = Items["Section"].Instance, CornerRadius = UDimNew(0, 4) })
            
            Items["Top"] = Instances:Create("Frame", {
                Parent = Items["Section"].Instance, Name = "\0", BackgroundTransparency = 0.65,
                Size = UDim2New(1, 0, 0, 55), ZIndex = 2, BackgroundColor3 = FromRGB(31, 31, 36)
            })  Items["Top"]:AddToTheme({BackgroundColor3 = "Outline"})
            
            Items["Icon"] = Instances:Create("ImageLabel", {
                Parent = Items["Top"].Instance, ImageColor3 = FromRGB(255, 255, 255), Size = UDim2New(0, 21, 0, 20),
                AnchorPoint = Vector2New(0, 0.5), BackgroundTransparency = 1, Position = UDim2New(0, 15, 0.5, 0), ZIndex = 2,
            })  Library:SetIcon(Items["Icon"].Instance, Section.Icon)
            
            Items["Title"] = Instances:Create("TextLabel", {
                Parent = Items["Top"].Instance, FontFace = Library.Font, TextColor3 = FromRGB(248, 248, 248),
                Text = Section.Name, Size = UDim2New(0, 0, 0, 15), BackgroundTransparency = 1, Position = UDim2New(0, 50, 0, 10), ZIndex = 2, TextSize = 15,
            })  Items["Title"]:AddToTheme({TextColor3 = "Text"})
            
            Items["Background"] = Instances:Create("Frame", {
                Parent = Items["Section"].Instance, Name = "\0", BackgroundTransparency = 0.65,
                Position = UDim2New(0, 1, 0, 55), Size = UDim2New(1, -2, 1, -56), ZIndex = 2, BackgroundColor3 = FromRGB(24, 22, 25)
            })  Items["Background"]:AddToTheme({BackgroundColor3 = "Section Background"})
            
            Items["Content"] = Instances:Create("Frame", {
                Parent = Items["Background"].Instance, Name = "\0", BackgroundTransparency = 1,
                Position = UDim2New(0, 12, 0, 15), Size = UDim2New(1, -24, 0, 0), AutomaticSize = Enum.AutomaticSize.Y
            })
            Instances:Create("UIListLayout", { Parent = Items["Content"].Instance, Name = "\0", Padding = UDimNew(0, 5), SortOrder = Enum.SortOrder.LayoutOrder })
            Instances:Create("UIPadding", { Parent = Items["Content"].Instance, Name = "\0", PaddingBottom = UDimNew(0, 10) })
            Section.Items = Items
        end

        function Section:TweenElements(Bool)
            for Index, Value in Section.Elements do Value:RefreshPosition(Bool) end
        end

        Section.Page.Sections[Section.Name] = Section
        return setmetatable(Section, Library.Sections)
    end

    Library.Sections.Toggle = function(self, Data)
        Data = Data or { }
        local Toggle = { Window = self.Window, Page = self.Page, Section = self, Name = Data.Name or "Toggle", Flag = Data.Flag or Library:NextFlag(), Default = Data.Default or false, Callback = Data.Callback or function() end, Value = false }
        local Items = { } do 
            Items["Toggle"] = Instances:Create("TextButton", {
                Parent = Toggle.Section.Items["Content"].Instance, Name = "\0", Text = "", AutoButtonColor = false,
                BackgroundTransparency = 1, Size = UDim2New(1, 0, 0, 18), ZIndex = 2
            })
            Items["Indicator"] = Instances:Create("Frame", {
                Parent = Items["Toggle"].Instance, Size = UDim2New(0, 18, 0, 18), ZIndex = 2, BackgroundColor3 = FromRGB(124, 163, 255)
            })  Items["Indicator"]:AddToTheme({BackgroundColor3 = "Element"})
            Instances:Create("UICorner", { Parent = Items["Indicator"].Instance, CornerRadius = UDimNew(0, 3) })
            
            Items["Accent"] = Instances:Create("Frame", {
                Parent = Items["Indicator"].Instance, Size = UDim2New(0, 0, 0, 0), ZIndex = 2, BackgroundTransparency = 1,
                BackgroundColor3 = FromRGB(255, 255, 255), AnchorPoint = Vector2New(0.5, 0.5), Position = UDim2New(0.5, 0, 0.5, 0)
            })
            Instances:Create("UICorner", { Parent = Items["Accent"].Instance, CornerRadius = UDimNew(0, 3) })
            
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Toggle"].Instance, FontFace = Library.Font, TextColor3 = FromRGB(240, 240, 240),
                TextTransparency = 0.3, Text = Toggle.Name, Size = UDim2New(0, 0, 0, 15), BackgroundTransparency = 1, Position = UDim2New(0, 24, 0, 0), ZIndex = 2, TextSize = 14,
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIGradient", { Parent = Items["Accent"].Instance, Rotation = -115, Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(143, 143, 143))} }):AddToTheme({Color = function() return RGBSequence{RGBSequenceKeypoint(0, Library.Theme.Accent), RGBSequenceKeypoint(1, Library.Theme.AccentGradient)} end})
        end

        function Toggle:Set(Value, SkipCallback)
            Toggle.Value = Value 
            Library.Flags[Toggle.Flag] = Value 
            if Toggle.Value then 
                Items["Accent"]:Tween(nil, {BackgroundTransparency = 0, Size = UDim2New(1, 0, 1, 0)})
            else
                Items["Accent"]:Tween(nil, {BackgroundTransparency = 1, Size = UDim2New(0, 0, 0, 0)})
            end
            if Toggle.Callback and not SkipCallback then Library:SafeCall(Toggle.Callback, Toggle.Value) end
        end

        function Toggle:RefreshPosition(Bool) end

        Items["Toggle"]:Connect("InputBegan", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then 
                Toggle:Set(not Toggle.Value)
            end
        end)

        Toggle:Set(Toggle.Default, true)
        Library.SetFlags[Toggle.Flag] = function(Value) Toggle:Set(Value) end
        Toggle.Section.Elements[#Toggle.Section.Elements+1] = Toggle
        return Toggle 
    end
    
    Library.Sections.Slider = function(self, Data)
        Data = Data or { }
        local Slider = { Window = self.Window, Page = self.Page, Section = self, Name = Data.Name or "Slider", Flag = Data.Flag or Library:NextFlag(), Min = Data.Min or 0, Default = Data.Default or 0, Max = Data.Max or 100, Suffix = Data.Suffix or "", Decimals = Data.Decimals or 1, Callback = Data.Callback or function() end, Value = 0 }
        local Items = { } do 
            Items["Slider"] = Instances:Create("Frame", { Parent = Slider.Section.Items["Content"].Instance, Name = "\0", BackgroundTransparency = 1, Size = UDim2New(1, 0, 0, 35) })
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Slider"].Instance, FontFace = Library.Font, TextColor3 = FromRGB(240, 240, 240), TextTransparency = 0.3,
                Text = Slider.Name, Size = UDim2New(0, 0, 0, 15), BackgroundTransparency = 1, Position = UDim2New(0, 0, 0, 0), ZIndex = 2, TextSize = 14,
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})
            Items["RealSlider"] = Instances:Create("TextButton", {
                Parent = Items["Slider"].Instance, Name = "\0", Text = "", AutoButtonColor = false,
                AnchorPoint = Vector2New(0, 1), Position = UDim2New(0, 20, 1, -3), Size = UDim2New(1, -40, 0, 7), ZIndex = 2, BackgroundColor3 = FromRGB(27, 26, 29)
            })  Items["RealSlider"]:AddToTheme({BackgroundColor3 = "Element"})
            Instances:Create("UICorner", { Parent = Items["RealSlider"].Instance, Name = "\0" })
            Items["Accent"] = Instances:Create("Frame", { Parent = Items["RealSlider"].Instance, Name = "\0", Size = UDim2New(0.5, 0, 1, 0), ZIndex = 2, BackgroundColor3 = Library.Theme.Accent })  Items["Accent"]:AddToTheme({BackgroundColor3 = "Accent"})
            Instances:Create("UICorner", { Parent = Items["Accent"].Instance, Name = "\0" })
            Items["Value"] = Instances:Create("TextBox", {
                Parent = Items["Slider"].Instance, Name = "\0", FontFace = Library.Font, TextColor3 = FromRGB(240, 240, 240), TextTransparency = 0.3,
                Text = "0", Size = UDim2New(0, 52, 0, 15), AnchorPoint = Vector2New(1, 0), BackgroundTransparency = 1, Position = UDim2New(1, 0, 0, 0), ZIndex = 2, TextSize = 14, ClearTextOnFocus = false, TextXAlignment = Enum.TextXAlignment.Right,
            })  Items["Value"]:AddToTheme({TextColor3 = "Text"})
        end
        function Slider:RefreshPosition() end
        function Slider:Set(Value, SkipCallback)
            Slider.Value = Library:Round(MathClamp(Value, Slider.Min, Slider.Max), Slider.Decimals)
            Library.Flags[Slider.Flag] = Slider.Value
            Items["Accent"]:Tween(nil, {Size = UDim2New((Slider.Value - Slider.Min) / (Slider.Max - Slider.Min), 0, 1, 0)})
            Items["Value"].Instance.Text = StringFormat("%s%s", Slider.Value, Slider.Suffix)
            if Slider.Callback and not SkipCallback then Library:SafeCall(Slider.Callback, Slider.Value) end
        end
        local InputChanged 
        Items["RealSlider"]:Connect("InputBegan", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                local SizeX = (Input.Position.X - Items["RealSlider"].Instance.AbsolutePosition.X) / Items["RealSlider"].Instance.AbsoluteSize.X
                Slider:Set(((Slider.Max - Slider.Min) * SizeX) + Slider.Min)
                InputChanged = UserInputService.InputChanged:Connect(function(Inp)
                    if Inp.UserInputType == Enum.UserInputType.MouseMovement or Inp.UserInputType == Enum.UserInputType.Touch then
                        local SX = (Inp.Position.X - Items["RealSlider"].Instance.AbsolutePosition.X) / Items["RealSlider"].Instance.AbsoluteSize.X
                        Slider:Set(((Slider.Max - Slider.Min) * SX) + Slider.Min)
                    end
                end)
                Input.Changed:Connect(function()
                    if Input.UserInputState == Enum.UserInputState.End then
                        if InputChanged then InputChanged:Disconnect() end
                    end
                end)
            end
        end)
        Slider:Set(Slider.Default, true)
        Library.SetFlags[Slider.Flag] = function(Value) Slider:Set(Value) end
        Slider.Section.Elements[#Slider.Section.Elements+1] = Slider
        return Slider 
    end

    Library.Unload = function(self)
        for Index, Value in self.Connections do Value.Connection:Disconnect() end
        if self.Holder then self.Holder:Clean() end
        Library = nil 
        getgenv().Library = nil
    end
end

getgenv().Library = Library

-- ══════════════════════════════════════════════════════════════
-- UI CLIMB FOR ANIMAL
-- ══════════════════════════════════════════════════════════════

local Window = Library:Window({
    Name = "VRILZHUB",
    SubName = "Climb For Animal",
})

local FarmPage = Window:Page({ Name = "Farm", Icon = "zap" })
local FarmSec = FarmPage:Section({ Name = "Auto Farm", Side = 1 })

FarmSec:Toggle({
    Name = "Auto Hatch",
    Flag = "AutoHatch",
    Default = false,
    Callback = function(v)
        if _G.VRILZ_Features and _G.VRILZ_Features.setAutoHatch then _G.VRILZ_Features.setAutoHatch(v) end
    end,
})

FarmSec:Toggle({
    Name = "Auto Steal",
    Flag = "AutoSteal",
    Default = false,
    Callback = function(v)
        if _G.VRILZ_Features and _G.VRILZ_Features.setAutoSteal then _G.VRILZ_Features.setAutoSteal(v) end
    end,
})

local MiscPage = Window:Page({ Name = "Misc", Icon = "settings" })
local MiscSec = MiscPage:Section({ Name = "Player", Side = 1 })

MiscSec:Slider({
    Name = "WalkSpeed",
    Flag = "Speed",
    Min = 16,
    Max = 300,
    Default = 16,
    Callback = function(v)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then char.Humanoid.WalkSpeed = v end
    end,
})

return Library
