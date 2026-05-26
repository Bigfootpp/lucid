--!strict
local Class = require(script.Class)

local function class<T>(variables: T)
    return function<U>(methods: U): Class.ClassObject<T, U>
        return Class.New(variables, methods)
    end
end

return class