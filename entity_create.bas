function player_entity_create(el as EntityList, cl as ComponentList) as integer
	dim eid as integer = el.add("Player", "player")
	cl.add(new ControllableComponent(eid))
	cl.add(new PositionComponent(eid, 10, 10, 1, "@", 1))
	cl.add(new AttributeComponent(eid, 25, 25, d(6, 3), d(6, 3), d(6, 3), d(6, 3), d(6, 3)))
	return eid
end function

function thingum_entity_create(el as EntityList, cl as ComponentList) as integer
	dim eid as integer = el.add("A Strange Thingum", "thingum")
	return eid
end function

function door_entity_create(el as EntityList, cl as ComponentList, x as integer, y as integer) as integer
	dim eid as integer = el.add("Wooden door", "wooden_door")
	cl.add(new DoorComponent(eid, 0, 0))
	cl.add(new PositionComponent(eid, x, y, 1, "+", 1))
	return eid
end function

sub MapToEntitySystem(el as EntityList, cl as ComponentList, map as Mapdata)
	for x as integer = 0 to 63
		for y as integer = 0 to 63
			if map.get(x, y) = "+" then
				door_entity_create(el, cl, x, y)
				map.set(x, y, ".")
			end if
		next
	next
end sub
