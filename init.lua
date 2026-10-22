--============================================================
-- RUMI HUB — Main Script (init.lua)
-- Owner: ItzShehryarOG & Shify
-- Production-ready key system + universal hub
--============================================================

-- ============================================================
-- SECTION 1: SERVICES & SHARED STATE
-- ============================================================
local Players = game:GetService("Players")
local UIS     = game:GetService("UserInputService")
local RS      = game:GetService("RunService")
local LT      = game:GetService("Lighting")
local TS      = game:GetService("TeleportService")
local HS      = game:GetService("HttpService")
local VU      = game:GetService("VirtualUser")
local WS      = workspace

local LP = Players.LocalPlayer
local PG = LP:WaitForChild("PlayerGui")

-- Key system configuration
local KEY_CODE     = "RUMI_VIP_2026"
local KEY_LINK     = "https://linkvertise.com/rumihub"
local DISCORD_LINK = "https://discord.gg/rumihub"

-- ============================================================
-- SECTION 2: LIGHTWEIGHT TOAST (used before framework loads)
-- ============================================================
local function quickNotify(title, content, color, duration)
    local sg = PG:FindFirstChild("RumiKeyNotif") or Instance.new("ScreenGui")
    sg.Name = "RumiKeyNotif"
    sg.ResetOnSpawn = false
    sg.DisplayOrder = 1000000
    sg.IgnoreGuiInset = true
    sg.Parent = PG

    local f = Instance.new("Frame")
    f.Size = UDim2.fromOffset(300, 64)
    f.Position = UDim2.new(0.5, -150, 0, 20)
    f.BackgroundColor3 = Color3.fromHex("#12151f")
    f.BorderSizePixel = 0
    f.Parent = sg
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
    local st = Instance.new("UIStroke", f)
    st.Color = color or Color3.fromHex("#5b8cff")
    st.Thickness = 1

    local t = Instance.new("TextLabel", f)
    t.Size = UDim2.new(1, -20, 0, 20)
    t.Position = UDim2.new(0, 10, 0, 8)
    t.BackgroundTransparency = 1
    t.Text = title
    t.TextColor3 = Color3.fromHex("#e8eaf0")
    t.TextSize = 13
    t.Font = Enum.Font.GothamBold
    t.TextXAlignment = Enum.TextXAlignment.Left

    local c = Instance.new("TextLabel", f)
    c.Size = UDim2.new(1, -20, 0, 26)
    c.Position = UDim2.new(0, 10, 0, 30)
    c.BackgroundTransparency = 1
    c.Text = content
    c.TextColor3 = Color3.fromHex("#6b7280")
    c.TextSize = 11
    c.Font = Enum.Font.Gotham
    c.TextXAlignment = Enum.TextXAlignment.Left
    c.TextWrapped = true

    task.delay(duration or 3, function()
        if f then f:Destroy() end
        if sg and #sg:GetChildren() == 0 then sg:Destroy() end
    end)
end

-- ============================================================
-- SECTION 3: KEY SYSTEM UI (loads BEFORE framework)
-- ============================================================
if PG:FindFirstChild("RumiKeySystem") then
    PG.RumiKeySystem:Destroy()
end

local keyGui = Instance.new("ScreenGui")
keyGui.Name = "RumiKeySystem"
keyGui.ResetOnSpawn = false
keyGui.IgnoreGuiInset = true
keyGui.DisplayOrder = 9999999
keyGui.Parent = PG

-- Main key frame
local keyFrame = Instance.new("Frame")
keyFrame.Size = UDim2.fromOffset(420, 320)
keyFrame.Position = UDim2.new(0.5, -210, 0.5, -160)
keyFrame.BackgroundColor3 = Color3.fromHex("#0b0d12")
keyFrame.BorderSizePixel = 0
keyFrame.Active = true
keyFrame.Parent = keyGui
Instance.new("UICorner", keyFrame).CornerRadius = UDim.new(0, 12)
local kfStroke = Instance.new("UIStroke", keyFrame)
kfStroke.Color = Color3.fromHex("#5b8cff")
kfStroke.Thickness = 1

-- Header title
local kHeader = Instance.new("TextLabel", keyFrame)
kHeader.Size = UDim2.new(1, 0, 0, 46)
kHeader.BackgroundTransparency = 1
kHeader.Text = "Rumi Hub — Key System"
kHeader.TextColor3 = Color3.fromHex("#e8eaf0")
kHeader.TextSize = 18
kHeader.Font = Enum.Font.GothamBold

-- Subtitle
local kSub = Instance.new("TextLabel", keyFrame)
kSub.Size = UDim2.new(1, 0, 0, 18)
kSub.Position = UDim2.new(0, 0, 0, 46)
kSub.BackgroundTransparency = 1
kSub.Text = "by ItzShehryarOG & Shify"
kSub.TextColor3 = Color3.fromHex("#6b7280")
kSub.TextSize = 11
kSub.Font = Enum.Font.Gotham

-- Key input box
local keyBox = Instance.new("TextBox", keyFrame)
keyBox.Size = UDim2.new(1, -60, 0, 42)
keyBox.Position = UDim2.new(0, 30, 0, 78)
keyBox.BackgroundColor3 = Color3.fromHex("#12151f")
keyBox.BorderSizePixel = 0
keyBox.Text = ""
keyBox.PlaceholderText = "Enter or paste your key..."
keyBox.PlaceholderColor3 = Color3.fromHex("#6b7280")
keyBox.TextColor3 = Color3.fromHex("#e8eaf0")
keyBox.TextSize = 13
keyBox.Font = Enum.Font.Gotham
keyBox.ClearTextOnFocus = false
keyBox.TextXAlignment = Enum.TextXAlignment.Left
Instance.new("UICorner", keyBox).CornerRadius = UDim.new(0, 8)
local keyPad = Instance.new("UIPadding", keyBox)
keyPad.PaddingLeft = UDim.new(0, 12)
local keyStroke = Instance.new("UIStroke", keyBox)
keyStroke.Color = Color3.fromHex("#1e2433")
keyStroke.Thickness = 1

-- Verify button
local verifyBtn = Instance.new("TextButton", keyFrame)
verifyBtn.Size = UDim2.new(1, -60, 0, 42)
verifyBtn.Position = UDim2.new(0, 30, 0, 130)
verifyBtn.BackgroundColor3 = Color3.fromHex("#5b8cff")
verifyBtn.Text = "✓  Verify Key"
verifyBtn.TextColor3 = Color3.new(1, 1, 1)
verifyBtn.TextSize = 14
verifyBtn.Font = Enum.Font.GothamBold
verifyBtn.AutoButtonColor = false
Instance.new("UICorner", verifyBtn).CornerRadius = UDim.new(0, 8)

-- Get Key button
local getKeyBtn = Instance.new("TextButton", keyFrame)
getKeyBtn.Size = UDim2.new(1, -60, 0, 36)
getKeyBtn.Position = UDim2.new(0, 30, 0, 185)
getKeyBtn.BackgroundColor3 = Color3.fromHex("#12151f")
getKeyBtn.Text = "📋  Get Key (Copy Link)"
getKeyBtn.TextColor3 = Color3.fromHex("#e8eaf0")
getKeyBtn.TextSize = 12
getKeyBtn.Font = Enum.Font.GothamMedium
getKeyBtn.AutoButtonColor = false
Instance.new("UICorner", getKeyBtn).CornerRadius = UDim.new(0, 8)
local gkStroke = Instance.new("UIStroke", getKeyBtn)
gkStroke.Color = Color3.fromHex("#1e2433")
gkStroke.Thickness = 1

-- Discord button
local discordBtn = Instance.new("TextButton", keyFrame)
discordBtn.Size = UDim2.new(1, -60, 0, 36)
discordBtn.Position = UDim2.new(0, 30, 0, 230)
discordBtn.BackgroundColor3 = Color3.fromHex("#5865f2")
discordBtn.Text = "💬  Join Discord"
discordBtn.TextColor3 = Color3.new(1, 1, 1)
discordBtn.TextSize = 12
discordBtn.Font = Enum.Font.GothamBold
discordBtn.AutoButtonColor = false
Instance.new("UICorner", discordBtn).CornerRadius = UDim.new(0, 8)

-- Status label
local statusLabel = Instance.new("TextLabel", keyFrame)
statusLabel.Size = UDim2.new(1, -60, 0, 20)
statusLabel.Position = UDim2.new(0, 30, 1, -26)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = ""
statusLabel.TextColor3 = Color3.fromHex("#ef4444")
statusLabel.TextSize = 11
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextXAlignment = Enum.TextXAlignment.Center

-- ============================================================
-- SECTION 4: KEY SYSTEM EVENT HANDLERS
-- ============================================================
getKeyBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        local ok = pcall(setclipboard, KEY_LINK)
        if ok then
            statusLabel.Text = "Key Link Copied to Clipboard!"
            statusLabel.TextColor3 = Color3.fromHex("#10b981")
        else
            statusLabel.Text = "Clipboard failed. Link: " .. KEY_LINK
            statusLabel.TextColor3 = Color3.fromHex("#ef4444")
        end
    else
        statusLabel.Text = "Copy link: " .. KEY_LINK
        statusLabel.TextColor3 = Color3.fromHex("#f59e0b")
    end
    task.delay(3, function()
        if statusLabel and statusLabel.Parent then statusLabel.Text = "" end
    end)
end)

discordBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        pcall(setclipboard, DISCORD_LINK)
        statusLabel.Text = "Discord invite copied!"
        statusLabel.TextColor3 = Color3.fromHex("#10b981")
    else
        statusLabel.Text = "Discord: " .. DISCORD_LINK
        statusLabel.TextColor3 = Color3.fromHex("#f59e0b")
    end
    task.delay(3, function()
        if statusLabel and statusLabel.Parent then statusLabel.Text = "" end
    end)
end)

-- ============================================================
-- SECTION 5: MAIN HUB BUILDER (called only after key verified)
-- ============================================================
local function buildMainHub()
    -- ---- Load framework ----
    local ok, RumiUI = pcall(function()
        return loadstring(game:HttpGet(
            "https://raw.githubusercontent.com/itzshehryarog/rumiui/main/rumiui.lua"
        ))()
    end)
    if not ok or not RumiUI then
        quickNotify("Framework Error", "Failed to load RumiUI: " .. tostring(RumiUI),
            Color3.fromHex("#ef4444"), 5)
        return
    end

    -- Framework notifier
    local function notify(title, content, color, duration)
        local fn = RumiUI.Notify or RumiUI.SendNotification
        if fn then
            pcall(fn, RumiUI, {
                Title = title,
                Content = content,
                Color = color or Color3.fromHex("#5b8cff"),
                Duration = duration or 3,
            })
        else
            quickNotify(title, content, color, duration)
        end
    end

    -- ---- Create main window ----
    local Window
    if RumiUI.NewWindow then
        local okW, w = pcall(RumiUI.NewWindow, RumiUI, "Rumi Hub", 128337196312757, 1, "blue")
        if okW then Window = w end
    end
    if not Window and RumiUI.CreateWindow then
        local okW, w = pcall(RumiUI.CreateWindow, RumiUI, {
            Title = "Rumi Hub",
            Subtitle = "by ItzShehryarOG & Shify",
            Width = 680,
            Height = 420,
        })
        if okW then Window = w end
    end
    if not Window then
        quickNotify("Framework Error", "No window API available",
            Color3.fromHex("#ef4444"), 5)
        return
    end

    -- Optional window decorators (defensive)
    if Window.SetFooter then
        pcall(Window.SetFooter, Window, "yt: ItzShehryarOG", 128337196312757, 1)
    end
    if Window.SetToggleKey then
        pcall(Window.SetToggleKey, Window, Enum.KeyCode.RightShift)
    end
    if Window.SetParticle then
        pcall(Window.SetParticle, Window, "Cyber Tech ✨")
    end

    -- Shared mutable state (framework-agnostic)
    local S = {
        SilentAim  = false,
        Hitbox     = false,
        InfJump    = false,
        Noclip     = false,
        AntiAFK    = false,
        Spinbot    = false,
    }

    -- ============================================================
    -- TAB 1: MAIN / COMBAT
    -- ============================================================
    local MainTab = Window:Tab({ Title = "Main", Icon = "crosshair" })
    MainTab:Section({ Title = "Combat" })

    MainTab:Toggle({
        Title = "Silent Aim",
        Flag = "SilentAim",
        Default = false,
        Callback = function(v)
            S.SilentAim = v
            notify("Silent Aim", v and "Enabled" or "Disabled",
                v and Color3.fromHex("#10b981") or Color3.fromHex("#ef4444"))
        end,
    })

    MainTab:Toggle({
        Title = "Hitbox Expander",
        Flag = "Hitbox",
        Default = false,
        Callback = function(v)
            S.Hitbox = v
            if v then
                task.spawn(function()
                    -- Loop respects mobile safety: wait >= 0.5s between iterations
                    while S.Hitbox do
                        for _, pl in ipairs(Players:GetPlayers()) do
                            if pl ~= LP and pl.Character then
                                local hrp = pl.Character:FindFirstChild("HumanoidRootPart")
                                if hrp then hrp.Size = Vector3.new(6, 6, 6) end
                            end
                        end
                        task.wait(0.5)
                    end
                    -- Restore on disable
                    for _, pl in ipairs(Players:GetPlayers()) do
                        if pl ~= LP and pl.Character then
                            local hrp = pl.Character:FindFirstChild("HumanoidRootPart")
                            if hrp then hrp.Size = Vector3.new(2, 2, 1) end
                        end
                    end
                end)
            end
        end,
    })

    -- ============================================================
    -- TAB 2: MOVEMENT
    -- ============================================================
    local MoveTab = Window:Tab({ Title = "Movement", Icon = "move" })
    MoveTab:Section({ Title = "Speed & Jump" })

    MoveTab:Slider({
        Title = "WalkSpeed",
        Min = 16, Max = 300, Default = 16, Step = 1,
        Flag = "WalkSpeed",
        Callback = function(v)
            local c = LP.Character
            local h = c and c:FindFirstChildOfClass("Humanoid")
            if h then h.WalkSpeed = v end
        end,
    })

    MoveTab:Slider({
        Title = "JumpPower",
        Min = 50, Max = 300, Default = 50, Step = 5,
        Flag = "JumpPower",
        Callback = function(v)
            local c = LP.Character
            local h = c and c:FindFirstChildOfClass("Humanoid")
            if h then
                h.UseJumpPower = true
                h.JumpPower = v
            end
        end,
    })

    MoveTab:Toggle({
        Title = "Infinite Jump",
        Flag = "InfJump",
        Default = false,
        Callback = function(v) S.InfJump = v end,
    })

    -- Persistent infinite jump handler
    UIS.JumpRequest:Connect(function()
        if S.InfJump then
            local c = LP.Character
            local h = c and c:FindFirstChildOfClass("Humanoid")
            if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end)

    MoveTab:Toggle({
        Title = "Noclip",
        Flag = "Noclip",
        Default = false,
        Callback = function(v) S.Noclip = v end,
    })

    -- Noclip tick
    RS.Stepped:Connect(function()
        if not S.Noclip then return end
        local c = LP.Character
        if not c then return end
        for _, p in ipairs(c:GetDescendants()) do
            if p:IsA("BasePart") and p.CanCollide then
                p.CanCollide = false
            end
        end
    end)

    MoveTab:Toggle({
        Title = "Anti-AFK",
        Flag = "AntiAFK",
        Default = false,
        Callback = function(v) S.AntiAFK = v end,
    })

    LP.Idled:Connect(function()
        if S.AntiAFK then
            VU:CaptureController()
            VU:ClickButton2(Vector2.new())
        end
    end)

    -- ============================================================
    -- TAB 3: VISUALS
    -- ============================================================
    local VisTab = Window:Tab({ Title = "Visuals", Icon = "eye" })
    VisTab:Section({ Title = "Environment" })

    VisTab:Toggle({
        Title = "Fullbright",
        Flag = "Fullbright",
        Default = false,
        Callback = function(v)
            if v then
                LT.Brightness = 3
                LT.ClockTime = 12
                LT.FogEnd = 1e5
                LT.GlobalShadows = false
                LT.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
            else
                LT.Brightness = 2
                LT.GlobalShadows = true
            end
        end,
    })

    VisTab:Slider({
        Title = "FOV",
        Min = 60, Max = 120, Default = 70, Step = 1,
        Flag = "FOV",
        Callback = function(v)
            if WS.CurrentCamera then
                WS.CurrentCamera.FieldOfView = v
            end
        end,
    })

    -- ============================================================
    -- TAB 4: SERVER & INFO
    -- ============================================================
    local ServTab = Window:Tab({ Title = "Server", Icon = "server" })
    ServTab:Section({ Title = "Info" })

    ServTab:Button({
        Title = "Server Stats",
        Callback = function()
            local online = #Players:GetPlayers()
            local cap = Players.MaxPlayers
            notify("Server Stats", online .. " / " .. cap .. " players online",
                Color3.fromHex("#5b8cff"), 4)
        end,
    })

    ServTab:Section({ Title = "Connection" })

    ServTab:Button({
        Title = "Rejoin Server",
        Callback = function()
            pcall(function() TS:Teleport(game.PlaceId, LP) end)
        end,
    })

    ServTab:Button({
        Title = "Server Hop (Lowest Players)",
        Callback = function()
            local okHop, res = pcall(function()
                return HS:JSONDecode(game:HttpGet(
                    "https://games.roblox.com/v1/games/" .. game.PlaceId ..
                    "/servers/Public?sortOrder=Asc&limit=100"
                ))
            end)
            if okHop and res and res.data then
                table.sort(res.data, function(a, b) return a.playing < b.playing end)
                for _, s in ipairs(res.data) do
                    if s.playing < s.maxPlayers and s.id ~= game.JobId then
                        pcall(function()
                            TS:TeleportToPlaceInstance(game.PlaceId, s.id, LP)
                        end)
                        return
                    end
                end
            end
            notify("Server Hop", "No servers available", Color3.fromHex("#ef4444"))
        end,
    })

    ServTab:Button({
        Title = "Copy Job ID",
        Callback = function()
            if setclipboard then pcall(setclipboard, game.JobId) end
            notify("Copied", "Job ID: " .. game.JobId, Color3.fromHex("#10b981"))
        end,
    })

    ServTab:Section({ Title = "Performance" })

    ServTab:Toggle({
        Title = "Anti-Lag / FPS Boost",
        Flag = "AntiLag",
        Default = false,
        Callback = function(v)
            if v then
                task.spawn(function()
                    local disabled = 0
                    for _, o in ipairs(game:GetDescendants()) do
                        if o:IsA("ParticleEmitter") or o:IsA("Smoke")
                        or o:IsA("Fire") or o:IsA("Sparkles") or o:IsA("Trail") then
                            pcall(function()
                                o.Enabled = false
                                disabled = disabled + 1
                            end)
                        end
                        -- Yield every 50 items to keep mobile responsive
                        if disabled % 50 == 0 then
                            task.wait(0)
                        end
                    end
                    notify("Anti-Lag", "Disabled " .. disabled .. " effects",
                        Color3.fromHex("#10b981"))
                end)
            end
        end,
    })

    -- ============================================================
    -- TAB 5: CHARACTER & FUN
    -- ============================================================
    local CharTab = Window:Tab({ Title = "Character", Icon = "user" })
    CharTab:Section({ Title = "Tools" })

    CharTab:Button({
        Title = "Give Btools",
        Callback = function()
            local bp = LP:FindFirstChildOfClass("Backpack")
            if not bp then
                notify("Btools", "No backpack found", Color3.fromHex("#ef4444"))
                return
            end
            local count = 0
            for _, name in ipairs({ "Weld", "Rocket", "Hammer", "Sign" }) do
                pcall(function()
                    local b = Instance.new("HopperBin")
                    b.BinType = Enum.BinType[name]
                    b.Parent = bp
                    count = count + 1
                end)
            end
            notify("Btools", count .. " tools injected!", Color3.fromHex("#10b981"))
        end,
    })

    CharTab:Toggle({
        Title = "Spinbot",
        Flag = "Spinbot",
        Default = false,
        Callback = function(v) S.Spinbot = v end,
    })

    -- Spinbot: uses Heartbeat (engine-paced), no unbounded while-loop
    RS.Heartbeat:Connect(function(dt)
        if not S.Spinbot then return end
        local c = LP.Character
        local hrp = c and c:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(720) * dt, 0)
        end
    end)

    -- ============================================================
    -- SUCCESS NOTIFICATION
    -- ============================================================
    notify("Rumi Hub Loaded",
        "Press RightShift to toggle UI",
        Color3.fromHex("#5b8cff"), 5)

    print("[Rumi Hub] v3.0 loaded successfully.")
end

-- ============================================================
-- SECTION 6: VERIFY BUTTON HANDLER (triggers hub load)
-- ============================================================
verifyBtn.MouseButton1Click:Connect(function()
    local input = keyBox.Text

    if input == KEY_CODE then
        statusLabel.Text = "✓ Key verified! Loading Rumi Hub..."
        statusLabel.TextColor3 = Color3.fromHex("#10b981")
        verifyBtn.Text = "Loading..."
        verifyBtn.BackgroundColor3 = Color3.fromHex("#10b981")
        verifyBtn.Active = false

        task.wait(0.5)
        pcall(function() keyGui:Destroy() end)
        task.wait(0.2)

        local okLoad, err = pcall(buildMainHub)
        if not okLoad then
            quickNotify("Load Error", "Hub build failed: " .. tostring(err),
                Color3.fromHex("#ef4444"), 5)
        end
    else
        statusLabel.Text = "✗ Invalid key! Please try again."
        statusLabel.TextColor3 = Color3.fromHex("#ef4444")
        keyBox.Text = ""
        keyStroke.Color = Color3.fromHex("#ef4444")

        task.delay(1.2, function()
            if keyStroke and keyStroke.Parent then
                keyStroke.Color = Color3.fromHex("#1e2433")
            end
        end)
    end
end)

-- Enter key submits
keyBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        verifyBtn:Fire("MouseButton1Click")
    end
end)

print("[Rumi Hub] Key System ready. Awaiting verification...")