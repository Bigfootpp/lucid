local HttpService = game:GetService("HttpService")

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
    local self = setmetatable({}, Class)
    self._variables = variables
    self._methods = methods
    self._id = HttpService:GenerateGUID(false)

    return self :: ClassObject<T, U>
end

function Class.create(self: any, ...): any
    return Object.New(self._variables, self._methods, self._id, ...)
end

return Class