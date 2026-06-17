--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local class = require(ReplicatedStorage.Packages.LuCid)

return function(): boolean | string

	local ids = {}
	for i = 1, 10 do
		local T = class() { idx = i } {}
		local obj = T:create()
		local id = obj:getId()
		if not (type(id) == "string") then return "getId returns string" end
		if not (not ids[id]) then return "getId must be unique: " .. id end
		ids[id] = true
	end

	return true
end