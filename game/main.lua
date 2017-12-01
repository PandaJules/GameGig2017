require "collision"
require "lane"

-- GLOBALS --

SCREEN_WIDTH = love.graphics.getWidth()
SCREEN_HEIGHT = love.graphics.getHeight()

-- Properties for each lane
laneSpacing = love.graphics.getWidth()/8

lane1TimerMax = 2
lane1Timer = lane1TimerMax
lane1Speed = 300
lane1X = laneSpacing

lane2TimerMax = 3
lane2Timer = lane2TimerMax
lane2Speed = -300
lane2X = laneSpacing*2

lane3TimerMax = 4
lane3Timer = lane3TimerMax
lane3Speed = 100
lane3X = laneSpacing*3

lane4TimerMax = 5
lane4Timer = lane4TimerMax
lane4Speed = -50
lane4X = laneSpacing*5

lane5TimerMax = 4
lane5Timer = lane5TimerMax
lane5Speed = 75
lane5X = laneSpacing*6

function love.load()
	math.randomseed(os.time())

	player = {}
	player.x = SCREEN_WIDTH - 150
	player.y = SCREEN_HEIGHT/2 - 64
	player.w = 128
	player.h = 128

	coins = {}
	
	goal = {}
	goal.x = 50
	goal.y = SCREEN_HEIGHT/2
	lives = 5

	sounds = {}
	sounds.coin = love.audio.newSource("assets/sounds/coin.ogg", "static")

	fonts = {}
	fonts.large = love.graphics.newFont("assets/fonts/Gamer.ttf", 80)


	images = {}
	images.background = love.graphics.newImage("assets/images/ground.png")
	images.goal = love.graphics.newImage("assets/images/coin.png")
	images.player_right = love.graphics.newImage("assets/images/bikeman_right.png")
	images.player_left = love.graphics.newImage("assets/images/bikeman_left.png")

	-- empty lanes
	lane1 = {}
	lane2 = {}
	lane3 = {}
	lane4 = {}
	lane5 = {}

	-- river properties
	river1 = { w = 80, h = SCREEN_HEIGHT/4, y = 0, x = laneSpacing*4}
	river2 = { w = 80, h = 3*SCREEN_HEIGHT/4, y = SCREEN_HEIGHT/4 + 128, x = laneSpacing*4}
end


function love.update(dt)
	move_player(dt)
	update_lanes(dt)
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


	-- if AABB(player.x, player.y, player.w, player.h, coin.x, coin.y, ) then
	-- 		table.remove(coins, i)
	-- 		score = score +1 
	-- 		sounds.coin:play()
	-- 	end
	-- end


	-- if math.random()<0.02 then
	-- 	local coin
	-- 	coin = {}
	-- 	coin.r = 25
	-- 	coin.x = math.random(0, 800-2 * coin.r)
	-- 	coin.y = math.random(0, 600-2 * coin.r)
	-- 	table.insert(coins, coin)
	-- end	
end

function update_lanes(dt)
	lane1Timer = lane1Timer - (1*dt)
	lane2Timer = lane2Timer - (1*dt)
	lane3Timer = lane3Timer - (1*dt)
	lane4Timer = lane4Timer - (1*dt)
	lane5Timer = lane5Timer - (1*dt)

	addnew = false
	if lane1Timer < 0 then
		addnew = true
		lane1Timer = lane1TimerMax
	end
	update_lane(dt, lane1, lane1Speed, lane1X, addnew)

	addnew = false
	if lane2Timer < 0 then
		addnew = true
		lane2Timer = lane2TimerMax
	end
	update_lane(dt, lane2, lane2Speed, lane2X, addnew)

	addnew = false
	if lane3Timer < 0 then
		addnew = true
		lane3Timer = lane3TimerMax
	end
	update_lane(dt, lane3, lane3Speed, lane3X, addnew)

	addnew = false
	if lane4Timer < 0 then
		addnew = true
		lane4Timer = lane4TimerMax
	end
	update_lane(dt, lane4, lane4Speed, lane4X, addnew)

	addnew = false
	if lane5Timer < 0 then
		addnew = true
		lane5Timer = lane5TimerMax
	end
	update_lane(dt, lane5, lane5Speed, lane5X, addnew)
end

function love.draw()
	draw_background()
	draw_player() 
	love.graphics.draw(images.goal, goal.x, goal.y)
	draw_lanes()
	draw_river()

	love.graphics.setFont(fonts.large)
	love.graphics.print("LIVES: " .. lives, 10, 10)
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
	draw_lane(lane1)
	draw_lane(lane2)
	draw_lane(lane3)
	draw_lane(lane4)
	draw_lane(lane5)
end

function draw_river()
	love.graphics.setColor(30, 120, 180)
	love.graphics.rectangle("fill", river1.x, river1.y, river1.w, river1.h)
	love.graphics.rectangle("fill", river2.x, river2.y, river2.w, river2.h)
end