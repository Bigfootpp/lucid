--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local class = require(ReplicatedStorage.Packages.LuCid)

return function()
	local Container = class() { items = {} } {}

	local a = Container:create()
	local b = Container:create()

	a.items["sword"] = true
	if not (a.items["sword"] == true) then return "Instance A should have the sword" end
	if not (b.items["sword"] == nil) then return "Instance B must not share the table with A" end
	if not (Container:create().items["sword"] == nil) then return "New instance must not be tainted" end

	local ParentWithTable = class() { data = {} } {
		add = function(self, k, v) self.data[k] = v end,
	}

	local ChildWithTable = class(ParentWithTable) {} {}

	local c1 = ChildWithTable:create()
	local c2 = ChildWithTable:create()

	c1:add("key", "value1")
	if not (c1.data["key"] == "value1") then return "Child 1 should have key" end
	if not (c2.data["key"] == nil) then return "Child 2 must not share parent table" end

	return true
end