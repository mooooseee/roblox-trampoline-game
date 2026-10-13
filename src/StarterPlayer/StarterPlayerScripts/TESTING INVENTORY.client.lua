local added = false
local re = game.ReplicatedStorage:WaitForChild("RemoteEvent"):: RemoteEvent

game:GetService("UserInputService").InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.Z then
		if not added then
			re:FireServer("add")
		elseif added then
			re:FireServer("rem")
		end
		added = not added
	end
end)