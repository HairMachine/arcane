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
		if item->x = posi->x and item->y = posi->y and item->liftable = 1 and posi->entity_id <> item->entity_id then
			'todo: stacks; for now, get everything
			gm.ml.add("Picked up " + gm.el.entities(item->entity_id).name + ".")
			dim matching as ComponentList = gm.cl.filter("InventoryItemComponent")
			for j as integer = 0 to matching.length - 1
				dim item as InventoryItemComponent ptr = Cast(InventoryItemComponent ptr, matching.components(j))
				if item->holder = picker then
					item->stack += 1
					exit sub
				end if
			next
			gm.cl.add(new InventoryItemComponent(item->entity_id, picker))
			item->visible = 0
			item->x = -5
			item->y = -5
		end if
	next
end sub

sub InventoryListSystem(holder as integer, gm as Gamestate)
	cls
	dim matching as ComponentList = gm.cl.filter("InventoryItemComponent")
	for i as integer = 0 to matching.length - 1
		dim item as InventoryItemComponent ptr = Cast(InventoryItemComponent ptr, matching.components(i))
		if item->holder = holder then
			print str(i + 1) + ") " + gm.el.entities(item->entity_id).name + " (" + str(item->stack + 1) + ")"
		end if
	next
	getkey
end sub

sub InventoryDropSystem(holder as integer, gm as Gamestate)
	cls
	dim matching as ComponentList = gm.cl.filter("InventoryItemComponent")
	for i as integer = 0 to matching.length - 1
		dim item as InventoryItemComponent ptr = Cast(InventoryItemComponent ptr, matching.components(i))
		if item->holder = holder then
			print str(i + 1) + ") " + gm.el.entities(item->entity_id).name + " (" + str(item->stack + 1) + ")"
		end if
	next
	'drop
	dim selection as integer = getkey - 49
	if selection < 0 or selection > matching.length - 1 then exit sub
	dim dropped_id as integer = matching.components(selection)->entity_id
	dim dropped_item as PositionComponent ptr = cast(PositionComponent ptr, gm.cl.entityComponent(dropped_id, "PositionComponent"))
	dim dropped_inv as InventoryItemComponent ptr = cast(InventoryItemComponent ptr, gm.cl.entityComponent(dropped_id, "InventoryItemComponent"))
	dim dropper_pos as PositionComponent ptr = cast(PositionComponent ptr, gm.cl.entityComponent(gm.playerId, "PositionComponent"))
	dropped_item->visible = 1
	dropped_item->x = dropper_pos->x
	dropped_item->y = dropper_pos->y
	if dropped_inv->stack = 1 then
		dropped_inv->stack -= 1
	else
		gm.cl.remove(dropped_inv->id)
	end if
	gm.ml.add("Dropped " + gm.el.entities(dropped_id).name + ".")
end sub

sub InventoryUseSystem(user as integer, gm as Gamestate)
	cls
	dim matching as ComponentList = gm.cl.filter("InventoryItemComponent")
	for i as integer = 0 to matching.length - 1
		dim item as InventoryItemComponent ptr = Cast(InventoryItemComponent ptr, matching.components(i))
		if item->holder = user then
			print str(i + 1) + ") " + gm.el.entities(item->entity_id).name + " (" + str(item->stack + 1) + ")"
		end if
	next
	'use
	dim selection as integer = getkey - 49
	if selection < 0 or selection > matching.length - 1 then exit sub
	select case gm.el.entities(matching.components(selection)->entity_id).tp
		case "thingum":
			gm.ml.add("Nothing seems to happen.")
	end select
end sub
