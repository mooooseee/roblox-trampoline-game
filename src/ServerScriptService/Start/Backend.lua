local Backend = {}

local Services = script.Parent.Parent.Services;

function Backend.start()
	warn("---STARTING BACKEND---")
	for _, service: ModuleScript in ipairs(Services:GetChildren()) do
		if service:IsA("ModuleScript") and service.Name:match("Service$") and require(service).start then
			require(service).start()
		end
	end
	warn("---BACKEND STARTED---")
end


return Backend
