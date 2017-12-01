require "collision"


function love.load()
	math.randomseed(os.time())

	player = {}
	player.x = 500
	player.y = 300
	player.w = 100
	player.h = 100

	coins = {}
	
	lives = 5

	sounds = {}
	sounds.coin = love.audio.newSource("assets/sounds/coin.ogg", "static")

	fonts = {}
	fonts.large = love.graphics.newFont("assets/fonts/Gamer.ttf", 80)


	images = {}
	images.background = love.graphics.newImage("assets/images/ground.png")
	--images.coin = love.graphics.newImage("assets/images/coin.png")
	images.player_down = love.graphics.newImage("assets/images/player_down.png")
	images.player_right = love.graphics.newImage("assets/images/player_right.png")
	images.player_left = love.graphics.newImage("assets/images/player_left.png")
	images.player_up = love.graphics.newImage("assets/images/player_up.png")


end


function love.update(dt)
	move_player(dt)
end

function move_player(dt)
	local SPEED = 500
	if love.keyboard.isDown("right") then 
		player.x = math.min(love.graphics.getWidth()-images.player_down:getWidth(), player.x + dt * SPEED)
		player.direction = "right"
	elseif love.keyboard.isDown("left") then
		player.x = math.max(0, player.x - dt * SPEED)
		player.direction = "left"
	elseif love.keyboard.isDown("up") then
		player.y = math.max(0, player.y - dt * SPEED)
		player.direction = "up"
	elseif love.keyboard.isDown("down") then
		player.y = math.min(love.graphics.getHeight()-images.player_down:getWidth(), player.y + dt * SPEED)
		player.direction = "down"
	end 


	-- for i=#coins, 1, -1 do
	-- 	local coin = coins[i]
	-- 	if AABB(player.x, player.y, player.w, player.h, coin.x, coin.y, coin.r) then
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


function love.draw()
	for x=0, love.graphics.getWidth(), images.background:getWidth() do
		for y=0, love.graphics.getHeight(), images.background:getHeight() do
			love.graphics.draw(images.background, x, y)
		end
	end

	love.graphics.setColor(255, 255, 0)
	-- for i=1, #coins, 1 do
	-- 	local coin = coins[i]
	-- 	love.graphics.circle("fill", coin.x, coin.y, coin.r)
	-- end
	local img = images.player_down
	if player.direction == "right" then
			img = images.player_right
	elseif player.direction == "up" then
			img = images.player_up
	elseif player.direction == "left" then
			img = images.player_left
	elseif player.direction == "down" then
			img = images.player_down
	else
			img = images.player_right
	end

	love.graphics.draw(img, player.x, player.y)
	love.graphics.setFont(fonts.large)
	love.graphics.print("LIVES: " .. lives, 10, 10) 

end