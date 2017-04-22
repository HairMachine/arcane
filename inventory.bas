type InventoryItemComponent extends Component
	holder as integer
	stack as integer
	declare constructor(eid as integer, holder as integer)
end type

constructor InventoryItemComponent(eid as integer, holder as integer)
	this.name = "InventoryItemComponent"
	this.entity_id = eid
	this.holder = holder
end constructor


sub InventoryPickupSystem(picker as integer, gm as Gamestate)
	dim posi as PositionComponent ptr = cast(PositionComponent ptr, gm.cl.entityComponent(picker, "PositionComponent"))
	dim things_here as ComponentList = gm.cl.filter("PositionComponent")
	for i as integer = 0 to things_here.length - 1
		dim item as PositionComponent ptr = cast(PositionComponent ptr, things_here.components(i))
		if item->x = posi->x and item->y = posi->y and posi->entity_id <> item->entity_id then
			'todo: stacks; for now, get everything
			gm.ml.add("Picked up " + gm.el.entities(item->entity_id).name)
			dim matching as ComponentList = gm.cl.filter("InventoryItemComponent")
			for j as integer = 0 to matching.length - 1
				dim item as InventoryItemComponent ptr = Cast(InventoryItemComponent ptr, matching.components(j))
				if item->holder = picker then
					item->stack += 1
					exit sub
				end if
			next
			gm.cl.add(new InventoryItemComponent(item->entity_id, picker))
			gm.cl.remove(item->id)
		end if
	next
end sub

/'sub InventoryPickupSystem(eid as integer, picker as integer, gm as Gamestate)
	gm.ml.add("Picked up " + gm.el.entities(eid).name)
	dim matching as ComponentList = gm.cl.filter("InventoryItemComponent")
	for i as integer = 0 to matching.length - 1
		dim item as InventoryItemComponent ptr = Cast(InventoryItemComponent ptr, matching.components(i))
		if item->holder = picker then
			item->stack += 1
			exit sub
		end if
	next
	gm.cl.add(new InventoryItemComponent(eid, picker))
end sub'/

sub InventoryListSystem(holder_eid as integer, gm as Gamestate)
	cls
	dim matching as ComponentList = gm.cl.filter("InventoryItemComponent")
	for i as integer = 0 to matching.length - 1
		dim item as InventoryItemComponent ptr = Cast(InventoryItemComponent ptr, matching.components(i))
		if item->holder = holder_eid then
			print str(i + 1) + ") " + gm.el.entities(item->entity_id).name + " (" + str(item->stack + 1) + ")"
		end if
	next
	getkey
end sub

sub InventoryUseSystem(item_eid as integer, gm as Gamestate)
	select case gm.el.entities(item_eid).tp
		case "thingum": end
	end select
end sub
