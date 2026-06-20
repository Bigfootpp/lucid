local TypeUtils = require(script.Parent.Utils.TypeUtils)

export type function Convert(M: type)
    local METAMETHODS_MAP = {
        __plus = "__add",
        __minus = "__sub",
        __times = "__mul",
        __divide = "__div",
        __floordiv = "__idiv",
        __modulo = "__mod",
        __power = "__pow",
        __negate = "__unm",
        __equals = "__eq",
        __less = "__lt",
        __less_equal = "__le",
        __str = "__tostring",
        __join = "__concat",
        __invoke = "__call",
        __size = "__len",
        __iterate = "__iter",
    }

    local result = types.newtable()
    for propKey, propData in M:properties() do
        if propKey:is("singleton") then
            local value = propKey:value()
            if METAMETHODS_MAP[value] then
                result:setproperty(types.singleton(METAMETHODS_MAP[value]), propData.write or propData.read)
            end
        end
    end

    return result
end

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
    _class: {},
    getId: (self: any) -> string,
    getParentIds: (self: any) -> {[number]: string},
    getClass: (self: any) -> {},
    isA: (self: any, class: any) -> boolean,
}

export type InterObjectClass<V, M, P, MM> = TypeUtils.Unseal<setmetatable<TypeUtils.Merge<TypeUtils.Merge<V, ObjectType>, {
    super: (self: any) -> SuperReference<P>
}>, TypeUtils.Merge<{ __index: M }, MM>>>

export type ClassObject<V, M, P> = {
    _id: string,
    _parentIds: {[number]: string},
    _parentClass: P?,
    _variables: TypeUtils.DeepUnseal<TypeUtils.Merge<V, GetVariables<P>>>,
    _methods: TypeUtils.Merge<GetMethods<P>, TypeUtils.Clean<M>>,
    create: (self: any, ...any) -> InstantiatedObject<V, TypeUtils.Clean<M>, P>,
    isA: (self: any, class: any) -> boolean,
    getId: (self: any) -> string,
    getParentIds: (self: any) -> {[number]: string}
}

export type InstantiatedObject<V, M, P> = InterObjectClass<
    TypeUtils.Merge<TypeUtils.DeepUnseal<V>, GetVariables<P>>, 
    TypeUtils.Merge<M, GetMethods<P>>,
    P,
    Convert<M>
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

export type MethodsTable<V, P> = {
    [string]: (self: SelfReference<V, P>, ...any) -> ...any,
    __init: (self: SelfReference<V, P>, ...any) -> (),

    __plus: (self: SelfReference<V, P>, other: any) -> any,
    __rplus: (self: SelfReference<V, P>, other: any) -> any,
    __minus: (self: SelfReference<V, P>, other: any) -> any,
    __rminus: (self: SelfReference<V, P>, other: any) -> any,
    __times: (self: SelfReference<V, P>, other: any) -> any,
    __rtimes: (self: SelfReference<V, P>, other: any) -> any,
    __divide: (self: SelfReference<V, P>, other: any) -> any,
    __rdivide: (self: SelfReference<V, P>, other: any) -> any,
    __floordiv: (self: SelfReference<V, P>, other: any) -> any,
    __rfloordiv: (self: SelfReference<V, P>, other: any) -> any,
    __modulo: (self: SelfReference<V, P>, other: any) -> any,
    __rmodulo: (self: SelfReference<V, P>, other: any) -> any,
    __power: (self: SelfReference<V, P>, other: any) -> any,
    __rpower: (self: SelfReference<V, P>, other: any) -> any,
    __negate: (self: SelfReference<V, P>) -> any,
    __equals: (self: SelfReference<V, P>, other: any) -> boolean,
    __less: (self: SelfReference<V, P>, other: any) -> boolean,
    __less_equal: (self: SelfReference<V, P>, other: any) -> boolean,
    __str: (self: SelfReference<V, P>) -> string,
    __join: (self: SelfReference<V, P>, other: any) -> any,
    __rjoin: (self: SelfReference<V, P>, other: any) -> any,
    __invoke: (self: SelfReference<V, P>, ...any) -> any,
    __size: (self: SelfReference<V, P>) -> number,
    __iter: (self: SelfReference<V, P>) -> ((any, any) -> ...any, any, any),
}

return {}
