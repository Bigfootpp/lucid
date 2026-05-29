local TableUtils = require(script.Parent.Parent.TableUtil)

local Object = {}
Object.__index = Object

type ObjectType = {
    _id: string,
    _parent_ids: {[number]: string}
}

export type InterObjectClass<V, M> = ObjectType & V & M

function Object:GetId(): string
    return self._id
end

function Object:GetParentIds(): {[number]: string}
    return self._parent_ids
end

function Object.New<V, M>(variables: V, methods: M, id: string, parentIds: {[number]: string}, ...): InterObjectClass<V, M>
    local self = TableUtils.Copy(variables, true) :: ObjectType
    self._parent_ids = parentIds
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