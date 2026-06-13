local TypeUtils = require(script.Parent.Utils.TypeUtils)

export type function GetClassInfo(C)
    local result = types.newtable({
        [types.singleton("_variables")] = types.newtable(),
        [types.singleton("_methods")] = types.newtable(),
        [types.singleton("_parentClass")] = types.singleton(nil)
    })
    
    if not C:is("table") then
        return result
    end
    
    for propKey, propData in C:properties() do
        if propKey:is("singleton") then
            local keyName = propKey:value()
            if keyName == "_variables" or keyName == "_methods" or keyName == "_parentClass" then
                if propData.read then
                    result:setproperty(propKey, propData.read)
                end
            end
        end
    end
    
    return result
end

export type function GetMethods(C)
    local info = GetClassInfo(C)
    return info:readproperty(types.singleton("_methods"))
end

export type function GetVariables(C)
    local info = GetClassInfo(C)
    return info:readproperty(types.singleton("_variables"))
end

export type function GetParentClass(C)
    local info = GetClassInfo(C)
    return info:readproperty(types.singleton("_parentClass"))
end

export type ObjectType = {
    _id: string,
    _parentIds: {[number]: string},
    super: (self: any) -> any, -- temporarily any
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
    _methods: TypeUtils.Clean<M>,
    create: (self: any, ...any) -> InstantiatedObject<V, TypeUtils.Clean<M>, P>
}

export type InstantiatedObject<V, M, P> = InterObjectClass<
    TypeUtils.Merge<TypeUtils.DeepUnseal<V>, GetVariables<P>>, 
    TypeUtils.Merge<M, GetMethods<P>>
>

export type SuperReference<V, P> = FlatInterObjectClass<
    TypeUtils.Merge<TypeUtils.DeepUnseal<V>, GetVariables<P>>, 
    {}
>

return {}