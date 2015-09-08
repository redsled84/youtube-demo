function load_lights()
    math.randomseed(os.time())
	for rowIndex=1, #map.tile_tables[1] do
        local row = map.tile_tables[1][rowIndex]
        for columnIndex=1, #row do
            local number = row[columnIndex]
            local x = (columnIndex-1)*32
            local y = (rowIndex-1)*32
            local colors = {math.random(200,255),math.random(200,255), math.random(200,255)}
            if number ~= 0 then
            	local light = lightWorld:newLight(x, y, unpack(colors), 350)
                light:setGlowStrength(0.25)
                light:setSmooth(1.25)
            end
        end
    end
end