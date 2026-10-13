local TrampolineService = {}

local CollectionService = game:GetService("CollectionService");

local TrampolineClass = require(script.TrampolineClass);

function TrampolineService:Init()
	for _, hitbox in CollectionService:GetTagged("hitbox") do
		TrampolineClass.new(hitbox);
	end
	
	CollectionService:GetInstanceAddedSignal("hitbox"):Connect(function(instance)
		TrampolineClass.new(instance);
	end)
	
	for _, angledTramp: BasePart in CollectionService:GetTagged("angledTramp") do
		TrampolineService._angleTramp(angledTramp)
	end
	
	CollectionService:GetInstanceAddedSignal("angledTramp"):Connect(function(instance)
		TrampolineService._angleTramp(instance)
	end)
	
	print("Trampolines initialized!");
end

function TrampolineService._angleTramp(angledTramp: BasePart)
	angledTramp.Touched:Connect(function(other)
		if other.Parent:FindFirstChild("Humanoid") then
			local hrp: BasePart = other.Parent:FindFirstChild("HumanoidRootPart")
			local vel = (angledTramp.CFrame.LookVector * 110)

			hrp.AssemblyLinearVelocity = vel
		end
	end)
end



return TrampolineService
