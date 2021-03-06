function player_entity_create(gm as Gamestate) as integer
	dim eid as integer = gm.el.add("Player", "player")
	gm.cl.add(new ControllableComponent(eid))
	gm.cl.add(new PositionComponent(eid, 10, 10, 1, "@", 1, 0))
	gm.cl.add(new AttributeComponent(eid, 25, 25, d(6, 3), d(6, 3), d(6, 3), d(6, 3), d(6, 3)))
	return eid
end function

function thingum_entity_create(gm as Gamestate, x as integer, y as integer) as integer
	dim eid as integer = gm.el.add("A Strange Thingum", "thingum")
	gm.cl.add(new PositionComponent(eid, x, y, 1, "?", 0, 1))
	return eid
end function

function door_entity_create(gm as Gamestate, x as integer, y as integer) as integer
	dim eid as integer = gm.el.add("Wooden door", "wooden_door")
	gm.cl.add(new DoorComponent(eid, 0, 0))
	gm.cl.add(new PositionComponent(eid, x, y, 1, "+", 1, 0))
	return eid
end function

sub MapToEntitySystem(gm as Gamestate, map as Mapdata)
	for x as integer = 0 to 63
		for y as integer = 0 to 63
			if map.get(x, y) = "+" then
				door_entity_create(gm, x, y)
				map.set(x, y, ".")
			elseif map.get(x, y) = "?" then
				artefact_entity_create(gm, x, y)
				map.set(x, y, ".")
			elseif map.get(x, y) = "%" then
				essence_entity_create_random(gm, x, y)
				map.set(x, y, ".")
			elseif map.get(x, y) = "&" then
				book_entity_create(gm, x, y)
				map.set(x, y, ".")
			elseif map.get(x, y) = "I" then
				distiller_input_entity_create(gm, x, y)
				map.set(x, y, ".")
			elseif map.get(x, y) = "$" then
				distiller_output_entity_create(gm, x, y)
				map.set(x, y, ".")
			elseif map.get(x, y) = "|" then
				distiller_switch_entity_create(gm, x, y)
				map.set(x, y, ".")
			elseif map.get(x, y) = "R" then
				ritual_trigger_entity_create(gm, x, y)
				map.set(x, y, ".")
			end if
		next
	next
end sub
