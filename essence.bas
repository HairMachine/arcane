type EssenceComponent extends Component
	effect as string
	declare constructor(eid as integer, effect as string)
end type

constructor EssenceComponent(eid as integer, effect as string)
	this.entity_id = eid
	this.name = "EssenceComponent"
	this.effect = effect
end constructor

/''
 ' Set up essence description / spell mapping
 '/
sub essence_init(gm as Gamestate)
	dim descs as StringList
	descs.add("weathered")
	descs.add("glimmering")
	descs.add("diamond")
	descs.add("flickering")
	descs.add("sublime")
	descs.add("chaotic")
	descs.add("glowing")
	descs.add("warm")
	descs.add("blackened")
	descs.add("pulsing")
	descs.add("aquamarine")
	descs.add("gelatinous")
	descs.add("metallic")
	descs.add("sulphurous")
	descs.add("reflective")
	descs.add("porous")
	dim r as integer = rnd() * descs.length - 1
	gm.essences.set("drain_strength", descs.items(r))
	descs.remove(descs.items(r))
end sub

function essence_entity_create(gm as Gamestate, x as integer, y as integer, spell as string) as integer
	dim eid as integer = gm.el.add(gm.essences.get(spell) + " essence", spell + " essence")
	gm.cl.add(new PositionComponent(eid, x, y, 1, "essence", 0, 1))
	gm.cl.add(new EssenceComponent(eid, spell))
	return eid
end function

function essence_entity_create_random(gm as Gamestate, x as integer, y as integer) as integer
	return essence_entity_create(gm, x, y, "drain_strength")
end function
