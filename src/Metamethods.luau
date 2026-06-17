local Metamethods = {}
local TypeUtils = require(script.Parent.Utils.TypeUtils)

local METAMETHODS_MAP = {
    __plus = "__add",
    __minus = "__sub",
    __multiply = "__mul",
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

export type MetamethodsType = typeof(METAMETHODS_MAP)

function Metamethods.OverrideNativeMetamethods<T>(self, methods: {}, tbl: T): TypeUtils.Merge<T, MetamethodsType>
    for name, nativeName in METAMETHODS_MAP do
        if methods[name] then
            tbl[nativeName] = function(_, ...)
                return self[name](self, ...)
            end
        end
    end

    return tbl
end

function Metamethods.PreventNativeMetamethods(self, level: number?)
    level = level or 0
    for name, nativeName in METAMETHODS_MAP do
        if self[nativeName] then
            error("Cannot override native metamethods", level + 1)
        end
    end
end

function Metamethods.GetMetamethodsMap()
    return METAMETHODS_MAP
end

return Metamethods