--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local class = require(ReplicatedStorage.Packages.LuCid)

return function(): boolean | string

	local GrandParent = class() { x = 1 } {
		getX = function(self)
			return self.x
		end,
	}

	local MidParent = class(GrandParent) { x = 10 } {
		getX = function(self)
			return self:super():getX() * 2
		end,
	}

	local ChildSuper = class(MidParent) { x = 100 } {
		getX = function(self)
			return self:super():getX() + 1
		end,
	}

	local cs = ChildSuper:create()
	if not (cs:getX() == 201) then return "super chain failed, expected 201, got " .. tostring(cs:getX()) end


	local A = class() {} {
		foo = function(self)
			return "A"
		end,
	}

	local B = class(A) {} {
		foo = function(self)
			return self:super():foo() .. "B"
		end,
	}

	local C = class(B) {} {
		foo = function(self)
			return self:super():foo() .. "C"
		end,
	}

	local cObj = C:create()
	if not (cObj:foo() == "ABC") then return "super parent calling own super failed, expected ABC, got " .. tostring(cObj:foo()) end

	return true
end