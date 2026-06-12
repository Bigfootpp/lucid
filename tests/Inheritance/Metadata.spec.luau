--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local class = require(ReplicatedStorage.Packages.LuCid)

return function()

	local G1 = class() { g1 = true } {}
	local G2 = class(G1) { g2 = true } {}
	local G3 = class(G2) { g3 = true } {}

	local g1 = G1:create()
	local g2 = G2:create()
	local g3 = G3:create()

	assert(#g1:GetParentIds() == 0, "G1 should have 0 parents")
	assert(#g2:GetParentIds() == 1, "G2 should have 1 parent")
	assert(#g3:GetParentIds() == 2, "G3 should have 2 parents")

	local allIds = {}
	for _, id in ipairs(g3:GetParentIds()) do
		assert(type(id) == "string", "Parent ID must be string")
		assert(not allIds[id], "Parent IDs must be unique")
		allIds[id] = true
	end


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

end