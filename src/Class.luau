local HttpService = game:GetService("HttpService")
local TableUtils = require(script.Parent.Utils.Table)
local TypeUtils = require(script.Parent.Utils.TypeUtils)

local PREFIX = HttpService:GenerateGUID(false)
local counter = 0

local Object = require(script.Parent.Object)

local Class = {}
Class.__index = Class

type GetMethods<C> = Object.GetMethods<C>
type GetVariables<C> = Object.GetVariables<C>

export type ClassObject<V, M, P> = {
    _id: string,
    _parentIds: {[number]: string},
    _parentClass: P?,
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
    counter = counter + 1
    local self = setmetatable({}, Class) :: ClassObject<V, M, P>
    self._variables = parentClass and TableUtils.Update(variables, parentClass._variables, false) or variables
    self._methods = parentClass and TableUtils.Update(methods, parentClass._methods, false) or methods
    self._parentIds = parentClass and TableUtils.Extend({parentClass._id}, parentClass._parentIds) or {}
    self._parentClass = parentClass
    self._id = PREFIX .. "_" .. counter

    return self :: ClassObject<V, M, P>
end

function Class.create(self, ...)
    return Object.New(self, ...)
end

return Class