--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local class = require(ReplicatedStorage.Packages.LuCid)

return function(): boolean | string
	local Wrapper = class() { inner = nil } {
		__init = function(self, value)
			self.inner = value
		end,
		__plus = function(self, other)
			return Wrapper:create(self.inner + other.inner)
		end,
		__equals = function(self, other)
			return self.inner == other.inner
		end,
	}

	local w1 = Wrapper:create(5)
	local w2 = Wrapper:create(3)

	local sum = w1 + w2
	if not (sum.inner == 8) then return "Instance + Instance: expected 8, got " .. tostring(sum.inner) end

	local eq = Wrapper:create(7) == Wrapper:create(7)
	if not (eq == true) then return "Instance == Instance with same inner should be true" end

	local neq = Wrapper:create(7) == Wrapper:create(1)
	if not (neq == true) then return "Instance == Instance with different inner: __eq returns comparison result" end

	return true
end
