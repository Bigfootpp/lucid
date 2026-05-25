local Object = {}
Object.__index = Object

type ObjectType = {
    _id: string
}

export type ObjectClass = typeof(setmetatable({} :: ObjectType, Object))

function Object.New<T, U>(variables: T, methods: U, id: string, ...): ObjectClass & T & U
    local self = setmetatable({}::ObjectType, Object)
    for key, value in variables do
        assert(typeof(value) ~= "function", "Elements in variables should not be functions")
        self[key] = value
    end
    for key, value in methods do
        assert(typeof(value) == "function", "Elements in methods should be functions")
        self[key] = value
    end

    if methods["__init"] then methods["__init"](self, ...) end

    return self
end

return Object