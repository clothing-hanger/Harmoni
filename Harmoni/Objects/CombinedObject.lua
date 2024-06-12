local CombinedObject

CombinedObject = {
	_mt={
		__index=function(this,key)
			local sounds = this.sounds
			if(type(key) == "number") then
				return sounds[key]
			end
			local firstSound = sounds[1];
			local e = firstSound[key]
			if(type(e) == "function") then
				if(key:sub(0,3)=="get") then
					return function(the,...)
						return firstSound[key](the == this and firstSound or the,...)
					end
				end
				return function(the,...)

					if(the == this) then
						for i=2,#sounds do
							local v=sounds[i]
							v[key](v,...)
						end
						return firstSound[key](firstSound,...)

					else

						for i=2,#sounds do
							local v=sounds[i]
							v[key](the,...)
						end
						return firstSound[key](the,...)
					end
				end
			end
			return e
		end,
		__newindex=function(this,key,value)
			if(type(key) == "number") then
				this.sounds[key] = value
				return 
			end
			for i,v in pairs(this.sounds) do
				v[key] = value
			end
		end
	},
	new=function(self,list)
		return setmetatable({sounds=(list or {})},self._mt)
	end

}

return CombinedObject