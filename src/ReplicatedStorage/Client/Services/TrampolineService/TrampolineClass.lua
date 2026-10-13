--!strict
local TrampolineClass = {}
TrampolineClass.__index = TrampolineClass;

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Modules = ReplicatedStorage:WaitForChild("Client"):WaitForChild("Modules");
local ZoneModule = require(Modules.Zone);

local Player = game.Players.LocalPlayer;
local jumpingConn: RBXScriptConnection

function TrampolineClass.new(hitbox: BasePart)
	local self = setmetatable({}, TrampolineClass);
	
	self._hitbox = hitbox;
	self._zone = ZoneModule.new(hitbox);
	
	self._zone.localPlayerEntered:Connect(function()
		print("enter")
		if Player.Character then
			Player.Character:FindFirstChild("Humanoid").JumpHeight = 30;
			
			-->Jump sound
			jumpingConn = (Player.Character.Humanoid::Humanoid).Jumping:Connect(function()
				ReplicatedStorage.Client.Sounds.JumpSound:Play()
			end)
			
		end
	end)
	
	self._zone.localPlayerExited:Connect(function()
		print("left")
		Player.Character:FindFirstChild("Humanoid").JumpHeight = 7.2;
		if jumpingConn then
			jumpingConn:Disconnect()
		end
	end)
	
	return self;
end

return TrampolineClass
