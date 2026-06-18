--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local class = require(ReplicatedStorage.Packages.LuCid)

return function(): boolean | string
	-- 1. Test basic arithmetic & commutative metamethods
	local NumberWrapper = class() { val = 0 } {
		__init = function(self, val: number)
			self.val = val
		end,
		__plus = function(self, other)
			local otherVal = typeof(other) == "table" and other.val or other
			return self.val + otherVal
		end,
		__times = function(self, other)
			local otherVal = typeof(other) == "table" and other.val or other
			return self.val * otherVal
		end,
		__str = function(self)
			return "Num(" .. tostring(self.val) .. ")"
		end,
		__equals = function(self, other)
			if typeof(other) ~= "table" then return false end
			return self.val == other.val
		end,
		__less = function(self, other)
			if typeof(other) ~= "table" then return false end
			return self.val < other.val
		end,
		__size = function(self)
			return math.abs(self.val)
		end,
	}

	local n1 = NumberWrapper:create(10)
	local n2 = NumberWrapper:create(20)

	-- Addition (basic + commutative)
	local sum1 = n1 + n2
	if sum1 ~= 30 then return "Basic addition failed: expected 30, got " .. tostring(sum1) end

	local sum2 = n1 + 5
	if sum2 ~= 15 then return "Addition with primitive on right failed: expected 15, got " .. tostring(sum2) end

	local sum3 = 5 + n1
	if sum3 ~= 15 then return "Commutative addition fallback failed: expected 15, got " .. tostring(sum3) end

	-- Multiplication (commutative fallback)
	local prod1 = n1 * 3
	if prod1 ~= 30 then return "Multiplication with primitive on right failed: expected 30, got " .. tostring(prod1) end

	local prod2 = 3 * n1
	if prod2 ~= 30 then return "Commutative multiplication fallback failed: expected 30, got " .. tostring(prod2) end

	-- Stringification
	if tostring(n1) ~= "Num(10)" then return "Stringification failed: expected 'Num(10)', got " .. tostring(n1) end

	-- Equality & Comparisons
	if not (n1 == NumberWrapper:create(10)) then return "Equality comparison failed" end
	if n1 == n2 then return "Equality comparison failed (should not be equal)" end
	if not (n1 < n2) then return "Less-than comparison failed" end

	-- Size (length)
	local negativeNum = NumberWrapper:create(-42)
	if #negativeNum ~= 42 then return "Size metamethod failed: expected 42, got " .. tostring(#negativeNum) end

	-- 2. Test non-commutative reflected methods (like division or subtraction)
	local MathObj = class() { val = 0 } {
		__init = function(self, val: number)
			self.val = val
		end,
		__minus = function(self, other)
			local otherVal = typeof(other) == "table" and other.val or other
			return self.val - otherVal
		end,
		__rminus = function(self, other)
			-- other - self
			local otherVal = typeof(other) == "table" and other.val or other
			return otherVal - self.val
		end,
	}

	local m = MathObj:create(10)
	local subRight = m - 3 -- self - 3 -> 10 - 3 = 7
	if subRight ~= 7 then return "Basic subtraction failed: expected 7, got " .. tostring(subRight) end

	local subLeft = 25 - m -- 25 - self -> 25 - 10 = 15
	if subLeft ~= 15 then return "Reflected subtraction __rminus failed: expected 15, got " .. tostring(subLeft) end

	-- 3. Test division without reflected method (should throw when primitive is on left)
	local DivObj = class() { val = 1 } {
		__init = function(self, val: number)
			self.val = val
		end,
		__divide = function(self, other)
			local otherVal = typeof(other) == "table" and other.val or other
			return self.val / otherVal
		end,
	}

	local d = DivObj:create(2)
	local divRight = d / 2 -- works fine
	if divRight ~= 1 then return "Basic division on right failed" end

	local success, err = pcall(function()
		return 10 / d -- should throw because __rdivide is not defined
	end)
	if success then
		return "Expected error when calling non-commutative division from left without __rdivide"
	end
	if not string.find(tostring(err), "__rdivide") then
		return "Expected error message to mention '__rdivide', got: " .. tostring(err)
	end

	-- 4. Prevent Native Metamethod declaration error
	local createFailSuccess, createFailErr = pcall(function()
		class() {} {
			__add = function(self, other)
				return 0
			end
		}
	end)
	if createFailSuccess then
		return "Expected class creation to fail when defining __add directly"
	end
	if not string.find(tostring(createFailErr), "Cannot override native metamethods") then
		return "Expected 'Cannot override native metamethods' error, got: " .. tostring(createFailErr)
	end

	return true
end
