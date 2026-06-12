local TableUtils = require(script.Parent.Utils.Table)
local Types = require(script.Parent.Types)

local Object = {}
Object.__index = Object

local superContext = nil

function Object:GetId(): string
    return self._id
end

function Object:GetParentIds(): {[number]: string}
    return self._parentIds
end

function Object:super()
    if not superContext then
        error("super() called outside of class method")
    end

    local parentClass = superContext._parentClass
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
                return function(...)
                    return method(self, ...)
                end
            end

            local objMethod = Object[key]
            if type(objMethod) == "function" then
                return function(...)
                    return objMethod(self, ...)
                end
            end

            return nil
        end
    })
end

local function defineMetatable(self, methods)
    setmetatable(methods, Object)
    setmetatable(self, {
        __index = function(_, key)
            local method = methods[key]

            if type(method) == "table" and rawget(method, "_definedIn") then
                return function(...)
                    local prev = superContext
                    superContext = rawget(method, "_definedIn")
                    local result = method(...)
                    superContext = prev
                    return result
                end
            end

            return method
        end
    })
end

local function callInit(self, ...)
    if self["__init"] then
        self["__init"](self, ...) 
    end
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

    defineMetatable(self, methods)
    callInit(self, ...)

    return self
end

return Object
