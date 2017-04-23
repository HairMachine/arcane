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

function artefact_entity_create(gm as Gamestate, x as integer, y as integer) as integer
	dim ki as integer = rnd() * 8
	dim rname as string
	dim glyph as string
	dim eid as integer
	'choose cosmetic information
	select case ki
		case 0:
			rname = "something rod"
			eid = gm.el.add(rname, "rod")
			glyph = "rod"
		case 1:
			rname = "scroll labelled something"
			eid = gm.el.add(rname, "scroll")
			glyph = "scroll"
		case 2:
			rname = "something gem"
			eid = gm.el.add(rname, "gem")
			glyph = "gem"
		case 3:
			rname = "something ring"
			eid = gm.el.add(rname, "ring")
			glyph = "ring"
		case 4:
			rname = "something amulet"
			eid = gm.el.add(rname, "amulet")
			glyph = "amulet"
		case 5:
			rname = "something instrument"
			eid = gm.el.add(rname, "instrument")
			glyph = "instrument"
		case 6:
			rname = "something lamp"
			eid = gm.el.add(rname, "lamp")
			glyph = "lamp"
		case 7:
			rname = "something dagger"
			eid = gm.el.add(rname, "dagger")
			glyph = "dagger"
		case 8:
			rname = "something mirror"
			eid = gm.el.add(rname, "mirror")
			glyph = "mirror"
	end select
	dim display_name as string
	dim good_effect as string
	dim bad_effect as string
	dim stat_name as string
	dim stat_thresh as integer
	'choose the display name, good effect and stat threshold of the item
	dim effect as integer = rnd() * 26
	select case effect
		case else: 
			display_name = "Triumph"
			good_effect = "triumph"
			stat_thresh = rnd() * 25
	end select
	'choose the bad effect of the item
	effect = rnd() * 26
	select case effect
		case 0: bad_effect = "suicide"
		case else: bad_effect = "suicide"
	end select
	'choose the stat of the item
	dim stat as integer = rnd() * 4
	select case stat
		case 0: stat_name = "strength"
		case 1: stat_name = "dexterity"
		case 2: stat_name = "intelligence"
		case 3: stat_name = "wisdom"
		case 4: stat_name = "charisma"
	end select
	'create and drop the artefact
	gm.cl.add(new ArtefactEffectComponent(eid, display_name, good_effect, bad_effect, stat_name, stat_thresh))
	cls
	print "Artefact created:"
	print rname + " of " + display_name
	print good_effect
	print bad_effect
	print stat_name + " >= " + str(stat_thresh)
	getkey
	gm.cl.add(new PositionComponent(eid, x, y, 1, glyph, 0, 1))
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
			end if
		next
	next
end sub
