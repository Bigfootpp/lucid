# LuCid

LuCid is a **lightweight** Luau package designed to simplify Object-Oriented Programming (OOP) in Roblox.

> [!WARNING]
> This project is currently in **Beta**. Expect breaking changes and use with caution.

> [!IMPORTANT]
> You must enable the new Luau type solver for the types to work correctly.

## Installation

### Wally

```toml
LuCid = "bigfootpp/lucid@0.6.0"
```

## Quick Start

```lua
local class = require(path.to.lucid)

local Character = class() { Health = 100 } {
    __init = function(self, name: string)
        self.Name = name
    end,

    TakeDamage = function(self, amount: number)
        self.Health = math.max(0, self.Health - amount)
    end
}

local hero = Character:create("Explorer")
hero:TakeDamage(25)
```

## Inheritance

```lua
local Animal = class() { species = "" } {
    speak = function(self)
        return ("The %s makes a sound"):format(self.species)
    end,
}

local Cat = class(Animal) { tail = true } {
    speak = function(self)
        return ("The %s meows"):format(self.species)
    end,
}
```

## super()

Call a parent method from a child override:

```lua
local Base = class() { health = 100 } {
    getHealth = function(self)
        return self.health
    end,
}

local Tank = class(Base) { armor = 50 } {
    getHealth = function(self)
        return self:super():getHealth() + self.armor
    end,
}
```

Chained `super()` calls work across multiple levels:

```lua
-- A -> B -> C
-- C:foo() calls super() -> B:foo() calls super() -> A:foo()
```

### Limitations

- `super()` must be called **inside a class method**. Calling it directly in a `task.spawn` or `task.delay` callback will error.
- A class method using `super()` **can** be called from `task.spawn`
- `obj.method == obj.method` is `false` -- each access returns a new wrapper.

## License

MIT License. See `LICENSE`.
