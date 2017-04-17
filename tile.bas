type TileMap
	dim mapInt(127) as IntPair
	dim mapStr(127) as string
	declare function map(s as string) as IntPair
	declare sub insert(s as string, x as integer, y as integer)
end type

function TileMap.map(s as string) as IntPair
	dim ip as IntPair
	for i as integer = 0 to ubound(this.mapStr(i))
		if s = this.mapStr(i) then
			ip = this.mapInt(i)
			return ip
		end if
	next
	return ip
end function

sub TileMap.insert(s as string, x as integer, y as integer)
	for i as integer = 0 to ubound(this.mapStr(i))
		if this.mapStr(i) = "" then
			dim ip as IntPair
			ip.one = x
			ip.two = y
			this.mapStr(i) = s
			this.mapInt(i) = ip
			exit sub
		end if
	next
end sub

type Tileset
	sheet as any ptr
	tsize as integer = 32
	sizex as integer = 9
	sizey as integer = 10
	tileMap as TileMap
	declare sub loadFromFile(filename as string)
	declare destructor
end type

sub Tileset.loadFromFile(filename as string)
	this.sheet = imagecreate(this.sizex * this.tsize, this.sizey * this.tsize)
	bload filename + ".bmp", this.sheet
end sub

destructor Tileset
	imagedestroy(sheet)
end destructor
