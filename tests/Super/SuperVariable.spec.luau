--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local class = require(ReplicatedStorage.Packages.LuCid)

return function(): boolean | string

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
	if not (vd:getName() == "derived") then return "super with shadowed var: expected 'derived', got " .. tostring(vd:getName()) end

	return true
end