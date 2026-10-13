--!strict

local Players = game:GetService("Players")
local template = script.Parent.template;

local GlobalLeaderboardClass = {}
GlobalLeaderboardClass.__index = GlobalLeaderboardClass

export type ClassType = typeof(setmetatable(
	{}:: {
		_model: Model,
		_container: ScrollingFrame,
		_datastore: OrderedDataStore
	},
	GlobalLeaderboardClass
	)
)

function GlobalLeaderboardClass.new(model: Model, scrollContainer: ScrollingFrame, datastore: OrderedDataStore): ClassType
	local self = {
		_model = model,
		_container = scrollContainer,
		_datastore = datastore
	}
	
	setmetatable(self, GlobalLeaderboardClass)
	return self
end

function GlobalLeaderboardClass.cleanUp(self: ClassType)
	for _, element in pairs(self._container:GetChildren()) do
		if element:IsA("Frame") then
			element:Destroy()
		end
	end
end

function GlobalLeaderboardClass.setUpPages(self: ClassType)
	local success, pages: Pages = pcall(function()
		return self._datastore:GetSortedAsync(false, 20):: Pages
	end)
	
	if success and pages:IsA("Pages") then
		for i, entry in pages:GetCurrentPage() do
			if Players:GetNameFromUserIdAsync(entry.key) and entry.value >= 1 then
				local clone = template:Clone()
				clone.Parent = self._container
				clone.position.Text = tostring(i).."."
				clone.username.Text = Players:GetNameFromUserIdAsync(entry.key)
				clone.value.Text = entry.value
			end
		end
	end
end

return GlobalLeaderboardClass
