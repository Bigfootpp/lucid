local HttpService = game:GetService("HttpService")
local TableUtils = require(script.Parent.Parent.TableUtil)
local TypeUtils = require(script.Parent.TypeUtils)

local PREFIX = HttpService:GenerateGUID(false)
local counter = 0

local Object = require(script.Parent.Object)

local Class = {}
Class.__index = Class

type function GetMethods(C)
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

export type ClassObject<V, M, P> = {
    _id: string,
    _parentIds: {[number]: string},
    _variables: TypeUtils.DeepUnseal<TypeUtils.Merge<V, GetVariables<P>>>,
    _methods: M,
    create: (self: any, ...any) -> InstantiatedObject<V, M, P>
}

export type InstantiatedObject<V, M, P> = Object.InterObjectClass<
    TypeUtils.Merge<V, GetVariables<P>>, 
    TypeUtils.Merge<M, GetMethods<P>>
>

export type FlatInstantiatedObject<V, M, P> = Object.FlatInterObjectClass<
    TypeUtils.Merge<V, GetVariables<P>>, 
    TypeUtils.Merge<M, GetMethods<P>>
>

function Class.New<V, M, P>(variables: V, methods: M, parentClass: P?): ClassObject<V, TypeUtils.Clean<M>, P>
    local parent = parentClass
    
    counter = counter + 1
    local self = setmetatable({}, Class)
    self._variables = TableUtils.Extend(variables, parent and parent._variables or {})
    self._methods = TableUtils.Extend(methods, parent and parent._methods or {})
    self._parentIds = parent and TableUtils.Extend(parent._parentIds, {parent._id}) or {}
    self._id = PREFIX .. "_" .. counter

    return self :: ClassObject<V, M, P>
end

function Class.create(self, ...)
    return Object.New(self._variables, self._methods, self._id, self._parentIds, ...)
end

return Class