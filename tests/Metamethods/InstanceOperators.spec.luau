--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local class = require(ReplicatedStorage.Packages.LuCid)

return function(): boolean | string
	local Wrapper = class() { inner = nil } {
		__init = function(self, value)
			self.inner = value
		end,
		__plus = function(self, other)
			return self.inner + other.inner
		end,
		__equals = function(self, other)
			return self.inner == other.inner
		end,
	}

	local w1 = Wrapper:create(5)
	local w2 = Wrapper:create(3)

	local sum = w1 + w2
	if not (sum == 8) then return "Instance + Instance: expected 8, got " .. tostring(sum) end

	return true
end
