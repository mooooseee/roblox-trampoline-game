while script.Parent do
	game:GetService("TweenService"):Create(script.Parent, TweenInfo.new(1), {Rotation = 2}):Play()
	task.wait(1.1)
	game:GetService("TweenService"):Create(script.Parent, TweenInfo.new(1), {Rotation = -2}):Play()
	task.wait(1.1)
end