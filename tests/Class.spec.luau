--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local class = require(ReplicatedStorage.Packages.LuCid)

function main()
	-- ==========================================
	-- 1. BASIC CLASS CREATION & INSTANTIATION
	-- ==========================================
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

	-- ==========================================
	-- 2. SINGLE LEVEL INHERITANCE
	-- ==========================================
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

	-- ==========================================
	-- 3. MULTI-LEVEL INHERITANCE (3 GENERATIONS)
	-- ==========================================
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

	-- Verify parent IDs are in correct order (closest first or oldest first?)
	-- Current implementation: parent._parentIds extended with {parent._id}
	-- So order should be: [Mammal_id, LivingBeing_id]
	assert(dogParentIds[1] ~= dogParentIds[2], "Parent IDs should be unique")

	-- ==========================================
	-- 4. VARIABLE OVERRIDE VS INHERITANCE
	-- ==========================================
	local Base = class() { value = 100, shared = "base" } {
		getValue = function(self) return self.value end,
	}

	local Derived = class(Base) { value = 200 } { -- override value
		getValue = function(self) return self.value * 2 end, -- override method
	}

	local baseObj = Base:create()
	local derivedObj = Derived:create()

	assert(baseObj.value == 100, "Base value should be 100")
	assert(baseObj.shared == "base", "Base shared should be 'base'")
	assert(baseObj:getValue() == 100, "Base getValue should return 100")

	assert(derivedObj.value == 200, "Derived value should override to 200")
	assert(derivedObj.shared == "base", "Derived should inherit 'shared'")
	assert(derivedObj:getValue() == 400, "Derived getValue should return 400 (200*2)")

	-- ==========================================
	-- 5. METHOD OVERRIDE ISOLATION
	-- ==========================================
	local Parent = class() { value = 0 } {
		get = function(self) return self.value end,
	}

	local Child = class(Parent) { value = 10 } {
		get = function(self) return self.value * 2 end,
	}

	local parentObj = Parent:create()
	local childObj = Child:create()

	assert(parentObj:get() == 0, "Parent method must remain unchanged")
	assert(childObj:get() == 20, "Child override should apply only to child (10*2)")

	-- ==========================================
	-- 6. INSTANCE ISOLATION (NO SHARED STATE)
	-- ==========================================
	local Container = class() { items = {} } {}

	local a = Container:create()
	local b = Container:create()

	a.items["sword"] = true
	assert(a.items["sword"] == true, "Instance A should have the sword")
	assert(b.items["sword"] == nil, "Instance B must not share the table with A")
	assert(Container:create().items["sword"] == nil, "New instance must not be tainted")

	-- Test with inheritance too
	local ParentWithTable = class() { data = {} } {
		add = function(self, k, v) self.data[k] = v end,
	}

	local ChildWithTable = class(ParentWithTable) {} {}

	local c1 = ChildWithTable:create()
	local c2 = ChildWithTable:create()

	c1:add("key", "value1")
	assert(c1.data["key"] == "value1", "Child 1 should have key")
	assert(c2.data["key"] == nil, "Child 2 must not share parent table")

	-- ==========================================
	-- 7. GETPARENTIDS ACCURACY AT EACH LEVEL
	-- ==========================================
	local G1 = class() { g1 = true } {}
	local G2 = class(G1) { g2 = true } {}
	local G3 = class(G2) { g3 = true } {}

	local g1 = G1:create()
	local g2 = G2:create()
	local g3 = G3:create()

	assert(#g1:GetParentIds() == 0, "G1 should have 0 parents")
	assert(#g2:GetParentIds() == 1, "G2 should have 1 parent")
	assert(#g3:GetParentIds() == 2, "G3 should have 2 parents")

	-- Verify IDs are strings and unique
	local allIds = {}
	for _, id in ipairs(g3:GetParentIds()) do
		assert(type(id) == "string", "Parent ID must be string")
		assert(not allIds[id], "Parent IDs must be unique")
		allIds[id] = true
	end

	-- ==========================================
	-- 8. COMPLEX INIT WITH MULTIPLE ARGS
	-- ==========================================
	local Config = class() {
		host = "localhost",
		port = 8080,
		timeout = 5000,
		ssl = false,
	} {}

	local Database = class(Config) {
		name = "default",
		poolSize = 10,
	} {
		__init = function(self, name: string, opts: {poolSize: number?, ssl: boolean?}?)
			self.name = name
			self.poolSize = opts and opts.poolSize or 10
			self.ssl = opts and opts.ssl or false
		end,
		connect = function(self)
			return ("Connecting to %s:%d (%s)"):format(self.host, self.port, self.name)
		end,
	}

	local db = Database:create("users", { poolSize = 20, ssl = true })
	assert(db.host == "localhost", "Inherited host")
	assert(db.port == 8080, "Inherited port")
	assert(db.timeout == 5000, "Inherited timeout")
	assert(db.name == "users", "Own name")
	assert(db.poolSize == 20, "Own poolSize from opts")
	assert(db.ssl == true, "Own ssl from opts")
	assert(db:connect() == "Connecting to localhost:8080 (users)", "Method uses inherited + own")

	-- ==========================================
	-- 9. EMPTY PARENT / NIL PARENT
	-- ==========================================
	local NoParent = class() { x = 1 } {}
	local WithNilParent = class(nil) { y = 2 } {}

	local np = NoParent:create()
	local wnp = WithNilParent:create()

	assert(np.x == 1, "No parent works")
	assert(wnp.y == 2, "Nil parent works")
	assert(#np:GetParentIds() == 0, "No parent -> 0 IDs")
	assert(#wnp:GetParentIds() == 0, "Nil parent -> 0 IDs")

	-- ==========================================
	-- 10. MULTIPLE CHILDREN FROM SAME PARENT
	-- ==========================================
	local Vehicle = class() { wheels = 0, maxSpeed = 0 } {
		__init = function(self, wheels: number, maxSpeed: number)
			self.wheels = wheels
			self.maxSpeed = maxSpeed
		end,
		drive = function(self)
			return ("Driving at %d km/h"):format(self.maxSpeed)
		end,
	}

	local Car = class(Vehicle) { doors = 4 } {
		__init = function(self, maxSpeed: number)
			self.wheels = 4
			self.maxSpeed = maxSpeed
			self.doors = 4
		end,
	}

	local Motorcycle = class(Vehicle) { hasSidecar = false } {
		__init = function(self, maxSpeed: number, hasSidecar: boolean)
			self.wheels = hasSidecar and 3 or 2
			self.maxSpeed = maxSpeed
			self.hasSidecar = hasSidecar
		end,
	}

	local car = Car:create(200)
	local moto = Motorcycle:create(150, true)

	assert(car.wheels == 4, "Car wheels")
	assert(car.doors == 4, "Car doors")
	assert(car:drive() == "Driving at 200 km/h", "Car drive")

	assert(moto.wheels == 3, "Moto wheels with sidecar")
	assert(moto.hasSidecar == true, "Moto sidecar")
	assert(moto:drive() == "Driving at 150 km/h", "Moto drive")

	-- Both inherit from same Vehicle -> same parent ID in parentIds
	assert(#car:GetParentIds() == 1, "Car has 1 parent")
	assert(#moto:GetParentIds() == 1, "Moto has 1 parent")
	assert(car:GetParentIds()[1] == moto:GetParentIds()[1], "Same parent Vehicle ID")

	-- But different instances -> different GetId()
	assert(car:GetId() ~= moto:GetId(), "Different instance IDs")

	-- ==========================================
	-- 11. GETID UNIQUENESS
	-- ==========================================
	local ids = {}
	for i = 1, 10 do
		local T = class() { idx = i } {}
		local obj = T:create()
		local id = obj:GetId()
		assert(type(id) == "string", "GetId returns string")
		assert(not ids[id], "GetId must be unique: " .. id)
		ids[id] = true
	end

	-- ==========================================
	-- 12. DEEP INHERITANCE CHAIN (5 LEVELS)
	-- ==========================================
	local L1 = class() { l1 = 1 } {}
	local L2 = class(L1) { l2 = 2 } {}
	local L3 = class(L2) { l3 = 3 } {}
	local L4 = class(L3) { l4 = 4 } {}
	local L5 = class(L4) { l5 = 5 } {}

	local l5 = L5:create()
	assert(l5.l1 == 1, "L1 var")
	assert(l5.l2 == 2, "L2 var")
	assert(l5.l3 == 3, "L3 var")
	assert(l5.l4 == 4, "L4 var")
	assert(l5.l5 == 5, "L5 var")
	assert(#l5:GetParentIds() == 4, "5 levels = 4 parents")

	print("All tests passed")
end

return main