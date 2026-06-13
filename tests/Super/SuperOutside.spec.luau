--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local class = require(ReplicatedStorage.Packages.LuCid)

return function()

	local Simple = class() {} {
		method = function(self)
			return "ok"
		end,
	}

	local simpleObj = Simple:create()
	local ok, err: string? = pcall(function(): string?
		return simpleObj:super()
	end)
	if ok then return "super() outside of method should error" end
	if not (string.find(err, "outside")) then return "Error message should mention 'outside' or 'super'" end

	return true
end