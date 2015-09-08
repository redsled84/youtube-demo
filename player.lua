player = {
			x=     30*32,
			y=     18*32,
			dx=    0,
			dy=    0,
			speed= 175,
			w=     28,
			h=     32,
			cols=  nil,
		}	

-- animation

player.animationImages = 
{
	runningSide =
	{
		"images/playerRunningS0.png",
		"images/playerRunningS1.png",
		"images/playerRunningS2.png",
		"images/playerRunningS3.png"
	},

	runningFoward =
	{
		"images/playerRunningF0.png",
		"images/playerRunningF1.png",
		"images/playerRunningF2.png",
		"images/playerRunningF3.png"
	},	

	runningBack =
	{
		"images/playerRunningB0.png",
		"images/playerRunningB1.png",
		"images/playerRunningB2.png",
		"images/playerRunningB3.png"
	},

	idle =
	{
		"images/playerIdle0.png",
		"images/playerIdle1.png",
		"images/playerIdle2.png"
	}
}

player.animtimer = 0
player.animDir = "right"
player.pnum = 1
player.image = love.graphics.newImage(player.animationImages.idle[1])
player.image:setFilter("nearest", "nearest", 1)

local function animation(image, frameconst, dt)
	player.image = love.graphics.newImage(image[player.pnum])
	player.image:setFilter("nearest", "nearest", 1)
	player.animtimer = player.animtimer + dt
	if player.animtimer > frameconst then
		player.pnum = player.pnum + 1
		player.animtimer = 0
	end
	if player.pnum > #image then
		player.pnum = 1
	end
end

-- camera 
player.cam = {
					x=0, 
	                y=0, 
	                width=0, 
	                height=0, 
	                offsetX=224, 
	                offsetY=192, 
	                centerX=0, 
	                centerY=0, 
	                speed=100
				}

local function loadCamera()
	--[[player.cam.width, player.cam.height = love.graphics.getWidth() - 2*player.cam.offsetX, love.graphics.getHeight()-2*player.cam.offsetY
	player.cam.x = cam.x - love.graphics.getWidth() / 2
	player.cam.y = cam.y - love.graphics.getHeight() / 2]]
end

local function updateCamera(dt)
	local x = cam.x + player.cam.offsetX - love.graphics.getWidth() / 2
	local y = cam.y + player.cam.offsetY - love.graphics.getHeight() / 2
	local width = love.graphics.getWidth() - player.cam.offsetX*2
	local height = love.graphics.getHeight() - player.cam.offsetY*2
	local offsetX, offsetY = player.cam.offsetX, player.cam.offsetY

	-- player camera logic
	if player.y+player.h > y+height+love.graphics.getHeight()/2 then
		cam.y = player.y - offsetY - height + player.h
	elseif player.y+player.h < y+height/2+offsetY+player.h then
		cam.y = player.y - offsetY
	end

	if player.x+player.w > x+width+love.graphics.getWidth()/2 then
		cam.x = player.x - offsetX - width + player.w
	elseif player.x+player.w < x+width/2+offsetX+player.w then
		cam.x = player.x - offsetX
	end

	player.cam.x = x
	player.cam.y = y 
	player.cam.width = width 
	player.cam.height = height 
end

-- main sub functions

local function movement(dt)
	local lk = love.keyboard

	player.dx, player.dy = 0, 0
	if lk.isDown("w") then
		player.dy = player.dy - player.speed * dt
		animation(player.animationImages.runningFoward, 0.2, dt)
		player.animDir = "up"
	end
	if lk.isDown("s") then
		player.dy = player.dy + player.speed * dt
		animation(player.animationImages.runningBack, 0.2, dt)
		player.animDir = "down"
	end
	if lk.isDown("d") then
		player.dx = player.dx + player.speed * dt 
		animation(player.animationImages.runningSide, 0.175, dt)
		player.animDir = "right"
	end
	if lk.isDown("a") then
		player.dx = player.dx - player.speed * dt
		animation(player.animationImages.runningSide, 0.175, dt)
		player.animDir = "left"
	end
	if not (lk.isDown("a") or lk.isDown("d") or lk.isDown("s") or lk.isDown("w")) then
		animation(player.animationImages.idle, 0.3, dt)
		player.animDir = "idle"
	end
end

local function collision(dt)
	local cols
	player.x, player.y, cols = world:move(player, player.x + player.dx, player.y + player.dy)
end

local function drawPlayer()
	love.graphics.setColor(255,255,255)
	if player.animDir == "left" then
		love.graphics.draw(player.image, player.x, player.y, 0, -1, 1, player.w, 0)
	else
		love.graphics.draw(player.image, player.x, player.y)
	end
end

--[[
	MAIN FUNCTIONS
	**************
]]

function player.LOAD()
	world:add(player, player.x, player.y, player.w, player.h)
	-- playerLight = lightWorld.newRectangle(player.x+18, player.y+18, player.w-2, player.h-2)
	loadCamera()
end

function player.UPDATE(dt)
	movement(dt)
	collision(dt)
	updateCamera(dt)
	-- playerLight.setPosition(player.x+16, player.y+16)
end

function player.DRAW()
	drawPlayer()
end

function player.KEYPRESSED(key)
	if key == "escape" then
		love.event.quit()
	end
end

function player.KEYRELEASED(key)
	if key == "w" or key == "s" or key == "d" or key == "a" then
		player.animtimer = 0
		player.pnum = 1
	end
end