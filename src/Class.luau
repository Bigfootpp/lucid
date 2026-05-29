local HttpService = game:GetService("HttpService")
local PREFIX = HttpService:GenerateGUID(false)
local counter = 0

local Object = require(script.Parent.Object)

local Class = {}
Class.__index = Class

type ClassType = {
    _id: string
}

export type ClassObject<V, M> = ClassType & {
    create: (self: any, ...any) -> Object.InterObjectClass<V, M>
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