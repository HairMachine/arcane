type BookComponent extends Component
	text as string
	spell as string
	holder as integer
	declare constructor(eid as integer, text as string, spell as string)
end type

constructor BookComponent(eid as integer, text as string, spell as string)
	this.entity_id = eid
	this.name = "BookComponent"
	this.text = text
	this.spell = spell
	this.holder = -1
end constructor

sub book_show_text(bc as BookComponent ptr)
	dim handle as integer
	dim line_in as string
	dim text as string
	handle = freefile()
	open bc->text + ".dat" for input as #handle
	while not eof(handle)
		input #handle, line_in
		print line_in
	wend
end sub

sub BookReadSystem(reader as integer, gm as Gamestate)
	cls
	print "Read which book?"
	dim matching as ComponentList = gm.cl.filter("BookComponent")
	for i as integer = 0 to matching.length - 1
		dim bk as BookComponent ptr = cast(BookComponent ptr, matching.components(i))
		if bk->holder = reader then
			print str(i + 1) + ") " + gm.el.entities(bk->entity_id).name
		end if
	next
	dim a as integer
	input a
	if a - 1 < matching.length and a - 1 >= 0 then
		cls
		book_show_text(cast(BookComponent ptr, matching.components(a - 1)))
		getkey
	end if
end sub

sub spellbook_cast(bk as BookComponent ptr, gm as Gamestate)
	dim posi as PositionComponent ptr = cast(PositionComponent ptr, gm.cl.entityComponent(bk->holder, "PositionComponent"))
	gm.ml.add(gm.el.entities(bk->holder).name + " marshalls the arcane forces...")
	essence_entity_create(gm, posi->x, posi->y, bk->spell)
end sub

sub SpellCastSystem(caster as integer, gm as Gamestate)
	cls
	print "Cast which spell?"
	dim matching as ComponentList = gm.cl.filter("BookComponent")
	for i as integer = 0 to matching.length - 1
		dim bk as BookComponent ptr = cast(BookComponent ptr, matching.components(i))
		if bk->holder = caster then
			print str(i + 1) + ") " + gm.el.entities(bk->entity_id).name
		end if
	next
	dim a as integer
	input a
	if a - 1 < matching.length and a - 1 >= 0 then
		spellbook_cast(cast(BookComponent ptr, matching.components(a - 1)), gm)
	end if
end sub

/'
probably when picked up, you learn the spell and the thing is immediately removed from your inventory.
so books in general i guess do this:
- pickable
- when picked show a cls with their book text, whatever it might be
- add the text to your notes for a normal book
- add a spell to your spell list for a spellbook
'/
function book_entity_create(gm as Gamestate, x as integer, y as integer) as integer
	dim eid as integer = gm.el.add("Spellbook", "spellbook")
	gm.cl.add(new PositionComponent(eid, x, y, 1, "book", 0, 1))
	gm.cl.add(new BookComponent(eid, "spellbook", "drain_strength"))
	return eid
end function
