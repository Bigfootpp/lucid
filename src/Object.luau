local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TableUtils = require(ReplicatedStorage.Packages.TableUtil)

local Object = {}
Object.__index = Object

type ObjectType = {
    _id: string
}

export type InterObjectClass<T, U> = ObjectType & T & U

function Object.New<T, U>(variables: T, methods: U, id: string, ...): InterObjectClass<T, U>
    local self = setmetatable({}, Object)
    self._id = id
    
    for key, value in variables do self[key] = typeof(value) ~= "table" and value or TableUtils.Copy(value, true) end
    for key, value in methods do self[key] = value end

    if (methods)["__init"] then (methods)["__init"](self, ...) end

    return self :: InterObjectClass<T, U>
end

return Object