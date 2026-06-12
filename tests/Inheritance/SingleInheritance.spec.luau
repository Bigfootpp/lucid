--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local class = require(ReplicatedStorage.Packages.LuCid)

return function()

	local Animal = class() { species = "", legs = 0 } {
		__init = function(self, species: string, legs: number)
			self.species = species
			self.legs = legs
		end,
		speak = function(self)
			return ("The %s makes a sound"):format(self.species)
		end,
	}

	local Cat = class(Animal) { tail = true } {
		__init = function(self, species: string, legs: number, tail: boolean)
			self.species = species
			self.legs = legs
			self.tail = tail
		end,
		speak = function(self)
			return ("The %s meows"):format(self.species)
		end,
	}

	local cat = Cat:create("Felis catus", 4, true)
	assert(cat.species == "Felis catus", "Inherited variable 'species' failed")
	assert(cat.legs == 4, "Inherited variable 'legs' failed")
	assert(cat.tail == true, "Own variable 'tail' failed")
	assert(cat:speak() == "The Felis catus meows", "Method override failed")

	local parentIds = cat:GetParentIds()
	assert(type(parentIds) == "table", "GetParentIds must return a table")
	assert(#parentIds == 1, "Expected exactly one parent id")

end