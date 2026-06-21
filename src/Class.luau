local HttpService = game:GetService("HttpService")
local TableUtils = require(script.Parent.Utils.Table)
local Types = require(script.Parent.Types)
local Metamethods = require(script.Parent.Metamethods)
local ContextManager = require(script.Parent.ContextManager)

local PREFIX = HttpService:GenerateGUID(false)
local counter = 0

local Object = require(script.Parent.Object)

local Class = {}
Class.__index = Class

function Class.isA(self: Types.ClassObject<{}, {}, {}>, class: Types.ClassObject<{}, {}, {}>): boolean
    if class._id == self._id then return true end
    if table.find(self._parentIds, class._id) then return true end
    return false
end

function Class.getId(self: Types.ClassObject<{}, {}, {}>): string
    return self._id
end

function Class.getParentIds(self: Types.ClassObject<{}, {}, {}>): {[number]: string}
    return table.clone(self._parentIds)
end

function Class.New<V, M, P>(variables: V, methods: M, parentClass: P?): Types.ClassObject<V, M, P>
    counter = counter + 1
    local self = setmetatable({}, Class) :: Types.ClassObject<V, M, P>
    self._variables = parentClass and TableUtils.Update(variables, parentClass._variables, false) or variables
    self._methods = parentClass and TableUtils.Update(methods, parentClass._methods, false) or methods

    Metamethods.PreventNativeMetamethods(self._methods, 2)

    self._parentIds = parentClass and TableUtils.Extend({parentClass._id}, parentClass._parentIds) or {}
    self._parentClass = parentClass
    self._id = PREFIX .. "_" .. counter

    for name, func in self._methods do
        if type(func) == "function" then
            self._methods[name] = setmetatable({
                _definedIn = self
            }, {
                __call = function(funcSelf, ...)
                    return func(...)
                end
            })
        end
    end

    setmetatable(self._methods, Object)
    self._metatable = Metamethods.OverrideNativeMetamethods(self._id, self._methods, {
        __index = function(instance, key)
            local method = self._methods[key]

            if type(method) == "table" and rawget(method, "_definedIn") then
                return ContextManager.BindContext(instance, method, rawget(method, "_definedIn"))
            end

            return method
        end
    })

    return self :: Types.ClassObject<V, M, P>
end

function Class.create(self, ...)
    return Object.New(self, ...)
end

return Class
