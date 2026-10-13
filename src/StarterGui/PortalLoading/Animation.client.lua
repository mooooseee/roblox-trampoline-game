local TweenService = game:GetService("TweenService")

local module = require(game:GetService("ReplicatedStorage").Client.Modules.CircularTransition).new(game.Players.LocalPlayer)

local Time = 1
---------------------------------------------------------------------------------------------------------

game.ReplicatedStorage.Remotes.portalUiRE.OnClientEvent:Connect(function()
	--if arg == "close" then
	--	OpenViewport()
	--elseif arg == "open" then
	--	CloseViewport()
	--end
	module:Play(Time)
end)