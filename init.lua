--============================================================
-- RUMI HUB — Main Script (init.lua) [FIXED & ULTRA FAST]
--============================================================

-- ===== 1. SINGLE FRAMEWORK LOAD =====
local RumiUI
local ok, err = pcall(function()
    if getgenv().RumiUIFramework then
        return getgenv().RumiUIFramework
    end
    local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/itzshehryarog/rumiui/main/rumiui.lua"))()
    getgenv().RumiUIFramework = lib
    return lib
end)

RumiUI = ok and err or nil

if not RumiUI then
    warn("[Rumi Hub Error] Framework failed to load!")
    return
end

-- ===== 2. KEY SYSTEM WINDOW =====
local KeyWindow = RumiUI:NewWindow("Rumi Hub — Key System", 128337196312757, 1, "blue")

local UserKey = ""
local CorrectKey = "RUMI_VIP_2026"

KeyWindow:Section({ Title = "Enter Your Access Key" })

KeyWindow:Textbox({ Title = "Paste Key Here", Flag = "KeyInput", Callback = function(txt)
    UserKey = txt
end })

KeyWindow:Button({ Title = "Verify Key", Callback = function()
    if UserKey == CorrectKey then
        RumiUI:Notify({ Title = "Success", Content = "Key Verified! Loading Hub...", Color = Color3.fromRGB(16, 185, 129), Duration = 3 })
        
        -- Load Main Hub
        task.wait(1)
        
        local MainWin = RumiUI:NewWindow("Rumi Hub", 128337196312757, 1, "blue")
        MainWin:SetFooter("yt: ItzShehryarOG | Verified ✓", 128337196312757, 1)

        -- Movement Tab
        local MoveTab = MainWin:Tab({ Title = "Movement", Icon = "move" })
        MoveTab:Slider({ Title = "WalkSpeed", Min = 16, Max = 300, Default = 16, Step = 1, Callback = function(v)
            if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
                game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
            end
        end })

        -- Server Tab
        local ServTab = MainWin:Tab({ Title = "Server & Info", Icon = "server" })
        ServTab:Button({ Title = "Check Players Online", Callback = function()
            RumiUI:Notify({ Title = "Server Info", Content = "Online: " .. #game.Players:GetPlayers() .. " Players", Color = Color3.fromRGB(91, 140, 255), Duration = 4 })
        end })
        
        ServTab:Button({ Title = "Rejoin Server", Callback = function()
            game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
        end })

    else
        RumiUI:Notify({ Title = "Error", Content = "Invalid Key! Please check again.", Color = Color3.fromRGB(239, 68, 68), Duration = 3 })
    end
end })

KeyWindow:Button({ Title = "Get Key (Copy Link)", Callback = function()
    if setclipboard then
        setclipboard("https://linkvertise.com/rumihubkey")
        RumiUI:Notify({ Title = "Copied", Content = "Key Link copied to clipboard!", Color = Color3.fromRGB(91, 140, 255), Duration = 3 })
    end
end })

KeyWindow:Button({ Title = "Join Discord Server", Callback = function()
    if setclipboard then
        setclipboard("https://discord.gg/xyrexmc")
        RumiUI:Notify({ Title = "Copied", Content = "Discord invite copied!", Color = Color3.fromRGB(91, 140, 255), Duration = 3 })
    end
end })
