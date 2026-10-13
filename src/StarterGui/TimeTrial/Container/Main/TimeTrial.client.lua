--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local timeTrialRE = ReplicatedStorage.Remotes.timeTrialRE

local ui = script.Parent.Parent.Parent
local pbText = script.Parent.PersonalBest
local timeText = script.Parent.Time

local startTime: number
local currentTime: number
local stop = false

local connection: RBXScriptConnection

--functions

local function startTimer(personalBest: number)
	if not ui.Enabled then
		ui.Enabled = true
		startTime = tick()
		currentTime = 0
		stop = false
		
		if personalBest ~= math.huge then
			pbText.Text = "PB: "..string.format("%.3f", (personalBest))
		else 
			pbText.Text = "PB: N/A"
		end
		
		connection = RunService.RenderStepped:Connect(function()
			if not stop then
				currentTime = tick() - startTime
				timeText.Text = string.format("%.3f", currentTime)
			end
		end)
	end
end

local function stopTimer(fail: boolean, pb: NumberValue?)
	if not stop and ui.Enabled then
		connection:Disconnect()
		stop = true
		if fail then
			timeText.Text = "0.000"
		else
			timeText.TextColor3 = Color3.new(0, 200, 0)
			if pb and currentTime < pb.Value then
				print(pb)
				pbText.Text = "PB: "..string.format("%.3f", currentTime)
				pbText.TextColor3 = Color3.new(0, 200, 0)
				timeTrialRE:FireServer(currentTime, pb.Name)
			end
			task.wait(1.5)
		end
		ui.Enabled = false
		currentTime = 0
		startTime = 0
		timeText.TextColor3 = Color3.new(255, 255, 255)
	end 
end

timeTrialRE.OnClientEvent:Connect(function(arg: string, pb: NumberValue)--TODO sync up pb
	if arg == "start" then
		startTimer(pb.Value)
	elseif arg == "end" then
		stopTimer(false, pb)
	elseif arg == "fail" then
		stopTimer(true)
	end
end)