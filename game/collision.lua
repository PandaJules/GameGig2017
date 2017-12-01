function AABB(x1, y1, w1, h1, x2, y2, r2)
	return  x1 < x2 + 2 * r2 and
			x1 + w1 > x2 and
			y1 < y2 + 2 * r2 and 
			y1 + h1 > y2
end