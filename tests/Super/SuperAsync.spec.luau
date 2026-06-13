--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local class = require(ReplicatedStorage.Packages.LuCid)

return function()
	local Base = class() { health = 100 } {
		getHealth = function(self)
			return self.health
		end,
	}

	local Tank = class(Base) { armor = 50 } {
		getHealth = function(self)
			return self:super():getHealth() + self.armor
		end,
	}

	local directSuperErr = nil
	local tank = Tank:create()

	task.spawn(function()
		local ok, err = pcall(function()
			tank:super()
		end)
		if not ok then
			directSuperErr = tostring(err)
		end
	end)
	task.wait()

	if directSuperErr == nil then
		return "direct super() in task.spawn should have errored"
	end
	if not string.find(directSuperErr, "outside") then
		return "expected 'super() called outside' error, got: " .. directSuperErr
	end

	local spawnResult = nil
	task.spawn(function()
		spawnResult = tank:getHealth()
	end)
	task.wait()

	if spawnResult ~= 150 then
		return "method with super() called from task.spawn failed, expected 150, got " .. tostring(spawnResult)
	end

	local tank2 = Tank:create()
	tank2.armor = 30

	local resultA = nil
	local resultB = nil

	task.spawn(function()
		resultA = tank:getHealth()
	end)
	task.spawn(function()
		resultB = tank2:getHealth()
	end)
	task.wait()

	if resultA ~= 150 then
		return "concurrent spawn A failed, expected 150, got " .. tostring(resultA)
	end
	if resultB ~= 130 then
		return "concurrent spawn B failed, expected 130, got " .. tostring(resultB)
	end

	local delaySuperErr = nil
	task.delay(0, function()
		local ok, err = pcall(function()
			tank:super()
		end)
		if not ok then
			delaySuperErr = tostring(err)
		end
	end)
	task.wait()

	if delaySuperErr == nil then
		return "direct super() in task.delay should have errored"
	end
	if not string.find(delaySuperErr, "outside") then
		return "expected 'super() called outside' from task.delay, got: " .. delaySuperErr
	end

	return true
end
