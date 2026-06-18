--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local class = require(ReplicatedStorage.Packages.LuCid)

return function(): boolean | string
	local Vec = class() { x = 0, y = 0 } {
		__init = function(self, x: number, y: number)
			self.x = x
			self.y = y
		end,
		__minus = function(self, other)
			return Vec:create(self.x - other, self.y - other)
		end,
		__rminus = function(self, other)
			return Vec:create(other - self.x, other - self.y)
		end,
		__divide = function(self, scalar: number)
			return Vec:create(self.x / scalar, self.y / scalar)
		end,
		__rdivide = function(self, scalar: number)
			return Vec:create(scalar / self.x, scalar / self.y)
		end,
	}

	local v = Vec:create(2, 4)

	local leftSub = v - 1
	if not (leftSub.x == 1 and leftSub.y == 3) then return "Expected (1,3), got (" .. tostring(leftSub.x) .. "," .. tostring(leftSub.y) .. ")" end

	local rightSub = 10 - v
	if not (rightSub.x == 8 and rightSub.y == 6) then return "Expected (8,6), got (" .. tostring(rightSub.x) .. "," .. tostring(rightSub.y) .. ")" end

	local leftDiv = v / 2
	if not (leftDiv.x == 1 and leftDiv.y == 2) then return "Expected (1,2), got (" .. tostring(leftDiv.x) .. "," .. tostring(leftDiv.y) .. ")" end

	local rightDiv = 20 / v
	if not (rightDiv.x == 10 and rightDiv.y == 5) then return "Expected (10,5), got (" .. tostring(rightDiv.x) .. "," .. tostring(rightDiv.y) .. ")" end

	return true
end
