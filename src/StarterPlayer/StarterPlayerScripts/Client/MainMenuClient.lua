--!strict
local ButtonStyle = require(game:GetService("ReplicatedStorage").Client.Modules.ButtonStyle)
-->Services
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
-->Player Variables
local Player = Players.LocalPlayer
local camera = workspace.CurrentCamera;
local mouse = Player:GetMouse();
-->UI Variables
local MenuUi = Player.PlayerGui.Menu
local PlayContainer = MenuUi.Container.Buttons.PlayContainer
local playButton = PlayContainer.playButton
local playShadow = PlayContainer.playShadow

local pointsUi = Player.PlayerGui:WaitForChild("Points")
local hotbarPc = Player.PlayerGui:WaitForChild("hotbarPC")
local hotbarMobile = Player.PlayerGui:WaitForChild("hotbarMobile")

-->Other
local camPart = workspace:WaitForChild("cameraPart")
local menuBlur = game:GetService("Lighting").menuBlur

local unblurTween = TweenService:Create(menuBlur, TweenInfo.new(1), {Size = 0});

local MainMenuClient = {}

ButtonStyle.ShadowButton(playButton, playShadow, PlayContainer)

menuBlur.Enabled = true;
Player.Character:FindFirstChild("HumanoidRootPart").Anchored = true;
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false);

local DEFAULT_CFRAME = camera.CFrame

repeat
	task.wait()
	camera.CameraType = Enum.CameraType.Scriptable
until camera.CameraType == Enum.CameraType.Scriptable
camera.CFrame = camPart.CFrame

local menuMouseLoop = RunService.RenderStepped:Connect(function()
	local center = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2);
	local moveVector = Vector3.new((-mouse.X+center.X)/250, (-mouse.Y+center.Y)/250, 0);
	camera.CFrame = camPart.CFrame * CFrame.Angles(math.rad(moveVector.Y), math.rad(moveVector.X), 0);
end)

playButton.MouseButton1Click:Connect(function()
	menuMouseLoop:Disconnect()
	local camTween: Tween = TweenService:Create(camera, TweenInfo.new(.8), {CFrame = DEFAULT_CFRAME})
	camTween:Play()
	unblurTween:Play()
	Player.Character:FindFirstChild("HumanoidRootPart").Anchored = false
	MenuUi.Container.Visible = false
	camTween.Completed:Once(function()
		camera.CameraType = Enum.CameraType.Custom
	end)
	pointsUi.Enabled = true
	if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
		hotbarMobile.Enabled = true
	elseif not UserInputService.TouchEnabled and UserInputService.KeyboardEnabled then
		hotbarPc.Enabled = true
	end
end)

return MainMenuClient