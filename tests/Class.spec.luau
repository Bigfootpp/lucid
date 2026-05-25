local ReplicatedStorage = game:GetService("ReplicatedStorage")
local class = require(ReplicatedStorage.LuCid)

function main()
    local Human = class {
        name = "",
        age = 0
    } {
        __init = function(self, name, age)
            self.name = name
            self.age = age
        end,
        greet = function(self)
            print("Hello my name is", self.name, "I'm", self.age, "years old")
        end
    }

    assert(Human, "Class is not created")
    print("Class successfully created")

    local adult = Human("Jean", 20)

    assert(adult, "Object is not created")
    print("Object successfully created")

    adult:greet()
end

return main