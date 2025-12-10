local sandState = State("sandState")

function sandState:enter()
    self.rows    = 144
    self.cols    = 256
    self.gridSquareSize = 10

    self.grainSpawnTimerFull = 100

    self.grid = {}
    self:setupGrid()
    self.grains = {}
    

    self:createCup(100,200,5,3)
    
end

function sandState:createCup(row,col,width,height)
    for h = 1,height do
        for w = 1,width do
            self.grid[row+h][col+w].content = "cup"
        end
    end
end


function sandState:updateGrid()
     -- we check all the grains and if any of them are in a grid space we set that space here to be occupied
    for row = 1, self.rows do
        for col = 1, self.cols do
            local Space = self.grid[row][col]
            if Space.content ~= "ground" and Space.content ~= "cup" then Space.content = "empty" end -- set it to empty first, cuz obviously 
            for j, Grain in ipairs(self.grains) do
                if Grain.row == row and Grain.col == col and Space.content == "empty" then
                    Space.content = "sand"
                end
            end
        end
    end
end




function sandState:createGrain(parent,row,col)
    local grain = {   -- we are doing it this way cuz i am not adding shit for this into the actual objects table
        row = row,
        col = col,
        parent = parent,
        timerFull = 100,

        update = function(self,dt)
            -- we need a timer so it doesnt update every frame
            self.timer = self.timer or self.timerFull
            self.timer = self.timer-1000*dt
            if self.timer > 0 then return end
            self.timer = self.timerFull


            -- check if this grain is touching the cup
            if parent.grid[self.row+1][self.col].content == "cup" then
                print("TOUVHINH CUP")
                self.touchedCup = true
            end



            -- first we check if the space below is empty
            if parent.grid[self.row+1] and parent.grid[self.row+1][self.col] and parent.grid[self.row+1][self.col].content == "empty" then

                -- we move down and then return
                self.row = self.row+1
                -- now we move a random amount left or right
                self.col = self.col + love.math.random(-1,1)
                return


    
            else -- it wasnt empty, so we check randomly to the left or right for 2 empty spaces
                -- first we choose a direction
                local checkLeft = chance(50)
                local dick = 1
                local balls = 2
                if checkLeft then
                    dick = -dick
                    balls = -balls
                end

                hasCheckBothWays = false
                ::checkForSpacesIGuessIdk::

                if parent.grid[self.row+1] and parent.grid[self.row+1][self.col+dick] and parent.grid[self.row+1][self.col+dick].content == "empty" then
                    self.row = self.row + 1
                    self.col = self.col + dick
                    return
                end


                if hasCheckBothWays then return end  -- so we dont get stuck looping doing this
                -- if we made it here, we gotta check the other direction
                dick = -dick
                balls = -balls
                hasCheckBothWays = true
                goto checkForSpacesIGuessIdk
            end
        end,
    }


    return grain
end


function sandState:setupGrid()
    for row = 1, self.rows do
        self.grid[row] = {}
        for col = 1, self.cols do
            local x = (col - 1) * self.gridSquareSize
            local y = (row - 1) * self.gridSquareSize

            self.grid[row][col] = {row = row,col = col,x = x,y = y}
            if row > self.rows-10 then
                self.grid[row][col].content = "ground" -- this is obvious i think
            end

        end
    end

    
end

function sandState:update(dt)
    local mx,my = cursor:getPosition()



    for i, Grain in ipairs(self.grains) do
        if Grain.touchedCup then
         --   table.remove(self.grains, i)
            self.inCup = self.inCup + 1
            break
        end
        Grain:update(dt)
    end

    self:updateGrid()




    self.prevCursorX = self.prevCursorX or mx
    self.prevCursorY = self.prevCursorY or my
    if Input:down("menuClickLeft") then
        local dx = mx - self.prevCursorX
        local dy = my - self.prevCursorY
        local steps = math.max(math.abs(dx), math.abs(dy))
        local brushRadius = 1
        for i = 0, steps do
            local x = self.prevCursorX + dx * (i / steps)
            local y = self.prevCursorY + dy * (i / steps)
            local col = math.floor(x / self.gridSquareSize) + 1          -- chatgpt wrote this part cuz i have NO idea how i would ever figure this out (its to prevent gaps when moving the cursor quickly)
            local row = math.floor(y / self.gridSquareSize) + 1
            for r = row - brushRadius, row + brushRadius do
                for c = col - brushRadius, col + brushRadius do
                    if r >= 1 and r <= self.rows and c >= 1 and c <= self.cols then
                        local cell = self.grid[r][c]
                        if cell.content == "empty" then
                            cell.content = "ground"
                        end
                    end
                end
            end
        end
    end
    self.prevCursorX = mx
    self.prevCursorY = my
    self.prevCursorX = mx
    self.prevCursorY = my




    self.grainSpawnTimer = self.grainSpawnTimer or self.grainSpawnTimerFull
    self.grainSpawnTimer = self.grainSpawnTimer - 1000*dt
    if self.grainSpawnTimer < 0 and #self.grains < 100 then self.grainSpawnTimer = self.grainSpawnTimerFull; table.insert(self.grains,self:createGrain(self,0, self.cols/2)) end

end



function sandState:draw()
    for row = 1, self.rows do
        for col = 1, self.cols do
            local cell = self.grid[row][col]
          --  love.graphics.rectangle("line", cell.x, cell.y, self.gridSquareSize, self.gridSquareSize)


            if cell.content == "sand" then
                love.graphics.setColor(1,1,0)
                love.graphics.rectangle("fill", cell.x, cell.y, self.gridSquareSize, self.gridSquareSize)
            end

            love.graphics.setColor(1,1,1)



            if cell.content == "ground" then
                love.graphics.setColor(1,1,1)
                love.graphics.rectangle("fill", cell.x, cell.y, self.gridSquareSize, self.gridSquareSize)
            end
            

            if cell.content == "cup" then
                love.graphics.setColor(1,0,1)
                love.graphics.rectangle("fill", cell.x, cell.y, self.gridSquareSize, self.gridSquareSize)
            end
        end
    end
end

return sandState
