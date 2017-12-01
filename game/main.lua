require "collision"


function love.load()
	math.randomseed(os.time())

	player = {}
	player.x = 500
	player.y = 300
	player.w = 100
	player.h = 100

	coins = {}
	
	score = 0

	sounds = {}
	sounds.coin = love.audio.newSource("assets/sounds/coin.ogg", "static")

	fonts = {}
	fonts.large = love.graphics.newFont("assets/fonts/Gamer.ttf", 50)


	images = {}
	images.background = love.graphics.newImage("assets/images/ground.png")
	images.coin = love.graphics.newImage("assets/images/coin.png")
	images.player_down = love.graphics.newImage("assets/images/player_down.png")
	images.left = love.graphics.newImage("assets/images/player_left.png")

end

SPEED = 500

function love.update(dt)
	if love.keyboard.isDown("right") then 
		player.x = player.x + 10
		player.direction = "right"
	elseif love.keyboard.isDown("left") then
		player.x = player.x - 10
	elseif love.keyboard.isDown("up") then
		player.y = player.y - dt * SPEED
	elseif love.keyboard.isDown("down") then
		player.y = player.y + dt * SPEED
		player.direction = "down"
	end 


	for i=#coins, 1, -1 do
		local coin = coins[i]
		if AABB(player.x, player.y, player.w, player.h, coin.x, coin.y, coin.r) then
			table.remove(coins, i)
			score = score +1 
			sounds.coin:play()
		end
	end


	if math.random()<0.02 then
		local coin
		coin = {}
		coin.r = 25
		coin.x = math.random(0, 800-2 * coin.r)
		coin.y = math.random(0, 600-2 * coin.r)
		table.insert(coins, coin)
	end	

end


function love.draw()
	for x=0, love.graphics.getWidth(), images.background:getWidth() do
		for y=0, love.graphics.getHeight(), images.background:getHeight() do
			love.graphics.draw(images.background, x, y)
		end
	end

	love.graphics.setColor(255, 255, 0)
	for i=1, #coins, 1 do
		local coin = coins[i]
		love.graphics.circle("fill", coin.x, coin.y, coin.r)
	end

	love.graphics.draw(images.player_down, player.x, player.y)
	love.graphics.setFont(fonts.large)
	love.graphics.print("SCORE: " .. score, 10, 10) 

end
