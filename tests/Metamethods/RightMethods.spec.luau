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
			return self.x - other, self.y - other
		end,
		__rminus = function(self, other)
			return other - self.x, other - self.y
		end,
		__divide = function(self, scalar: number)
			return self.x / scalar, self.y / scalar
		end,
		__rdivide = function(self, scalar: number)
			return scalar / self.x, scalar / self.y
		end,
	}

	local v = Vec:create(2, 4)

	local lx, ly = v - 1
	if not (lx == 1 and ly == 3) then return "Expected (1,3), got (" .. tostring(lx) .. "," .. tostring(ly) .. ")" end

	local rx, ry = 10 - v
	if not (rx == 8 and ry == 6) then return "Expected (8,6), got (" .. tostring(rx) .. "," .. tostring(ry) .. ")" end

	local dx, dy = v / 2
	if not (dx == 1 and dy == 2) then return "Expected (1,2), got (" .. tostring(dx) .. "," .. tostring(dy) .. ")" end

	local rdx, rdy = 20 / v
	if not (rdx == 10 and rdy == 5) then return "Expected (10,5), got (" .. tostring(rdx) .. "," .. tostring(rdy) .. ")" end

	return true
end
