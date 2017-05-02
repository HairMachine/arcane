function ritual_trigger_entity_create(gm as Gamestate, x as integer, y as integer) as integer
	dim eid as integer = gm.el.add("Ritual Switch", "ritual_switch")
	gm.cl.add(new TagComponent(eid, "RitualSwitchComponent"))
	gm.cl.add(new PositionComponent(eid, x, y, 1, "ritual_switch", 0, 0))
	return eid
end function

sub spell_cast(bk as BookComponent ptr, gm as Gamestate)
	dim posi as PositionComponent ptr = cast(PositionComponent ptr, gm.cl.entityComponent(bk->holder, "PositionComponent"))
	gm.ml.add(gm.el.entities(bk->holder).name + " marshalls the arcane forces...")
	essence_entity_create(gm, posi->x, posi->y, bk->spell)
end sub

sub SpellCastSystem(caster as integer, gm as Gamestate)
	dim matching as ComponentList = gm.cl.filter("BookComponent")
	dim spell_count as integer = 0
	cls
	print "Cast which spell?"
	for i as integer = 0 to matching.length - 1
		dim bk as BookComponent ptr = cast(BookComponent ptr, matching.components(i))
		if bk->holder = caster and bk->spell <> "" then
			print str(i + 1) + ") " + gm.el.entities(bk->entity_id).name
			spell_count += 1
		end if
	next
	if spell_count = 0 then 
		gm.ml.add("As yet, you know no spells.")
		exit sub
	end if
	dim a as integer
	input a
	if a - 1 < matching.length and a - 1 >= 0 then
		spell_cast(cast(BookComponent ptr, matching.components(a - 1)), gm)
	end if
end sub

sub RitualUseSystem(user as integer, gm as Gamestate)
	dim s as TagComponent ptr = cast(TagComponent ptr, gm.cl.filter("RitualSwitchComponent").components(0))
	'check we are on a switch
	dim switch_pos as PositionComponent ptr = cast(PositionComponent ptr, gm.cl.entityComponent(s->entity_id, "PositionComponent"))
	dim user_pos as PositionComponent ptr = cast(PositionComponent ptr, gm.cl.entityComponent(user, "PositionComponent"))
	if switch_pos->x = user_pos->x and switch_pos->y = user_pos->y then
		'open the player's spellbook
		SpellCastSystem(gm.playerId, gm)
	end if
end sub
