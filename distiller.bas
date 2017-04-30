type DistillerComponent extends Component
	declare constructor(eid as integer, n as string)
end type

constructor DistillerComponent(eid as integer, n as string)
	this.entity_id = eid
	this.name = n
end constructor

function distiller_output_entity_create(gm as Gamestate, x as integer, y as integer) as integer
	dim out_eid as integer = gm.el.add("Distiller Output", "distilleroutput")
	gm.cl.add(new PositionComponent(out_eid, x, y, 1, "$", 0, 0))
	gm.cl.add(new DistillerComponent(out_eid, "DistillerOutputComponent"))
	return out_eid
end function

function distiller_input_entity_create(gm as Gamestate, x as integer, y as integer) as integer
	dim inp_eid as integer = gm.el.add("Distiller Input", "distillerinput")
	gm.cl.add(new PositionComponent(inp_eid, x, y, 1, "I", 0, 0))
	gm.cl.add(new DistillerComponent(inp_eid, "DistillerInputComponent"))
	return inp_eid
end function

function distiller_switch_entity_create(gm as Gamestate, x as integer, y as integer) as integer
	dim eid as integer = gm.el.add("Distiller Switch", "distillerswitch")
	gm.cl.add(new PositionComponent(eid, x, y, 1, "|", 0, 0))
	gm.cl.add(new DistillerComponent(eid, "DistillerSwitchComponent"))
	return eid
end function

sub DistillerUseSystem(user as integer, gm as Gamestate)
	dim s as DistillerComponent ptr = cast(DistillerComponent ptr, gm.cl.filter("DistillerSwitchComponent").components(0))
	'check we are on a switch
	dim switch_pos as PositionComponent ptr = cast(PositionComponent ptr, gm.cl.entityComponent(s->entity_id, "PositionComponent"))
	dim user_pos as PositionComponent ptr = cast(PositionComponent ptr, gm.cl.entityComponent(user, "PositionComponent"))
	if switch_pos->x = user_pos->x and switch_pos->y = user_pos->y then
		'get the stuff on the input box, if anything
		dim in as DistillerComponent ptr = cast(DistillerComponent ptr, gm.cl.filter("DistillerInputComponent").components(0))
		dim in_p as PositionComponent ptr = cast(PositionComponent ptr, gm.cl.entityComponent(in->entity_id, "PositionComponent"))
		dim essences as ComponentList = gm.cl.filter("EssenceComponent")
		dim combined(1) as EssenceComponent ptr
		dim in_count as integer
		for i as integer = 0 to essences.length - 1
			dim es_p as PositionComponent ptr = cast(PositionComponent ptr, gm.cl.entityComponent(essences.components(i)->entity_id, "PositionComponent"))
			if es_p->x = in_p->x and es_p->y = in_p->y then
				if in_count > 1 then
					gm.ml.add("You hear a strange strangled noise, but nothing else happens.")
					exit sub
				else
					combined(in_count) = cast(EssenceComponent ptr, essences.components(i))
					in_count += 1
				end if
			end if
		next
		if in_count = 2 then
			gm.ml.add("With a strange whooshing noise, the essences are consumed!")
			for i as integer = 0 to ubound(combined)
				dim es_p as PositionComponent ptr = cast(PositionComponent ptr, gm.cl.entityComponent(combined(i)->entity_id, "PositionComponent"))
				es_p->visible = 0
				es_p->x = -5
				es_p->y = -5
			next
			'create an elixir
			dim o as DistillerComponent ptr = cast(DistillerComponent ptr, gm.cl.filter("DistillerOutputComponent").components(0))
			dim o_p as PositionComponent ptr = cast(PositionComponent ptr, gm.cl.entityComponent(o->entity_id, "PositionComponent"))
			elixir_entity_create(gm, o_p->x, o_p->y)
		else
			gm.ml.add("You hear a strange whistling noise, but nothing else happens.")
		end if
	end if
end sub
