SCREEN_WIDTH = love.graphics.getWidth()
SCREEN_HEIGHT = love.graphics.getHeight()

function level3_load_images()
	images = {}
	images.background = love.graphics.newImage("assets/images/ground.png")
	images.goal = love.graphics.newImage("assets/images/doors.png")
	images.background = love.graphics.newImage("assets/images/stone.png")
	images.road = love.graphics.newImage("assets/images/road.png")
	images.player_right = love.graphics.newImage("assets/images/bikeman_debiked_right.png")
	images.player_left = love.graphics.newImage("assets/images/bikeman_debiked_left.png")
	images.marcelo = love.graphics.newImage("assets/images/marcelo.png")
	images.john = love.graphics.newImage("assets/images/john.png")
	images.larry = love.graphics.newImage("assets/images/larry.png")
	images.harle = love.graphics.newImage("assets/images/harle.png")
	images.andrew = love.graphics.newImage("assets/images/andrew.png")
	images.tree = love.graphics.newImage("assets/images/trees.png")
	images.stone = love.graphics.newImage("assets/images/stone.png")
	images.water = love.graphics.newImage("assets/images/tables.png")

	return images
end

function level3_load_lanes()
	lane1 = {timerMax = 5, timer = 0, speed = -250, x = laneSpacing*2, image = images.andrew}
	lane1.obstacles = {}
	lane2 = {timerMax = 6, timer = 0, speed = 250, x = laneSpacing*3, image = images.harle}
	lane2.obstacles = {}
	lane3 = {timerMax = 6, timer = 0, speed = 50, x = laneSpacing*5, image = images.larry}
	lane3.obstacles = {}
	lane4 = {timerMax = 5, timer = 0, speed = 70, x = laneSpacing*7, image = images.john}
	lane4.obstacles = {}
	lane5 = {timerMax = 4, timer = 0, speed = -80, x = laneSpacing*8, image = images.marcelo}
	lane5.obstacles = {}
	lanes = {lane1, lane2, lane3, lane4, lane5}

	return lanes
end

function level3_load_player_goal()
	player = {x = SCREEN_WIDTH - 150, y = SCREEN_HEIGHT/2 - 64, w = 100, h = 100}
	goal = {x = 10, y = SCREEN_HEIGHT/2-100, w = 40, h = 40}
end