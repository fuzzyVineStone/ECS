return {
	new = function(requires)
		assert(type(requires) == "table", "Not a table!")
		local system = {
			requires = requires
		}

		function system:match(entity)
			for i=1, #self.requires do
				if entity:get(self.requires[i]) == nil then
					return false
				else
					return true
				end
			end
		end

		function system:load(entity)	   end
		function system:update(dt, entity) end
		function system:draw(entity)	   end
		function system:destroy(entity)	   end

		return system
	end
}
