--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local class = require(ReplicatedStorage.Packages.LuCid)

return function(): boolean | string
	-- 1. Basic super() method call
	local Parent = class() { val = 5 } {
		calculate = function(self, n: number)
			return n * self.val
		end,
	}

	local Child = class(Parent) { val = 10 } {
		calculate = function(self, n: number)
			-- Calls Parent's calculate method (n * 10) but using the child's context
			return self:super():calculate(n) + 1
		end,
	}

	local childInst = Child:create()
	local result = childInst:calculate(3)
	-- self.val on childInst is 10.
	-- Parent calculate(3) does 3 * 10 = 30.
	-- Child adds 1 -> 31.
	if result ~= 31 then
		return "Basic super() method call failed: expected 31, got " .. tostring(result)
	end

	-- 2. Chained super() calls (A -> B -> C)
	local A = class() {} {
		identify = function(self) return "A" end,
	}
	local B = class(A) {} {
		identify = function(self)
			return self:super():identify() .. " -> B"
		end,
	}
	local C = class(B) {} {
		identify = function(self)
			return self:super():identify() .. " -> C"
		end,
	}

	local cInst = C:create()
	local chainResult = cInst:identify()
	if chainResult ~= "A -> B -> C" then
		return "Chained super() calls failed: expected 'A -> B -> C', got " .. tostring(chainResult)
	end

	-- 3. super() in constructor (__init)
	local InitializerParent = class() { initialized = false, parentVal = 0 } {
		__init = function(self, val)
			self.initialized = true
			self.parentVal = val
		end
	}

	local InitializerChild = class(InitializerParent) { childVal = 0 } {
		__init = function(self, val)
			self:super():__init(val * 2)
			self.childVal = val
		end
	}

	local childInitInst = InitializerChild:create(10)
	if not childInitInst.initialized then
		return "super() in constructor failed to trigger parent __init"
	end
	if childInitInst.parentVal ~= 20 then
		return "super() in constructor failed to pass arguments correctly to parent __init"
	end
	if childInitInst.childVal ~= 10 then
		return "child variable not set correctly after super() constructor call"
	end

	-- 4. Errors: super() outside class method
	local NoParent = class() {} {
		test = function(self)
			local success, err = pcall(function()
				self:super()
			end)
			if success then
				return "Error expected when calling super() on class with no parent"
			end
			if not string.find(tostring(err), "No parent class") then
				return "Expected 'No parent class' error, got " .. tostring(err)
			end
			return "OK"
		end
	}

	local noParentInst = NoParent:create()
	local noParentResult = noParentInst:test()
	if noParentResult ~= "OK" then
		return noParentResult
	end

	-- 5. Errors: Calling super() in an async/different coroutine thread
	local AsyncParent = class() {} {
		foo = function(self) return "foo" end
	}
	local AsyncChild = class(AsyncParent) {} {
		testAsync = function(self)
			local threadSuccess = true
			local threadError = ""
			
			local thread = coroutine.create(function()
				local success, err = pcall(function()
					self:super()
				end)
				threadSuccess = success
				threadError = tostring(err)
			end)
			coroutine.resume(thread)

			if threadSuccess then
				return "Expected super() in a separate coroutine thread to fail, but it succeeded"
			end
			if not string.find(threadError, "outside of class method") then
				return "Expected 'outside of class method' error in thread, got " .. threadError
			end
			return "OK"
		end
	}

	local asyncChildInst = AsyncChild:create()
	local asyncResult = asyncChildInst:testAsync()
	if asyncResult ~= "OK" then
		return asyncResult
	end

	return true
end
