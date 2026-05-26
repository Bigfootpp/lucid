local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TableUtils = require(ReplicatedStorage.Packages.TableUtil)

local Object = {}
Object.__index = Object

type ObjectType = {
    _id: string
}

export type InterObjectClass<T, U> = ObjectType & T & U

function Object:GetId(): string
    return self._id
end

function Object.New<T, U>(variables: T, methods: U, id: string, ...): InterObjectClass<T, U>
    local self = TableUtils.Copy(variables, true)
    self._id = id

    if not getmetatable(methods) then
        setmetatable(methods, Object)
    end
    
    local mt = {
        __index = methods
    }
    setmetatable(self, mt)

    if methods["__init"] then 
        methods["__init"](self, ...) 
    end

    return self :: InterObjectClass<T, U>
end

return Object