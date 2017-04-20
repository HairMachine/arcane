type Component extends object
	id as integer = -1
	name as string = ""
	entity_id as integer
	declare sub setEntity(entity_id as integer)
end type

sub Component.setEntity(entity_id as integer)
	this.entity_id = entity_id
end sub

type ComponentList
	components(255) as Component ptr
	length as integer
	declare sub add(c as Component ptr)
	declare sub remove(id as integer)
	declare function filter(cpt as string) as ComponentList
	declare function entityComponents(eid as integer) as ComponentList
	declare function entityComponent(eid as integer, component as string) as Component ptr
end type

sub ComponentList.add(c as Component ptr)
	for i as integer = 0 to ubound(this.components)
		if this.components(i) = 0 then
			c->id = i
			this.components(i) = c
			this.length += 1
			exit sub
		end if
	next
end sub

sub ComponentList.remove(id as integer)
	this.components(id) = 0
	this.length -= 1
	for i as integer = id to ubound(this.components) - 1
		this.components(i) = this.components(i + 1)
		if this.components(i) = 0 then exit sub	
		this.components(i)->id = i
	next
end sub

function ComponentList.filter(cpt as string) as ComponentList
	dim filtered as ComponentList
	for i as integer = 0 to this.length - 1
		if this.components(i)->name = cpt then 
			filtered.add(this.components(i))
			this.components(i)->id = i
		end if
	next
	return filtered
end function

function ComponentList.entityComponents(eid as integer) as ComponentList
	dim filtered as ComponentList
	for i as integer = 0 to this.length - 1
		if this.components(i)->entity_id = eid then 
			filtered.add(this.components(i))
			this.components(i)->id = i
		end if
	next
	return filtered
end function

function ComponentList.entityComponent(eid as integer, component as string) as Component ptr
	for i as integer = 0 to this.length - 1
		if (this.components(i)->entity_id = eid and this.components(i)->name = component) then return this.components(i)
	next
	return 0
end function

type Entity
	id as integer = -1
	name as string
	tp as string
end type
dim shared NULL_ENTITY as Entity

type EntityList
	entities(127) as Entity
	declare function add(n as string, tp as string) as integer
	declare sub remove(id as integer)
	declare function find(id as integer) as Entity
end type

function EntityList.add(n as string, t as string) as integer
	dim e as Entity
	e.name = n
	e.tp = t
	for i as integer = 0 to ubound(this.entities)
		if this.entities(i).id = -1 then
			e.id = i
			this.entities(i) = e
			return i
		end if
	next
	return -1
end function

sub EntityList.remove(id as integer)
	for i as integer = 0 to ubound(this.entities)
		if this.entities(i).id = id then
			this.entities(i) = NULL_ENTITY
			exit sub
		end if
	next
end sub

' helper function to destroy an entity and clean up any components it owns
sub EntityDestroy(eid as integer, el as EntityList, cl as ComponentList)
	dim entity_components as ComponentList = cl.entityComponents(eid)
	for i as integer = 0 to entity_components.length - 1
		cl.remove(entity_components.components(i)->id)
	next
	el.remove(eid)
end sub
