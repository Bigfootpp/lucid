local TableUtils = require(script.Parent.Utils.Table)
local Types = require(script.Parent.Types)

local Object = {}
Object.__index = Object

function Object:GetId(): string
    return self._id
end

function Object:GetParentIds(): {[number]: string}
    return self._parentIds
end

function Object.New<C>(Class: C, ...): Types.InterObjectClass<Types.GetVariables<C>, Types.GetMethods<C>, Types.GetParentClass<C>>
    local parentIds: {number} = Class._parentIds
    local id: number = Class._id
    local variables: Types.GetVariables<C> = Class._variables
    local methods: Types.GetMethods<C> = Class._methods
    local parentClass: Types.GetParentClass<C> = Class._parentClass
    
    local self = TableUtils.DeepCopy(variables) :: Types.ObjectType<Types.GetParentClass<C>>
    self._parentIds = parentIds
    self._parentClass = parentClass
    self._id = id

    setmetatable(methods, Object)
    setmetatable(self, {
        __index = function(_, key)
            return methods[key]
        end
    })

    if methods["__init"] then 
        methods["__init"](self, ...) 
    end

    return self
end

return Object