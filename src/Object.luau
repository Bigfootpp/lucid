local TableUtils = require(script.Parent.Utils.Table)
local TypeUtils = require(script.Parent.Utils.TypeUtils)

local Object = {}
Object.__index = Object

export type function GetMethods(C)
    if not C:is("table") then
        return types.newtable()
    end
    
    for propKey, propData in pairs(C:properties()) do
        if propKey:is("singleton") and propKey:value() == "_methods" then
            if propData.read then
                return propData.read
            end
        end
    end
    
    return types.newtable()
end

export type function GetVariables(C)
    if not C:is("table") then
        return types.newtable()
    end
    
    for propKey, propData in C:properties() do
        if propKey:is("singleton") and propKey:value() == "_variables" then
            if propData.read then
                return propData.read
            end
        end
    end
    
    return types.newtable()
end

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

function Object.New<C>(Class: C, ...): InterObjectClass<GetVariables<C>, GetMethods<C>>
    local parentIds: {number} = Class._parentClass
    local id: number = Class._id
    local variables: GetVariables<C> = Class._variables
    local methods: GetMethods<C> = Class._methods
    
    local self = TableUtils.DeepCopy(variables) :: ObjectType
    self._parentIds = parentIds
    self._id = id

    setmetatable(methods, Object)
    setmetatable(self, {
        __index = methods
    })

    if methods["__init"] then 
        methods["__init"](self, ...) 
    end

    return self
end

return Object