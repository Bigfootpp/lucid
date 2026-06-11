--!strict
local Class = require(script.Class)
local TypeUtils = require(script.Utils.TypeUtils)
local Types = require(script.Types)

local function class<P>(parentClass: P?)
    return function<V>(variables: V)
        type InstanceState = Types.FlatInstantiatedObject<TypeUtils.DeepUnseal<V>, {}, P>
        
        return function<M>(methods: M & {[string]: (self: InstanceState, ...any) -> ...any}): Types.ClassObject<TypeUtils.DeepUnseal<V>, TypeUtils.Clean<M>, P>
            return Class.New(variables, methods, parentClass)
        end
    end
end

return class