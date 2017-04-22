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

type MessageLog
	dim messages(127) as string
	dim size as integer
	declare sub add(m as string)
	declare function get(index as integer) as string
end type

sub MessageLog.add(m as string)
	'todo: this currently a hard limit on messages
	if this.size > ubound(this.messages) then exit sub
	messages(this.size) = m
	this.size += 1
end sub

function MessageLog.get(index as integer) as string
	if index < 0 or index > this.size - 1 then return ""
	return this.messages(index)
end function
