--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local class = require(ReplicatedStorage.Packages.LuCid)

return function(): boolean | string
	local Num = class() { x = 0, y = 0 } {
		__init = function(self, x: number, y: number)
			self.x = x
			self.y = y
		end,
		__plus = function(self, other)
			return self.x + other.x, self.y + other.y
		end,
		__minus = function(self, other)
			return self.x - other.x, self.y - other.y
		end,
		__times = function(self, other)
			if type(other) == "number" then
				return self.x * other, self.y * other
			end
			return self.x * other.x, self.y * other.y
		end,
		__divide = function(self, scalar: number)
			return self.x / scalar, self.y / scalar
		end,
		__floordiv = function(self, scalar: number)
			return math.floor(self.x / scalar), math.floor(self.y / scalar)
		end,
		__modulo = function(self, scalar: number)
			return self.x % scalar, self.y % scalar
		end,
		__power = function(self, scalar: number)
			return self.x ^ scalar, self.y ^ scalar
		end,
	}

	local a = Num:create(3, 4)
	local b = Num:create(1, 2)

	local sx, sy = a + b
	if not (sx == 4 and sy == 6) then return "Expected (4,6), got (" .. tostring(sx) .. "," .. tostring(sy) .. ")" end

	local dx, dy = a - b
	if not (dx == 2 and dy == 2) then return "Expected (2,2), got (" .. tostring(dx) .. "," .. tostring(dy) .. ")" end

	local mx, my = a * 2
	if not (mx == 6 and my == 8) then return "Expected (6,8), got (" .. tostring(mx) .. "," .. tostring(my) .. ")" end

	local cx, cy = a * b
	if not (cx == 3 and cy == 8) then return "Expected (3,8), got (" .. tostring(cx) .. "," .. tostring(cy) .. ")" end

	local dvx, dvy = a / 2
	if not (dvx == 1.5 and dvy == 2) then return "Expected (1.5,2), got (" .. tostring(dvx) .. "," .. tostring(dvy) .. ")" end

	local fx, fy = a // 2
	if not (fx == 1 and fy == 2) then return "Expected (1,2), got (" .. tostring(fx) .. "," .. tostring(fy) .. ")" end

	local mmx, mmy = a % 3
	if not (mmx == 0 and mmy == 1) then return "Expected (0,1), got (" .. tostring(mmx) .. "," .. tostring(mmy) .. ")" end

	local px, py = a ^ 2
	if not (px == 9 and py == 16) then return "Expected (9,16), got (" .. tostring(px) .. "," .. tostring(py) .. ")" end

	return true
end
