local ReplicatedStorage = game:GetService("ReplicatedStorage")
local class = require(ReplicatedStorage.LuCid)

function main()
    local MyClass = class()

    assert(MyClass, "Class is not created")
    print("Class successfully created")
end

return main