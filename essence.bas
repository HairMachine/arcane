type EssenceComponent extends Component
	effect as string
	declare constructor(eid as integer, effect as string)
end type

constructor EssenceComponent(eid as integer, effect as string)
	this.entity_id = eid
	this.name = "EssenceComponent"
	this.effect = effect
end constructor

function essence_entity_create(gm as Gamestate, x as integer, y as integer, spell as string) as integer
	dim eid as integer = gm.el.add("essence", "essence")
	gm.cl.add(new PositionComponent(eid, x, y, 1, "essence", 0, 1))
	gm.cl.add(new EssenceComponent(eid, spell))
	return eid
end function

function essence_entity_create_random(gm as Gamestate, x as integer, y as integer) as integer
	return essence_entity_create(gm, x, y, "drain_strength")
end function
