--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local class = require(ReplicatedStorage.Packages.LuCid)

return function(): boolean | string

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
	if not (cat.species == "Felis catus") then return "Inherited variable 'species' failed" end
	if not (cat.legs == 4) then return "Inherited variable 'legs' failed" end
	if not (cat.tail == true) then return "Own variable 'tail' failed" end
	if not (cat:speak() == "The Felis catus meows") then return "Method override failed" end

	local parentIds = cat:GetParentIds()
	if not (type(parentIds) == "table") then return "GetParentIds must return a table" end
	if not (#parentIds == 1) then return "Expected exactly one parent id" end

	return true
end