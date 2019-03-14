local entity = require("lib.ecs-core.entity")
local system = require("lib.ecs-core.system")

return {
	new = function()
		local world = {
			entities = {},
			systems  = {}
		}

		function world:create_entity()
			local _entity = entity.new()
			table.insert(self.entities, _entity)
			return _entity
		end

		function world:add_entity(entity)
			table.insert(self.entities, entity)
		end

		function world:add_system(system)
			table.insert(self.systems, system)
		end

		function world:remove_entity(entity)
			table.remove(self.entities, entity)
		end

		function world:remove_system(system)
			table.remove(self.systems, system)
		end

		function world:update(dt)
			for i=#self.entities, 1, -1 do
				local entity = self.entities[i]
				if entity.remove then
					for _, system in ipairs(self.systems) do
						if system:match(entity) then
							system:destroy(entity)	
						end
					end
					table.remove(self.entities, i)
				else
					for _, system in ipairs(self.systems) do
						if system:match(entity) then
							if not entity.loaded then
								system:load(entity)
								entity.loaded = true
							end
							system:update(dt, entity)
						end
					end
				end
			end
		end

		function world:draw()
			for i=1, #self.entities do
				local entity = self.entities[i]
				for _, system in ipairs(self.systems) do
					if system:match(entity) then
						system:draw(entity)
					end
				end
			end
		end

		return world
	end
}

