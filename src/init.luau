--!strict
local Class = require(script.Class)
local Types = require(script.Types)

local function class<P>(parentClass: P?)
    return function<V>(variables: V)
        type InstanceState = Types.SelfReference<V, P>
        
        return function<M>(methods: M & {[string]: (self: InstanceState, ...any) -> ...any}): Types.ClassObject<V, M, P>
            return Class.New(variables, methods, parentClass)
        end
    end
end

return class