type PositionComponent extends Component
	declare constructor(eid as integer, x as integer, y as integer, visible as integer, glyph as string, solid as integer, liftable as integer)
	x as integer
	y as integer
	visible as integer
	glyph as string
	solid as integer
	liftable as integer
end type

constructor PositionComponent(eid as integer, x as integer, y as integer, visible as integer, glyph as string, solid as integer, liftable as integer)
	this.name = "PositionComponent"
	this.entity_id = eid
	this.x = x
	this.y = y
	this.visible = visible
	this.glyph = glyph
	this.solid = solid
	this.liftable = liftable
end constructor

type AttributeComponent extends Component
	hp as integer
	maxHp as integer
	sanity as integer
	maxSanity as integer
	strength as integer
	dexterity as integer
	wisdom as integer
	intelligence as integer
	charisma as integer
	declare constructor(eid as integer, hp as integer, sanity as integer, strength as integer, dexterity as integer, wisdom as integer, intelligence as integer, charisma as integer)
end type

constructor AttributeComponent(eid as integer, hp as integer, sanity as integer, strength as integer, dexterity as integer, wisdom as integer, intelligence as integer, charisma as integer)
	this.name = "AttributeComponent"
	this.entity_id = eid
	this.maxHp = hp
	this.hp = this.maxHp
	this.maxSanity = sanity
	this.sanity = this.maxSanity
	this.strength = strength
	this.dexterity = dexterity
	this.wisdom = wisdom
	this.intelligence = intelligence
	this.charisma = charisma
end constructor

type DoorComponent extends Component
	open as integer
	locked as integer
	declare constructor(eid as integer, o as integer, l as integer)
end type

constructor DoorComponent(eid as integer, o as integer, l as integer)
	this.name = "DoorComponent"
	this.entity_id = eid
	this.open = o
	this.locked = l
end constructor

sub CollisionResolutionSystem(gm as Gamestate, eid as integer)
	dim posi as PositionComponent ptr = cast(PositionComponent ptr, gm.cl.entityComponent(eid, "PositionComponent"))
	
	' door opening
	dim door as DoorComponent ptr = cast(DoorComponent ptr, gm.cl.entityComponent(eid, "DoorComponent"))
	if door <> 0 then 
		door->open = 1
		posi->glyph = "/"
		posi->solid = 0
		gm.ml.add("Opened door.")
		exit sub
	end if
	
	'fighting
	
	'other contextual actions as appropriate
end sub

/''
 ' Check collision
 ' return entity id, -1 for wall, -2 for none
 '/
function collision_check(x as integer, y as integer, gm as Gamestate, map as MapData) as integer
	'check map first
	if map.get(x, y) = "#" then return -1
	'then check physical entites
	dim matching  as ComponentList = gm.cl.filter("PositionComponent")
	for i as integer = 0 to matching.length - 1
		dim check as PositionComponent ptr = Cast(PositionComponent ptr, matching.components(i))
		if check->x = x and check->y = y and check->solid = 1 then 
			CollisionResolutionSystem(gm, check->entity_id)
			return check->entity_id
		end if
	next i
	return -2
end function

sub MoveEntitySystem(gm as Gamestate, map as MapData, eid as integer, direction as string)
	dim ecmps as ComponentList = gm.cl.entityComponents(eid)
	dim matching as ComponentList = ecmps.filter("PositionComponent")
	dim moving as PositionComponent ptr = Cast(PositionComponent ptr, matching.components(0))
	if moving = 0 then exit sub
	select case direction
		case "north": if collision_check(moving->x, moving->y - 1, gm, map) = -2 then moving->y -= 1
		case "northeast":
			if collision_check(moving->x + 1, moving->y - 1, gm, map) = -2 then
				moving->y -= 1:	moving->x += 1
			end if
		case "east": if collision_check(moving->x + 1, moving->y, gm, map) = -2 then moving->x += 1
		case "southeast": 
			if collision_check(moving->x + 1, moving->y + 1, gm, map) = -2 then	
				moving->x += 1: moving->y += 1
			end if
		case "south": if collision_check(moving->x, moving->y + 1, gm, map) = -2 then moving->y += 1
		case "southwest":
			if collision_check(moving->x - 1, moving->y + 1, gm, map) = -2 then
				moving->y += 1: moving->x -= 1
			end if
		case "west": if collision_check(moving->x - 1, moving->y, gm, map) = -2 then moving->x -= 1
		case "northwest":
			if collision_check(moving->x - 1, moving->y - 1, gm, map) = -2 then
				moving->x -= 1: moving->y -= 1
			end if
	end select
end sub
