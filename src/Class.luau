local HttpService = game:GetService("HttpService")

local Object = require(script.Parent.Object)

local Class = {}
Class.__index = Class

type ClassType = {
    _variables: {[string]: any},
    _methods: {[string]: (...any) -> ...any},
    _id: string
}

export type ClassObject = typeof(setmetatable({} :: ClassType, Class))

function Class.New<T, U>(variables: T, methods: U): ClassObject
    assert(typeof(variables) == "table", "Variables should be a table")
    assert(typeof(methods) == "table", "Methods should be a table")

    local self = setmetatable({}::ClassType, Class)
    self._variables = {}
    self._methods = {}

    self._id = HttpService:GenerateGUID(false)
    for key, value in variables do
        assert(typeof(value) ~= "function", "Elements in variables should not be functions")
        self._variables[key] = value
    end
    for key, value in methods do
        assert(typeof(value) == "function", "Elements in methods should be functions")
        self._methods[key] = value
    end

    return self
end

function Class.__call(self: ClassObject, ...): Object.ObjectClass
    return Object.New(self._variables, self._methods, self._id, ...)
end

return Class