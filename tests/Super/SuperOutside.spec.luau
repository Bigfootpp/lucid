--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local class = require(ReplicatedStorage.Packages.LuCid)

return function()

	local Simple = class() {} {
		method = function(self)
			return "ok"
		end,
	}

	local simpleObj = Simple:create()
	local ok, err = pcall(function()
		simpleObj:super()
	end)
	assert(not ok, "super() outside of method should error")
	assert(string.find(err, "outside") or string.find(err, "super"), "Error message should mention 'outside' or 'super'")

end