local TableUtils = require(script.Parent.Utils.Table)
local Types = require(script.Parent.Types)
local ContextManager = require(script.Parent.ContextManager)

local Object = {}
Object.__index = Object

local function callInit(self, ...)
    if self["__init"] then
        self["__init"](self, ...) 
    end
end

function Object:super()
    if not ContextManager.GetContext() then
        error("super() called outside of class method")
    end

    local parentClass = ContextManager.GetContext()._parentClass
    if not parentClass then
        error("No parent class")
    end

    return setmetatable({}, {
        __index = function(_, key)
            local var = rawget(self, key)
            if var ~= nil then
                return var
            end

            local method = parentClass._methods[key]
            if type(method) == "table" and rawget(method, "_definedIn") then
                return ContextManager.BindContext(self, method, rawget(method, "_definedIn"))
            end

            local objMethod = Object[key]
            if type(objMethod) == "function" then
                return function(...)
                    return objMethod(self, ...)
                end
            end

            return nil
        end,

        __newindex = function(_, key, value)
            rawset(self, key, value)
        end
    })
end

function Object.getId(self: Types.ObjectType): string
    return self._id
end

function Object.getParentIds(self: Types.ObjectType): {[number]: string}
    return self._parentIds
end

function Object.isA(self: Types.ObjectType, class: Types.ClassObject<{}, {}, {}>): boolean
    if class._id == self._id then return true end
    if table.find(self._parentIds, class._id) then return true end
    return false
end

function Object.getClass(self: Types.ObjectType): {}
    return self._class
end

function Object.New<C>(Class: C, ...)
    local parentIds: {number} = Class._parentIds
    local id: number = Class._id
    local variables: {} = Class._variables
    local metatable = Class._metatable
    local parentClass = Class._parentClass
    
    local self = TableUtils.DeepCopy(variables) :: Types.ObjectType
    self._parentIds = parentIds
    self._parentClass = parentClass
    self._id = id
    self._class = Class

    setmetatable(self, metatable)
    callInit(self, ...)

    return self
end

return Object
