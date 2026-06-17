--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local class = require(ReplicatedStorage.Packages.LuCid)

return function(): boolean | string

	local NoParent = class() { x = 1 } {}
	local WithNilParent = class(nil) { y = 2 } {}

	local np = NoParent:create()
	local wnp = WithNilParent:create()

	if not (np.x == 1) then return "No parent works" end
	if not (wnp.y == 2) then return "Nil parent works" end
	if not (#np:getParentIds() == 0) then return "No parent -> 0 IDs" end
	if not (#wnp:getParentIds() == 0) then return "Nil parent -> 0 IDs" end
	return true
end