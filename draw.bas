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
		if this_comp->visible = 1 then
			tile_draw_from_char(this_comp->x - cam.x, this_comp->y - cam.y, this_comp->glyph, ts)
		end if
	next
end sub
