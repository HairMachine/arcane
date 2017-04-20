type MapData
	sizex as integer = 0
	sizey as integer = 0
	grid(63, 63) as string * 1
	declare sub inputLine(dat as string)
	declare sub loadFromFile(filename as string)
	declare function get(x as integer, y as integer) as string
	declare sub set(x as integer, y as integer, c as string)
end type

sub MapData.inputLine(dat as string)
	for x as integer = 0 to len(dat)
		this.grid(x, this.sizey) = mid(dat, x, 1)
	next
	this.sizey += 1
	if this.sizex < len(dat) then this.sizex = len(dat)
end sub

sub MapData.loadFromFile(filename as string)
	dim handle as integer
	dim line_in as string
	handle = freefile()
	open filename + ".map" for input as #handle
	while not eof(handle)
		input #handle, line_in
		this.inputLine(line_in)
	wend
end sub

function MapData.get(x as integer, y as integer) as string
	if x > 63 or y > 63 or x < 0 or y < 0 then return "#"
	return this.grid(x, y)
end function

sub MapData.set(x as integer, y as integer, c as string) 
	if x > 63 or y > 63 or x < 0 or y < 0 then exit sub
	this.grid(x, y) = c
end sub
