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

export type function CleanSelf(I)
    if not I:is("table") then
        return I
    end

    local function stripFunctions(tbl)
        local clean = types.newtable()
        
        local idx = tbl:readindexer()
        if idx then
            clean:setindexer(idx.index, idx.result)
        end
        
        for propKey, propData in pairs(tbl:properties()) do
            local propType = propData.read
            if propType and not propType:is("function") then
                clean:setproperty(propKey, propType)
            end
        end
        
        return clean
    end

    local result = types.copy(I)

    for propKey, propData in pairs(I:properties()) do
        local propType = propData.read
        
        if propType and propType:is("function") then
            local params = propType:parameters()
            local head = params.head or {}
            local firstParam = head[1]
            
            if firstParam and firstParam:is("table") then
                local cleanedSelf = stripFunctions(firstParam)
                
                local newParams = {}
                for i, param in ipairs(head) do
                    if i == 1 then
                        table.insert(newParams, cleanedSelf)
                    else
                        table.insert(newParams, param)
                    end
                end
                
                local newFunc = types.newfunction()
                newFunc:setparameters(newParams, params.tail)
                
                local returns = propType:returns()
                newFunc:setreturns(returns.head, returns.tail)
                
                result:setproperty(propKey, newFunc)
            end
        end
    end

    return result
end

type selfExample = CleanSelf<{
    var1: string,
    method1: (self: {
        var1: string,
        method1: () -> ()
    }, ...any) -> (...any)
}>

type selfTarget = {
    var1: string,
    method1: (self: {
        var1: string,
    }, ...any) -> (...any)
}

export type ObjectType = {
    _id: string,
    _parentIds: {[number]: string},
    GetId: (self: any) -> string,
    GetParentIds: (self: any) -> {[number]: string}
}

export type InterObjectClass<V, M> = TypeUtils.Unseal<setmetatable<TypeUtils.Merge<V, ObjectType>, { __index: M }>>

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
    TypeUtils.Merge<M, GetMethods<P>>
>

export type SuperReference<P> = TypeUtils.Unseal<TypeUtils.Merge<
    GetVariables<P>,
    GetMethods<P>
>>

export type SelfReference<V, M, P> = TypeUtils.Unseal<TypeUtils.Merge<
    TypeUtils.Merge<
        TypeUtils.Merge<TypeUtils.DeepUnseal<V>, GetVariables<P>>,
        TypeUtils.Merge<GetMethods<P>, M>
    >,
    {
        super: (self: any) -> SuperReference<P>
    }
>>

return {}