--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local class = require(ReplicatedStorage.Packages.LuCid)

return function()
	local Container = class() { items = {} } {}

	local a = Container:create()
	local b = Container:create()

	a.items["sword"] = true
	assert(a.items["sword"] == true, "Instance A should have the sword")
	assert(b.items["sword"] == nil, "Instance B must not share the table with A")
	assert(Container:create().items["sword"] == nil, "New instance must not be tainted")

	local ParentWithTable = class() { data = {} } {
		add = function(self, k, v) self.data[k] = v end,
	}

	local ChildWithTable = class(ParentWithTable) {} {}

	local c1 = ChildWithTable:create()
	local c2 = ChildWithTable:create()

	c1:add("key", "value1")
	assert(c1.data["key"] == "value1", "Child 1 should have key")
	assert(c2.data["key"] == nil, "Child 2 must not share parent table")

end