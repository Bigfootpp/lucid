--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local class = require(ReplicatedStorage.Packages.LuCid)

function main()
	local Human = class() { name = "", age = 0 } {
		__init = function(self, name: string, age: number)
			self.name = name
			self.age = age
		end,
		greet = function(self)
			return ("Hello my name is %s, I'm %d years old"):format(self.name, self.age)
		end,
	}

	assert(Human, "Class is not created")
	print("Class successfully created")

	local person = Human:create("Jean", 20)
	assert(person, "Object is not created")
	print("Object successfully created")

	assert(person.name == "Jean", "Expected name 'Jean', got " .. tostring(person.name))
	assert(person.age == 20, "Expected age 20, got " .. tostring(person.age))
	local greeting = person:greet()
	print(greeting)
	assert(greeting == "Hello my name is Jean, I'm 20 years old", "Unexpected greeting: " .. greeting)

	local Animal = class() { species = "", legs = 0 } {
		__init = function(self, species: string, legs: number)
			self.species = species
			self.legs = legs
		end,
		speak = function(self)
			return ("The %s makes a sound"):format(self.species)
		end,
	}

	local Cat = class(Animal)({ tail = true}) {
		__init = function(self, species: string, legs: number, tail: boolean)
			self.species = species
			self.legs = legs
			self.tail = tail
		end,
		speak = function(self: any)
			return ("The %s meows"):format(self.species)
		end,
	}

	local cat = Cat:create("Felis catus", 4, true)

	assert(cat.species == "Felis catus", "Inherited variable 'species' failed")
	assert(cat.legs == 4, "Inherited variable 'legs' failed")
	assert(cat.tail == true, "Own variable 'tail' failed")

	local catSound = cat:speak()
	assert(catSound == "The Felis catus meows", "Unexpected sound: " .. catSound)

	local parentIds = cat:GetParentIds()
	assert(type(parentIds) == "table", "GetParentIds must return a table")
	assert(#parentIds >= 1, "Expected at least one parent id")

	local Container = class() { items = {} } {}
	local a = Container:create()
	local b = Container:create()
	a.items["sword"] = true
	assert(a.items["sword"] == true, "Instance A should have the sword")
	assert(b.items["sword"] == nil, "Instance B must not share the table with A")
	assert(Container:create().items["sword"] == nil, "New instance must not be tainted")

	local Parent = class() { value = 0 } {
		get = function(self) return self.value end,
	}
	local Child = class(Parent)({ value = 10 }) {
		get = function(self) return self.value * 2 end,
	}
	local parentObj = Parent:create()
	local childObj = Child:create()
	assert(parentObj:get() == 0, "Parent method must remain unchanged")
	assert(childObj:get() == 20, "Child override should apply only to child")

	print("All tests passed")
end

return main
