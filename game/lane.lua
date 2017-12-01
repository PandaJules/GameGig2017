function update_lane(dt, lane, addnew)

	-- create some new things
	if addnew then
		local thing = {}
		thing.w = 80
		thing.h = 100
		thing.x = lane.x
		if lane.speed > 0 then
			thing.y = 0
		else
			thing.y = love.graphics.getHeight()
		end
		table.insert(lane.obstacles, thing)
	end
	
	-- move the existing things
	for i, thing in ipairs(lane.obstacles) do
		thing.y = thing.y + (lane.speed * dt)

		if thing.y < 0 then
			table.remove(lane.obstacles, i)
		end
	end
end

function draw_lane(lane)
	for i, thing in ipairs(lane.obstacles) do
		love.graphics.rectangle("fill", thing.x, thing.y, thing.w, thing.h)
	end
end