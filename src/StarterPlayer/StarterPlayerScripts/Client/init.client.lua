--[[
	title: client
	author: moose
]]--

--//Services

local Players = game:GetService("Players");

--//Variables

local Player = Players.LocalPlayer;

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Services = (ReplicatedStorage:WaitForChild("Client"):WaitForChild("Services"));
local cached: {ModuleScript} = {};

if not game.Players.LocalPlayer.Character then
	game.Players.LocalPlayer.CharacterAdded:Wait()
end

if not game:IsLoaded() then
	game.Loaded:Wait()
end

-->Shared Modules
for _, ModuleScript in pairs(Services:GetChildren()) do
	if ModuleScript:IsA("ModuleScript") then
		cached[ModuleScript.Name] = require(ModuleScript);
	end	
end

-->Client Sides Modules
for _, mod in script:GetChildren() do
	if mod:IsA("ModuleScript") then
		print("Requiring "..mod.Name)
		cached[mod.Name] = require(mod)
	end
end

-->Run Init
for _, moduleScript in cached do
	if moduleScript.Init then
		moduleScript:Init()
	end
end
