--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local class = require(ReplicatedStorage.Packages.LuCid)

return function()

	local AsyncBase = class() { val = "async" } {
		getVal = function(self)
			return self.val
		end,
	}

	local AsyncChild = class(AsyncBase) { val = "child" } {
		getValAsync = function(self)
			return self:super():getVal()
		end,
	}

	local asyncChild = AsyncChild:create()
	assert(asyncChild:getValAsync() == "child", "super in sync context should work")

	local _, _ = pcall(function()
		task.delay(0, function()
			asyncChild:super()
		end)
	end)
end