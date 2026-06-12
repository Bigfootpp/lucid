--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local class = require(ReplicatedStorage.Packages.LuCid)

return function()
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
	local person = Human:create("Jean", 20)
	assert(person, "Object is not created")
	assert(person.name == "Jean", "Expected name 'Jean', got " .. tostring(person.name))
	assert(person.age == 20, "Expected age 20, got " .. tostring(person.age))
	assert(person:greet() == "Hello my name is Jean, I'm 20 years old", "Greeting failed")


	local Base = class() { value = 100, shared = "base" } {
		getValue = function(self) return self.value end,
	}

	local Derived = class(Base) { value = 200 } {
		getValue = function(self) return self.value * 2 end,
	}

	local baseObj = Base:create()
	local derivedObj = Derived:create()

	assert(baseObj.value == 100, "Base value should be 100")
	assert(baseObj.shared == "base", "Base shared should be 'base'")
	assert(baseObj:getValue() == 100, "Base getValue should return 100")

	assert(derivedObj.value == 200, "Derived value should override to 200")
	assert(derivedObj.shared == "base", "Derived should inherit 'shared'")
	assert(derivedObj:getValue() == 400, "Derived getValue should return 400 (200*2)")


	local ParentClass = class() { value = 0 } {
		get = function(self) return self.value end,
	}

	local ChildClass = class(ParentClass) { value = 10 } {
		get = function(self) return self.value * 2 end,
	}

	local parentObj = ParentClass:create()
	local childObj = ChildClass:create()

	assert(parentObj:get() == 0, "Parent method must remain unchanged")
	assert(childObj:get() == 20, "Child override should apply only to child (10*2)")

end