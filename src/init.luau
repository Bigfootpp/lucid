--!strict
local Class = require(script.Class)

local function class<P>(parentClass: P?)
    return function<V>(variables: V)
        return function<M>(methods: M): Class.ClassObject<V, M, P>
            return Class.New(variables, methods, parentClass)
        end
    end
end

return class