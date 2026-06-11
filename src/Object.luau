local TableUtils = require(script.Parent.Utils.Table)
local Types = require(script.Parent.Types)

local Object = {}
Object.__index = Object

export type GetMethods<C> = Types.GetMethods<C>

export type GetVariables<C> = Types.GetVariables<C>

export type ObjectType = Types.ObjectType

export type InterObjectClass<V, M> = Types.InterObjectClass<V, M>
export type FlatInterObjectClass<V, M> = Types.FlatInterObjectClass<V, M>

function Object:GetId(): string
    return self._id
end

function Object:GetParentIds(): {[number]: string}
    return self._parentIds
end

function Object.New<C>(Class: C, ...): InterObjectClass<GetVariables<C>, GetMethods<C>>
    local parentIds: {number} = Class._parentIds
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