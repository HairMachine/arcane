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

sub InventoryPickupSystem(eid as integer, picker as integer, cl as ComponentList)
	dim matching as ComponentList = cl.filter("InventoryItemComponent")
	for i as integer = 0 to matching.length - 1
		dim item as InventoryItemComponent ptr = Cast(InventoryItemComponent ptr, matching.components(i))
		if item->holder = picker then
			item->stack += 1
			exit sub
		end if
	next
	cl.add(new InventoryItemComponent(eid, picker))
end sub

sub InventoryListSystem(holder_eid as integer, cl as ComponentList, el as EntityList)
	cls
	dim matching as ComponentList = cl.filter("InventoryItemComponent")
	for i as integer = 0 to matching.length - 1
		dim item as InventoryItemComponent ptr = Cast(InventoryItemComponent ptr, matching.components(i))
		if item->holder = holder_eid then
			print str(i + 1) + ") " + el.entities(item->entity_id).name + " (" + str(item->stack + 1) + ")"
		end if
	next
	getkey
end sub

sub InventoryUseSystem(item_eid as integer, el as EntityList)
	select case el.entities(item_eid).tp
		case "thingum": end
	end select
end sub
