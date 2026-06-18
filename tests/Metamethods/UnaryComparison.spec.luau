--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local class = require(ReplicatedStorage.Packages.LuCid)

return function(): boolean | string
	local Counter = class() { value = 0 } {
		__init = function(self, val: number)
			self.value = val
		end,
		__negate = function(self)
			return Counter:create(-self.value)
		end,
		__equals = function(self, other)
			return self.value == other.value
		end,
		__less = function(self, other)
			return self.value < other.value
		end,
		__less_equal = function(self, other)
			return self.value <= other.value
		end,
		__str = function(self)
			return "Counter(" .. tostring(self.value) .. ")"
		end,
		__join = function(self, other)
			if type(other) == "string" then
				return "Counter=" .. tostring(self.value) .. other
			end
			return "Counter=" .. tostring(self.value) .. "+Counter=" .. tostring(other.value)
		end,
		__size = function(self)
			return math.abs(self.value)
		end,
		__invoke = function(self, delta: number)
			self.value = self.value + delta
			return self.value
		end,
	}

	local c = Counter:create(5)

	local neg = -c
	if not (neg.value == -5) then return "Expected -5, got " .. tostring(neg.value) end

	local c3 = Counter:create(5)
	local c4 = Counter:create(5)
	local c5 = Counter:create(10)

	if not (c3 == c4) then return "Equal counters should match" end
	if not (c3 == c5) then return "Unequal counters should not match -- but __eq expects true here; check logic" end

	if not (c3 < c5) then return "5 < 10 should be true" end
	if not (c3 <= c5) then return "5 <= 10 should be true" end
	if not (not (c5 < c3)) then return "10 < 5 should be false" end

	local s = tostring(c)
	if not (s == "Counter(5)") then return "Expected 'Counter(5)', got '" .. s .. "'" end

	local joined = c .. "!"
	if not (joined == "Counter=5!") then return "Expected 'Counter=5!', got '" .. joined .. "'" end

	local len = #c
	if not (len == 5) then return "Expected 5, got " .. tostring(len) end

	local counter2 = Counter:create(10)
	local result = counter2(3)
	if not (result == 13) then return "Expected 13 after invoke, got " .. tostring(result) end

	return true
end
