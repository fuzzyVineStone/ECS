# ECS

Simple entity component system written in Lua using love2D for framework. The system should be easy to use.

## Usage

Firstly, create a world to handle the entities and the systems (remember to acquire the module).

```Lua 
-- Require the module.
local ecs = require("lib.ecs")

-- The standard love functions.
function love.load()
	-- Create a world to manage the entity system.
	world = ecs.world.new()
end
```

Secondly, create an entity and attach the components (preferably in `love.load()`).

```Lua 
	...

	-- Create an entity using the world.
	player = world:create_entity()

	-- Add components to the entity.
	player:add_component(ecs.component.new("player"))

	...
```

You can add components through function returns for more complex assignment.

```Lua
...

function position_component(x, y)
	local component = ecs.component.new("position")

	component.x = x
	component.y = y

	return component
end

function rectangle_component(width, height)
	local component = ecs.component.new("shape")

    component.w = width
	component.h = height

	return component
end

function circle_component(radius)
	local component = ecs.component.new("shape")

	component.r = radius

	return component
end

...
```

Then, just add them as components.

```Lua 
	...

	-- Components added through function returns.
	player:add_component(position_component())
	player:add_component(rectangle_component())

	...
```

Thirdly, add the entity to the world.


```Lua
	...

	world:add_entity(player)

	...
```

To have something acting upon our entity, we need a system. The systems should be returned through functions.

```Lua
...

function renderer_system()
	-- A system typically requires components. This way
	-- the system knows which entities to act upon.
	local system = ecs.system.new({ "position", "shape" })

	-- The draw function overrides the module's and is used 
	-- to specify in which way you want to draw you entities.
	function system:draw(entity)
		-- Get the entity of component "position" and "shape" (though they may be the same).
		local position = entity:get("position")
		local shape    = entity:get("shape")

		-- If the entity has the "player" component, set 
		-- another color. Otherwise, set the color to white.
		if entity:get("player") then
			love.graphics.setColor(1, 0.5, 0.3)
		else
			love.graphics.setColor(1, 1, 1)
		end
	
		-- If the "shape" component has a radius, draw a circle.
		if shape.r then
			love.graphics.circle("fill", position.x, position.y, shape.r)

		-- If the "shape" component has a width and a height, draw a rectangle.
		elseif shape.w and shape.h then
			love.graphics.rectangle("fill", position.x, position.y, shape.w, shape.h)

		-- If none of the above, assert that dimensions are missing.
		else
			assert(false, "'shape' requires dimensions.")
		end
	end
	
	return system
end

...
```

Just add the system to the world.

```Lua
	...
	
	world:add_system(renderer_system())
	
	...
```

To update and draw the world, simply set `world:update(dt)` and `world:draw` in `love.update(dt)` and `love.draw()` respectively. Don't forget to pass delta time.

```Lua
...

function love.update(dt)
	world:update(dt)
end

function love.draw()
	world:draw()
end

```

Here is an overview of the full code:

```Lua
local ecs = require("lib.ecs")

function position_component(x, y)
	local component = ecs.component.new("position")

	component.x = x
	component.y = y

	return component
end

function rectangle_component(width, height)
	local component = ecs.component.new("shape")

	component.w = width
	component.h = height

	return component
end

function circle_component(radius)
	local component = ecs.component.new("shape")

	component.r = radius

	return component
end

function renderer_system()
	local system = ecs.system.new({ "position", "shape" })

	function system:draw(entity)
		local position = entity:get("position")
		local shape    = entity:get("shape")

		if entity:get("player") then
			love.graphics.setColor(1, 0.5, 0.3)
		else
			love.graphics.setColor(1, 1, 1)
		end
	
		if shape.r then
			love.graphics.circle("fill", position.x, position.y, shape.r)
		elseif shape.w and shape.h then
			love.graphics.rectangle("fill", position.x, position.y, shape.w, shape.h)
		else
			assert(false, "Shape requires dimensions.")
		end
	end
	
	return system
end

function love.load()
	world = ecs.world.new()

	player = world:create_entity()

	player:add_component(ecs.component.new("player"))
	player:add_component(position_component())
	player:add_component(rectangle_component())

	world:add_entity(player)
	world:add_system(renderer_system())
end

function love.update(dt)
	world:update(dt)
end

function love.draw()
	world:draw()
end

```

### Appendix

Props to @skyVaultGames as the only real source of information I could find on an actual emplementation of an Entity Component System and as the main inspiration to this project.
