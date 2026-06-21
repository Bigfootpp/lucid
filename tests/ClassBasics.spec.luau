--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local class = require(ReplicatedStorage.Packages.LuCid)

return function(): boolean | string
	-- 1. Test basic class creation & instantiation
	local Counter = class() { count = 0 } {
		__init = function(self, startValue: number)
			self.count = startValue
		end,
		increment = function(self)
			self.count = self.count + 1
		end,
		decrement = function(self)
			self.count = self.count - 1
		end,
	}

	if not Counter then return "Failed to create Counter class" end

	local c1 = Counter:create(10)
	local c2 = Counter:create(20)

	if not c1 then return "Failed to instantiate c1" end
	if not c2 then return "Failed to instantiate c2" end

	if c1.count ~= 10 then return "Expected c1.count to be 10, got " .. tostring(c1.count) end
	if c2.count ~= 20 then return "Expected c2.count to be 20, got " .. tostring(c2.count) end

	c1:increment()
	if c1.count ~= 11 then return "Expected c1.count to increment to 11, got " .. tostring(c1.count) end
	if c2.count ~= 20 then return "c1:increment() affected c2.count" end

	c2:decrement()
	if c2.count ~= 19 then return "Expected c2.count to decrement to 19, got " .. tostring(c2.count) end
	if c1.count ~= 11 then return "c2:decrement() affected c1.count" end

	-- 2. Test deep copying of state (isolation of reference tables)
	local Config = class() {
		tags = { "default" },
		nested = {
			value = 100
		}
	} {}

	local conf1 = Config:create()
	local conf2 = Config:create()

	table.insert(conf1.tags, "admin")
	conf1.nested.value = 999

	if #conf2.tags ~= 1 or conf2.tags[1] ~= "default" then
		return "Table variables were not deep copied (tags array was mutated across instances)"
	end

	if conf2.nested.value ~= 100 then
		return "Nested table variables were not deep copied (nested.value was mutated across instances)"
	end

	-- 3. Test constructor arguments passing
	local Params = class() { a = 0, b = "", c = false } {
		__init = function(self, a, b, c)
			self.a = a
			self.b = b
			self.c = c
		end
	}
	local p = Params:create(42, "hello", true)
	if p.a ~= 42 or p.b ~= "hello" or p.c ~= true then
		return "Constructor did not receive all parameters correctly"
	end

	-- 4. Test method that returns self
	local Chainable = class() { value = 0 } {
		add = function(self, val: number)
			self.value = self.value + val
			return self
		end
	}
	local chainObj = Chainable:create()
	local returned = chainObj:add(5):add(10)
	if returned.value ~= 15 then
		return "Chained methods did not return self correctly or update value"
	end

	return true
end
