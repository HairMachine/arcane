type ControllableComponent extends Component
	declare constructor(eid as integer)
end type

constructor ControllableComponent(eid as integer)
	this.name = "ControllableComponent"
	this.entity_id = eid
end constructor

sub KeyboardControlSystem(cl as ComponentList, el as EntityList, gm as Gamestate, map as MapData)
	'take first match; you can only control one at a time, any more is A Bug	
	dim matching as ComponentList = cl.filter("ControllableComponent")
	dim controlling as ControllableComponent ptr = Cast(ControllableComponent ptr, matching.components(0))
	
	dim key as string = inkey()
	select case key
		case "8": MoveEntitySystem(cl, map, controlling->entity_id, "north")
		case "9": MoveEntitySystem(cl, map, controlling->entity_id, "northeast")
		case "6": MoveEntitySystem(cl, map, controlling->entity_id, "east")
		case "3": MoveEntitySystem(cl, map, controlling->entity_id, "southeast")
		case "2": MoveEntitySystem(cl, map, controlling->entity_id, "south")
		case "1": MoveEntitySystem(cl, map, controlling->entity_id, "southwest")
		case "4": MoveEntitySystem(cl, map, controlling->entity_id, "west")
		case "7": MoveEntitySystem(cl, map, controlling->entity_id, "northwest")
		case "u": InventoryUseSystem(2, el)
		case "i": InventoryListSystem(1, cl, el)
		case "q": gm.gameover = 1
	end select
end sub
