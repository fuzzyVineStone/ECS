return {
	new = function() 
		entity = {
			components = {},
			remove = false,
			loaded = false
		}

		function entity:add_component(component)
			assert(component.__id)
			print(unpack(self.components))
			self.components[component.__id] = component
		end

		function entity:remove_component(component)
			assert(component.__id)
			self.components[component.__id] = component
		end

		function entity:get(id)
			return self.components[id]
		end

		function entity:destroy()
			self.remove = true
		end

		return entity
	end
}
