local Metamethods = {}
local TypeUtils = require(script.Parent.Utils.TypeUtils)

local METAMETHODS_MAP = {
    __plus = "__add",
    __minus = "__sub",
    __times = "__mul",
    __divide = "__div",
    __floordiv = "__idiv",
    __modulo = "__mod",
    __power = "__pow",
    __negate = "__unm",
    __equals = "__eq",
    __less = "__lt",
    __less_equal = "__le",
    __str = "__tostring",
    __join = "__concat",
    __invoke = "__call",
    __size = "__len",
    __iterate = "__iter",
}

local RIGHT_OPERATOR_METAMETHODS_MAP = {
    __plus = "__rplus",
    __minus = "__rminus",
    __times = "__rtimes",
    __divide = "__rdivide",
    __floordiv = "__rfloordiv",
    __modulo = "__rmodulo",
    __power = "__rpower",
    __join = "__rjoin",
}

export type MetamethodsType = typeof(METAMETHODS_MAP)

function Metamethods.OverrideNativeMetamethods<T>(self, methods: {}, tbl: T): TypeUtils.Merge<T, MetamethodsType>
    for name, nativeName in METAMETHODS_MAP do
        if methods[name] then
            if not RIGHT_OPERATOR_METAMETHODS_MAP[name] then
                tbl[nativeName] = function(_, ...)
                    return self[name](self, ...)
                end
            else
                tbl[nativeName] = function(a, b)
                    if typeof(a) == "table" and a._id == self._id then
                        return self[name](self, b)
                    elseif typeof(b) == "table" and b._id == self._id then
                        return self[RIGHT_OPERATOR_METAMETHODS_MAP[name]](self, a)
                    else
                        error(`Both argument are not instance of the class {self._id}`, 2)
                    end
                end
            end
        end
    end

    return tbl
end

function Metamethods.PreventNativeMetamethods(self, level: number?)
    level = level or 1
    for name, nativeName in METAMETHODS_MAP do
        if self[nativeName] then
            error("Cannot override native metamethods", level + 1)
        end
    end
end

return Metamethods