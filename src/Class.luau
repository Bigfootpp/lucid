local HttpService = game:GetService("HttpService")
local TableUtils = require(script.Parent.Utils.Table)
local Types = require(script.Parent.Types)

local PREFIX = HttpService:GenerateGUID(false)
local counter = 0

local Object = require(script.Parent.Object)

local Class = {}
Class.__index = Class

function Class.New<V, M, P>(variables: V, methods: M, parentClass: P?): Types.ClassObject<V, M, P>
    counter = counter + 1
    local self = setmetatable({}, Class) :: Types.ClassObject<V, M, P>
    self._variables = parentClass and TableUtils.Update(variables, parentClass._variables, false) or variables
    self._methods = parentClass and TableUtils.Update(methods, parentClass._methods, false) or methods
    
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

    self._parentIds = parentClass and TableUtils.Extend({parentClass._id}, parentClass._parentIds) or {}
    self._parentClass = parentClass
    self._id = PREFIX .. "_" .. counter

    return self :: Types.ClassObject<V, M, P>
end

function Class.create(self, ...)
    return Object.New(self, ...)
end

return Class
