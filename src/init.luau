--!strict
local Class = require(script.Class)
local Object = require(script.Object)
local TypeUtils = require(script.TypeUtils)

local function class<P>(parentClass: P?)
    return function<V>(variables: V)
        type InstanceState = TypeUtils.Merge<TypeUtils.Merge<V, Class.GetVariables<P>>, Object.ObjectType>
        
        return function<M>(methods: M & {[string]: (self: InstanceState, ...any) -> ...any}): Class.ClassObject<V, TypeUtils.Clean<M>, P>
            return Class.New(variables, methods, parentClass)
        end
    end
end

return class