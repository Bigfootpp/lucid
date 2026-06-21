--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local class = require(ReplicatedStorage.Packages.LuCid)

return function(): boolean | string
	local Base = class() {} {}
	local Sub = class(Base) {} {}
	local SubSub = class(Sub) {} {}
	local Other = class() {} {}

	local baseInst = Base:create()
	local _ = Sub:create()
	local subSubInst = SubSub:create()
	local _ = Other:create()

	-- 1. Test class-to-class isA reflection
	if not SubSub:isA(Sub) then return "SubSub:isA(Sub) should be true" end
	if not SubSub:isA(Base) then return "SubSub:isA(Base) should be true" end
	if SubSub:isA(Other) then return "SubSub:isA(Other) should be false" end
	if not SubSub:isA(SubSub) then return "SubSub:isA(SubSub) should be true" end
	if Base:isA(Sub) then return "Base:isA(Sub) should be false" end

	-- 2. Test instance-to-class isA reflection
	if not subSubInst:isA(SubSub) then return "subSubInst:isA(SubSub) should be true" end
	if not subSubInst:isA(Sub) then return "subSubInst:isA(Sub) should be true" end
	if not subSubInst:isA(Base) then return "subSubInst:isA(Base) should be true" end
	if subSubInst:isA(Other) then return "subSubInst:isA(Other) should be false" end
	if baseInst:isA(Sub) then return "baseInst:isA(Sub) should be false" end

	-- 3. Test getClass API
	if subSubInst:getClass() ~= SubSub then return "subSubInst:getClass() should return SubSub class" end
	if baseInst:getClass() ~= Base then return "baseInst:getClass() should return Base class" end

	-- 4. Test getId API
	local subSubId = SubSub:getId()
	if type(subSubId) ~= "string" or #subSubId == 0 then return "SubSub:getId() should return a non-empty string" end
	if subSubInst:getId() ~= subSubId then return "subSubInst:getId() should equal SubSub:getId()" end

	-- 5. Test getParentIds API
	local parentIds = subSubInst:getParentIds()
	if #parentIds ~= 2 then return "subSubInst:getParentIds() should contain 2 IDs" end
	if parentIds[1] ~= Sub:getId() then return "First parent ID should be Sub's ID" end
	if parentIds[2] ~= Base:getId() then return "Second parent ID should be Base's ID" end

	local classParentIds = SubSub:getParentIds()
	if #classParentIds ~= 2 then return "SubSub:getParentIds() should contain 2 IDs" end
	if classParentIds[1] ~= Sub:getId() then return "Class: First parent ID should be Sub's ID" end
	if classParentIds[2] ~= Base:getId() then return "Class: Second parent ID should be Base's ID" end

	return true
end
