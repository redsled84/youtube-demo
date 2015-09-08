
-- solids
blocks = {}

function blocks:add(x, y, w, h)
	block = {x = x, y = y, w = w, h = h}
	blocks[#blocks+1] = block
	world:add(block, x, y, w, h)
end

function blocks:draw()
	for _,v in ipairs(blocks) do
		love.graphics.setColor(255,255,255,255)
		love.graphics.rectangle("line", v.x, v.y, v.w, v.h)
		love.graphics.setColor(255,255,255,128)
		love.graphics.rectangle("fill", v.x, v.y, v.w, v.h)
	end
end

function blocks:load_blocks()
	for rowIndex=1, #map.tile_tables[2] do
        local row = map.tile_tables[2][rowIndex]
        for columnIndex=1, #row do
            local number = row[columnIndex]
            local x = (columnIndex-1)*32
            local y = (rowIndex-1)*32

            if number ~= 0 then
            	self:add(x, y, map.tilew, map.tileh)
            	rect = lightWorld:newRectangle(x+32, y+16, 32, 32, 32)
            	--rect:setOffset(100, -1000)
            end
        end
    end
end

map = {}
map.tile_layers = {}
map.tile_tables = {}
map.tileset = love.graphics.newImage("images/tileset.png")
map.Quads = {}
map.quad_info = {}
map.tilew = 32
map.tileh = 32
map.mapwidth = 0
map.mapheight = 0
map.path = "maps/map.txt"

local function parseTiledTxtData()
	if love.filesystem.exists(map.path) then
		local currentLayer = ""
		local tile_tables = {}
		local tile_layers = {"light", "solid", "floor"}

		for i=1,#tile_layers do
			tile_tables[#tile_tables+1] = {}
		end

		for line in love.filesystem.lines(map.path) do
			if line:sub(1,6) == "width=" then
				map.mapwidth = tonumber(line:sub(7))
			end
			if line:sub(1,7) == "height=" then
				map.mapheight = tonumber(line:sub(8))
			end

			for i=#tile_layers,1,-1 do
				local string = tile_layers[i]
				if line:sub(1,string.len("type="..string)) == "type="..string then
					currentLayer = string
				end

				local string = tile_layers[i]
				if currentLayer == string then
					if tonumber(line:sub(1,1)) or tonumber(line:sub(2,2)) then
						local t = {}
		            	for s in (line .. ","):gmatch("([^,]*),") do
		                	table.insert(t, tonumber(s))
		            	end
		            	table.insert(tile_tables[i], t)
					end
				end
			end
		end

		map.tile_tables = tile_tables
		map.tile_layers = tile_layers
	end
end

local function draw_layer(...)
	local table = {...}

	love.graphics.setColor(255,255,255)
    map.tileset:setFilter("nearest", "nearest", 1)

    for rowIndex=1, #table do
        local row = table[rowIndex]
        for columnIndex=1, #row do
            local number = row[columnIndex]
            local x = (columnIndex-1)*map.tilew
            local y = (rowIndex-1)*map.tileh
            if number > 0 then
            	love.graphics.setColor(255,255,255)
            	love.graphics.draw(map.tileset, map.Quads[number], x, y)
            	-- love.graphics.print(math.floor(x).." "..math.floor(y), x, y)
        	end
        end
    end
end

local function load_map()
	local y = 0
	local numX, numY = map.tileset:getWidth()/map.tilew-1, map.tileset:getHeight()/map.tileh-1

	for y=0, numY do
		for x=0, numX do
			table.insert(map.quad_info, {x=x*map.tilew, y=y*map.tileh})
			x = x + map.tilew
		end
		x = 0
		y = y + map.tileh
	end
	
	if #map.quad_info ~= 0 then
		for i,info in ipairs(map.quad_info) do
	    	map.Quads[i] = love.graphics.newQuad(info.x, info.y, map.tilew, map.tileh, map.tileset:getWidth(), map.tileset:getHeight())
		end
	end
end

local function draw_map()
	for i=#map.tile_tables,1,-1 do
		if i > 1 then
		draw_layer(unpack(map.tile_tables[i]))
		end
	end
end

function map.LOAD()
	blocks:add(100, 100, 32, 32)
	parseTiledTxtData()
	load_map()
	blocks:load_blocks()
end

function map.DRAW()
	draw_map()
end