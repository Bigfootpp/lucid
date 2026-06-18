--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local class = require(ReplicatedStorage.Packages.LuCid)

return function(): boolean | string
	local Scalar = class() { val = 0 } {
		__init = function(self, v: number)
			self.val = v
		end,
		__plus = function(self, other)
			return self.val + other
		end,
		__times = function(self, other)
			return self.val * other
		end,
		__minus = function(self, other)
			return self.val - other
		end,
	}

	local s = Scalar:create(10)

	local leftAdd = s + 5
	if not (leftAdd == 15) then return "Expected 15, got " .. tostring(leftAdd) end

	local rightAdd = 5 + s
	if not (rightAdd == 15) then return "Commutative __plus: expected 15, got " .. tostring(rightAdd) end

	local leftMul = s * 3
	if not (leftMul == 30) then return "Expected 30, got " .. tostring(leftMul) end

	local rightMul = 3 * s
	if not (rightMul == 30) then return "Commutative __times: expected 30, got " .. tostring(rightMul) end

	local leftSub = s - 4
	if not (leftSub == 6) then return "Expected 6, got " .. tostring(leftSub) end

	local ok, err = pcall(function()
		local _ = 4 - s
	end)
	if not (not ok) then return "Non-commutative __minus without __rminus should error" end
	if not (string.find(err, "Non-commutative") or string.find(err, "__rminus")) then return "Error should mention __rminus, got: " .. tostring(err) end

	return true
end
