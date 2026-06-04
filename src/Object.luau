local TableUtils = require(script.Parent.Parent.TableUtil)
local TypeUtils = require(script.Parent.TypeUtils)

local Object = {}
Object.__index = Object

export type ObjectType = {
    _id: string,
    _parentIds: {[number]: string},
    GetId: (self: any) -> string,
    GetParentIds: (self: any) -> {[number]: string}
}

export type InterObjectClass<V, M> = setmetatable<TypeUtils.Merge<V, ObjectType>, { __index: M }>
export type FlatInterObjectClass<V, M> = TypeUtils.Merge<TypeUtils.Merge<V, M>, ObjectType>

function Object:GetId(): string
    return self._id
end

function Object:GetParentIds(): {[number]: string}
    return self._parentIds
end

function Object.New<V, M>(variables: V, methods: M, id: string, parentIds: {[number]: string}, ...): InterObjectClass<V, M>
    local self = TableUtils.Copy(variables, true) :: ObjectType
    self._parentIds = parentIds
    self._id = id

    setmetatable(methods, Object)
    setmetatable(self, {
        __index = methods
    })

    if methods["__init"] then 
        methods["__init"](self, ...) 
    end

    return self :: InterObjectClass<V, M>
end

return Object