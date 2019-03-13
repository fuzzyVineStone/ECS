# ECS

Simple entity component system written in Lua utilizing the LÖVE (love2D) framework. The system should be easy to use.

## Usage

Firstly, create a world to handle the entities and the systems (remember to acquire the module).

```lua
-- Require the module.
local ecs = require("lib.ecs")

-- The standard love functions.
function love.load()
    -- Create a world to manage the entity system.
    world = ecs.world.new()
end
```

Secondly, create an entity and attach a component (preferably in `love.load()`).

```lua
    ...

    -- Create an entity using the world.
    player = world:create_entity()

    -- Add components to the entity.
    player:add_component(ecs.component.new("player"))

    ...
```

You can create components through function returns for more complex assignment.

```lua
...

function position_component(x, y)
    local component = ecs.component.new("position")

    component.x = x
    component.y = y

    return component
end

...
```

Then add it as a component.

```lua
    ...

    -- Components added through function returns.
    player:add_component(position_component())

    ...
```

To have something acting upon our entity, we need a system. The systems should be returned through functions.

```lua
...

function renderer_system()
    -- A system typically requires components. This way
    -- the system knows which entities to act upon.
    local system = ecs.system.new({ "position" })

    -- The draw function overrides the module's and is used
    -- to specify in which way you want to draw you entities.
    function system:draw(entity)
        -- Get the entity of component "position".
        local position = entity:get("position")

        -- If the entity has the "player" component, set
        -- another color. Otherwise, set the color to white.
        if entity:get("player") then
            love.graphics.setColor(1, 0.5, 0.3)
        else
            love.graphics.setColor(1, 1, 1)
        end
    end

    return system
end

...
```

Just add the system to the world.

```lua
    ...

    world:add_system(renderer_system())

    ...
```

To update and draw the world, simply set `world:update(dt)` and `world:draw` in `love.update(dt)` and `love.draw()` respectively. Don't forget to pass delta time.

```lua
...

function love.update(dt)
    world:update(dt)
end

function love.draw()
    world:draw()
end
```

For a more complete walkthrough and a reference sheet, see the wiki.

## Appendix

Props to @skyVaultGames as the only real source of information I could find on an actual emplementation of an Entity Component System and as the main inspiration to this project.
