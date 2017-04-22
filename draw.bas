type CameraClass
	x as integer
	y as integer
	w as integer
	h as integer
	following as PositionComponent ptr
	declare sub lockToEntity(eid as integer, cl as ComponentList)
	declare sub followLockedEntity()
end type

sub CameraClass.lockToEntity(eid as integer, cl as ComponentList)
	dim matching as ComponentList = cl.entityComponents(eid).filter("PositionComponent")
	this.following = Cast(PositionComponent ptr, matching.components(0))
end sub

sub CameraClass.followLockedEntity()
	this.x = this.following->x - this.w / 2
	this.y = this.following->y - this.h / 2
end sub

sub tile_draw_from_char(x as integer, y as integer, c as string, ts as Tileset)
	dim map_res as IntPair = ts.tileMap.map(c)
	dim tx_start as integer = map_res.one * ts.tsize
	dim tx_end as integer = tx_start + ts.tsize - 1
	dim ty_start as integer = map_res.two * ts.tsize
	dim ty_end as integer = ty_start + ts.tsize - 1
	put(x * ts.tsize, y * ts.tsize), ts.sheet, (tx_start, ty_start)-(tx_end, ty_end), trans
end sub

sub MapDrawSystem(map as MapData, ts as Tileset, cam as CameraClass)
	for x as integer = 0 to cam.w
		for y as integer = 0 to cam.h
			tile_draw_from_char(x, y, map.get(x + cam.x, y + cam.y), ts)
		next
	next
end sub

sub EntityDrawSystem(cl as ComponentList, ts as Tileset, cam as CameraClass)
	dim matching as ComponentList = cl.filter("PositionComponent")
	for i as integer = 0 to matching.length - 1
		dim this_comp as PositionComponent ptr = Cast(PositionComponent ptr, matching.components(i))
		if this_comp->visible = 1 and this_comp->x - cam.x <= cam.w and this_comp->y - cam.y <= cam.h then
			tile_draw_from_char(this_comp->x - cam.x, this_comp->y - cam.y, this_comp->glyph, ts)
		end if
	next
end sub

sub AttributeDisplaySystem(cl as ComponentList, eid as integer)
	dim matched as ComponentList = cl.entityComponents(eid).filter("AttributeComponent")
	dim values as AttributeComponent ptr = cast(AttributeComponent ptr, matched.components(0))
	locate 1, 50: print "HP: " + str(values->hp) + "/" + str(values->maxHp)
	locate 2, 50: print "Sanity: " + str(values->sanity) + "/" + str(values->maxSanity)
	locate 4, 50: print "Strength: " + str(values->strength)
	locate 5, 50: print "Dexterity: " + str(values->dexterity)
	locate 6, 50: print "Wisdom: " + str(values->wisdom)
	locate 7, 50: print "Intelligence: " + str(values->intelligence)
	locate 8, 50: print "Charisma: " + str(values->charisma)
end sub

sub MessageDisplaySystem(ml as MessageLog)
	locate 10, 50: print "Messages:"
	dim p as integer = 0
	for i as integer = ml.size to ml.size - 10 step -1
		locate 10 + p, 50: print ml.get(i)
		p += 1
	next
end sub
