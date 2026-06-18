--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local class = require(ReplicatedStorage.Packages.LuCid)

return function(): boolean | string
	local Vec2 = class() { x = 0, y = 0 } {
		__init = function(self, x: number, y: number)
			self.x = x
			self.y = y
		end,
		__plus = function(self, other)
			return Vec2:create(self.x + other.x, self.y + other.y)
		end,
		__minus = function(self, other)
			return Vec2:create(self.x - other.x, self.y - other.y)
		end,
		__times = function(self, other)
			if type(other) == "number" then
				return Vec2:create(self.x * other, self.y * other)
			end
			return Vec2:create(self.x * other.x, self.y * other.y)
		end,
		__divide = function(self, scalar: number)
			return Vec2:create(self.x / scalar, self.y / scalar)
		end,
		__floordiv = function(self, scalar: number)
			return Vec2:create(math.floor(self.x / scalar), math.floor(self.y / scalar))
		end,
		__modulo = function(self, scalar: number)
			return Vec2:create(self.x % scalar, self.y % scalar)
		end,
		__power = function(self, scalar: number)
			return Vec2:create(self.x ^ scalar, self.y ^ scalar)
		end,
	}

	local a = Vec2:create(3, 4)
	local b = Vec2:create(1, 2)

	local sum = a + b
	if not (sum.x == 4 and sum.y == 6) then return "Expected (4,6), got (" .. tostring(sum.x) .. "," .. tostring(sum.y) .. ")" end

	local diff = a - b
	if not (diff.x == 2 and diff.y == 2) then return "Expected (2,2), got (" .. tostring(diff.x) .. "," .. tostring(diff.y) .. ")" end

	local scaled = a * 2
	if not (scaled.x == 6 and scaled.y == 8) then return "Expected (6,8), got (" .. tostring(scaled.x) .. "," .. tostring(scaled.y) .. ")" end

	local component = a * b
	if not (component.x == 3 and component.y == 8) then return "Expected (3,8), got (" .. tostring(component.x) .. "," .. tostring(component.y) .. ")" end

	local divided = a / 2
	if not (divided.x == 1.5 and divided.y == 2) then return "Expected (1.5,2), got (" .. tostring(divided.x) .. "," .. tostring(divided.y) .. ")" end

	local floored = a // 2
	if not (floored.x == 1 and floored.y == 2) then return "Expected (1,2), got (" .. tostring(floored.x) .. "," .. tostring(floored.y) .. ")" end

	local modded = a % 3
	if not (modded.x == 0 and modded.y == 1) then return "Expected (0,1), got (" .. tostring(modded.x) .. "," .. tostring(modded.y) .. ")" end

	local powered = a ^ 2
	if not (powered.x == 9 and powered.y == 16) then return "Expected (9,16), got (" .. tostring(powered.x) .. "," .. tostring(powered.y) .. ")" end

	return true
end
