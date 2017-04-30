type IntPair
	one as integer
	two as integer
end type

type StringToStringMap
	key(127) as string
	value(127) as string
	length as integer
	declare function get(key as string) as string
	declare sub set(key as string, value as string)
end type

function StringToStringMap.get(key as string) as string
	for i as integer = 0 to this.length - 1
		if this.key(i) = key then return this.value(i)
	next
	return ""
end function

sub StringToStringMap.set(key as string, value as string)
	for i as integer = 0 to this.length - 1
		if this.key(i) = key then 
			this.value(i) = value
			exit sub
		end if
	next
	'the key does not exist; we try to add it
	if this.length > ubound(this.key) then exit sub
	this.key(this.length) = key
	this.value(this.length) = value
	this.length += 1
end sub

type StringList
	items(127) as string
	length as integer
	declare sub add(s as string)
	declare sub remove(s as string)
end type

sub StringList.add(s as string)
	if this.length > ubound(this.items) then exit sub
	this.items(this.length) = s
	this.length += 1
end sub

sub StringList.remove(s as string)
	dim collapse as integer = 0
	for i as integer = 0 to this.length - 1
		if collapse = 1 then this.items(i - 1) = this.items(i)
		if this.items(i) = s then collapse = 1
	next
	this.items(this.length - 1) = ""
	this.length -= 1
end sub

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
