local HttpService = game:GetService("HttpService")
local TableUtils = require(script.Parent.Parent.TableUtil)
local PREFIX = HttpService:GenerateGUID(false)
local counter = 0

local Object = require(script.Parent.Object)

local Class = {}
Class.__index = Class

export type GetMethods<C> = index<C & { _methods: {} }, "_methods">
export type GetVariables<C> = index<C & { _variables: {} }, "_variables">

export type ClassObject<V, M, P> = {
    _id: string,
    _parentIds: {[number]: string},
    _variables: V,
    _methods: M,
    create: (self: any, ...any) -> InstantiatedObject<V, M, P>
}

export type InstantiatedObject<V, M, P> = Object.InterObjectClass<
        V & GetVariables<P>, 
        typeof(setmetatable({} :: M, {} :: { __index: GetMethods<P> }))
    >

function Class.New<V, M, P>(variables: V, methods: M & {[string]: (self: InstantiatedObject<V, M, P>, ...any) -> ...any}, parentClass: P?): ClassObject<V, M, P>
    local parent: any = parentClass
    
    counter = counter + 1
    local self = setmetatable({} :: any, Class)
    self._variables = TableUtils.Extend(variables, parent and parent._variables or {})
    self._methods = TableUtils.Extend(methods, parent and parent._methods or {})
    self._parentIds = parent and TableUtils.Extend(parent._parentIds, {parent._id}) or {}
    self._id = PREFIX .. "_" .. counter

    return self :: ClassObject<V, M, P>
end

function Class.create(self: any, ...): any
    return Object.New(self._variables, self._methods, self._id, self._parentIds, ...)
end

return Class