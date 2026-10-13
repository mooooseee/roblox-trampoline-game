-- Compiled with roblox-ts v2.0.2
local TweenState = {
	Idle = 0,
	Animating = 1
}

local Size = {
	In = UDim2.new(.0008, 0, .0008, 0),
	Out = UDim2.new(3, 0, 3, 0)
}

function TweenGUI(Type, Frame)
	if Type == "Close" then
		Frame:TweenSize(Size.In, Enum.EasingDirection.In, Enum.EasingStyle.Linear, .5)
	elseif Type == "Open" then
		Frame:TweenSize(Size.Out, Enum.EasingDirection.Out, Enum.EasingStyle.Linear, .5)
	end
end


local CircularTransition

CircularTransition = setmetatable({}, {
	__tostring = function()
		return "CircularTransition"
	end,
})
CircularTransition.__index = CircularTransition
function CircularTransition.new(...)
	local self = setmetatable({}, CircularTransition)
	return self:constructor(...) or self
end

function CircularTransition:constructor(...)
	-- Initializing 
	self.screenGUI = script.Transition:Clone() -- GUI Clone
	self.State = "" -- State of the transition screen

	self.screenGUI.Parent = game.Players.LocalPlayer.PlayerGui
	
	self.screenGUI.Enabled = false
	TweenGUI("Open", self.screenGUI.Main)
	wait(1)
	self.screenGUI.Enabled = true
	self.State = TweenState.Idle
end


function CircularTransition:Play(length: number) -- Animating 
	if self.State ~= TweenState.Animating then
		self.State = TweenState.Animating

		if not length or length <= 0.5 then
			length = .6
		end

		TweenGUI("Close", self.screenGUI.Main)

		wait(length)

		TweenGUI("Open", self.screenGUI.Main)
		self.State = TweenState.Idle
	end
end

function CircularTransition:SetColor(Color: Color3)
	for i,v in pairs(self.screenGUI:GetDescendants()) do
		if v:IsA("Frame") then
			v.BackgroundColor3 = Color
		elseif v:IsA("ImageLabel") then
			v.ImageColor3 = Color
		end
	end
end

function CircularTransition:getScreenGui()
	return self.screenGUI
end


return CircularTransition
