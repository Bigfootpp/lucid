local TableUtils = require(script.Parent.Utils.Table)
local Types = require(script.Parent.Types)
local Metamethods = require(script.Parent.Metamethods)

local Object = {}
Object.__index = Object

local superContexts = {}

local function getContext()
    return superContexts[coroutine.running()]
end

local function setContext(ctx)
    superContexts[coroutine.running()] = ctx
end

local function bindContext(self, ctx, method)
    return function(_, ...)
        local args = table.pack(self, ...)

        local prev = getContext()
        setContext(ctx)
        
        local success, result = pcall(method, table.unpack(args, 1, args.n))

        setContext(prev)

        if not success then
            error(result)
        end
        return result
    end
end

local function defineMetatable(self, methods)
    setmetatable(methods, Object)
    setmetatable(self, Metamethods.OverrideNativeMetamethods(self, methods, {
        __index = function(_, key)
            local method = methods[key]

            if type(method) == "table" and rawget(method, "_definedIn") then
                return bindContext(self, rawget(method, "_definedIn"), method)
            end

            return method
        end
    }))
    Metamethods.PreventNativeMetamethods(self, 4)
end

local function callInit(self, ...)
    if self["__init"] then
        self["__init"](self, ...) 
    end
end

function Object:super()
    if not getContext() then
        error("super() called outside of class method")
    end

    local parentClass = getContext()._parentClass
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
                return bindContext(self, rawget(method, "_definedIn"), method)
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

function Object.New<C>(Class: C, ...): Types.InterObjectClass<Types.GetVariables<C>, Types.GetMethods<C>>
    local parentIds: {number} = Class._parentIds
    local id: number = Class._id
    local variables: {} = Class._variables
    local methods: {} = Class._methods
    local parentClass = Class._parentClass
    
    local self = TableUtils.DeepCopy(variables) :: Types.ObjectType
    self._parentIds = parentIds
    self._parentClass = parentClass
    self._id = id
    self._class = Class

    defineMetatable(self, methods)
    callInit(self, ...)

    return self
end

return Object
