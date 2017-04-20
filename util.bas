type IntPair
	one as integer
	two as integer
end type

function d(sides as integer, num as integer) as integer
	dim roll as integer = 0
	for i as integer = 1 to num
		roll += rnd() * (sides - 1) + 1
	next
	return roll
end function
