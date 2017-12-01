SCREEN_WIDTH = love.graphics.getWidth()
SCREEN_HEIGHT = love.graphics.getHeight()

function level4_load_images()
	images = {}
	images.background = love.graphics.newImage("assets/images/ground.png")
	images.goal = love.graphics.newImage("assets/images/bed.png")
	images.background = love.graphics.newImage("assets/images/green_ground.png")
	images.road = love.graphics.newImage("assets/images/road.png")
	images.player_right = love.graphics.newImage("assets/images/bikeman_light_right.png")
	images.player_left = love.graphics.newImage("assets/images/bikeman_light_left.png")
	images.tourist = love.graphics.newImage("assets/images/tourist.png")
	images.duck = love.graphics.newImage("assets/images/duck.png")
	images.cow = love.graphics.newImage("assets/images/cow_up.png")
	images.car = love.graphics.newImage("assets/images/car_down.png")
	images.truck = love.graphics.newImage("assets/images/truck_up.png")
	images.tree = love.graphics.newImage("assets/images/trees.png")
	images.stone = love.graphics.newImage("assets/images/stone.png")
	images.water = love.graphics.newImage("assets/images/water.png")

	return images
end

function level4_load_lanes()
	lane1 = {timerMax = 2, timer = 0, speed = -300, x = laneSpacing*2, image = images.truck}
	lane1.obstacles = {}
	lane2 = {timerMax = 3, timer = 0, speed = 300, x = laneSpacing*3, image = images.car}
	lane2.obstacles = {}
	lane3 = {timerMax = 4, timer = 0, speed = -100, x = laneSpacing*5, image = images.cow}
	lane3.obstacles = {}
	lane4 = {timerMax = 5, timer = 0, speed = -50, x = laneSpacing*7, image = images.duck}
	lane4.obstacles = {}
	lane5 = {timerMax = 4, timer = 0, speed = 75, x = laneSpacing*8, image = images.tourist}
	lane5.obstacles = {}
	lanes = {lane1, lane2, lane3, lane4, lane5}

	return lanes
end

function level4_load_player_goal()
	player = {x = 10, y = SCREEN_HEIGHT/2-64, w = 100, h = 100}
	goal = {x = SCREEN_WIDTH - 150, y = SCREEN_HEIGHT/2 - 100, w = 50, h = 50}
end
