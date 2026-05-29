local TableUtils = require(script.Parent.Parent.TableUtil)

local Object = {}
Object.__index = Object

type ObjectType = {
    _id: string
}

export type InterObjectClass<V, M> = ObjectType & V & M

function Object:GetId(): string
    return self._id
end

function Object.New<V, M>(variables: V, methods: M, id: string, ...): InterObjectClass<V, M>
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

    return self :: InterObjectClass<V, M>
end

return Object