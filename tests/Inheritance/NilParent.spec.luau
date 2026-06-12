--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local class = require(ReplicatedStorage.Packages.LuCid)

return function()

	local NoParent = class() { x = 1 } {}
	local WithNilParent = class(nil) { y = 2 } {}

	local np = NoParent:create()
	local wnp = WithNilParent:create()

	assert(np.x == 1, "No parent works")
	assert(wnp.y == 2, "Nil parent works")
	assert(#np:GetParentIds() == 0, "No parent -> 0 IDs")
	assert(#wnp:GetParentIds() == 0, "Nil parent -> 0 IDs")
end