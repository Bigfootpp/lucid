--!strict
local Class = require(script.Class)
local TypeUtils = require(script.TypeUtils)

local function class<P>(parentClass: P?)
    return function<V>(variables: V)
        type InstanceState = Class.FlatInstantiatedObject<TypeUtils.DeepUnseal<V>, {}, P>
        
        return function<M>(methods: M & {[string]: (self: InstanceState, ...any) -> ...any}): Class.ClassObject<TypeUtils.DeepUnseal<V>, TypeUtils.Clean<M>, P>
            return Class.New(variables, methods, parentClass)
        end
    end
end

return class