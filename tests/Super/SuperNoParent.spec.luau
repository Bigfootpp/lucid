--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local class = require(ReplicatedStorage.Packages.LuCid)

return function(): boolean | string

	local Orphan = class() {} {
		trySuper = function(self)
			return pcall(function()
				local _ = self:super()
			end)
		end,
	}

	local orphan = Orphan:create()
	local success = orphan:trySuper()
	if not (not success) then return "super() on class without parent should error" end

	return true
end