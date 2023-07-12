if shared.GuiLibrary then
    shared.GuiLibrary["SelfDestruct"]()
end

wait(0.5)

loadstring(game:HttpGet("https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/NewMainScript.lua", true))()

wait(0.5)

-- Credits to Inf Yield & all the other scripts that helped me make bypasses
local GuiLibrary = shared.GuiLibrary
local players = game:GetService("Players")
local textservice = game:GetService("TextService")
local lplr = players.LocalPlayer
local workspace = game:GetService("Workspace")
local lighting = game:GetService("Lighting")
local cam = workspace.CurrentCamera
local targetinfo = shared.VapeTargetInfo
local uis = game:GetService("UserInputService")
local localmouse = lplr:GetMouse()
local requestfunc = syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or getgenv().request or request
local getasset = getsynasset or getcustomasset

local RenderStepTable = {}
local StepTable = {}

local function BindToRenderStep(name, num, func)
	if RenderStepTable[name] == nil then
		RenderStepTable[name] = game:GetService("RunService").RenderStepped:connect(func)
	end
end


local function UnbindFromRenderStep(name)
	if RenderStepTable[name] then
		RenderStepTable[name]:Disconnect()
		RenderStepTable[name] = nil
	end
end

local function BindToStepped(name, num, func)
	if StepTable[name] == nil then
		StepTable[name] = game:GetService("RunService").Stepped:connect(func)
	end
end
local function UnbindFromStepped(name)
	if StepTable[name] then
		StepTable[name]:Disconnect()
		StepTable[name] = nil
	end
end

local function infonotify(title, text, delay)
	pcall(function()
		local frame = GuiLibrary["CreateNotification"](title, text, delay, "assets/InfoNotification.png")
		frame.Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
		frame.Frame.Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
	end)
end
local function warnnotify(title, text, delay)
	pcall(function()
		local frame = GuiLibrary["CreateNotification"](title, text, delay, "assets/WarningNotification.png")
		frame.Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
		frame.Frame.Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
	end)
end

local function friendCheck(plr, recolor)
	return (recolor and GuiLibrary["ObjectsThatCanBeSaved"]["Recolor visualsToggle"]["Api"]["Enabled"] or (not recolor)) and GuiLibrary["ObjectsThatCanBeSaved"]["Use FriendsToggle"]["Api"]["Enabled"] and table.find(GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextCircleList"]["Api"]["ObjectList"], plr.Name) and GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextCircleList"]["Api"]["ObjectListEnabled"][table.find(GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextCircleList"]["Api"]["ObjectList"], plr.Name)]
end

local function getPlayerColor(plr)
	return (friendCheck(plr, true) and Color3.fromHSV(GuiLibrary["ObjectsThatCanBeSaved"]["Friends ColorSliderColor"]["Api"]["Hue"], GuiLibrary["ObjectsThatCanBeSaved"]["Friends ColorSliderColor"]["Api"]["Sat"], GuiLibrary["ObjectsThatCanBeSaved"]["Friends ColorSliderColor"]["Api"]["Value"]) or tostring(plr.TeamColor) ~= "White" and plr.TeamColor.Color)
end

local function getcustomassetfunc(path)
	if not isfile(path) then
		spawn(function()
			local textlabel = Instance.new("TextLabel")
			textlabel.Size = UDim2.new(1, 0, 0, 36)
			textlabel.Text = "Downloading "..path
			textlabel.BackgroundTransparency = 1
			textlabel.TextStrokeTransparency = 0
			textlabel.TextSize = 30
			textlabel.Font = Enum.Font.SourceSans
			textlabel.TextColor3 = Color3.new(1, 1, 1)
			textlabel.Position = UDim2.new(0, 0, 0, -36)
			textlabel.Parent = GuiLibrary["MainGui"]
			repeat wait() until isfile(path)
			textlabel:Remove()
		end)
		local req = requestfunc({
			Url = "https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/"..path:gsub("vape/assets", "assets"),
			Method = "GET"
		})
		writefile(path, req.Body)
	end
	return getasset(path) 
end

shared.vapeteamcheck = function(plr)
	return (GuiLibrary["ObjectsThatCanBeSaved"]["Teams by colorToggle"]["Api"]["Enabled"] and (plr.Team ~= lplr.Team or (lplr.Team == nil or #lplr.Team:GetPlayers() == #game:GetService("Players"):GetChildren())) or GuiLibrary["ObjectsThatCanBeSaved"]["Teams by colorToggle"]["Api"]["Enabled"] == false)
end

local function targetCheck(plr, check)
	return (check and plr.Character.Humanoid.Health > 0 and plr.Character:FindFirstChild("ForceField") == nil or check == false)
end

local function isAlive(plr)
	if plr then
		return plr and plr.Character and plr.Character.Parent ~= nil and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("Humanoid")
	end
	return lplr and lplr.Character and lplr.Character.Parent ~= nil and lplr.Character:FindFirstChild("HumanoidRootPart") and lplr.Character:FindFirstChild("Head") and lplr.Character:FindFirstChild("Humanoid")
end

local function isPlayerTargetable(plr, target, friend)
    return plr ~= lplr and plr and (friend and friendCheck(plr) == nil or (not friend)) and isAlive(plr) and targetCheck(plr, target) and shared.vapeteamcheck(plr)
end

local function vischeck(char, part)
	return not unpack(cam:GetPartsObscuringTarget({lplr.Character[part].Position, char[part].Position}, {lplr.Character, char}))
end

local function runcode(func)
	func()
end

local function GetAllNearestHumanoidToPosition(player, distance, amount)
	local returnedplayer = {}
	local currentamount = 0
    if isAlive() then
        for i, v in pairs(players:GetChildren()) do
            if isPlayerTargetable((player and v or nil), true, true) and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Head") and currentamount < amount then
                local mag = (lplr.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).magnitude
                if mag <= distance then
                    table.insert(returnedplayer, v)
					currentamount = currentamount + 1
                end
            end
        end
	end
	return returnedplayer
end

local function GetNearestHumanoidToPosition(player, distance)
	local closest, returnedplayer = distance, nil
    if isAlive() then
        for i, v in pairs(players:GetChildren()) do
            if isPlayerTargetable((player and v or nil), true, true) and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Head") then
                local mag = (lplr.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).magnitude
                if mag <= closest then
                    closest = mag
                    returnedplayer = v
                end
            end
        end
	end
	return returnedplayer
end

local function GetNearestHumanoidToMouse(player, distance, checkvis)
    local closest, returnedplayer = distance, nil
    if isAlive() then
        for i, v in pairs(players:GetChildren()) do
            if isPlayerTargetable((player and v or nil), true, true) and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Head") and (checkvis == false or checkvis and (vischeck(v.Character, "Head") or vischeck(v.Character, "HumanoidRootPart"))) then
                local vec, vis = cam:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
                if vis then
                    local mag = (uis:GetMouseLocation() - Vector2.new(vec.X, vec.Y)).magnitude
                    if mag <= closest then
                        closest = mag
                        returnedplayer = v
                    end
                end
            end
        end
    end
    return returnedplayer
end

local function CalculateObjectPosition(pos)
	local newpos = cam:WorldToViewportPoint(cam.CFrame:pointToWorldSpace(cam.CFrame:pointToObjectSpace(pos)))
	return Vector2.new(newpos.X, newpos.Y)
end

local function CalculateLine(startVector, endVector, obj)
	local Distance = (startVector - endVector).Magnitude
	obj.Size = UDim2.new(0, Distance, 0, 2)
	obj.Position = UDim2.new(0, (startVector.X + endVector.X) / 2, 0, ((startVector.Y + endVector.Y) / 2) - 36)
	obj.Rotation = math.atan2(endVector.Y - startVector.Y, endVector.X - startVector.X) * (180 / math.pi)
end

local function findTouchInterest(tool)
	for i,v in pairs(tool:GetDescendants()) do
		if v:IsA("TouchTransmitter") then
			return v
		end
	end
	return nil
end

infonotify("Smoke", "Loaded Successfully!", 5)
loadstring(game:HttpGet("https://raw.githubusercontent.com/SmokeXDev/SmokeXPubblic/main/SmokeXTeamDetector.lua", true))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/SmokeXDev/SmokeXPubblic/main/SmokeXTeam/NewDetect.lua", true))()

GuiLibrary.RemoveObject("AutoClickerOptionsButton")
GuiLibrary.RemoveObject("ReachOptionsButton")
GuiLibrary.RemoveObject("KillauraOptionsButton")
GuiLibrary.RemoveObject("TargetStrafeOptionsButton")
GuiLibrary.RemoveObject("ArrowsOptionsButton")
GuiLibrary.RemoveObject("SearchOptionsButton")
GuiLibrary.RemoveObject("AnimationPlayerOptionsButton")
GuiLibrary.RemoveObject("PanicOptionsButton")
GuiLibrary.RemoveObject("SafeWalkOptionsButton")
GuiLibrary.RemoveObject("XrayOptionsButton")

runcode(function()
	local NoAnim = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		["Name"] = "NoAnim",
		["Function"] = function(callback)
			if callback then
				game:GetService("Players").LocalPlayer.Character.Animate.Disabled = true
			else
				game:GetService("Players").LocalPlayer.Character.Animate.Disabled = false
			end
		end
	})
end)

runcode(function()
	local MassReportChat = {Enabled = false}
	local AutoChatVal = false
	local MassReport = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		["Name"] = "MassReport",
		["Function"] = function()
			infonotify("MassReport", "Enabled! [Check F9 if you want]", 5)
			loadstring(game:HttpGet("https://raw.githubusercontent.com/SmokeXDev/SmokeXPubblic/main/Resources/MassReport.lua", true))()
		end,
		["HoverText"] = "Can't be reversed"
	})
	MassReportChat = MassReport.CreateToggle({
		["Name"] = "AutoChat",
		["Function"] = function(callback)
			if callback and MassReport.Enabled == true then
				AutoChatVal = true
				while AutoChatVal and task.wait(1) do
					game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("Server getting mass reported!", "All")
						wait(2)
					game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("Reported Everyone Successfully", "All")
				end
			else
				AutoChatVal = false
			end
		end
	})
end)

runcode(function()
	local mouse = game:GetService("Players").LocalPlayer:GetMouse()
	local Crosshair = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		["Name"] = "Crosshair",
		["Function"] = function(callback)
			if callback then
				mouse.Icon = "rbxassetid://9943168532"
			else
				infonotify("Crosshair", "Removed!", 5)
				mouse.Icon = ""
			end
		end
	})
end)

runcode(function()
	local NightVal = false
	local Night = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		["Name"] = "Night",
		["Function"] = function(callback)
			if callback then
					NightVal = true
					while NightVal and task.wait(0.3) do
						game:GetService("Lighting").TimeOfDay = "00:00:00"
					end
				else
					infonotify("Night", "Night Removed!", 5)
					NightVal = false
					wait(0.3)
				game:GetService("Lighting").TimeOfDay = "13:00:00"
			end
		end
	})
end)

runcode(function()
	local DayVal = false
	local Day = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		["Name"] = "Day",
		["Function"] = function(callback)
			if callback then
				DayVal = true
				while DayVal and task.wait(0.3) do
					game:GetService("Lighting").TimeOfDay = "07:00:00"
				end
			else
				infonotify("Day", "Day Removed!", 5)
				DayVal = false
				wait(0.3)
				game:GetService("Lighting").TimeOfDay = ""
			end
		end
	})
end)

runcode(function()
	local ErrorTimeVal = false
	local ErrorTime = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		["Name"] = "ErrorTime",
		["Function"] = function(callback)
			if callback then
				ErrorTimeVal = true
				while ErrorTimeVal and task.wait(0.1) do
					game.Lighting.ClockTime = 1
						wait(0.1)
					game.Lighting.ClockTime = 13
				end
			else
				infonotify("ErrorTime", "Disabled!", 5)
				ErrorTimeVal = false
			end
		end
	})
end)

runcode(function()
	local GravityV2 = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		["Name"] = "GravityV2",
		["Function"] = function(callback)
		if callback then
				workspace.Gravity = GravitiyVal
			end
		end,
		["Hovertext"] = "Change your gravity"
	})
	GravityV2.CreateSlider({
		["Name"] = "GravityV2",
		["Min"] = 0,
		["Max"] = 192.2,
		["Function"] = function(GravitiyVal)
			if GravityV2.Enabled then
				workspace.Gravity = GravitiyVal
			end
		end,
		["Default"] = 192.2
	})
end)

runcode(function()
	local ChatDisabler = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		["Name"] = "ChatDisabler",
		["Function"] = function(callback)
			if callback then
				local succ, err = pcall(function() game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false) end)
				if succ then
					infonotify('ChatDisabler', "Chat Disabled!", 5)
				elseif err then
					infonotify('ChatDisabler', "Error has occured while trying to disable the chat", 5)
				end
			else
				local succ, err = pcall(function() game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true) end)
				if succ then
					infonotify('ChatDisabler', "Chat enabled!", 5)
				elseif err then
					infonotify('ChatDisabler', "Error has occured while trying to enable the chat", 5)
				end
			end
		end
	})
end)

runcode(function()
	local GravityV2 = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		["Name"] = "GravityV2",
		["Function"] = function(callback)
		if callback then
				workspace.Gravity = GravitiyVal
			end
		end,
		["Hovertext"] = "Change your gravity"
	})
	GravityV2.CreateSlider({
		["Name"] = "GravityV2",
		["Min"] = 0,
		["Max"] = 192.2,
		["Function"] = function(GravitiyVal)
			if GravityV2.Enabled then
				workspace.Gravity = GravitiyVal
			end
		end,
		["Default"] = 192.2
	})
end)

runcode(function()
	local ChatDisabler = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		["Name"] = "ChatDisabler",
		["Function"] = function(callback)
			if callback then
				local succ, err = pcall(function() game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false) end)
				if succ then
					infonotify('ChatDisabler', "Chat Disabled!", 5)
				elseif err then
					infonotify('ChatDisabler', "Error has occured while trying to disable the chat", 5)
				end
			else
				local succ, err = pcall(function() game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true) end)
				if succ then
					infonotify('ChatDisabler', "Chat enabled!", 5)
				elseif err then
					infonotify('ChatDisabler', "Error has occured while trying to enable the chat", 5)
				end
			end
		end
	})
end)

runcode(function()
	local SpamVal = {""}
	local EnabledSpamV2 = false
	local DelaySpamV2 = 10
	local ChatSpammerV2 = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton("Utility", {
		["Name"] = "ChatSpammerV2",
		["Function"] = function(callback)
			if callback then
				EnabledSpamV2 = true
					while EnabledSpamV2 and task.wait(DelaySpamV2) do
					game:GetService("TextChatService").ChatInputBarConfiguration.TargetTextChannel:SendAsync(SpamVal[math.random(1, #SpamVal)])
				end
			else
				EnabledSpamV2 = false
			end
		end
	})
	ChatSpammerV2.CreateTextList({
		["Name"] = "Message",
		["TempText"] = "You're message here.",
		["AddFunction"] = function(msg) table.insert(SpamVal, msg) end,
		["RemoveFunction"] = function(msg) table.remove(SpamVal, msg) end
	})
	ChatSpammerV2.CreateSlider({
		["Name"] = "Delay",
		["Min"] = 0,
		["Max"] = 10,
		["Function"] = function(DelaySpamV2Func) DelaySpamV2 = DelaySpamV2Func end,
		["Default"] = 10
	})
end)

runcode(function()
	local SuperPanic = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		["Name"] = "SuperPanic",
		["Function"] = function(callback)
			if callback then
				game.Players.LocalPlayer:Kick("You has been kicked from SuperPanic.")
					wait()
				game:Shutdown()
				GuiLibrary.ObjectsThatCanBeSaved.SuperPanicOptionsButton.Api.ToggleButton(false)
			end
		end
	})
end)

runcode(function() 
	local FogEndValue = 500
	local FogStartValue = 0
	local PermFog = false
	local RainbowVal = false
	local FogTheme = {Value = "Smoke"}
	local SmokeFog = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		["Name"] = "SmokeFog",
		["Function"] = function(callback)
			if callback then
					PermFog = true
				while PermFog and task.wait() do
					game.Lighting.FogEnd = FogEndValue
					game.Lighting.FogStart = FogStartValue
				end

				if FogTheme.Value == "Smoke" then
					game.Lighting.FogColor = Color3.fromRGB(0, 0, 255)
				end
				if FogTheme.Value == "Fog" then
					game.Lighting.FogColor = Color3.fromRGB(255, 255, 255)
				end
				if FogTheme.Value == "RainbowBETA" then
					RainbowVal = true
					while RainbowVal and task.wait() do
							game.Lighting.FogColor = Color3.fromRGB(255, 0, 0)
						wait(0.2)
							game.Lighting.FogColor = Color3.fromRGB(255, 127, 0)
						wait(0.2)
							game.Lighting.FogColor = Color3.fromRGB(255, 255, 0)
						wait(0.2)
							game.Lighting.FogColor = Color3.fromRGB(127, 255, 0)
						wait(0.2)
							game.Lighting.FogColor = Color3.fromRGB(0, 255, 0)
						wait(0.2)
							game.Lighting.FogColor = Color3.fromRGB(0, 255, 127)
						wait(0.2)
							game.Lighting.FogColor = Color3.fromRGB(0, 255, 255)
						wait(0.2)
							game.Lighting.FogColor = Color3.fromRGB(0, 127, 255)
						wait(0.2)
							game.Lighting.FogColor = Color3.fromRGB(0, 0, 255)
						wait(0.2)
							game.Lighting.FogColor = Color3.fromRGB(127, 0, 255)
						wait(0.2)
							game.Lighting.FogColor = Color3.fromRGB(255, 0, 255)
						wait(0.2)
							game.Lighting.FogColor = Color3.fromRGB(255, 0, 127)
						wait(0.2)
					end
				else
					RainbowVal = false
				end

			else
				infonotify("SmokeFog", "Removed", 5)
				PermFog = false
				RainbowVal = false
				wait(0.2)
				game.Lighting.FogEnd = 99999999
				game.Lighting.FogStart = 99999999
			end
		end
	})
	SmokeFog.CreateDropdown({
		["Name"] = "Theme",
		["List"] = {"Smoke", "Fog", "RainbowBETA"},
		["Function"] = function(fogthemefunc)
			FogTheme.Value = fogthemefunc
		end
	})
	SmokeFog.CreateSlider({
		["Name"] = "FogEnd",
		["Max"] = 1000,
		["Min"] = 0,
		["Function"] = function(fogendfunc)
			FogEndValue = fogendfunc
		end,
		["Default"] = 500
	})
	SmokeFog.CreateSlider({
		["Name"] = "FogStart",
		["Max"] = 1000,
		["Min"] = 0,
		["Function"] = function(fogstartfunc)
			FogStartValue = fogstartfunc
		end,
		["Default"] = 0
	})
end)

runcode(function()
	local RainbowSkinVal = false
	local RainbowSkin = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		["Name"] = "RainbowSkin",
		["Function"] = function(callback)
			if callback then
				RainbowSkinVal = true
				while RainbowSkinVal and task.wait() do
					local player = game.Players.LocalPlayer
					local character = player.Character or player.CharacterAdded:Wait()
					for _,part in pairs(character:GetDescendants()) do
					if part:IsA("BasePart") then
						part.Color = Color3.new(math.random(), math.random(), math.random())
					end
					end
				end
			else
				RainbowSkinVal = false
				infonotify("RainbowSkin", "Disabled!", 5)
			end
		end
	})
end)

runcode(function()
	local LightingValue = 1
	local PermLight = false
	local Lighting = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		["Name"] = "Lighting",
		["Function"] = function(callback)
			if callback then
				PermLight = true
				while PermLight and task.wait() do
					game.Lighting.Brightness = LightingValue
				end
			else
				PermLight = false
				infonotify("Lighting", "Restoring normal lights...")
				wait(1)
				game.Lighting.Brightness = 2.5
				infonotify("Lighting", "Light Restored!")
			end
		end
	})
	Lighting.CreateSlider({
		["Name"] = "Value",
		["Max"] = 100,
		["Min"] = 0,
		["Function"] = function(lightvalfunc)
			LightingValue = lightvalfunc
		end
	})
end)

runcode(function()
	local ZoomVal = 100
	local PermZoom = false
	local CameraZoom = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		["Name"] = "CameraZoom",
		["Function"] = function(callback)
			if callback then
				PermZoom = true
				while PermZoom and task.wait() do
					game.Players.LocalPlayer.CameraMaxZoomDistance = ZoomVal
				end
			else
				PermZoom = false
				game.Players.LocalPlayer.CameraMaxZoomDistance = 50
			end
		end
	})
	CameraZoom.CreateSlider({
		["Name"] = "Max",
		["Max"] = 5000,
		["Min"] = 0,
		["Function"] = function(zoomvaluefunc)
			ZoomVal = zoomvaluefunc
		end
	})
end)

runcode(function()
	local ResetMethod = {Value = "InstaReset"}
	local ResetDelay = 0
	local ResetV2 = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		["Name"] = "ResetV2",
		["Function"] = function()
			if ResetMethod.Value == "InstaReset" then
				wait(ResetDelay)
				game.Players.LocalPlayer.Character.Humanoid:TakeDamage(999999)
			end

			if ResetMethod.Value == "Lagback" then
				wait(ResetDelay)
				game.Players.LocalPlayer.Character.Humanoid.JumpPower = 500
				game.Players.LocalPlayer.Character.Humanoid.Jump = true
				wait(1)
				game.Players.LocalPlayer.Character.Humanoid:TakeDamage(999999)
			end

			if ResetMethod.Value == "Cya" then
				wait(ResetDelay)
				game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("Cya", "All")
				game.Players.LocalPlayer.Character.Humanoid:TakeDamage(10000)
			end

			if ResetMethod.Value == "Fling" then
				wait(ResetDelay)
				game.Players.LocalPlayer.Character:MoveTo(Vector3.new(0,1000,0))
				wait(1)
				game.Players.LocalPlayer.Character.Humanoid:TakeDamage(999999)
			end

			if ResetMethod.Value == "Jump" then
				infonotify("ResetV2", "Just an jump method.", 5)
				wait(ResetDelay)
				game.Players.LocalPlayer.Character.Humanoid.JumpPower = 500
				game.Players.LocalPlayer.Character.Humanoid.Jump = true
				wait(1)
				game.Players.LocalPlayer.Character.Humanoid:TakeDamage(999999)
			end
		end
	})
	ResetV2.CreateSlider({
		["Name"] = "Reset Delay",
		["Min"] = 0,
		["Max"] = 30,
		["Function"] = function(ResetDelayFunc)
			ResetDelay = ResetDelayFunc
		end,
		["Default"] = 0
	})
	ResetV2.CreateDropdown({
		["Name"] = "Method",
		["List"] = {"InstaReset", "Lagback", "Fling", "Cya", "Jump"},
		["Function"] = function(ResetMethodFunc)
			ResetMethod.Value = ResetMethodFunc
		end
	})
end)

runcode(function()
	local FlyBetaVal = false
	local FlyGrav = 3
	local FlySpeed = 23
	local FlyGravDefault = 192
	local FlySpeedDefault = 16
	local FlyBeta = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		["Name"] = "FlyBeta",
		["Function"] = function(FlyFunc, DelayFlyVal)
			if FlyFunc then
				wait(DelayFlyVal)
				FlyBetaVal = true
				while FlyBetaVal do
					workspace.Gravity = FlyGrav
					game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = FlySpeed
					task.wait()
				end
			else
				FlyBetaVal = false
				workspace.Gravity = FlyGravDefault
				game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = FlySpeedDefault
			end
		end
	})
	FlyBeta.CreateSlider({
		["Name"] = "Delay",
		["Min"] = 0,
		["Max"] = 10,
		["Function"] = function(DelayFlyVal)
		end,
		["Default"] = 1
	})
end)

runcode(function()
	local AutoGuns = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		["Name"] = "AutoGuns",
		["Function"] = function(callback)
			if callback then
				infonotify("AutoGuns", "Getting Guns...", 5)
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(823.260498, 99.9899826, 2253.3291, 1, -8.28284996e-10, -0.000169262014, 8.28318247e-10, 1, 1.96093281e-10, 0.000169262014, -1.96233474e-10, 1)
				wait(0.2)
				workspace.Remote.ItemHandler:InvokeServer(workspace.Prison_ITEMS.giver["Remington 870"].ITEMPICKUP)
				workspace.Remote.ItemHandler:InvokeServer(workspace.Prison_ITEMS.giver.M9.ITEMPICKUP)
				wait(0.1)
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-937.466064, 94.1287613, 2061.44702, -0.0350593626, 2.13304414e-08, -0.999385238, 3.84639947e-08, 1, 1.9994209e-08, 0.999385238, -3.77393619e-08, -0.0350593626)
				wait(0.2)
				workspace.Remote.ItemHandler:InvokeServer(workspace.Prison_ITEMS.giver["AK-47"].ITEMPICKUP)
				wait(0.1)
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(931.399658, 99.9899826, 2388.50073, -1, 0, 0, 0, 1, 0, 0, 0, -1)
				infonotify("AutoGuns", "Done.", 5)
			end
		end,
		["HoverText"] = "Disable it after used"
	})
end)

runcode(function()
	local TeamVal = {Value = "Criminals"}
	local SelectTeam = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		["Name"] = "SelectTeam",
		["Function"] = function()

			if TeamVal.Value == "Criminals" then
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-921.168884, 95.327179, 2144.69336, -0.0187869966, 2.35240947e-08, -0.999823511, -3.93195201e-08, 1, 2.42670737e-08, 0.999823511, 3.97684872e-08, -0.0187869966)
				wait(0.2)
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(931.399658, 99.9899826, 2388.50073, -1, 0, 0, 0, 1, 0, 0, 0, -1)
			end

			if TeamVal.Value == "Inmates" then
				workspace.Remote.TeamEvent:FireServer("Bright orange")
			end

			if TeamVal.Value == "Guards" then
				workspace.Remote.TeamEvent:FireServer("Bright blue")
			end
		end
	})
	SelectTeam.CreateDropdown({
		["Name"] = "Teams",
		["List"] = {"Criminals", "Inmates", "Guards"},
		["Function"] = function(TeamsListFunc)
			TeamVal.Value = TeamsListFunc
		end
	})
end)

runcode(function()
	local RainbowM9Val = false
	local RainbowM9 = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		["Name"] = "RainbowM9",
		["Function"] = function(callback)
			if callback then
				RainbowM9Val = true
				infonotify("RainbowM9", "Enabled!", 5)
				local character = game.Workspace[game.Players.LocalPlayer.Name]
				local m9 = character.M9
				local part = m9 and m9:FindFirstChild("Part")
				if part then
					local rainbowColors = { 
						BrickColor.new("Really red"),
						BrickColor.new("Bright orange"),
						BrickColor.new("New Yeller"),
						BrickColor.new("Lime green"),
						BrickColor.new("Really blue"),
						BrickColor.new("Indigo"),
						BrickColor.new("Magenta"),
					}
					while RainbowM9Val do
						for i = 1, #rainbowColors do
							part.BrickColor = rainbowColors[i]
							wait(0.1)
						end
					end
				end
			else
				RainbowM9Val = false
				infonotify("RainbowM9", "Disabled!", 5)
			end
		end
	})
end)

runcode(function()
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local meleeEvent = ReplicatedStorage:WaitForChild("meleeEvent")
	local Players = game:GetService("Players")
	local KillAuraVal = false
	local KillAura = GuiLibrary.ObjectsThatCanBeSaved.CombatWindow.Api.CreateOptionsButton({
		["Name"] = "KillAura",
		["Function"] = function(callback)
			if callback then
				infonotify("KillAura", "Enabled!", 5)
				KillAuraVal = true
				while KillAuraVal and task.wait() do
					for _, player in ipairs(Players:GetPlayers()) do
						if player ~= Players.LocalPlayer then
							meleeEvent:FireServer(player)
						end
					end
				end
			else
				infonotify("KillAura", "Disabled!", 5)
				KillAuraVal = false
			end
		end
	})
end)


runcode(function()
	local FunnyM9Val = false
	local FummyM9Speed = 1
	local FunnyM9 = GuiLibrary.ObjectsThatCanBeSaved.CombatWindow.Api.CreateOptionsButton({
		["Name"] = "FunnyM9",
		["Function"] = function(callback)
			if callback then
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(823.260498, 99.9899826, 2253.3291, 1, -8.28284996e-10, -0.000169262014, 8.28318247e-10, 1, 1.96093281e-10, 0.000169262014, -1.96233474e-10, 1)
				wait(0.1)
				workspace.Remote.ItemHandler:InvokeServer(workspace.Prison_ITEMS.giver.M9.ITEMPICKUP)
				wait(0.5)
				local plr = game.Players.LocalPlayer
				local M9Item = "M9"
				local M9Found = plr.Backpack:FindFirstChild(M9Item)
				if M9Found then
					plr.Character.Humanoid:EquipTool(M9Found)
				end
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(931.399658, 99.9899826, 2388.50073, -1, 0, 0, 0, 1, 0, 0, 0, -1)
				wait()
				infonotify("Animation", "Enabled!", 5)
				FunnyM9Val = true
				while FunnyM9Val and task.wait() do
					for angle = 0, 360, FummyM9Speed do
							local radians = math.rad(angle)
							local offsetX = math.sin(radians)
							local offsetY = math.cos(radians)
							local position = Vector3.new(offsetX, 0, offsetY)
							game.Players.LocalPlayer.Character.M9.Grip = CFrame.new(position)
						wait()
					end
				end
			else
				FunnyM9Val = false
				infonotify("Animation", "Disabled!", 5)
			end
		end
	})
	FunnyM9.CreateSlider({
		["Name"] = "Speed",
		["Min"] = 1,
		["Max"] = 50,
		["Function"] = function(FummyM9Speed)
		end
	})
end)