--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local class = require(ReplicatedStorage.Packages.LuCid)

return function(): boolean | string
	-- 1. Single Inheritance
	local Base = class() { baseVar = "base", sharedVar = "base" } {
		baseMethod = function(self) return "baseMethod" end,
		sharedMethod = function(self) return "baseShared" end,
	}

	local Derived = class(Base) { derivedVar = "derived", sharedVar = "derived" } {
		derivedMethod = function(self) return "derivedMethod" end,
		sharedMethod = function(self) return "derivedShared" end,
	}

	local baseInst = Base:create()
	local derivedInst = Derived:create()

	-- Verify Base instance
	if baseInst.baseVar ~= "base" then return "Base: baseVar should be 'base'" end
	if baseInst.sharedVar ~= "base" then return "Base: sharedVar should be 'base'" end
	if baseInst:baseMethod() ~= "baseMethod" then return "Base: baseMethod fail" end
	if baseInst:sharedMethod() ~= "baseShared" then return "Base: sharedMethod fail" end

	-- Verify Derived instance (inheritance & override)
	if derivedInst.baseVar ~= "base" then return "Derived: should inherit baseVar" end
	if derivedInst.derivedVar ~= "derived" then return "Derived: should have derivedVar" end
	if derivedInst.sharedVar ~= "derived" then return "Derived: should override sharedVar to 'derived'" end
	if derivedInst:baseMethod() ~= "baseMethod" then return "Derived: should inherit baseMethod" end
	if derivedInst:derivedMethod() ~= "derivedMethod" then return "Derived: should have derivedMethod" end
	if derivedInst:sharedMethod() ~= "derivedShared" then return "Derived: should override sharedMethod" end

	-- 2. Sibling Isolation
	local Sibling = class(Base) { siblingVar = "sibling" } {}
	local siblingInst = Sibling:create()

	if siblingInst.sharedVar ~= "base" then return "Sibling: should inherit base sharedVar" end
	if (siblingInst :: any).derivedVar ~= nil then return "Sibling: should not have derivedVar from other sibling" end

	-- 3. Multi-level Inheritance (A -> B -> C)
	local A = class() { valA = "A" } {
		methodA = function(self) return "A" end,
		overrideMe = function(self) return "A" end,
	}
	local B = class(A) { valB = "B" } {
		methodB = function(self) return "B" end,
		overrideMe = function(self) return "B" end,
	}
	local C = class(B) { valC = "C" } {
		methodC = function(self) return "C" end,
	}

	local cInst = C:create()
	if cInst.valA ~= "A" or cInst.valB ~= "B" or cInst.valC ~= "C" then
		return "Multi-level: Variable inheritance failed"
	end
	if cInst:methodA() ~= "A" or cInst:methodB() ~= "B" or cInst:methodC() ~= "C" then
		return "Multi-level: Method inheritance failed"
	end
	if cInst:overrideMe() ~= "B" then
		return "Multi-level: Method overriding resolution failed"
	end

	-- 4. Nil Parent
	local NilParentClass = class(nil) { value = 123 } {
		getValue = function(self) return self.value end
	}
	local nilParentInst = NilParentClass:create()
	if nilParentInst.value ~= 123 or nilParentInst:getValue() ~= 123 then
		return "Nil parent class creation or instantiation failed"
	end

	-- 5. Inheritance structure isolation (modifying parent variables in child doesn't affect parent instance)
	local ParentWithTable = class() { data = { x = 1 } } {}
	local ChildWithTable = class(ParentWithTable) {} {}

	local pObj = ParentWithTable:create()
	local cObj = ChildWithTable:create()

	cObj.data.x = 2
	if pObj.data.x ~= 1 then
		return "Modifying inherited table in child mutated parent's table"
	end

	return true
end
