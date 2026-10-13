local TweenService = game:GetService("TweenService")

local tween = TweenService:Create(script.Parent, TweenInfo.new(15, Enum.EasingStyle.Linear), {Position = UDim2.fromScale(0, -1)})

while true do
	script.Parent.Position = UDim2.fromScale(-1, 0)
	tween:Play()
	tween.Completed:Wait()
end