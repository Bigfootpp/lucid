--!strict
local Class = require(script.Class)

local function class<V>(variables: V)
    return function<M>(methods: M): Class.ClassObject<V, M>
        return Class.New(variables, methods)
    end
end

return class