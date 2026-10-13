--Serivices

local ReplicatedStorage = game:GetService("ReplicatedStorage")

--Variables

local slots = script.Parent

local slotsRE = ReplicatedStorage.Remotes.slotsRE

--Functins

slotsRE.OnClientEvent:Connect(function(slot: string, arg: string, image: string?)
	local slotToEdit = slots:FindFirstChild(slot)
	if slotToEdit and arg == "add" and image then
		local flipButton = script.template:Clone()
		flipButton.Image = image
		flipButton.Parent = slotToEdit
	elseif slotToEdit and arg == "rem" then
		if slotToEdit:FindFirstChildOfClass("ImageLabel") then
			slotToEdit:FindFirstChildOfClass("ImageLabel"):Destroy()
		end
	end
end)