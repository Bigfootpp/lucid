--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local class = require(ReplicatedStorage.Packages.LuCid)

return function(): boolean | string
	local Scalar = class() { val = 0 } {
		__init = function(self, v: number)
			self.val = v
		end,
		__plus = function(self, other)
			return Scalar:create(self.val + other)
		end,
		__times = function(self, other)
			return Scalar:create(self.val * other)
		end,
		__minus = function(self, other)
			return Scalar:create(self.val - other)
		end,
	}

	local s = Scalar:create(10)

	local leftAdd = s + 5
	if not (leftAdd.val == 15) then return "Expected 15, got " .. tostring(leftAdd.val) end

	local rightAdd = 5 + s
	if not (rightAdd.val == 15) then return "Commutative __plus: expected 15, got " .. tostring(rightAdd.val) end

	local leftMul = s * 3
	if not (leftMul.val == 30) then return "Expected 30, got " .. tostring(leftMul.val) end

	local rightMul = 3 * s
	if not (rightMul.val == 30) then return "Commutative __times: expected 30, got " .. tostring(rightMul.val) end

	local leftSub = s - 4
	if not (leftSub.val == 6) then return "Expected 6, got " .. tostring(leftSub.val) end

	local subOk = false
	local ok, err = pcall(function()
		local _ = 4 - s
	end)
	if not (not ok) then return "Non-commutative __minus without __rminus should error" end
	if not (string.find(err, "Non-commutative") or string.find(err, "__rminus")) then return "Error should mention __rminus, got: " .. tostring(err) end

	return true
end
