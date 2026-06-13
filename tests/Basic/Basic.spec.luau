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

	if not (Human) then return "Class is not created" end
	local person = Human:create("Jean", 20)
	if not (person) then return "Object is not created" end
	if not (person.name == "Jean") then return "Expected name 'Jean', got " .. tostring(person.name) end
	if not (person.age == 20) then return "Expected age 20, got " .. tostring(person.age) end
	if not (person:greet() == "Hello my name is Jean, I'm 20 years old") then return "Greeting failed" end


	local Base = class() { value = 100, shared = "base" } {
		getValue = function(self) return self.value end,
	}

	local Derived = class(Base) { value = 200 } {
		getValue = function(self) return self.value * 2 end,
	}

	local baseObj = Base:create()
	local derivedObj = Derived:create()

	if not (baseObj.value == 100) then return "Base value should be 100" end
	if not (baseObj.shared == "base") then return "Base shared should be 'base'" end
	if not (baseObj:getValue() == 100) then return "Base getValue should return 100" end

	if not (derivedObj.value == 200) then return "Derived value should override to 200" end
	if not (derivedObj.shared == "base") then return "Derived should inherit 'shared'" end
	if not (derivedObj:getValue() == 400) then return "Derived getValue should return 400 (200*2)" end


	local ParentClass = class() { value = 0 } {
		get = function(self) return self.value end,
	}

	local ChildClass = class(ParentClass) { value = 10 } {
		get = function(self) return self.value * 2 end,
	}

	local parentObj = ParentClass:create()
	local childObj = ChildClass:create()

	if not (parentObj:get() == 0) then return "Parent method must remain unchanged" end
	if not (childObj:get() == 20) then return "Child override should apply only to child (10*2)" end

	return true
end