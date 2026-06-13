--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local class = require(ReplicatedStorage.Packages.LuCid)

return function(): boolean | string

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

	if not (car.wheels == 4) then return "Car wheels" end
	if not (car.doors == 4) then return "Car doors" end
	if not (car:drive() == "Driving at 200 km/h") then return "Car drive" end

	if not (moto.wheels == 3) then return "Moto wheels with sidecar" end
	if not (moto.hasSidecar == true) then return "Moto sidecar" end
	if not (moto:drive() == "Driving at 150 km/h") then return "Moto drive" end

	if not (#car:GetParentIds() == 1) then return "Car has 1 parent" end
	if not (#moto:GetParentIds() == 1) then return "Moto has 1 parent" end
	if not (car:GetParentIds()[1] == moto:GetParentIds()[1]) then return "Same parent Vehicle ID" end

	if not (car:GetId() ~= moto:GetId()) then return "Different instance IDs" end

	return true
end