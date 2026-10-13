local pointUpdateRE = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("pointUpdateRE")
local valueText = script.Parent

pointUpdateRE.OnClientEvent:Connect(function(newValue: number)
	if tonumber(valueText.Text) < newValue then
		valueText.Text = tostring(newValue)
	end
end)