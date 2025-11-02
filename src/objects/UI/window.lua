local window = Class:extend()

function window:new(title,msg,width,height,buttons)
    -- buttons should be a table,, i think ,,, idk im just making it up as i go 
    if not type(buttons) == "table" then error("uhhhhhhhhhh") end -- this is temp, itll just detroy the window if its not a table 


    self.title,self.msg = title, msg 
    self.width,self.height = width or 0, height or 0

    if self.width == 0 then
        -- we will do this later lmao
    end

end

function window:update(dt) 

end

function window:draw()
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

return window