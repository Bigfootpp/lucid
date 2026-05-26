local HttpService = game:GetService("HttpService")
local PREFIX = HttpService:GenerateGUID(false)
local counter = 0

local Object = require(script.Parent.Object)

local Class = {}
Class.__index = Class

type ClassType = {
    _id: string
}

export type ClassObject<T, U> = ClassType & {
    create: (self: any, ...any) -> Object.InterObjectClass<T, U>
}

function Class.New<T, U>(variables: T, methods: U): ClassObject<T, U>
    counter = counter + 1
    local self = setmetatable({}, Class)
    self._variables = variables
    self._methods = methods
    self._id = PREFIX .. "_" .. counter

    return self :: ClassObject<T, U>
end

function Class.create(self: any, ...): any
    return Object.New(self._variables, self._methods, self._id, ...)
end

return Class