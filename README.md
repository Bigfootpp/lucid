# LuCid

LuCid is a lightweight Luau package designed to simplify Object-Oriented Programming (OOP) in Roblox.

> [!WARNING]  
> This project is currently in **Beta**. Expect breaking changes and use with caution.
> Versions below 0.2.4 are unusable.

## Features

- **Declarative**: Define initial state and methods in a clean, functional way.
- **Lightweight**: Minimalist implementation for performance.
- **Luau Ready**: Built with strict typing and modern Luau features.

## Installation

### Wally

Add LuCid to your `wally.toml` dependencies:

```toml
LuCid = "bigfootpp/lucid@0.2.4"
```

## Quick Start

```lua
local LuCid = require(path.to.lucid)

-- Define a class with initial variables and methods
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

-- Create an instance
local hero = Character:create("Explorer")
hero:TakeDamage(25) -- Explorer now has 75 health.
```

## License

Distributed under the MIT License. See `LICENSE` for more information.
