-- This basically makes roblox unable to log your chat messages sent in-game. Meaning if you get reported for saying something bad, you won't get banned!
-- Store in autoexec folder
-- Credits: AnthonyIsntHere and ArianBlaack
 
--[[
    Change-logs:
    8/22/2022 - Fixed Chat gui glitching on some games such as Prison Life.
]]--
 
if not game:IsLoaded() then
    game.Loaded:wait()
end
 
local ACL_LoadTime = tick()
 
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
 
local Player = Players.LocalPlayer
 
local PlayerGui = Player:FindFirstChildWhichIsA("PlayerGui") do
    if not PlayerGui then
        repeat task.wait() until Player:FindFirstChildWhichIsA("PlayerGui")
        PlayerGui = Player:FindFirstChildWhichIsA("PlayerGui")
    end
end
 
local Notify = function(_Title, _Text , Time)
    StarterGui:SetCore("SendNotification", {Title = _Title, Text = _Text, Icon = "rbxassetid://2541869220", Duration = Time})
end
 
local Tween = function(Object, Time, Style, Direction, Property)
	return TweenService:Create(Object, TweenInfo.new(Time, Enum.EasingStyle[Style], Enum.EasingDirection[Direction]), Property)
end
 
local Insert = function(Tbl, ...)
    for _, x in next, {...} do
        table.insert(Tbl, x) 
    end
end
 
local ChatFixToggle = true
local CoreGuiSettings = {}
local ChatFix
 
ChatFix = hookmetamethod(StarterGui, "__namecall", function(self, ...)
    local Method = getnamecallmethod()
    local Arguments = {...}
 
    if not checkcaller() and ChatFixToggle and Method == "SetCoreGuiEnabled" then
        local CoreGuiType = Arguments[1]
        local SettingValue = Arguments[2]
 
        if CoreGuiType == ("All" or "Chat") then
            Insert(CoreGuiSettings, CoreGuiType, SettingValue)
            return
        end
    end
 
    return ChatFix(self, ...)
end)
 
local ACLWarning = Instance.new("ScreenGui")
local Background = Instance.new("Frame")
local Top = Instance.new("Frame")
local Exit = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")
local WarningLbl = Instance.new("TextLabel")
local Loading = Instance.new("Frame")
local Bar = Instance.new("Frame")
local WarningBackground = Instance.new("Frame")
local WarningFrame = Instance.new("Frame")
local Despair = Instance.new("TextLabel")
local UIListLayout = Instance.new("UIListLayout")
local Reason_1 = Instance.new("TextLabel")
local Reason_2 = Instance.new("TextLabel")
local Trollge = Instance.new("ImageLabel")
local UIPadding = Instance.new("UIPadding")
 
local ExitCooldown = function()
    wait(3)
    local Tween = Tween(Bar, 5, "Quad", "InOut", {Size = UDim2.new(1, 0, 1, 0)})
    Tween:Play()
    Tween.Completed:wait()
    Loading:Destroy()
    Exit.Visible = true
end
 
local PlayerScripts = Player:WaitForChild("PlayerScripts")
local ChatMain = PlayerScripts:FindFirstChild("ChatMain", true) or false
 
if not ChatMain then
    local Timer = tick()
    repeat
        task.wait()
    until PlayerScripts:FindFirstChild("ChatMain", true) or tick() > (Timer + 3)
    ChatMain = PlayerScripts:FindFirstChild("ChatMain", true)
    if not ChatMain then
        ACLWarning.Enabled = true
        Reason_1.Visible = true
        ExitCooldown()
        return
    end
end
 
local PostMessage = require(ChatMain).MessagePosted
 
if not PostMessage then
    ACLWarning.Enabled = true
    Reason_2.Visible = true
    ExitCooldown()
    return
end
 
local MessageEvent = Instance.new("BindableEvent")
local OldFunctionHook
OldFunctionHook = hookfunction(PostMessage.fire, function(self, Message)
    if not checkcaller() and self == PostMessage then
        MessageEvent:Fire(Message)
        return
    end
    return OldFunctionHook(self, Message)
end)
 
if setfflag then
    setfflag("AbuseReportScreenshot", "False")
    setfflag("AbuseReportScreenshotPercentage", 0)
end
 
ChatFixToggle = false
ACLWarning:Destroy()
if OldSetting then
    StarterGui:SetCoreGuiEnabled(CoreGuiSettings[1], CoreGuiSettings[2])
end
Notify("Loaded Successfully", "Anti Chat and Screenshot Logger Loaded!", 15)
print(string.format("Anti Chat-Logger has loaded in %s seconds.", tostring(tick() - ACL_LoadTime):sub(1, 4)))
