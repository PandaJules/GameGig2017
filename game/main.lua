require "collision"
require "lane"

-- GLOBALS --

SCREEN_WIDTH = love.graphics.getWidth()
SCREEN_HEIGHT = love.graphics.getHeight()
laneSpacing = love.graphics.getWidth()/9


function love.load()
	math.randomseed(os.time())

	player = {x = SCREEN_WIDTH - 150, y = SCREEN_HEIGHT/2 - 64, w = 128, h = 128}
	
	goal = {x = 10, y = SCREEN_HEIGHT/2, w = 60, h = 60}
	lives = 5

	sounds = {}
	sounds.coin = love.audio.newSource("assets/sounds/coin.ogg", "static")

	fonts = {}
	fonts.large = love.graphics.newFont("assets/fonts/Gamer.ttf", 80)


	images = {}
	images.background = love.graphics.newImage("assets/images/ground.png")
	images.goal = love.graphics.newImage("assets/images/CL.png")
	images.player_right = love.graphics.newImage("assets/images/bikeman_right.png")
	images.player_left = love.graphics.newImage("assets/images/bikeman_left.png")
	images.tourist = love.graphics.newImage("assets/images/tourist.png")
	images.duck = love.graphics.newImage("assets/images/duck.png")
	images.cow = love.graphics.newImage("assets/images/cow_down.png")
	images.car = love.graphics.newImage("assets/images/car_up.png")
	images.truck = love.graphics.newImage("assets/images/truck_down.png")

	-- empty lanes
	lane1 = {timerMax = 2, timer = 0, speed = 300, x = laneSpacing, image = images.truck}
	lane1.obstacles = {}
	lane2 = {timerMax = 3, timer = 0, speed = -300, x = laneSpacing*2, image = images.car}
	lane2.obstacles = {}
	lane3 = {timerMax = 4, timer = 0, speed = 100, x = laneSpacing*4, image = images.cow}
	lane3.obstacles = {}
	lane4 = {timerMax = 5, timer = 0, speed = -50, x = laneSpacing*6, image = images.duck}
	lane4.obstacles = {}
	lane5 = {timerMax = 4, timer = 0, speed = 75, x = laneSpacing*7, image = images.tourist}
	lane5.obstacles = {}
	lanes = {lane1, lane2, lane3, lane4, lane5}

	-- river properties
	river = { w = 100, h = SCREEN_HEIGHT, y = 0, x = laneSpacing*5}

	-- bridge properties
	bridge = { w = 100, h = 150, y = SCREEN_HEIGHT/4, x = laneSpacing*5}

	-- treeLine properties
	treeLine1 = { w = 100, h = 3*SCREEN_HEIGHT/4 - 100, y = 0, x = laneSpacing*3}
	treeLine2 = { w = 100, h = SCREEN_HEIGHT/4 , y = 3*SCREEN_HEIGHT/4 + 100, x = laneSpacing*3}
	treeLines = {treeLine1, treeLine2}
end


function love.update(dt)
	move_player(dt)
	update_lanes(dt)
	collide_river(dt)
	collide_treeLine(dt)
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


	if AABB(player.x, player.y, player.w, player.h, goal.x, goal.y, goal.w/2, goal.h/2) then
		love.window.showMessageBox("Succes", "You've reached the goal!", "info")
		reset_player_position()
	end


	

end

function reset_player_position()
	player.x = SCREEN_WIDTH - 150
	player.y = SCREEN_HEIGHT/2 - 64
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

function collide_river(dt)
	if AABB(player.x, player.y, player.w, player.h, bridge.x, bridge.y, bridge.w, bridge.h) then
		-- stop the player from falling off of the bridge
		if player.y < bridge.y then
			player.y = bridge.y
		elseif (player.y + player.h) > (bridge.y + bridge.h) then
			player.y = bridge.y + bridge.h - player.h
		end
	elseif AABB(player.x, player.y, player.w, player.h, river.x, river.y, river.w, river.h) then
	    -- the player has fallen into the river
	    reset_player_position()
	end
end

function collide_treeLine(dt)
	for i, treeLine in ipairs(treeLines) do
		if AABB(player.x, player.y, player.w, player.h, treeLine.x, treeLine.y, treeLine.w, treeLine.h) then
			-- are we closer to the left or the right
			local xdifference = (treeLine.x + treeLine.w) - player.x
			debug = xdifference
			if xdifference < 20 then
				-- closer to the right
				player.x = treeLine.x + treeLine.w
			elseif xdifference > 150 then
				-- closer to the left
				player.x = treeLine.x - player.w
			end

			local ydifference = player.y - (treeLine.y + treeLine.h)
			debug = ydifference
			if ydifference > -30 then
				-- closer to the bottom
				player.y = treeLine.y + treeLine.h
			elseif ydifference < -260 then
				-- closer to the top
				player.y = treeLine.y - player.h
			end
		end
	end
end

function love.draw()
	draw_background()
	draw_river()
	draw_treeLine()
	draw_player() 
	love.graphics.draw(images.goal, goal.x, goal.y)
	draw_lanes()

	love.graphics.setFont(fonts.large)
	love.graphics.print("LIVES: " .. lives, 10, 10)
	-- love.graphics.print("DEBUG: " .. debug, 10, 30)
end

function draw_background()
	for x=0, SCREEN_WIDTH, images.background:getWidth() do
		for y=0, SCREEN_HEIGHT, images.background:getHeight() do
			love.graphics.draw(images.background, x, y)
		end
	end
end

function draw_player()
	local img = images.player_down
	if player.direction == "right" then
			img = images.player_right
	elseif player.direction == "left" then
			img = images.player_left
	else
			img = images.player_left
	end

	love.graphics.draw(img, player.x, player.y)
end

function draw_lanes()
	for i, lane in ipairs(lanes) do
		draw_lane(lane)
	end
end

function draw_river()
	love.graphics.setColor(30, 120, 180)
	love.graphics.rectangle("fill", river.x, river.y, river.w, river.h)
	love.graphics.setColor(150, 100, 50)
	love.graphics.rectangle("fill", bridge.x, bridge.y, bridge.w, bridge.h)
	love.graphics.setColor(255, 255, 255)
end

function draw_treeLine()
	love.graphics.setColor(0, 100, 0)
	love.graphics.rectangle("fill", treeLine1.x, treeLine1.y, treeLine1.w, treeLine1.h)
	love.graphics.rectangle("fill", treeLine2.x, treeLine2.y, treeLine2.w, treeLine2.h)
	love.graphics.setColor(255, 255, 255)
end