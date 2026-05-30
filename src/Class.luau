local HttpService = game:GetService("HttpService")
local TableUtils = require(script.Parent.Parent.TableUtil)
local PREFIX = HttpService:GenerateGUID(false)
local counter = 0

local Object = require(script.Parent.Object)

local Class = {}
Class.__index = Class

type ClassType = {
    _id: string,
    _parentIds: {[number]: string},
    _methods: {[string]: (self: any, ...any) -> (...any)},
    _variables: {[string]: any}
}

type GetMethods<C> = index<C & { _methods: {} }, "_methods">
type GetVariables<C> = index<C & { _variables: {} }, "_variables">

export type ClassObject<V, M, P> = ClassType & {
    create: (self: any, ...any) -> Object.InterObjectClass<V & GetVariables<P>, M & GetMethods<P>>
}

function Class.New<V, M, P>(variables: V, methods: M, parentClass: P?): ClassObject<V, M, P>
    -- Typing
    parentClass = parentClass :: ClassType
    
    counter = counter + 1
    local self = setmetatable({}, Class)
    self._variables = TableUtils.Extend(variables, parentClass and parentClass._variables or {})
    self._methods = TableUtils.Extend(methods, parentClass and parentClass._methods or {})
    self._parentIds = parentClass and TableUtils.Extend(parentClass._parentIds, {parentClass._id}) or {}
    self._id = PREFIX .. "_" .. counter

    return self :: ClassObject<V, M, P?>
end

function Class.create(self: any, ...): any
    return Object.New(self._variables, self._methods, self._id, self._parentIds, ...)
end

return Class