--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local class = require(ReplicatedStorage.Packages.LuCid)

return function(): boolean | string

	local LivingBeing = class() { alive = true } {
		__init = function(self)
			self.alive = true
		end,
		breathe = function(self)
			return "breathing"
		end,
	}

	local Mammal = class(LivingBeing) { warmBlooded = true } {
		__init = function(self)
			self.alive = true
			self.warmBlooded = true
		end,
		breathe = function(self)
			return "mammal breathing"
		end,
	}

	local Dog = class(Mammal) { breed = "" } {
		__init = function(self, breed: string)
			self.alive = true
			self.warmBlooded = true
			self.breed = breed
		end,
		bark = function(self)
			return ("%s barks"):format(self.breed)
		end,
	}

	local dog = Dog:create("Labrador")
	if not (dog.alive == true) then return "Grandparent variable 'alive' failed" end
	if not (dog.warmBlooded == true) then return "Parent variable 'warmBlooded' failed" end
	if not (dog.breed == "Labrador") then return "Own variable 'breed' failed" end
	if not (dog:breathe() == "mammal breathing") then return "Method override chain failed (should use Mammal)" end
	if not (dog:bark() == "Labrador barks") then return "Own method failed" end

	local dogParentIds = dog:getParentIds()
	if not (#dogParentIds == 2) then return "Expected two parent ids, got " .. #dogParentIds end
	if not (dogParentIds[1] ~= dogParentIds[2]) then return "Parent IDs should be unique" end

	return true
end