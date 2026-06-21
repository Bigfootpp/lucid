local Metamethods = {}

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

local COMMUTATIVE_METAMETHODS = {
    __plus = true,
    __times = true,
}

function Metamethods.OverrideNativeMetamethods<T>(id: number, methods: {}, tbl: T)
    for name, nativeName in METAMETHODS_MAP do
        if methods[name] then
            local rightMethodName = RIGHT_OPERATOR_METAMETHODS_MAP[name]
            if not rightMethodName then
                tbl[nativeName] = function(self, ...)
                    return self[name](self, ...)
                end
            else
                tbl[nativeName] = function(a, b)
                    if typeof(a) == "table" and a._id == id then
                        return a[name](a, b)
                    elseif typeof(b) == "table" and b._id == id then
                        if b[rightMethodName] then
                            return b[rightMethodName](b, a)
                        elseif COMMUTATIVE_METAMETHODS[name] then
                            return b[name](b, a)
                        else
                            error(`Non-commutative operation {nativeName} requires you to define the reflected method: {rightMethodName}`, 2)
                        end
                    else
                        error(`Both arguments are not instances of the class {id}`, 2)
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
