# LuCid

LuCid is a **lightweight** Luau package designed to simplify Object-Oriented Programming (OOP) in Roblox.

> [!WARNING]
> This project is currently in **Beta**. Expect breaking changes and use with caution.

## Installation

### Wally

```toml
LuCid = "bigfootpp/lucid@0.3.0"
```

## Quick Start

```lua
local LuCid = require(path.to.lucid)

local Character = LuCid {
    Health = 100,
    Name = "Unknown",
} {
    __init = function(self, name: string)
        self.Name = name
    end,

    TakeDamage = function(self, amount: number)
        self.Health = math.max(0, self.Health - amount)
        print(self.Name .. " now has " .. self.Health .. " health.")
    end
}

local hero = Character:create("Explorer")
hero:TakeDamage(25) -- Explorer now has 75 health.
```

## Inheritance

Pass a parent class as first argument to `LuCid()`:

```lua
local Animal = LuCid {
    species = "",
    legs = 0,
} {
    __init = function(self, species: string, legs: number)
        self.species = species
        self.legs = legs
    end,
    speak = function(self)
        return ("The %s makes a sound"):format(self.species)
    end,
}

local Cat = LuCid(Animal) { -- inherits from Animal
    tail = true,
} {
    __init = function(self, species: string, legs: number, tail: boolean)
        self.species = species
        self.legs = legs
        self.tail = tail
    end,
    speak = function(self) -- override
        return ("The %s meows"):format(self.species)
    end,
}

local cat = Cat:create("Felis catus", 4, true)
print(cat:speak()) -- "The Felis catus meows"
print(cat:GetParentIds()) -- { "animal_class_id" }
```

### Multi-level

```lua
local LivingBeing = LuCid { alive = true } {}
local Mammal = LuCid(LivingBeing) { warmBlooded = true } {}
local Dog = LuCid(Mammal) { breed = "" } {}

local dog = Dog:create()
print(dog.alive)       -- true (LivingBeing)
print(dog.warmBlooded) -- true (Mammal)
print(#dog:GetParentIds()) -- 2
```

## API

| Method | Description |
|--------|-------------|
| `Class:create(...)` | Create instance, calls `__init` if defined. |
| `instance:GetId()` | Unique instance ID. |
| `instance:GetParentIds()` | Array of parent class IDs. |

## License

MIT License. See `LICENSE`.