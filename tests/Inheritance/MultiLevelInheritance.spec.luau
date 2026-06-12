--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local class = require(ReplicatedStorage.Packages.LuCid)

return function()

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
	assert(dog.alive == true, "Grandparent variable 'alive' failed")
	assert(dog.warmBlooded == true, "Parent variable 'warmBlooded' failed")
	assert(dog.breed == "Labrador", "Own variable 'breed' failed")
	assert(dog:breathe() == "mammal breathing", "Method override chain failed (should use Mammal)")
	assert(dog:bark() == "Labrador barks", "Own method failed")

	local dogParentIds = dog:GetParentIds()
	assert(#dogParentIds == 2, "Expected two parent ids, got " .. #dogParentIds)
	assert(dogParentIds[1] ~= dogParentIds[2], "Parent IDs should be unique")

end