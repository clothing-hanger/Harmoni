
local strUpper=string.upper

function quaverParse(file)
	
	if not love.filesystem.getInfo(file, "file") then
		notification("Chart File Not Found!", notifErrorIcon)
		log("Chart File Not Found For Song " .. selectedSong)
		return false
	end


	
	
	print("quaverParse()")
	-- huge credits to https://github.com/AGORI-Studios/Rit for this part
		local chart = tinyyaml.parse(love.filesystem.read(file))
		lanes = {}
		timingPointsTable = {}
		scrollVelocities = {}
		totalNoteCount = 0
		holdNoteCount = 0
		for i = 1,7 do
			table.insert(lanes, {})
		end
		banner = nil
		metaData = {
			name = chart.Title,
			song = chart.AudioFile,
			artist = chart.Artist,
			source = chart.Source, -- not sure what this one even is really
			tags = chart.Tags, -- not gonna be used in this file but im putting it here for now so i dont forget it
			diffName = chart.DifficultyName,
			creator = chart.Creator,
			background = chart.BackgroundFile,
			banner = chart.BannerFile or nil,
			previewTime = (chart.SongPreviewTime or 0) / Modifiers[2], -- also wont be used here
			noteCount = 0,
			length = 0,
			bpm = 0,
			inputMode = chart.Mode:gsub("Keys", ""),  -- will be used to make sure its 4 key
		}
		

		

		if love.filesystem.getInfo("Music/" .. songList[selectedSong] .. "/" .. metaData.song, "file") then
			song = love.audio.newSource("Music/" .. songList[selectedSong] .. "/" .. metaData.song, "stream")
		else
			notification("Audio Failed to Load! Chart Loading Cancelled.", notifErrorIcon)
			log("Audio File Not Found For Song " .. selectedSong)
			return
		end


		if love.filesystem.getInfo("Music/" .. songList[selectedSong] .. "/" .. metaData.background, "file") then
			background = love.graphics.newImage("Music/" .. songList[selectedSong] .. "/" .. metaData.background)
		else
			notification("Background Failed to Load! Incorrect Background Will be Displayed.", notifErrorIcon)
			log("Background File Not Found For Song " .. selectedSong)

		end


		if tostring(metaData.inputMode) == "7" then
			sevenKey = true
		else
			fourKey = true
		end
		if tostring(metaData.inputMode) == "7" then
			notification("7 Key Not Supported! (yet)", notifErrorIcon)
			return false
		end
	   -- if metaData.banner and love.filesystem.getInfo("Music/" .. songList[selectedSong] .. "/" .. metaData.banner) then           this works but it looks ugly so i just commented out this
	   --     banner = love.graphics.newImage("Music/" .. songList[selectedSong] .. "/" .. metaData.banner)
	   --     print("Banner")
	   -- end
		firstNoteTime = nil

		initialScrollVelocity = chart.initialScrollVelocity or 1


		for i = 1,#chart.TimingPoints do    -- ?????? why does this not work 😭😭😭😭          why did i type this it literally does work??
			local timingPoint = chart.TimingPoints[i]
			local startTime = timingPoint.StartTime
			local bpm = (timingPoint.Bpm or 0) / Modifiers[2]
			table.insert(timingPointsTable, {startTime, bpm})
			-- if bpm and startTime then 
				--print(" TimingPoint " ..bpm .. "    " .. startTime)
			-- end 

			if i == 1 then
				metaData.bpm = timingPoint.Bpm / Modifiers[2]
				--print(timingPoint.Bpm)
			end
		end
	

		for i = 1,#chart.HitObjects do
			local hitObject = chart.HitObjects[i]
			local startTime = (hitObject.StartTime or 0) --/ Modifiers[2]
			if not startTime then goto continue end
			local endTime = hitObject.EndTime or 0
			local lane = hitObject.Lane

			totalNoteCount = totalNoteCount + 1
			if endTime > 0 then
				holdNoteCount = holdNoteCount + 1
			end


			if Modifiers[4] then
				lane = 5 - lane
			end

			local note = Objects.Game.Note(startTime, lane, endTime)
			table.insert(lanes[lane], note)
			
			if not firstNoteTime and startTime then
				firstNoteTime = math.floor(startTime*0.0001)
				print("first note time: ".. firstNoteTime)
			end
			
			lastNoteTime = startTime -- this should work because the last time its run will be the last note      
			::continue::
		end
		

		for i = 1, #chart.SliderVelocities do
			local velocity = chart.SliderVelocities[i]
			local startTime = (velocity.StartTime or 0) / Modifiers[2]
			local velocityChange = velocity.Multiplier

			

			table.insert(scrollVelocities, {startTime = startTime, multiplier = velocityChange})
		end
 
		print("Total Note Count: ".. totalNoteCount)
		songLength = song:getDuration()
		print(songLength)
		songLengthToLastNote = lastNoteTime*0.001
		bestScorePerNote = 1000000/(#lanes[1]+#lanes[2]+#lanes[3]+#lanes[4])
		holdNotePercent = math.ceil((holdNoteCount / totalNoteCount)*100)

		currentBpm = metaData.bpm
		if currentBpm then
			print("BPM: "..currentBpm)
		end
	return true
end
local function getAudio(path)
	if not love.filesystem.getInfo(path, "file") then return nil end
	return love.audio.newSource(path, "stream")
end
function fnfParse(file)
	
	if not love.filesystem.getInfo(file, "file") then
		notification("Chart File Not Found!", notifErrorIcon)
		log("Chart File Not Found For Song " .. selectedSong)
		return false
	end
	print("fnfParse()")
	-- TODO VSLICE

	local chart
	local succ,err = pcall(function()
		local json = json.parse(love.filesystem.read(file))
		chart = json.song -- FNF moment
	end)
	if not succ then
		notification("Chart Failed to Load! Chart Loading Cancelled.", notifErrorIcon)
		log("Error while parsing chart for " .. selectedSong .. ": " .. err)
		return
	end

	lanes = {}
	timingPointsTable = {}
	scrollVelocities = {}
	totalNoteCount = 0
	holdNoteCount = 0
	for i = 1,4 do
		table.insert(lanes, {})
	end
	banner = nil
	metaData = {
		name = chart.song,
		song = 'Inst.ogg',
		artist = chart.Artist or chart.artist or 'N/A',
		source = chart.Source or "N/A", -- not sure what this one even is really
		tags = chart.Tags, -- not gonna be used in this file but im putting it here for now so i dont forget it
		diffName = file:match('([^\\/]-)%.'):gsub('^.',strUpper):gsub('[_%-](.)',function(a) return ' '..a:upper() end),
		creator = "N/A",
		background = chart.BackgroundFile or "bg.png",
		banner = chart.BannerFile or "banner.png",
		previewTime = 0, -- also wont be used here
		noteCount = 0,
		length = 0,
		bpm = chart.bpm / Modifiers[2],
		inputMode = "4",  -- will be used to make sure its 4 key
	}
	


	initialScrollVelocity = 1

--[[
		for i = 1,#chart.HitObjects do
			local hitObject = chart.HitObjects[i]
			local startTime = (hitObject.StartTime or 0) --/ Modifiers[2]
			if not startTime then goto continue end
			local endTime = hitObject.EndTime or 0
			local lane = hitObject.Lane

			totalNoteCount = totalNoteCount + 1
			if endTime > 0 then
				holdNoteCount = holdNoteCount + 1
			end


			if Modifiers[4] then
				lane = 5 - lane
			end

			local note = Objects.Game.Note(startTime, lane, endTime)
			table.insert(lanes[lane], note)
			
			if not firstNoteTime and startTime then
				firstNoteTime = math.floor(startTime*0.0001)
				print("first note time: ".. firstNoteTime)
			end
			
			lastNoteTime = startTime -- this should work because the last time its run will be the last note      
			::continue::
		end

]]
	local steps = 0
	local bpm = metaData.bpm / Modifiers[2]
	local crochet = ((60 / bpm) * 1000)
	local stepCrochet = crochet / 4
	local time = 0
	for sectionID,section in pairs(chart.notes) do
		-- steps = steps + 
		time = time + (stepCrochet * 16)
		local playerNote = section.mustHitSection
		if(section.bpm) then
			section.bpm = section.bpm/ Modifiers[2];
			if(bpm ~= section.bpm and section.changeBPM) then

				bpm = section.bpm or bpm 
				crochet = ((60 / bpm) * 1000)
				stepCrochet = crochet / 4
				table.insert(timingPointsTable, {time, bpm})
			end

		end
		for _,note in ipairs(section.sectionNotes) do
			local time,lane,endTime = (tonumber(note[1]) or 0),(tonumber(note[2]) or 0),(tonumber(note[3]) or 0)
			if(lane < -1) then goto NCONTINUE end -- Early versions of Psych Engine use -1 for event notes

			if lane > 4 then lane = (lane - 4) end
			lane = lane + 1
			if(lane > 4 or lane <= 0) then goto NCONTINUE end
			if(endTime > 0) then 
				endTime = time+(endTime)
				-- print(endTime)
				holdNoteCount = holdNoteCount + 1
			end
			-- print(time,lane,endTime)
			local note = Objects.Game.Note(time, lane, endTime)

			table.insert(lanes[lane], note)
			if not firstNoteTime then firstNoteTime = time * 0.001 end
			lastNoteTime = time
			totalNoteCount = totalNoteCount+1
			
			::NCONTINUE::
		end
	end
	local function sort(n,n2) return n.time > n.time end
	for _,lane in pairs(lanes) do
		table.sort(lane,sort)
		local remList = {}
		local lastNoteTime = -10
		for i,note in pairs(lane) do
			if(lastNoteTime == note.time) then
				table.insert(remList,i)
			end
			lastNoteTime=note.time
		end
		for i,v in pairs(remList) do
			table.remove(lane,v+i)
		end
	end
	metaData.noteCount = totalNoteCount

	local s = Objects.CombinedObject:new()


	table.insert(s.sounds,getAudio("Music/" .. songList[selectedSong] .. "/Inst.ogg"))
	table.insert(s.sounds,getAudio("Music/" .. songList[selectedSong] .. "/Voices.ogg"))
	if not s.sounds[1] then
		notification("Audio Failed to Load! Chart Loading Cancelled.", notifErrorIcon)
		log("Audio File Not Found For Song " .. selectedSong)
		return
	end
	song = s
	songLength = song:getDuration()
	currentBpm = bpm
	songLengthToLastNote = lastNoteTime*0.001
	bestScorePerNote = 1000000/(#lanes[1]+#lanes[2]+#lanes[3]+#lanes[4])
	holdNotePercent = math.ceil((holdNoteCount / totalNoteCount)*100)

	return true

end
local chartTypes = {
	qua={
		parse=quaverParse,
		chartInfo=function(file) 
			if not love.filesystem.getInfo(file, "file") then print('Unable to find ' .. file) return end
			local chart = tinyyaml.parse(love.filesystem.read(file))

			return {diffName = chart.DifficultyName,name=chart.Title}
		end
	},
	json={
		parse=fnfParse,
		chartInfo=function(file) 
			-- local e = {}
			-- pcall(function()
			if not love.filesystem.getInfo(file, "file") then print('Unable to find ' .. file) return end
			local chart = json.parse(love.filesystem.read(file))
			if not chart then print('Chart ' .. file .. ' is invalid or broken' ) return end

			-- end)
			-- e.diffName = 
			return {diffName=file:match('([^\\/]-)%..-$'):gsub('^.',strUpper):gsub('[_%-](.)',function(a) return ' '..a:upper() end),name=chart.song.song}
		end
	}
}


function chartParse(file)
	func = chartTypes[file:match('%.(.-)$') or ""]
	if(func) then return func.parse(file) end
	return nil
end
function getChartInfo(file)
	func = chartTypes[file:match('%.(.-)$') or ""]
	if(func) then return func.chartInfo(file) end
	return nil

end



function harmoniParse(file) -- don't use this
	log("why did this code run lmfao")
	chart = love.filesystem.load(file)()
	bestScorePerNote = 1000000/#chart

	for i = 1,#chart do
		table.insert(lanes[chart[i][2]], chart[i][1])
	end

	song = love.audio.newSource("Music/" .. songList[selectedSong] .. "/audio.mp3", "stream")
	background = love.graphics.newImage("Music/" .. songList[selectedSong] .. "/background.jpg")
	songLength = song:getDuration()
	songLengthToLastNote = lastNoteTime/1000
	lastNoteTime = chart[#chart][1]
end