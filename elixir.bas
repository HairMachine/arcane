type ElixirComponent extends Component
	effect as string
	declare constructor(eid as integer, effect as string)
end type

constructor ElixirComponent(eid as integer, effect as string)
	this.entity_id = eid
	this.effect = effect
	this.name = "ElixirComponent"
end constructor

function elixir_entity_create(gm as Gamestate, x as integer, y as integer) as integer
	dim eid as integer = gm.el.add("Elixir", "elixir")
	gm.cl.add(new PositionComponent(eid, x, y, 1, "elixir", 0, 1))
	gm.cl.add(new ElixirComponent(eid, "nothing"))
	return eid
end function
