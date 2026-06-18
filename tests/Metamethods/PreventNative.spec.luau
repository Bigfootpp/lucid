--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local class = require(ReplicatedStorage.Packages.LuCid)

return function(): boolean | string
	local ok, err: any = pcall(function()
		local _BadClass = class() { value = 0 } {
			__add = function(self, other: number)
				return self.value + other
			end,
		}
	end)
	if not (not ok) then return "Defining native __add in methods should be prevented" end
	if not (string.find(err, "Cannot override native metamethods")) then return "Error should mention 'Cannot override native metamethods', got: " .. tostring(err) end

	local SafeClass = class() { value = 0 } {
		__plus = function(self, other: number)
			return self.value + other
		end,
	}
	local obj = SafeClass:create()
	obj.value = 10
	local obj2 = obj + 5
	if not (obj2 == 15) then return "Expected 15, got " .. tostring(obj2) end

	return true
end
