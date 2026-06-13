--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local class = require(ReplicatedStorage.Packages.LuCid)

return function(): boolean | string

	local G1 = class() { g1 = true } {}
	local G2 = class(G1) { g2 = true } {}
	local G3 = class(G2) { g3 = true } {}

	local g1 = G1:create()
	local g2 = G2:create()
	local g3 = G3:create()

	if not (#g1:GetParentIds() == 0) then return "G1 should have 0 parents" end
	if not (#g2:GetParentIds() == 1) then return "G2 should have 1 parent" end
	if not (#g3:GetParentIds() == 2) then return "G3 should have 2 parents" end

	local allIds = {}
	for _, id in ipairs(g3:GetParentIds()) do
		if not (type(id) == "string") then return "Parent ID must be string" end
		if not (not allIds[id]) then return "Parent IDs must be unique" end
		allIds[id] = true
	end


	local L1 = class() { l1 = 1 } {}
	local L2 = class(L1) { l2 = 2 } {}
	local L3 = class(L2) { l3 = 3 } {}
	local L4 = class(L3) { l4 = 4 } {}
	local L5 = class(L4) { l5 = 5 } {}

	local l5 = L5:create()
	if not (l5.l1 == 1) then return "L1 var" end
	if not (l5.l2 == 2) then return "L2 var" end
	if not (l5.l3 == 3) then return "L3 var" end
	if not (l5.l4 == 4) then return "L4 var" end
	if not (l5.l5 == 5) then return "L5 var" end
	if not (#l5:GetParentIds() == 4) then return "5 levels = 4 parents" end

	return true
end