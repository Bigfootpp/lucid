--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local class = require(ReplicatedStorage.Packages.LuCid)

return function()

	local InitA = class() { a = 0 } {
		__init = function(self)
			self.a = 1
		end,
	}

	local InitB = class(InitA) { b = 0 } {
		__init = function(self)
			self:super().__init(self)
			self.b = 2
		end,
	}

	local initB = InitB:create()
	assert(initB.a == 1, "super init chain: a should be 1")
	assert(initB.b == 2, "super init chain: b should be 2")

end