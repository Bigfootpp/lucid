--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local class = require(ReplicatedStorage.Packages.LuCid)

return function()

	local VarBase = class() { name = "base" } {
		getName = function(self)
			return self.name
		end,
	}

	local VarDerived = class(VarBase) { name = "derived" } {
		getName = function(self)
			return self:super():getName()
		end,
	}

	local vd = VarDerived:create()
	assert(vd:getName() == "derived", "super with shadowed var: expected 'derived', got " .. tostring(vd:getName()))

end