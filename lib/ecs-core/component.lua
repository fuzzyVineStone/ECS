return {
	new = function(id)
		assert(id)
		local component = { __id = id }
		return component
	end
}
