--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local class = require(ReplicatedStorage.Packages.LuCid)

return function()

	local Orphan = class() {} {
		trySuper = function(self)
			return pcall(function()
				local s = self:super()
			end)
		end,
	}

	local orphan = Orphan:create()
	local success = orphan:trySuper()
	assert(not success, "super() on class without parent should error")

end