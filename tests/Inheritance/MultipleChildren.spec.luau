--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local class = require(ReplicatedStorage.Packages.LuCid)

return function()

	local Vehicle = class() { wheels = 0, maxSpeed = 0 } {
		__init = function(self, wheels: number, maxSpeed: number)
			self.wheels = wheels
			self.maxSpeed = maxSpeed
		end,
		drive = function(self)
			return ("Driving at %d km/h"):format(self.maxSpeed)
		end,
	}

	local Car = class(Vehicle) { doors = 4 } {
		__init = function(self, maxSpeed: number)
			self.wheels = 4
			self.maxSpeed = maxSpeed
			self.doors = 4
		end,
	}

	local Motorcycle = class(Vehicle) { hasSidecar = false } {
		__init = function(self, maxSpeed: number, hasSidecar: boolean)
			self.wheels = hasSidecar and 3 or 2
			self.maxSpeed = maxSpeed
			self.hasSidecar = hasSidecar
		end,
	}

	local car = Car:create(200)
	local moto = Motorcycle:create(150, true)

	assert(car.wheels == 4, "Car wheels")
	assert(car.doors == 4, "Car doors")
	assert(car:drive() == "Driving at 200 km/h", "Car drive")

	assert(moto.wheels == 3, "Moto wheels with sidecar")
	assert(moto.hasSidecar == true, "Moto sidecar")
	assert(moto:drive() == "Driving at 150 km/h", "Moto drive")

	assert(#car:GetParentIds() == 1, "Car has 1 parent")
	assert(#moto:GetParentIds() == 1, "Moto has 1 parent")
	assert(car:GetParentIds()[1] == moto:GetParentIds()[1], "Same parent Vehicle ID")

	assert(car:GetId() ~= moto:GetId(), "Different instance IDs")

end