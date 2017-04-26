type BookComponent extends Component
	text as string
	spell as string
	declare constructor(eid as integer, text as string, spell as string)
end type

constructor BookComponent(eid as integer, text as string, spell as string)
	this.entity_id = eid
	this.name = "BookComponent"
	this.text = text
	this.spell = spell
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
