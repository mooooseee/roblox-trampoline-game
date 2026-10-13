--!strict
local SoundService = game:GetService("SoundService")
local music: Sound = SoundService:WaitForChild("BackgroundMusic")

local ids: {number} = {1839910816, 9046864489}
local iteration: number = 1

local MusicService = {}

function MusicService.start()
	task.spawn(function()
		while true do
			music.SoundId = "rbxassetid://"..ids[iteration]
			
			if iteration == #ids then
				iteration = 1
			else
				iteration += 1
			end
			music:Play()
			music.Ended:Wait()
		end
	end)
	
	print("MusicService Started")
end

return MusicService
