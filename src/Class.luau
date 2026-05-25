local HttpService = game:GetService("HttpService")

local Object = require(script.Parent.Object)

local Class = {}
Class.__index = Class

type ClassType<T,U> = {
    _variables: T,
    _methods: U,
    _id: string
}

export type ClassObject<T, U> = typeof(setmetatable({} :: ClassType<T, U>, Class)) & {
    create: (...any) -> (Object.InterObjectClass<T, U>)
}


function Class.New<T, U>(
    variables: T,
    methods: U -- & {[string]: (Object.InterObjectClass<T, U>, ...any) -> ...any}
): ClassObject<T, U>
    assert(typeof(variables) == "table", "Variables should be a table")
    assert(typeof(methods) == "table", "Methods should be a table")

    local self = setmetatable({}::ClassType<T, U>, Class)
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

function Class.create(self: any, ...): any
    return Object.New(self._variables, self._methods, self._id, ...)
end

return Class