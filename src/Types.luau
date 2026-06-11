local TypeUtils = require(script.Parent.Utils.TypeUtils)

export type function GetMethods(C)
    if not C:is("table") then
        return types.newtable()
    end
    
    for propKey, propData in pairs(C:properties()) do
        if propKey:is("singleton") and propKey:value() == "_methods" then
            if propData.read then
                return propData.read
            end
        end
    end
    
    return types.newtable()
end

export type function GetVariables(C)
    if not C:is("table") then
        return types.newtable()
    end
    
    for propKey, propData in C:properties() do
        if propKey:is("singleton") and propKey:value() == "_variables" then
            if propData.read then
                return propData.read
            end
        end
    end
    
    return types.newtable()
end

export type ObjectType = {
    _id: string,
    _parentIds: {[number]: string},
    GetId: (self: any) -> string,
    GetParentIds: (self: any) -> {[number]: string}
}

export type InterObjectClass<V, M> = setmetatable<TypeUtils.Merge<V, ObjectType>, { __index: M }>
export type FlatInterObjectClass<V, M> = TypeUtils.Merge<TypeUtils.Merge<V, M>, ObjectType>

export type ClassObject<V, M, P> = {
    _id: string,
    _parentIds: {[number]: string},
    _parentClass: P?,
    _variables: TypeUtils.DeepUnseal<TypeUtils.Merge<V, GetVariables<P>>>,
    _methods: M,
    create: (self: any, ...any) -> InstantiatedObject<V, M, P>
}

export type InstantiatedObject<V, M, P> = InterObjectClass<
    TypeUtils.Merge<V, GetVariables<P>>, 
    TypeUtils.Merge<M, GetMethods<P>>
>

export type FlatInstantiatedObject<V, M, P> = FlatInterObjectClass<
    TypeUtils.Merge<V, GetVariables<P>>, 
    TypeUtils.Merge<M, GetMethods<P>>
>

return {}