--!strict
local ButtonStyle = {}

local SETTINGS = {
	Direction = Enum.EasingDirection.InOut;
	Style = Enum.EasingStyle.Quad;
	Time = .1;
}

local HoverSound = game:GetService("ReplicatedStorage").Client.Sounds.Hover
local ClickSound = game:GetService("ReplicatedStorage").Client.Sounds.Click

-->Button With Shadow
function ButtonStyle.ShadowButton(button: GuiButton, shadow: GuiObject, container: GuiObject)
	if not container then
		container = button
	end
	assert(container)
	local inside = false
	local down = false
	local baseColor: Color3 = container.BackgroundColor3

	local absoluteSize = container.AbsoluteSize
	local offsetUdim = UDim2.fromOffset(absoluteSize.X * .1, absoluteSize.Y * .1)
	local smallOffsetUdim = UDim2.fromOffset(absoluteSize.X * .05, absoluteSize.Y * .05)

	local baseSize: UDim2 = container.Size
	local basePostion: UDim2 = button.Position --Button's base position
	local biggerSize: UDim2 = baseSize + offsetUdim
	local smallerSize: UDim2 = baseSize - smallOffsetUdim

	button.MouseEnter:Connect(function()
		inside = true
		container:TweenSize(biggerSize, SETTINGS.Direction, SETTINGS.Style, SETTINGS.Time, true)
		HoverSound:Play()
	end)
	
	button.MouseLeave:Connect(function()
		inside = false
		container:TweenSize(baseSize, SETTINGS.Direction, SETTINGS.Style, SETTINGS.Time, true)
		if down then
			button:TweenPosition(basePostion, SETTINGS.Direction, SETTINGS.Style, SETTINGS.Time, true)
		end
	end)
	
	button.MouseButton1Down:Connect(function()
		down = true
		button:TweenPosition(shadow.Position, SETTINGS.Direction, SETTINGS.Style, SETTINGS.Time, true)
		ClickSound:Play()
	end)
	
	button.MouseButton1Up:Connect(function()
		down = false
		button:TweenPosition(basePostion, SETTINGS.Direction, SETTINGS.Style, SETTINGS.Time, true)
	end)
end

-->Button With Soft Style
function ButtonStyle.SoftButton(button: GuiButton, container: GuiObject?)
	if not container then
		container = button
	end
	assert(container)
	local inside = false
	local baseColor: Color3 = container.BackgroundColor3

	local absoluteSize = container.AbsoluteSize
	local offsetUdim = UDim2.fromOffset(absoluteSize.X * .1, absoluteSize.Y * .1)
	local smallOffsetUdim = UDim2.fromOffset(absoluteSize.X * .05, absoluteSize.Y * .05)

	local baseSize: UDim2 = container.Size
	local biggerSize: UDim2 = baseSize + offsetUdim
	local smallerSize: UDim2 = baseSize - smallOffsetUdim

	button.MouseEnter:Connect(function()
		inside = true
		container:TweenSize(biggerSize, SETTINGS.Direction, SETTINGS.Style, SETTINGS.Time, true)
		HoverSound:Play()
	end)

	button.MouseLeave:Connect(function()
		inside = false
		container:TweenSize(baseSize, SETTINGS.Direction, SETTINGS.Style, SETTINGS.Time, true)
	end)

	button.MouseButton1Down:Connect(function()
		container:TweenSize(smallerSize, SETTINGS.Direction, SETTINGS.Style, SETTINGS.Time, true)
		ClickSound:Play()
	end)

	button.MouseButton1Up:Connect(function()
		if inside then
			container:TweenSize(biggerSize, SETTINGS.Direction, SETTINGS.Style, SETTINGS.Time, true)
		else
			container:TweenSize(baseSize, SETTINGS.Direction, SETTINGS.Style, SETTINGS.Time, true)
		end
	end)
end


return ButtonStyle