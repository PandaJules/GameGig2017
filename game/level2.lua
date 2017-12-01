function level2_load_images()
	images = {}
	images.background = love.graphics.newImage("assets/images/ground.png")
	images.goal = love.graphics.newImage("assets/images/CL.png")
	images.background = love.graphics.newImage("assets/images/brown_ground.png")
	images.road = love.graphics.newImage("assets/images/road.png")
	images.player_right = love.graphics.newImage("assets/images/bikeman_right.png")
	images.player_left = love.graphics.newImage("assets/images/bikeman_left.png")
	images.marcelo = love.graphics.newImage("assets/images/marcelo.png")
	images.john = love.graphics.newImage("assets/images/john.png")
	images.larry = love.graphics.newImage("assets/images/larry.png")
	images.harle = love.graphics.newImage("assets/images/harle.png")
	images.andrew = love.graphics.newImage("assets/images/andrew.png")
	images.tree = love.graphics.newImage("assets/images/trees.png")

	return images
end

function level2_load_lanes()
	lane1 = {timerMax = 5, timer = 0, speed = -300, x = laneSpacing, image = images.andrew}
	lane1.obstacles = {}
	lane2 = {timerMax = 6, timer = 0, speed = 300, x = laneSpacing*2, image = images.harle}
	lane2.obstacles = {}
	lane3 = {timerMax = 4, timer = 0, speed = -100, x = laneSpacing*4, image = images.larry}
	lane3.obstacles = {}
	lane4 = {timerMax = 5, timer = 0, speed = 100, x = laneSpacing*6, image = images.john}
	lane4.obstacles = {}
	lane5 = {timerMax = 4, timer = 0, speed = -75, x = laneSpacing*7, image = images.marcelo}
	lane5.obstacles = {}
	lanes = {lane1, lane2, lane3, lane4, lane5}

	return lanes
end