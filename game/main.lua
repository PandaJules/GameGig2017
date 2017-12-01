require "collision"
require "lane"
require "level1"
require "level2"

-- GLOBALS --

SCREEN_WIDTH = love.graphics.getWidth()
SCREEN_HEIGHT = love.graphics.getHeight()
laneSpacing = love.graphics.getWidth()/10

LEVEL = 0 -- the level we're on
levelLoaded = false



function love.load()
	math.randomseed(os.time())
	hit_time = 1000
	invincible = false


	lives = 5

	sounds = {}
	sounds.coin = love.audio.newSource("assets/sounds/coin.ogg", "static")
	sounds.music = love.audio.newSource("assets/music/retro-bridge.wav", "static")
	sounds.music:play()

	fonts = {}
	fonts.large = love.graphics.newFont("assets/fonts/Gamer.ttf", 90)
	fonts.huge = love.graphics.newFont("assets/fonts/Gamer.ttf", 160)

	river = { w = 125, h = SCREEN_HEIGHT, y = 0, x = laneSpacing*6}
	bridge = { w = 125, h = 150, y = SCREEN_HEIGHT/6, x = laneSpacing*6}

	treeLine1 = { w = 128, h = 128*4, y = 0, x = laneSpacing*4}
	treeLine2 = { w = 128, h = 128 , y = SCREEN_HEIGHT-128, x = laneSpacing*4}
	treeLines = {treeLine1, treeLine2}
end


function love.update(dt)
	if levelLoaded == false then
		if LEVEL == 1 then
			images = level1_load_images()
			lanes = level1_load_lanes()
			level1_load_player_goal()
			levelLoaded = true
		elseif LEVEL == 2 then
			images = level2_load_images()
			lanes = level2_load_lanes()
			level2_load_player_goal()
			levelLoaded = true
		end
	end

	if LEVEL > 0 then
		move_player(dt)
		update_lanes(dt)
		check_collision(dt)
		hit_time = hit_time + dt
	else
		if love.keyboard.isDown("space") then
			LEVEL = 1
		end
	end
end

function move_player(dt)
	local VERTICAL_SPEED = 300
	local HORIZOTAL_SPEED = 500
	if love.keyboard.isDown("right") then 
		player.x = math.min(SCREEN_WIDTH-images.player_left:getWidth(), player.x + dt * HORIZOTAL_SPEED)
		player.direction = "right"
	elseif love.keyboard.isDown("left") then
		player.x = math.max(0, player.x - dt * HORIZOTAL_SPEED)
		player.direction = "left"
	elseif love.keyboard.isDown("up") then
		player.y = math.max(0, player.y - dt * VERTICAL_SPEED)
		player.direction = "up"
	elseif love.keyboard.isDown("down") then
		player.y = math.min(SCREEN_HEIGHT-images.player_left:getWidth(), player.y + dt * VERTICAL_SPEED)
		player.direction = "down"
	end 
	

end

function reset_player_position(level)
	if level == 1 then
		player.x = SCREEN_WIDTH - 150
		player.y = SCREEN_HEIGHT/2 - 64
	elseif level ==2 then 
		player.x = 10
		player.y = SCREEN_HEIGHT/2-64
	end
end

function update_lanes(dt)
	for i, lane in ipairs(lanes) do
		lane.timer = lane.timer - dt
		addnew = false
		if lane.timer < 0 then
			addnew = true
			lane.timer = lane.timerMax
		end
		update_lane(dt, lane, addnew)
	end
end

function check_collision()
	if AABB(player.x, player.y, player.w, player.h, bridge.x, bridge.y, bridge.w, bridge.h) then
		-- stop the player from falling off of the bridge
		if player.y < bridge.y then
			player.y = bridge.y
		elseif (player.y + player.h) > (bridge.y + bridge.h) then
			player.y = bridge.y + bridge.h - player.h
		end
	elseif AABB(player.x, player.y, player.w, player.h, river.x, river.y, river.w-50, river.h) then
	    -- the player has fallen into the river
	    reset_player_position(LEVEL)
	    if lives>0 then 
			lives = lives - 1
		else 
			love.window.showMessageBox("FAILURE", "You died! Watch the traffic in your next line", "info")
			lives = 5
			reset_player_position(LEVEL)
		end
	end


	if AABB(player.x, player.y, player.w, player.h, goal.x, goal.y, goal.w/2, goal.h/2) then
		-- the player has reached the goal
		love.window.showMessageBox("Succes", "You've reached the CL!", "info")		
		-- progress to the next level
		if LEVEL == 1 then
			LEVEL = 2
			levelLoaded = false
			lives = 5
		else
			love.window.showMessageBox("Succes", "You've have submitted your supervision!", "info")
		end
	end
	
	for i, lane in ipairs(lanes) do
		for j, thing in ipairs(lane.obstacles) do 
			if AABB(player.x, player.y, player.w, player.h, thing.x, thing.y, thing.w, thing.h) and invincible == false then
				hit_time = 0
				invincible = true
				if lives>0 then 
					lives = lives - 1
				else 
					love.window.showMessageBox("FAILURE", "You died! Watch the traffic in your next line", "info")
					lives = 5
					reset_player_position(LEVEL)
				end
			end
		end
	end


	for i, treeLine in ipairs(treeLines) do
		if AABB(player.x, player.y, player.w, player.h, treeLine.x, treeLine.y, treeLine.w, treeLine.h) then
			-- are we closer to the left or the right
			if player.x < treeLine.x + treeLine.w then
				-- closer to the right
				player.x = treeLine.x + treeLine.w
			elseif player.x > treeLine.x - player.w then
				-- closer to the left
				player.x = treeLine.x - player.w
			elseif player.y < treeLine.y + treeLine.h then
				-- closer to the bottom
				player.y = treeLine.y + treeLine.h
			elseif player.y + player.h > treeLine.y then
				-- closer to the top
				player.y = treeLine.y - player.h
			end
		end
	end


	invincible = hit_time<1

end


function love.draw()
	if LEVEL == 0 then
		love.graphics.setFont(fonts.huge)
		love.graphics.print("RETRO-BRIDGE", 100, SCREEN_HEIGHT/2 - 100)
		love.graphics.setFont(fonts.large)
		if math.cos(2*math.pi*love.timer.getTime())>0 then
			love.graphics.print("hit SPACE to start", 100, SCREEN_HEIGHT/2)
		end
	elseif levelLoaded then
		draw_background()
		draw_river()
		draw_treeLine()
		draw_player() 
		love.graphics.draw(images.goal, goal.x, goal.y)
		draw_lanes()

		love.graphics.setFont(fonts.large)
		love.graphics.print("LIVES: " .. lives, 10, 10)
	end
end

function draw_background()
	-- love.graphics.setColor(139, 181, 74)
	for x=0, SCREEN_WIDTH, images.background:getWidth() do
		for y=0, SCREEN_HEIGHT, images.background:getHeight() do
			love.graphics.draw(images.background, x, y)
		end
	end
	
	for x=laneSpacing*2, laneSpacing*3, 128 do
		for y=0, SCREEN_HEIGHT, 128 do
			love.graphics.draw(images.road, x, y)
		end
	end

	for x=laneSpacing*7, laneSpacing*9, 64 do
		for y=0, SCREEN_HEIGHT, 64 do
			love.graphics.draw(images.stone, x, y)
		end
	end 
end

function draw_player(level)
	local img = images.player_left
	if level == 1 then 
		img = images.player_left
	elseif level == 2 then
		img = images.player_right
	end
	if player.direction == "right" then
			img = images.player_right
	elseif player.direction == "left" then
			img = images.player_left
	end

	if hit_time > 1 or math.cos(2*math.pi*6*love.timer.getTime())>0 then
		love.graphics.draw(img, player.x, player.y)
	end
end

function draw_lanes()
	for i, lane in ipairs(lanes) do
		draw_lane(lane)
	end
end

function draw_river()
	for y=0, SCREEN_HEIGHT, images.tree:getHeight() do
		love.graphics.draw(images.water, laneSpacing*6, y)
	end
	love.graphics.setColor(150, 100, 50)
	love.graphics.rectangle("fill", bridge.x, bridge.y, 128, bridge.h)
	love.graphics.setColor(255, 255, 255)
end

function draw_treeLine()
	love.graphics.setColor(255, 255, 255)
	for y=0, SCREEN_HEIGHT/2, images.tree:getHeight() do
		love.graphics.draw(images.tree, laneSpacing*4, y)
	end
	love.graphics.draw(images.tree, laneSpacing*4, SCREEN_HEIGHT-128)
	love.graphics.setColor(255, 255, 255)
end
