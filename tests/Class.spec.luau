local ReplicatedStorage = game:GetService("ReplicatedStorage")
local class = require(ReplicatedStorage.LuCid)

print(require(ReplicatedStorage.LuCid.Class))

function main()
    local MyClass = class {
        __init = function(self)
            
        end
    }

    MyClass:__init()

    assert(MyClass, "Class is not created")
    print("Class successfully created")
end

return main