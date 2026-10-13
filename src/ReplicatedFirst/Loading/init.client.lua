local CollectionService = game:GetService("CollectionService");
local ContentProvider = game:GetService("ContentProvider");
local TweenService = game:GetService("TweenService")

local Player = game.Players.LocalPlayer
local PlayerGui: PlayerGui = Player:WaitForChild("PlayerGui")

local ui = script.LoadingUi

local LOADING_BAR_MAX_SIZE = UDim2.new(0.551, 0, .059, 0)
--ContentProvider:PreloadAsync(CollectionService:GetTagged("trampoline"))
--ContentProvider:PreloadAsync(CollectionService:GetTagged("hitbox"))
--ContentProvider:PreloadAsync(CollectionService:GetTagged("angledTramp"))

local clone = ui:Clone()
local Container = clone:WaitForChild("Container")
local Background = Container:WaitForChild("Background")
local ProgressFolder = Background:WaitForChild("Progress")
local loadingBar = ProgressFolder:WaitForChild("progress")
local loadingBack = ProgressFolder:WaitForChild("progressBack")
local assetsText = ProgressFolder:WaitForChild("TextLabel")

ContentProvider:PreloadAsync({Container})
game.StarterGui:SetCore("ResetButtonCallback", false)

local done = false

--assetsText.Text = "0/"..maxAssets
assetsText.Text = "0%"
clone.Parent = PlayerGui
task.spawn(function()
	for i = 1, 100 do
		--assetsText.Text = i.."/".. maxAssets
		local percentage = i / 100
		assetsText.Text = i.."%"
		TweenService:Create(loadingBar, TweenInfo.new(.05, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {Size = UDim2.fromScale(LOADING_BAR_MAX_SIZE.X.Scale*(percentage), LOADING_BAR_MAX_SIZE.Y.Scale)}):Play()
		
		if i % 10 == 0 then
			task.wait()
		end
		
		if i == 100 then
			if not game:IsLoaded() then
				game.Loaded:Wait()
			end
			loadingBack.Visible = false
			task.wait(.2)
			task.wait(.4)
			TweenService:Create(Container, TweenInfo.new(1.4), {Position = UDim2.fromScale(0, -2)}):Play()
			PlayerGui:WaitForChild("Menu").Container.Visible = true
			task.wait(1.5)
			done = true
			clone:Destroy()
		end
		--loadingBar.Size = UDim2.new(LOADING_BAR_MAX_SIZE.X.Scale * (i/#assets), 0, LOADING_BAR_MAX_SIZE.Y.Scale, 0)
		task.wait(math.random(.5, .9))
	end
end)


