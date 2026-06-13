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

export type ObjectType<P> = {
    _id: string,
    _parentIds: {[number]: string},
    GetId: (self: any) -> string,
    GetParentIds: (self: any) -> {[number]: string}
}

export type InterObjectClass<V, M, P> = TypeUtils.Unseal<setmetatable<TypeUtils.Merge<V, ObjectType<P>>, { __index: M }>>

export type ClassObject<V, M, P> = {
    _id: string,
    _parentIds: {[number]: string},
    _parentClass: P?,
    _variables: TypeUtils.DeepUnseal<TypeUtils.Merge<V, GetVariables<P>>>,
    _methods: TypeUtils.Merge<GetMethods<P>, TypeUtils.Clean<M>>,
    create: (self: any, ...any) -> InstantiatedObject<V, TypeUtils.Clean<M>, P>
}

export type InstantiatedObject<V, M, P> = InterObjectClass<
    TypeUtils.Merge<TypeUtils.DeepUnseal<V>, GetVariables<P>>, 
    TypeUtils.Merge<M, GetMethods<P>>,
    P
>

export type SuperReference<P> = TypeUtils.Unseal<TypeUtils.Merge<
    GetVariables<P>,
    GetMethods<P>
>>

export type SelfReference<V, P> = TypeUtils.Unseal<TypeUtils.Merge<
    TypeUtils.Merge<TypeUtils.DeepUnseal<V>, GetVariables<P>>,
    {
        super: (self: any) -> SuperReference<P>
    }
>>

return {}