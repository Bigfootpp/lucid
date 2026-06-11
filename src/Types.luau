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

export type function GetParentClass(C)
    if not C:is("table") then
        return types.singleton(nil)
    end
    
    for propKey, propData in C:properties() do
        if propKey:is("singleton") and propKey:value() == "_parentClass" then
            if propData.read then
                return propData.read
            end
        end
    end
    
    return types.singleton(nil)
end

export type ObjectType<P> = {
    _id: string,
    _parentIds: {[number]: string},
    _parentClass: P,
    GetId: (self: any) -> string,
    GetParentIds: (self: any) -> {[number]: string}
}

export type InterObjectClass<V, M, P> = setmetatable<TypeUtils.Merge<V, ObjectType<P>>, { __index: M }>
export type FlatInterObjectClass<V, M, P> = TypeUtils.Merge<TypeUtils.Merge<V, M>, ObjectType<P>>

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
    TypeUtils.Merge<M, GetMethods<P>>,
    P
>

export type FlatInstantiatedObject<V, M, P> = FlatInterObjectClass<
    TypeUtils.Merge<V, GetVariables<P>>, 
    TypeUtils.Merge<M, GetMethods<P>>,
    P
>

return {}