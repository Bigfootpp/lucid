--!strict
local Class = require(script.Class)
local Object = require(script.Object)

local function class<P>(parentClass: P?)
    return function<V>(variables: V)
        type InstanceState = Object.InterObjectClass<V & Class.GetVariables<P>, {}>
        
        return function<M>(methods: M & {[string]: (self: InstanceState, ...any) -> ...any}): Class.ClassObject<V, M, P>
            return Class.New(variables, methods :: any, parentClass :: any) :: any
        end
    end
end

return class