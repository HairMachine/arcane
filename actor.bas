type PositionComponent extends Component
	declare constructor(eid as integer, x as integer, y as integer, visible as integer, glyph as string)
	x as integer
	y as integer
	visible as integer
	glyph as string
end type

constructor PositionComponent(eid as integer, x as integer, y as integer, visible as integer, glyph as string)
	this.name = "PositionComponent"
	this.entity_id = eid
	this.x = x
	this.y = y
	this.visible = visible
	this.glyph = glyph
end constructor

/''
 ' Check collision. 0 = OK, 1 = collided
 '/
function collision_check(x as integer, y as integer, cl as ComponentList, map as MapData) as integer
	'check map first
	if map.get(x, y) = "#" then return 1
	'then check physical entites
	dim matching  as ComponentList = cl.filter("PositionComponent")
	for i as integer = 0 to matching.length - 1
		dim check as PositionComponent ptr = Cast(PositionComponent ptr, matching.components(i))
		if check->x = x and check->y = y then return 1
	next i
	return 0
end function

sub MoveEntitySystem(cl as ComponentList, map as MapData, eid as integer, direction as string)
	dim ecmps as ComponentList = cl.entityComponents(eid)
	dim matching as ComponentList = ecmps.filter("PositionComponent")
	dim moving as PositionComponent ptr = Cast(PositionComponent ptr, matching.components(0))
	if moving = 0 then exit sub
	select case direction
		case "north": if collision_check(moving->x, moving->y - 1, cl, map) <> 1 then moving->y -= 1
		case "northeast":
			if collision_check(moving->x + 1, moving->y - 1, cl, map) <> 1 then
				moving->y -= 1:	moving->x += 1
			end if
		case "east": if collision_check(moving->x + 1, moving->y, cl, map) <> 1 then moving->x += 1
		case "southeast": 
			if collision_check(moving->x + 1, moving->y + 1, cl, map) <> 1 then	
				moving->x += 1: moving->y += 1
			end if
		case "south": if collision_check(moving->x, moving->y + 1, cl, map) <> 1 then moving->y += 1
		case "southwest":
			if collision_check(moving->x - 1, moving->y + 1, cl, map) <> 1 then
				moving->y += 1: moving->x -= 1
			end if
		case "west": if collision_check(moving->x - 1, moving->y, cl, map) <> 1 then moving->x -= 1
		case "northwest":
			if collision_check(moving->x - 1, moving->y - 1, cl, map) <> 1 then
				moving->x -= 1: moving->y -= 1
			end if
	end select
end sub
