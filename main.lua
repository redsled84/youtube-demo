PostShader = require "lib/light/postshader"
LightWorld = require "lib/light"
gamera =     require "lib/gamera"
bump =       require "lib/bump"
inspect =    require "lib/inspect"
world = bump.newWorld()

--require "lighting"
require "player"
require "map"
require "lights"

function love.load()
	cam = gamera.new(-love.graphics.getWidth(),-love.graphics.getHeight(),60*32+love.graphics.getWidth(),60*32+love.graphics.getHeight())
	scale = 1
	
	-- create light world
	lightWorld = LightWorld({
		ambient = {55,55,55},
		refractionStrength = 32.0,
		reflectionVisibility = 0.75,
	})

	player.LOAD()
	map.LOAD()
	load_lights()

	post_shader = PostShader()
end

function love.update(dt)
	local x, y, scale = player.cam.x, player.cam.y, scale
	
	love.window.setTitle("Light vs. Shadow Engine (FPS:" .. love.timer.getFPS() .. ")")

	cam:devMovement(dt)

	cam:setScale(scale)
	lightWorld:update(dt)
	lightWorld:setTranslation(-cam.x, -cam.y)
	lightWorld:setScale(scale)

	player.UPDATE(dt)
end

function love.draw()
	

   	cam:draw(function(l,t,w,h)
    	lightWorld:draw(function(l, t, w, h, s)
			map.DRAW()
			player.DRAW()
		end)
		
		--[[
		love.graphics.setColor(255,255,255,100)
   		love.graphics.rectangle("fill", player.cam.x, player.cam.y, player.cam.width, player.cam.height)
   		--]]
   		
   		lightWorld.post_shader:addEffect("bloom")
	end)

   
end

function love.keypressed(key)
	player.KEYPRESSED(key)
end

function love.keyreleased(key)
	player.KEYRELEASED(key)
end