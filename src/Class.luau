local HttpService = game:GetService("HttpService")
local PREFIX = HttpService:GenerateGUID(false)
local counter = 0

local Object = require(script.Parent.Object)

local Class = {}
Class.__index = Class

type ClassType = {
    _id: string,
    _parent_ids: {[number]: string},
    _methods: {[string]: (self: any, ...any) -> (...any)},
    _variables: {[string]: any}
}

type GetMethods<C> = index<C, "_methods">
type GetVariables<C> = index<C, "_variables">

export type ClassObject<V, M, P = {}> = ClassType & {
    create: (self: any, ...any) -> Object.InterObjectClass<V, M, GetMethods<P>, GetVariables<P>>
}

function Class.New<V, M>(variables: V, methods: M): ClassObject<V, M>
    counter = counter + 1
    local self = setmetatable({}, Class)
    self._variables = variables
    self._methods = methods
    self._id = PREFIX .. "_" .. counter

    return self :: ClassObject<V, M>
end

function Class.create(self: any, ...): any
    return Object.New(self._variables, self._methods, self._id, ...)
end

return Class