--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local class = require(ReplicatedStorage.Packages.LuCid)

return function()

	local GrandParent = class() { x = 1 } {
		getX = function(self)
			return self.x
		end,
	}

	local MidParent = class(GrandParent) { x = 10 } {
		getX = function(self)
			return self:super().getX(self) * 2
		end,
	}

	local ChildSuper = class(MidParent) { x = 100 } {
		getX = function(self)
			return self:super().getX(self) + 1
		end,
	}

	local cs = ChildSuper:create()
	assert(cs:getX() == 3, "super chain failed, expected 3, got " .. tostring(cs:getX())) -- 1 * 2 + 1 = 3


	local A = class() {} {
		foo = function(self)
			return "A"
		end,
	}

	local B = class(A) {} {
		foo = function(self)
			return self:super().foo(self) .. "B"
		end,
	}

	local C = class(B) {} {
		foo = function(self)
			return self:super().foo(self) .. "C"
		end,
	}

	local cObj = C:create()
	assert(cObj:foo() == "ABC", "super parent calling own super failed, expected ABC, got " .. tostring(cObj:foo()))

end