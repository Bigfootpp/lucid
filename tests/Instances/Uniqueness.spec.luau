--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local class = require(ReplicatedStorage.Packages.LuCid)

return function(): boolean | string

	local ids = {}
	for i = 1, 10 do
		local T = class() { idx = i } {}
		local obj = T:create()
		local id = obj:GetId()
		if not (type(id) == "string") then return "GetId returns string" end
		if not (not ids[id]) then return "GetId must be unique: " .. id end
		ids[id] = true
	end

	return true
end