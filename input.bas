type ControllableComponent extends Component
	declare constructor(eid as integer)
end type

constructor ControllableComponent(eid as integer)
	this.name = "ControllableComponent"
	this.entity_id = eid
end constructor

sub GenericInteractionSystem(gm as Gamestate)
	DistillerUseSystem(gm.playerId, gm)
	RitualUseSystem(gm.playerId, gm)
end sub

sub KeyboardControlSystem(gm as Gamestate, map as MapData)
	'take first match; you can only control one at a time, any more is A Bug	
	dim matching as ComponentList = gm.cl.filter("ControllableComponent")
	dim controlling as ControllableComponent ptr = Cast(ControllableComponent ptr, matching.components(0))
	
	dim key as string = inkey()
	select case key
		case "8": MoveEntitySystem(gm, map, controlling->entity_id, "north")
		case "9": MoveEntitySystem(gm, map, controlling->entity_id, "northeast")
		case "6": MoveEntitySystem(gm, map, controlling->entity_id, "east")
		case "3": MoveEntitySystem(gm, map, controlling->entity_id, "southeast")
		case "2": MoveEntitySystem(gm, map, controlling->entity_id, "south")
		case "1": MoveEntitySystem(gm, map, controlling->entity_id, "southwest")
		case "4": MoveEntitySystem(gm, map, controlling->entity_id, "west")
		case "7": MoveEntitySystem(gm, map, controlling->entity_id, "northwest")
		case "u": InventoryUseSystem(gm.playerId, gm)
		case "i": InventoryListSystem(gm.playerId, gm)
		case ",": InventoryPickupSystem(gm.playerId, gm)
		case "d": InventoryDropSystem(gm.playerid, gm)
		case "n": InventoryNameSystem(gm)
		case "r": BookReadSystem(gm.playerId, gm)
		case " ": GenericInteractionSystem(gm)
		case "q": gm.gameover = 1
	end select	
end sub
