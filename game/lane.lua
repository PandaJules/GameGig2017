function update_lane(dt, lane, speed, lanex, addnew)

	-- create some new things
	if addnew then
		local thing = {}
		thing.w = 80
		thing.h = 100
		thing.x = lanex
		if speed > 0 then
			thing.y = 0
		else
			thing.y = love.graphics.getHeight()
		end
		table.insert(lane, thing)
	end
	
	-- move the existing things
	for i, thing in ipairs(lane) do
		thing.y = thing.y + (speed * dt)

		if thing.y < 0 then
			table.remove(lane, i)
		end
	end
end

function draw_lane(lane)
	for i, thing in ipairs(lane) do
		love.graphics.rectangle("fill", thing.x, thing.y, thing.w, thing.h)
	end
end