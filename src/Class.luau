local Class = {}
Class.__index = Class

type ClassType = {
    _methods: {}
}

export type ClassObject = typeof(setmetatable({} :: ClassType, Class))

function Class.New<T>(methods: T): ClassObject & T
    assert(typeof(methods) == "table", "Methods should be a table")

    local self = setmetatable({}::ClassType, Class)
    self._methods = methods

    return self
end

return Class