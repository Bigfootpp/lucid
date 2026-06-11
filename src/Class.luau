local HttpService = game:GetService("HttpService")
local TableUtils = require(script.Parent.Utils.Table)
local Types = require(script.Parent.Types)

local PREFIX = HttpService:GenerateGUID(false)
local counter = 0

local Object = require(script.Parent.Object)

local Class = {}
Class.__index = Class

type GetMethods<C> = Object.GetMethods<C>
type GetVariables<C> = Object.GetVariables<C>

export type ClassObject<V, M, P> = Types.ClassObject<V, M, P>

export type InstantiatedObject<V, M, P> = Types.InstantiatedObject<V, M, P>

export type FlatInstantiatedObject<V, M, P> = Types.FlatInstantiatedObject<V, M, P>

function Class.New<V, M, P>(variables: V, methods: M, parentClass: P?): ClassObject<V, M, P>
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