--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local class = require(ReplicatedStorage.Packages.LuCid)

return function()

	local ids = {}
	for i = 1, 10 do
		local T = class() { idx = i } {}
		local obj = T:create()
		local id = obj:GetId()
		assert(type(id) == "string", "GetId returns string")
		assert(not ids[id], "GetId must be unique: " .. id)
		ids[id] = true
	end

end