--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local class = require(ReplicatedStorage.Packages.LuCid)

return function()

	local BaseClass = class() { val = 0 } {
		getVal = function(self)
			return self.val
		end,
	}

	local DerivedClass = class(BaseClass) { val = 100 } {
		getVal = function(self)
			return self:super():getVal() + 1
		end,
	}

	local dc = DerivedClass:create()
	assert(dc:getVal() == 101, "super basic call failed, expected 101, got " .. tostring(dc:getVal()))

end